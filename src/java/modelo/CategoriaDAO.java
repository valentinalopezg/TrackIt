package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestionar operaciones de Categoria en la base de datos
 * Track!t - Sistema de Gestión de Inventarios
 */
public class CategoriaDAO {
    
    private Conexion conexion;
    
    public CategoriaDAO() {
        this.conexion = new Conexion();
    }
    
    /**
     * Agrega una nueva categoría
     * @param c Categoria a agregar
     * @return int número de filas afectadas
     */
    public int agregarCategoria(Categoria categoria) {
        int resultado = 0;
        String sql = "INSERT INTO categorias (nombre, descripcion, estado) VALUES (?, ?, ?)";

        System.out.println("=== DAO: agregarCategoria ===");
        System.out.println("SQL: " + sql);
        System.out.println("Nombre: " + categoria.getNombre());
        System.out.println("Descripción: " + categoria.getDescripcion());
        System.out.println("Estado: " + categoria.getEstado());

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = conexion.crearConexion(); 

            if (con == null) {
                System.err.println("ERROR: Conexión es NULL");
                return 0;
            }

            System.out.println("✓ Conexión establecida");

            ps = con.prepareStatement(sql);
            ps.setString(1, categoria.getNombre());
            ps.setString(2, categoria.getDescripcion());
            ps.setString(3, categoria.getEstado());

            System.out.println("✓ PreparedStatement configurado");

            resultado = ps.executeUpdate();

            System.out.println("✓ Filas afectadas: " + resultado);

        } catch (SQLException e) {
            System.err.println("ERROR SQL al agregar categoría");
            System.err.println("Mensaje: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }

        return resultado;
    }
    
    /**
     * Actualiza una categoría
     * @param c Categoria con datos actualizados
     * @return int número de filas afectadas
     */
    public int actualizarCategoria(Categoria c) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE categorias SET nombre=?, descripcion=?, estado=? WHERE id_categoria=?";
            ps = con.prepareStatement(query);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setString(3, c.getEstado());
            ps.setInt(4, c.getIdCategoria());
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Categoría actualizada: " + c.getNombre());
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al actualizar categoría: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Elimina una categoría (soft delete)
     * @param idCategoria ID de la categoría
     * @return int número de filas afectadas
     */
    public int eliminarCategoria(int idCategoria) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE categorias SET estado = 'inactiva' WHERE id_categoria = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idCategoria);
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Categoría eliminada: ID " + idCategoria);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al eliminar categoría: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Obtiene una categoría por ID
     * @param idCategoria ID de la categoría
     * @return Categoria encontrada o null
     */
    public Categoria obtenerCategoriaPorId(int idCategoria) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Categoria c = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM categorias WHERE id_categoria = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idCategoria);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setEstado(rs.getString("estado"));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener categoría: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return c;
    }
    
    /**
     * Lista todas las categorías
     * @return List de categorías
     */
    public List<Categoria> listarCategorias() {
        List<Categoria> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM categorias ORDER BY id_categoria DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setEstado(rs.getString("estado"));
                
                lista.add(c);
            }
            
            System.out.println("Categorías encontradas: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar categorías: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista solo categorías activas
     * @return List de categorías activas
     */
    public List<Categoria> listarCategoriasActivas() {
        List<Categoria> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM categorias WHERE estado = 'activa' ORDER BY nombre ASC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setEstado(rs.getString("estado"));
                
                lista.add(c);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar categorías activas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
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