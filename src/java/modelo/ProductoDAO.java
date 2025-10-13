package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestionar operaciones de Producto en la base de datos
 * Track!t - Sistema de Gestión de Inventarios
 */
public class ProductoDAO {
    
    private Conexion conexion;
    
    public ProductoDAO() {
        this.conexion = new Conexion();
    }
    
    /**
     * Agrega un nuevo producto
     * @param p Producto a agregar
     * @return int número de filas afectadas
     */
    public int agregarProducto(Producto p) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "INSERT INTO productos (codigo, nombre, descripcion, id_categoria, "
                         + "precio_compra, precio_venta, stock_actual, stock_minimo, stock_maximo, estado) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, p.getCodigo());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getDescripcion());
            ps.setInt(4, p.getIdCategoria());
            ps.setBigDecimal(5, p.getPrecioCompra());
            ps.setBigDecimal(6, p.getPrecioVenta());
            ps.setInt(7, p.getStockActual());
            ps.setInt(8, p.getStockMinimo());
            ps.setInt(9, p.getStockMaximo());
            ps.setString(10, p.getEstado());
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Producto agregado: " + p.getNombre());
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al agregar producto: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Actualiza un producto
     * @param p Producto con datos actualizados
     * @return int número de filas afectadas
     */
    public int actualizarProducto(Producto p) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE productos SET codigo=?, nombre=?, descripcion=?, id_categoria=?, "
                         + "precio_compra=?, precio_venta=?, stock_actual=?, stock_minimo=?, "
                         + "stock_maximo=?, estado=? WHERE id_producto=?";
            ps = con.prepareStatement(query);
            ps.setString(1, p.getCodigo());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getDescripcion());
            ps.setInt(4, p.getIdCategoria());
            ps.setBigDecimal(5, p.getPrecioCompra());
            ps.setBigDecimal(6, p.getPrecioVenta());
            ps.setInt(7, p.getStockActual());
            ps.setInt(8, p.getStockMinimo());
            ps.setInt(9, p.getStockMaximo());
            ps.setString(10, p.getEstado());
            ps.setInt(11, p.getIdProducto());
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Producto actualizado: " + p.getNombre());
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al actualizar producto: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Actualiza solo el stock de un producto (para ventas)
     * @param idProducto ID del producto
     * @param cantidadVendida Cantidad a restar del stock
     * @return int número de filas afectadas
     */
    public int actualizarStock(int idProducto, int cantidadVendida) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE productos SET stock_actual = stock_actual - ? WHERE id_producto = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, cantidadVendida);
            ps.setInt(2, idProducto);
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Stock actualizado para producto ID: " + idProducto);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al actualizar stock: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Elimina un producto (soft delete)
     * @param idProducto ID del producto
     * @return int número de filas afectadas
     */
    public int eliminarProducto(int idProducto) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE productos SET estado = 'inactivo' WHERE id_producto = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idProducto);
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Producto eliminado: ID " + idProducto);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al eliminar producto: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Obtiene un producto por ID con información de categoría
     * @param idProducto ID del producto
     * @return Producto encontrado o null
     */
    public Producto obtenerProductoPorId(int idProducto) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Producto p = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "WHERE p.id_producto = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idProducto);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                p = mapearProducto(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener producto: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return p;
    }
    
    /**
     * Obtiene un producto por código
     * @param codigo Código del producto
     * @return Producto encontrado o null
     */
    public Producto obtenerProductoPorCodigo(String codigo) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Producto p = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "WHERE p.codigo = ? AND p.estado = 'activo'";
            ps = con.prepareStatement(query);
            ps.setString(1, codigo);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                p = mapearProducto(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener producto por código: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return p;
    }
    
    /**
     * Lista todos los productos con información de categoría
     * @return List de productos
     */
    public List<Producto> listarProductos() {
        List<Producto> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "ORDER BY p.nombre ASC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
            
            System.out.println("Productos encontrados: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar productos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista solo productos activos
     * @return List de productos activos
     */
    public List<Producto> listarProductosActivos() {
        List<Producto> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "WHERE p.estado = 'activo' "
                         + "ORDER BY p.nombre ASC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar productos activos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista productos con stock bajo (stock_actual <= stock_minimo)
     * @return List de productos con stock bajo
     */
    public List<Producto> listarProductosStockBajo() {
        List<Producto> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "WHERE p.stock_actual <= p.stock_minimo AND p.estado = 'activo' "
                         + "ORDER BY p.stock_actual ASC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
            
            System.out.println("⚠️ Productos con stock bajo: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar productos con stock bajo: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista productos agotados (stock_actual = 0)
     * @return List de productos agotados
     */
    public List<Producto> listarProductosAgotados() {
        List<Producto> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "WHERE p.stock_actual = 0 AND p.estado = 'activo' "
                         + "ORDER BY p.nombre ASC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
            
            System.out.println("?Productos agotados: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar productos agotados: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista productos por categoría
     * @param idCategoria ID de la categoría
     * @return List de productos de la categoría
     */
    public List<Producto> listarProductosPorCategoria(int idCategoria) {
        List<Producto> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "WHERE p.id_categoria = ? AND p.estado = 'activo' "
                         + "ORDER BY p.nombre ASC";
            ps = con.prepareStatement(query);
            ps.setInt(1, idCategoria);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar productos por categoría: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Busca productos por nombre o código
     * @param termino Término de búsqueda
     * @return List de productos encontrados
     */
    public List<Producto> buscarProductos(String termino) {
        List<Producto> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT p.*, c.nombre as nombre_categoria "
                         + "FROM productos p "
                         + "INNER JOIN categorias c ON p.id_categoria = c.id_categoria "
                         + "WHERE (p.nombre LIKE ? OR p.codigo LIKE ?) AND p.estado = 'activo' "
                         + "ORDER BY p.nombre ASC";
            ps = con.prepareStatement(query);
            String busqueda = "%" + termino + "%";
            ps.setString(1, busqueda);
            ps.setString(2, busqueda);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearProducto(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al buscar productos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Verifica si un código de producto ya existe
     * @param codigo Código a verificar
     * @return true si existe, false si no
     */
    public boolean existeCodigo(String codigo) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean existe = false;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT COUNT(*) as total FROM productos WHERE codigo = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, codigo);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                existe = rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al verificar código: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return existe;
    }
    
    /**
     * Mapea un ResultSet a un objeto Producto
     * @param rs ResultSet con datos del producto
     * @return Producto mapeado
     * @throws SQLException si hay error al leer datos
     */
    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProducto(rs.getInt("id_producto"));
        p.setCodigo(rs.getString("codigo"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setIdCategoria(rs.getInt("id_categoria"));
        p.setNombreCategoria(rs.getString("nombre_categoria"));
        p.setPrecioCompra(rs.getBigDecimal("precio_compra"));
        p.setPrecioVenta(rs.getBigDecimal("precio_venta"));
        p.setStockActual(rs.getInt("stock_actual"));
        p.setStockMinimo(rs.getInt("stock_minimo"));
        p.setStockMaximo(rs.getInt("stock_maximo"));
        p.setEstado(rs.getString("estado"));
        p.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        return p;
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