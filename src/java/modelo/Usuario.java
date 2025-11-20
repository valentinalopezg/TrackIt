package modelo;

import java.sql.Timestamp;

/**
 * Clase modelo para Usuario del sistema
 * Track!t - Sistema de Gestión de Inventarios
 */
public class Usuario {
    
    // Atributos según la BD existente
    private int idUsuario;
    private String identificacion;
    private String nombre;
    private String apellido;
    private String email;
    private String usuario;
    private String clave;
    private String rol; // 'admin' o 'vendedor'
    private String estado; // 'activo' o 'inactivo'
    private Timestamp fechaRegistro;
    
    // Constructor vacío
    public Usuario() {
        this.estado = "activo";
        this.rol = "vendedor";
    }
    
    // Constructor con parámetros principales
    public Usuario(String identificacion, String nombre, String apellido, 
                   String email, String usuario, String clave, String rol) {
        this.identificacion = identificacion;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.usuario = usuario;
        this.clave = clave;
        this.rol = rol;
        this.estado = "activo";
    }
    
    // Getters y Setters
    public int getIdUsuario() {
        return idUsuario;
    }
    
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public String getIdentificacion() {
        return identificacion;
    }
    
    public void setIdentificacion(String identificacion) {
        this.identificacion = identificacion;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getApellido() {
        return apellido;
    }
    
    public void setApellido(String apellido) {
        this.apellido = apellido;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getUsuario() {
        return usuario;
    }
    
    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }
    
    public String getClave() {
        return clave;
    }
    
    public void setClave(String clave) {
        this.clave = clave;
    }
    
    public String getRol() {
        return rol;
    }
    
    public void setRol(String rol) {
        this.rol = rol;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }
    
    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
    // Métodos de utilidad
    
    /**
     * Obtiene el nombre completo del usuario
     * @return String con nombre completo
     */
    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }
    
    /**
     * Verifica si el usuario es administrador
     * @return true si es admin
     */
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.rol);
    }
    
    /**
     * Verifica si el usuario es vendedor
     * @return true si es vendedor
     */
    public boolean isVendedor() {
        return "vendedor".equalsIgnoreCase(this.rol);
    }
    
    /**
     * Verifica si el usuario está activo
     * @return true si estado es 'activo'
     */
    public boolean isActivo() {
        return "activo".equalsIgnoreCase(this.estado);
    }
    
    /**
     * Obtiene las iniciales del usuario para el avatar
     * @return String con las iniciales
     */
    public String getIniciales() {
        String inicialNombre = nombre != null && !nombre.isEmpty() ? nombre.substring(0, 1) : "";
        String inicialApellido = apellido != null && !apellido.isEmpty() ? apellido.substring(0, 1) : "";
        return (inicialNombre + inicialApellido).toUpperCase();
    }
    
    /**
     * Obtiene el nombre del rol en español
     * @return String con el nombre del rol
     */
    public String getRolNombre() {
        return "admin".equalsIgnoreCase(rol) ? "Administrador" : "Vendedor";
    }
    
    /**
     * Obtiene el color del badge según el rol
     * @return String con la clase CSS
     */
    public String getRolColor() {
        return "admin".equalsIgnoreCase(rol) ? "danger" : "info";
    }
    
    /**
     * Obtiene el icono según el rol
     * @return String con el icono de Font Awesome
     */
    public String getRolIcono() {
        return "admin".equalsIgnoreCase(rol) ? "fa-user-shield" : "fa-user";
    }
    
    @Override
    public String toString() {
        return "Usuario{" +
                "idUsuario=" + idUsuario +
                ", identificacion='" + identificacion + '\'' +
                ", nombre='" + nombre + '\'' +
                ", apellido='" + apellido + '\'' +
                ", usuario='" + usuario + '\'' +
                ", rol='" + rol + '\'' +
                ", estado='" + estado + '\'' +
                '}';
    }
}