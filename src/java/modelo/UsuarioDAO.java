package modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestionar operaciones de Usuario en la base de datos
 * Track!t - Sistema de Gestión de Inventarios
 */
public class UsuarioDAO {
    
    private Conexion conexion;
    
    public UsuarioDAO() {
        this.conexion = new Conexion();
    }
    
    /**
     * Valida las credenciales de login
     * @param usuario nombre de usuario
     * @param clave contraseña
     * @return Usuario si las credenciales son correctas, null si no
     */
    public Usuario validarLogin(String usuario, String clave) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario u = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM usuarios WHERE usuario = ? AND clave = ? AND estado = 'activo'";
            ps = con.prepareStatement(query);
            ps.setString(1, usuario);
            ps.setString(2, clave);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setIdentificacion(rs.getString("identificacion"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setEmail(rs.getString("email"));
                u.setUsuario(rs.getString("usuario"));
                u.setClave(rs.getString("clave"));
                u.setRol(rs.getString("rol"));
                u.setEstado(rs.getString("estado"));
                u.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                
                System.out.println("Login exitoso: " + u.getNombreCompleto());
            } else {
                System.out.println("Credenciales incorrectas");
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al validar login: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return u;
    }
    
    /**
     * Agrega un nuevo usuario
     * @param u Usuario a agregar
     * @return int número de filas afectadas
     */
    public int agregarUsuario(Usuario u) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "INSERT INTO usuarios (identificacion, nombre, apellido, email, usuario, clave, rol, estado) "
                         + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, u.getIdentificacion());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getApellido());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUsuario());
            ps.setString(6, u.getClave());
            ps.setString(7, u.getRol());
            ps.setString(8, u.getEstado());
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Usuario agregado: " + u.getUsuario());
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al agregar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Actualiza los datos de un usuario
     * @param u Usuario con datos actualizados
     * @return int número de filas afectadas
     */
    public int actualizarUsuario(Usuario u) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE usuarios SET identificacion=?, nombre=?, apellido=?, "
                         + "email=?, usuario=?, clave=?, rol=?, estado=? WHERE id_usuario=?";
            ps = con.prepareStatement(query);
            ps.setString(1, u.getIdentificacion());
            ps.setString(2, u.getNombre());
            ps.setString(3, u.getApellido());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUsuario());
            ps.setString(6, u.getClave());
            ps.setString(7, u.getRol());
            ps.setString(8, u.getEstado());
            ps.setInt(9, u.getIdUsuario());
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Usuario actualizado: " + u.getUsuario());
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al actualizar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Elimina un usuario (soft delete - cambia estado a 'inactivo')
     * @param idUsuario ID del usuario a eliminar
     * @return int número de filas afectadas
     */
    public int eliminarUsuario(int idUsuario) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE usuarios SET estado = 'inactivo' WHERE id_usuario = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idUsuario);
            
            resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("Usuario eliminado (inactivado): ID " + idUsuario);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al eliminar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Obtiene un usuario por su ID
     * @param idUsuario ID del usuario
     * @return Usuario encontrado o null
     */
    public Usuario obtenerUsuarioPorId(int idUsuario) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario u = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM usuarios WHERE id_usuario = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, idUsuario);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setIdentificacion(rs.getString("identificacion"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setEmail(rs.getString("email"));
                u.setUsuario(rs.getString("usuario"));
                u.setClave(rs.getString("clave"));
                u.setRol(rs.getString("rol"));
                u.setEstado(rs.getString("estado"));
                u.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al obtener usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return u;
    }
    
    /**
     * Lista todos los usuarios
     * @return List de usuarios
     */
    public List<Usuario> listarUsuarios() {
        List<Usuario> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM usuarios ORDER BY id_usuario DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setIdentificacion(rs.getString("identificacion"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setEmail(rs.getString("email"));
                u.setUsuario(rs.getString("usuario"));
                u.setClave(rs.getString("clave"));
                u.setRol(rs.getString("rol"));
                u.setEstado(rs.getString("estado"));
                u.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                
                lista.add(u);
            }
            
            System.out.println("Usuarios encontrados: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar usuarios: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista solo usuarios activos
     * @return List de usuarios activos
     */
    public List<Usuario> listarUsuariosActivos() {
        List<Usuario> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM usuarios WHERE estado = 'activo' ORDER BY nombre ASC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setIdentificacion(rs.getString("identificacion"));
                u.setNombre(rs.getString("nombre"));
                u.setApellido(rs.getString("apellido"));
                u.setEmail(rs.getString("email"));
                u.setUsuario(rs.getString("usuario"));
                u.setRol(rs.getString("rol"));
                u.setEstado(rs.getString("estado"));
                
                lista.add(u);
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al listar usuarios activos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Verifica si un nombre de usuario ya existe
     * @param usuario nombre de usuario a verificar
     * @return true si existe, false si no
     */
    public boolean existeUsuario(String usuario) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean existe = false;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT COUNT(*) as total FROM usuarios WHERE usuario = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, usuario);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                existe = rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR al verificar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return existe;
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