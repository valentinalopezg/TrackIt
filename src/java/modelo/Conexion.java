package modelo;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Clase para gestionar la conexión a la base de datos MySQL
 * Track!t - Sistema de Gestión de Inventarios
 * Ahora lee credenciales desde db.properties para evitar conflictos en Git
 */
public class Conexion {
    
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static String USUARIO;
    private static String CLAVE;
    private static String SERVIDOR;
    private static String PUERTO;
    private static String BD;
    private static String URL;
    
    // Bloque estático que se ejecuta al cargar la clase
    static {
        cargarConfiguracion();
    }
    
    /**
     * Carga la configuración desde db.properties
     * Si no existe el archivo, usa valores por defecto
     */
    private static void cargarConfiguracion() {
        Properties props = new Properties();
        boolean cargado = false;
        
        // PRIMERO: Intentar desde el classpath (cuando está desplegado en Tomcat)
        // Este archivo debe estar en web/WEB-INF/classes/db.properties
        try (InputStream is = Conexion.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
                cargado = true;
                System.out.println("✓ Configuración cargada desde classpath (db.properties)");
            }
        } catch (IOException e) {
            // Continuar con archivos locales
        }
        
        // SEGUNDO: Si no se cargó, intentar desde archivos del sistema (desarrollo local)
        if (!cargado) {
            String[] rutas = {
                "web/WEB-INF/classes/db.properties",
                "src/db.properties",
                "db.properties"
            };
            
            for (String ruta : rutas) {
                try (FileInputStream fis = new FileInputStream(ruta)) {
                    props.load(fis);
                    cargado = true;
                    System.out.println("✓ Configuración cargada desde: " + ruta);
                    break;
                } catch (IOException e) {
                    // Continuar con la siguiente ruta
                }
            }
        }
        
        if (cargado) {
            // Cargar valores desde el archivo
            USUARIO = props.getProperty("db.usuario", "root");
            CLAVE = props.getProperty("db.clave", "");
            SERVIDOR = props.getProperty("db.servidor", "localhost");
            PUERTO = props.getProperty("db.puerto", "3306");
            BD = props.getProperty("db.nombre", "trackit_db");
        } else {
            // Valores por defecto si no existe el archivo
            System.err.println("⚠ ADVERTENCIA: No se encontró db.properties");
            System.err.println("   Asegúrate de que web/WEB-INF/classes/db.properties existe");
            System.err.println("   O créalo con estas propiedades:");
            System.err.println("   db.usuario=root");
            System.err.println("   db.clave=tu_password");
            System.err.println("   db.servidor=localhost");
            System.err.println("   db.puerto=3306");
            System.err.println("   db.nombre=trackit_db");
            
            USUARIO = "root";
            CLAVE = ""; // ← Esto probablemente fallará
            SERVIDOR = "localhost";
            PUERTO = "3306";
            BD = "trackit_db";
        }
        
        construirURL();
    }
    
    /**
     * Construye la URL de conexión con los parámetros configurados
     */
    private static void construirURL() {
        URL = "jdbc:mysql://" + SERVIDOR + ":" + PUERTO + "/" + BD 
            + "?useSSL=false"
            + "&serverTimezone=UTC"
            + "&allowPublicKeyRetrieval=true"
            + "&useUnicode=true"
            + "&characterEncoding=UTF-8";
    }
    
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
                    System.err.println("   → Verifica el usuario y contraseña en db.properties");
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
        System.out.println("Contraseña: " + (CLAVE.isEmpty() ? "(vacía)" : "***"));
        System.out.println("==========================================\n");
        
        Conexion cn = new Conexion();
        Connection con = cn.crearConexion();
        
        if (con != null) {
            System.out.println("\n✓✓✓ PRUEBA EXITOSA - La conexión funciona correctamente ✓✓✓");
            
            // Verificar que podemos hacer queries
            try {
                java.sql.Statement stmt = con.createStatement();
                java.sql.ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM usuarios");
                if (rs.next()) {
                    System.out.println("✓ Total de usuarios en la BD: " + rs.getInt("total"));
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
            System.out.println("1. Crea el archivo src/db.properties con tus credenciales");
            System.out.println("2. Verifica que MySQL esté corriendo");
            System.out.println("3. Verifica que existe la base de datos: " + BD);
            System.out.println("4. Verifica que tienes el driver mysql-connector-j en las librerías");
        }
    }
}