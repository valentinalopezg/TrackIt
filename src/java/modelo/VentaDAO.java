package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestionar operaciones de Venta en la base de datos
 * Track!t - Sistema de Gestión de Inventarios
 */
public class VentaDAO {
    
    private Conexion conexion;
    private ProductoDAO productoDAO;
    
    public VentaDAO() {
        this.conexion = new Conexion();
        this.productoDAO = new ProductoDAO();
    }
    
    /**
     * Procesa una venta completa (venta + detalles + actualización de stock)
     * Este es el método MÁS IMPORTANTE del sistema
     * @param venta Venta con sus detalles
     * @return int ID de la venta generada, 0 si falla
     */
    public int procesarVenta(Venta venta) {
        Connection con = null;
        PreparedStatement psVenta = null;
        PreparedStatement psDetalle = null;
        ResultSet rs = null;
        int idVentaGenerado = 0;
        
        try {
            con = conexion.crearConexion();
            
            // IMPORTANTE: Desactivar auto-commit para manejar transacción
            con.setAutoCommit(false);
            
            // 1. Insertar la venta principal
            String queryVenta = "INSERT INTO ventas (numero_venta, id_usuario, subtotal, total, metodo_pago, estado) "
                              + "VALUES (?, ?, ?, ?, ?, ?)";
            psVenta = con.prepareStatement(queryVenta, Statement.RETURN_GENERATED_KEYS);
            psVenta.setString(1, venta.getNumeroVenta());
            psVenta.setInt(2, venta.getIdUsuario());
            psVenta.setBigDecimal(3, venta.getSubtotal());
            psVenta.setBigDecimal(4, venta.getTotal());
            psVenta.setString(5, venta.getMetodoPago());
            psVenta.setString(6, venta.getEstado());
            
            int filasVenta = psVenta.executeUpdate();
            
            if (filasVenta > 0) {
                // Obtener el ID generado de la venta
                rs = psVenta.getGeneratedKeys();
                if (rs.next()) {
                    idVentaGenerado = rs.getInt(1);
                    System.out.println("Venta registrada con ID: " + idVentaGenerado);
                }
                
                // 2. Insertar los detalles de la venta y actualizar stock
                String queryDetalle = "INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, precio_unitario, subtotal) "
                                    + "VALUES (?, ?, ?, ?, ?)";
                psDetalle = con.prepareStatement(queryDetalle);
                
                for (DetalleVenta detalle : venta.getDetalles()) {
                    // Insertar detalle
                    psDetalle.setInt(1, idVentaGenerado);
                    psDetalle.setInt(2, detalle.getIdProducto());
                    psDetalle.setInt(3, detalle.getCantidad());
                    psDetalle.setBigDecimal(4, detalle.getPrecioUnitario());
                    psDetalle.setBigDecimal(5, detalle.getSubtotal());
                    psDetalle.executeUpdate();
                    
                    // CRÍTICO: Actualizar el stock del producto
                    int resultado = productoDAO.actualizarStock(detalle.getIdProducto(), detalle.getCantidad());
                    
                    if (resultado <= 0) {
                        throw new SQLException("No se pudo actualizar el stock del producto ID: " + detalle.getIdProducto());
                    }
                    
                    System.out.println("Detalle agregado: " + detalle.getNombreProducto() + " x" + detalle.getCantidad());
                }
                
                // 3. Si todo salió bien, confirmar la transacción
                con.commit();
                System.out.println("VENTA PROCESADA EXITOSAMENTE - Número: " + venta.getNumeroVenta());
                
            } else {
                con.rollback();
                System.err.println("Error al registrar la venta");
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al procesar venta: " + e.getMessage());
            e.printStackTrace();
            
            // Si hay error, revertir TODA la transacción
            try {
                if (con != null) {
                    con.rollback();
                    System.err.println("⚠️ Transacción revertida");
                }
            } catch (SQLException ex) {
                System.err.println("Error al revertir transacción: " + ex.getMessage());
            }
            
            idVentaGenerado = 0;
            
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true); // Restaurar auto-commit
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            cerrarRecursos(con, psVenta, rs);
            if (psDetalle != null) {
                try {
                    psDetalle.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return idVentaGenerado;
    }
    
    /**
     * Obtiene una venta por ID con sus detalles
     * @param idVenta ID de la venta
     * @return Venta con detalles o null
     */
    public Venta obtenerVentaPorId(int idVenta) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Venta venta = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT v.*, u.nombre as nombre_usuario, u.apellido as apellido_usuario "
                         + "FROM ventas v "
                         + "INNER JOIN usuarios u ON v.id_usuario = u.id_usuario "
                         + "WHERE v.id_venta = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idVenta);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                venta = mapearVenta(rs);
                // Cargar los detalles de la venta
                venta.setDetalles(obtenerDetallesVenta(idVenta));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener venta: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return venta;
    }
    
    /**
     * Obtiene los detalles de una venta
     * @param idVenta ID de la venta
     * @return List de detalles
     */
    public List<DetalleVenta> obtenerDetallesVenta(int idVenta) {
        List<DetalleVenta> detalles = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT dv.*, p.nombre as nombre_producto, p.codigo as codigo_producto "
                         + "FROM detalle_ventas dv "
                         + "INNER JOIN productos p ON dv.id_producto = p.id_producto "
                         + "WHERE dv.id_venta = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idVenta);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                DetalleVenta detalle = new DetalleVenta();
                detalle.setIdDetalle(rs.getInt("id_detalle"));
                detalle.setIdVenta(rs.getInt("id_venta"));
                detalle.setIdProducto(rs.getInt("id_producto"));
                detalle.setNombreProducto(rs.getString("nombre_producto"));
                detalle.setCodigoProducto(rs.getString("codigo_producto"));
                detalle.setCantidad(rs.getInt("cantidad"));
                detalle.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                detalle.setSubtotal(rs.getBigDecimal("subtotal"));
                
                detalles.add(detalle);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener detalles de venta: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return detalles;
    }
    
    /**
     * Lista todas las ventas
     * @return List de ventas
     */
    public List<Venta> listarVentas() {
        List<Venta> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT v.*, CONCAT(u.nombre, ' ', u.apellido) as nombre_usuario "
                         + "FROM ventas v "
                         + "INNER JOIN usuarios u ON v.id_usuario = u.id_usuario "
                         + "ORDER BY v.fecha_venta DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearVenta(rs));
            }
            
            System.out.println("Ventas encontradas: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar ventas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista ventas de un usuario específico
     * @param idUsuario ID del usuario
     * @return List de ventas del usuario
     */
    public List<Venta> listarVentasPorUsuario(int idUsuario) {
        List<Venta> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT v.*, CONCAT(u.nombre, ' ', u.apellido) as nombre_usuario "
                         + "FROM ventas v "
                         + "INNER JOIN usuarios u ON v.id_usuario = u.id_usuario "
                         + "WHERE v.id_usuario = ? "
                         + "ORDER BY v.fecha_venta DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearVenta(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar ventas por usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista ventas por rango de fechas
     * @param fechaInicio Fecha inicial (formato: YYYY-MM-DD)
     * @param fechaFin Fecha final (formato: YYYY-MM-DD)
     * @return List de ventas en el rango
     */
    public List<Venta> listarVentasPorFecha(String fechaInicio, String fechaFin) {
        List<Venta> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT v.*, CONCAT(u.nombre, ' ', u.apellido) as nombre_usuario "
                         + "FROM ventas v "
                         + "INNER JOIN usuarios u ON v.id_usuario = u.id_usuario "
                         + "WHERE DATE(v.fecha_venta) BETWEEN ? AND ? "
                         + "ORDER BY v.fecha_venta DESC";
            ps = con.prepareStatement(query);
            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearVenta(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar ventas por fecha: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista ventas del día actual
     * @return List de ventas del día
     */
    public List<Venta> listarVentasDelDia() {
        List<Venta> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT v.*, CONCAT(u.nombre, ' ', u.apellido) as nombre_usuario "
                         + "FROM ventas v "
                         + "INNER JOIN usuarios u ON v.id_usuario = u.id_usuario "
                         + "WHERE DATE(v.fecha_venta) = CURDATE() "
                         + "ORDER BY v.fecha_venta DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearVenta(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar ventas del día: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Genera el próximo número de venta correlativo
     * @return String con el número de venta generado
     */
    public String generarNumeroVenta() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int correlativo = 1;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT COUNT(*) + 1 as correlativo FROM ventas WHERE YEAR(fecha_venta) = YEAR(CURDATE())";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                correlativo = rs.getInt("correlativo");
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al generar número de venta: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return "VENTA-" + String.format("%05d", correlativo);
    }
    
    /**
     * Cancela una venta (cambia estado a 'cancelada')
     * NOTA: No devuelve el stock
     * @param idVenta ID de la venta
     * @return int número de filas afectadas
     */
    public int cancelarVenta(int idVenta) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE ventas SET estado = 'cancelada' WHERE id_venta = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idVenta);
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Venta cancelada: ID " + idVenta);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al cancelar venta: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Obtiene el total de ventas del día
     * @return Total de ventas en BigDecimal
     */
    public java.math.BigDecimal obtenerTotalVentasDelDia() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT COALESCE(SUM(total), 0) as total_dia "
                         + "FROM ventas "
                         + "WHERE DATE(fecha_venta) = CURDATE() AND estado = 'completada'";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getBigDecimal("total_dia");
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener total ventas del día: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return total;
    }
    
    /**
     * Obtiene el conteo de ventas del día
     * @return Número de ventas del día
     */
    public int contarVentasDelDia() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int conteo = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT COUNT(*) as total "
                         + "FROM ventas "
                         + "WHERE DATE(fecha_venta) = CURDATE() AND estado = 'completada'";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                conteo = rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al contar ventas del día: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return conteo;
    }
    
    /**
     * Obtiene los productos más vendidos
     * @param limite Número de productos a retornar
     * @return List de productos con cantidad vendida
     */
    public List<Object[]> obtenerProductosMasVendidos(int limite) {
        List<Object[]> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.nombre, p.codigo, SUM(dv.cantidad) as total_vendido, "
                         + "SUM(dv.subtotal) as ingresos "
                         + "FROM detalle_ventas dv "
                         + "INNER JOIN productos p ON dv.id_producto = p.id_producto "
                         + "INNER JOIN ventas v ON dv.id_venta = v.id_venta "
                         + "WHERE v.estado = 'completada' "
                         + "GROUP BY p.id_producto, p.nombre, p.codigo "
                         + "ORDER BY total_vendido DESC "
                         + "LIMIT ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, limite);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Object[] fila = new Object[4];
                fila[0] = rs.getString("nombre");
                fila[1] = rs.getString("codigo");
                fila[2] = rs.getInt("total_vendido");
                fila[3] = rs.getBigDecimal("ingresos");
                lista.add(fila);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener productos más vendidos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Obtiene estadísticas de ventas por método de pago
     * @return List con estadísticas [metodo_pago, cantidad, total]
     */
    public List<Object[]> obtenerEstadisticasPorMetodoPago() {
        List<Object[]> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT metodo_pago, COUNT(*) as cantidad, SUM(total) as total_ventas "
                         + "FROM ventas "
                         + "WHERE estado = 'completada' AND DATE(fecha_venta) = CURDATE() "
                         + "GROUP BY metodo_pago";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Object[] fila = new Object[3];
                fila[0] = rs.getString("metodo_pago");
                fila[1] = rs.getInt("cantidad");
                fila[2] = rs.getBigDecimal("total_ventas");
                lista.add(fila);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener estadísticas por método de pago: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Mapea un ResultSet a un objeto Venta
     * @param rs ResultSet con datos de la venta
     * @return Venta mapeada
     * @throws SQLException si hay error al leer datos
     */
    private Venta mapearVenta(ResultSet rs) throws SQLException {
        Venta v = new Venta();
        v.setIdVenta(rs.getInt("id_venta"));
        v.setNumeroVenta(rs.getString("numero_venta"));
        v.setIdUsuario(rs.getInt("id_usuario"));
        v.setNombreUsuario(rs.getString("nombre_usuario"));
        v.setFechaVenta(rs.getTimestamp("fecha_venta"));
        v.setSubtotal(rs.getBigDecimal("subtotal"));
        v.setTotal(rs.getBigDecimal("total"));
        v.setMetodoPago(rs.getString("metodo_pago"));
        v.setEstado(rs.getString("estado"));
        return v;
    }
    
    /**
     * Cierra los recursos de base de datos
     */
    private void cerrarRecursos(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            System.err.println("ERROR al cerrar recursos: " + e.getMessage());
        }
    }
}