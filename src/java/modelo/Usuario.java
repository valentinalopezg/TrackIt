package modelo;

import java.sql.Timestamp;

/**
 * Clase modelo para representar un Usuario del sistema
 * Track!t - Sistema de Gestión de Inventarios
 */
public class Usuario {
    
    // Atributos
    private int idUsuario;
    private String identificacion;
    private String nombre;
    private String apellido;
    private String email;
    private String usuario;
    private String clave;
    private String rol; // 'admin' o 'vendedor'
    private String estado; // 'activo' o 'inactivo'
    private Timestamp fechaCreacion;
    
    // Constructor vacío
    public Usuario() {
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
    
    // Constructor completo
    public Usuario(int idUsuario, String identificacion, String nombre, 
                   String apellido, String email, String usuario, String clave, 
                   String rol, String estado, Timestamp fechaCreacion) {
        this.idUsuario = idUsuario;
        this.identificacion = identificacion;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.usuario = usuario;
        this.clave = clave;
        this.rol = rol;
        this.estado = estado;
        this.fechaCreacion = fechaCreacion;
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
    
    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }
    
    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
    
    // Método para obtener nombre completo
    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }
    
    // Método para verificar si es admin
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.rol);
    }
    
    // Método para verificar si es vendedor
    public boolean isVendedor() {
        return "vendedor".equalsIgnoreCase(this.rol);
    }
    
    // Método para verificar si está activo
    public boolean isActivo() {
        return "activo".equalsIgnoreCase(this.estado);
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