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
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String USUARIO = "root";
    private static final String CLAVE = "admin1234"; 
    private static final String SERVIDOR = "localhost";
    private static final String PUERTO = "3306";
    private static final String BD = "trackit_db";
    
    // URL completa de conexión
    private static final String URL = "jdbc:mysql://" + SERVIDOR + ":" + PUERTO + "/" + BD 
            + "?useSSL=false"
            + "&serverTimezone=UTC"
            + "&allowPublicKeyRetrieval=true"
            + "&useUnicode=true"
            + "&characterEncoding=UTF-8";
    
    /**
     * Método para crear y retornar una conexión a la base de datos
     * @return Connection objeto de conexión o null si falla
     */
    public Connection crearConexion() {
        Connection conexion = null;
        
        try {
            // Cargar el driver de MySQL
            Class.forName(DRIVER);
            System.out.println("✓ Driver MySQL cargado correctamente");
            
            // Establecer la conexión
            conexion = DriverManager.getConnection(URL, USUARIO, CLAVE);
            
            if (conexion != null) {
                System.out.println("✓ Conexión exitosa a la base de datos: " + BD);
            }
            
        } catch (ClassNotFoundException ex) {
            System.err.println("✗ ERROR: Driver de MySQL no encontrado");
            System.err.println("   Asegúrate de tener mysql-connector-j en las librerías");
            System.err.println("   Detalles: " + ex.getMessage());
            ex.printStackTrace();
        } catch (SQLException ex) {
            System.err.println("✗ ERROR: No se pudo conectar a la base de datos");
            System.err.println("   Servidor: " + SERVIDOR + ":" + PUERTO);
            System.err.println("   Base de datos: " + BD);
            System.err.println("   Usuario: " + USUARIO);
            System.err.println("   Detalles: " + ex.getMessage());
            System.err.println("   SQLState: " + ex.getSQLState());
            System.err.println("   Error Code: " + ex.getErrorCode());
            ex.printStackTrace();
            
            // Mensajes de ayuda según el código de error
            switch (ex.getErrorCode()) {
                case 1045:
                    System.err.println("   → Verifica el usuario y contraseña");
                    break;
                case 0:
                    System.err.println("   → Verifica que MySQL esté corriendo");
                    System.err.println("   → Verifica el puerto (3306 por defecto)");
                    break;
                case 1049:
                    System.err.println("   → La base de datos '" + BD + "' no existe");
                    System.err.println("   → Créala usando el script SQL proporcionado");
                    break;
            }
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
                System.out.println("✓ Conexión cerrada correctamente");
            } catch (SQLException ex) {
                System.err.println("✗ ERROR al cerrar la conexión");
                ex.printStackTrace();
            }
        }
    }
    
    /**
     * Método de prueba para verificar la conexión
     */
    public static void main(String[] args) {
        System.out.println("=== PRUEBA DE CONEXIÓN A BASE DE DATOS ===");
        System.out.println("Servidor: " + SERVIDOR + ":" + PUERTO);
        System.out.println("Base de datos: " + BD);
        System.out.println("Usuario: " + USUARIO);
        System.out.println("==========================================\n");
        
        Conexion cn = new Conexion();
        Connection con = cn.crearConexion();
        
        if (con != null) {
            System.out.println("\n✓✓✓ PRUEBA EXITOSA - La conexión funciona correctamente ✓✓✓");
            
            // Verificar que podemos hacer queries
            try {
                java.sql.Statement stmt = con.createStatement();
                java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM productos");
                if (rs.next()) {
                    System.out.println("✓ Total de productos en la BD: " + rs.getInt("total"));
                }
                rs.close();
                stmt.close();
            } catch (SQLException e) {
                System.err.println("⚠ Conexión exitosa pero error al consultar: " + e.getMessage());
            }
            
            cerrarConexion(con);
        } else {
            System.out.println("\n✗✗✗ PRUEBA FALLIDA - Revisa los errores arriba ✗✗✗");
            System.out.println("\nPasos para solucionar:");
            System.out.println("1. Verifica que MySQL esté corriendo");
            System.out.println("2. Verifica usuario y contraseña");
            System.out.println("3. Verifica que existe la base de datos: " + BD);
            System.out.println("4. Verifica que tienes el driver mysql-connector-j en las librerías");
        }
    }
}