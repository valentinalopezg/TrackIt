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
     * Valida las credenciales de un usuario (login)
     * @param usuario Nombre de usuario
     * @param clave Contraseña
     * @return Usuario si las credenciales son válidas, null si no
     */
    public Usuario validarLogin(String usuario, String clave) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuarioObj = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM usuarios WHERE usuario = ? AND clave = ? AND estado = 'activo'";
            ps = con.prepareStatement(query);
            ps.setString(1, usuario);
            ps.setString(2, clave);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                usuarioObj = mapearUsuario(rs);
                System.out.println("✓ Login exitoso: " + usuario + " (" + usuarioObj.getRol() + ")");
            } else {
                System.out.println("✗ Login fallido para: " + usuario);
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al validar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return usuarioObj;
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
                System.out.println("✓ Usuario agregado: " + u.getUsuario());
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al agregar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Actualiza un usuario
     * @param u Usuario con datos actualizados
     * @return int número de filas afectadas
     */
    public int actualizarUsuario(Usuario u) {
        Connection con = null;
        PreparedStatement ps = null;
        int resultado = 0;
        
        try {
            con = conexion.crearConexion();
            String query = "UPDATE usuarios SET identificacion=?, nombre=?, apellido=?, email=?, "
                         + "usuario=?, clave=?, rol=?, estado=? WHERE id_usuario=?";
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
                System.out.println("✓ Usuario actualizado: " + u.getUsuario());
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al actualizar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Elimina un usuario (soft delete)
     * @param idUsuario ID del usuario
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
                System.out.println("✓ Usuario desactivado: ID " + idUsuario);
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al eliminar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, null);
        }
        
        return resultado;
    }
    
    /**
     * Obtiene un usuario por ID
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
                u = mapearUsuario(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al obtener usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return u;
    }
    
    /**
     * Lista todos los usuarios activos
     * @return List de usuarios
     */
    public List<Usuario> listarUsuarios() {
        List<Usuario> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM usuarios WHERE estado = 'activo' ORDER BY rol DESC, nombre ASC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
            
            System.out.println("✓ Usuarios activos encontrados: " + lista.size());
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al listar usuarios: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Lista usuarios por rol
     * @param rol Rol del usuario
     * @return List de usuarios del rol especificado
     */
    public List<Usuario> listarUsuariosPorRol(String rol) {
        List<Usuario> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT * FROM usuarios WHERE rol = ? AND estado = 'activo' ORDER BY nombre ASC";
            ps = con.prepareStatement(query);
            ps.setString(1, rol);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al listar usuarios por rol: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return lista;
    }
    
    /**
     * Verifica si existe un usuario (nombre de usuario)
     * @param usuario Nombre de usuario a verificar
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
            System.err.println("✗ ERROR al verificar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return existe;
    }
    
    /**
     * Verifica si existe una identificación
     * @param identificacion Identificación a verificar
     * @return true si existe, false si no
     */
    public boolean existeIdentificacion(String identificacion) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean existe = false;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT COUNT(*) as total FROM usuarios WHERE identificacion = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, identificacion);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                existe = rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al verificar identificación: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return existe;
    }
    
    /**
     * Verifica si existe un email
     * @param email Email a verificar
     * @return true si existe, false si no
     */
    public boolean existeEmail(String email) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean existe = false;
        
        try {
            con = conexion.crearConexion();
            String query = "SELECT COUNT(*) as total FROM usuarios WHERE email = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                existe = rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ ERROR al verificar email: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(con, ps, rs);
        }
        
        return existe;
    }
    
    /**
     * Mapea un ResultSet a un objeto Usuario
     * @param rs ResultSet con datos del usuario
     * @return Usuario mapeado
     * @throws SQLException si hay error al leer datos
     */
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
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
        u.setFechaRegistro(rs.getTimestamp("fecha_registro"));
        return u;
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
            System.err.println("✗ ERROR al cerrar recursos: " + e.getMessage());
        }
    }
}