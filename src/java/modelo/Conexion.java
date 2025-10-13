package modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase para gestionar la conexión a la base de datos MySQL
 * Track!t - Sistema de Gestión de Inventarios
 */
public class Conexion {
    
    // Configuración de la base de datos
    private static final String USUARIO = "root";
    private static final String CLAVE = "vale1234"; 
    private static final String SERVIDOR = "localhost:3306";
    private static final String BD = "trackit_db";
    
    // URL completa de conexión
    private static final String URL = "jdbc:mysql://" + SERVIDOR + "/" + BD 
            + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"
            + "&useUnicode=true&characterEncoding=UTF-8";
    
    /**
     * Método para crear y retornar una conexión a la base de datos
     * @return Connection objeto de conexión o null si falla
     */
    public Connection crearConexion() {
        Connection conexion = null;
        
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establecer la conexión
            conexion = DriverManager.getConnection(URL, USUARIO, CLAVE);
            
            System.out.println("Conexión exitosa a la base de datos Track!t");
            
        } catch (ClassNotFoundException ex) {
            System.err.println("ERROR: Driver de MySQL no encontrado");
            System.err.println("Detalles: " + ex.getMessage());
            ex.printStackTrace();
        } catch (SQLException ex) {
            System.err.println("ERROR: No se pudo conectar a la base de datos");
            System.err.println("Detalles: " + ex.getMessage());
            ex.printStackTrace();
        }
        
        return conexion;
    }
    
    /**
     * Método para cerrar la conexión de forma segura
     * @param conexion Conexión a cerrar
     */
    public static void cerrarConexion(Connection conexion) {
        if (conexion != null) {
            try {
                conexion.close();
                System.out.println("Conexión cerrada correctamente");
            } catch (SQLException ex) {
                System.err.println("ERROR al cerrar la conexión");
                ex.printStackTrace();
            }
        }
    }
    
    /**
     * Método de prueba para verificar la conexión
     */
     public static void main(String[] args) {
        Conexion cn = new Conexion();
        Connection con = cn.crearConexion();
        
        if (con != null) {
            System.out.println("Prueba de conexión exitosa!");
            cerrarConexion(con);
        } else {
            System.out.println("La conexión falló. Verifica tus credenciales.");
        }
    }
}