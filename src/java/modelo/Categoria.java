package modelo;

/**
 * Clase modelo para representar una Categoría de productos
 * Track!t - Sistema de Gestión de Inventarios
 */
public class Categoria {
    
    // Atributos
    private int idCategoria;
    private String nombre;
    private String descripcion;
    private String estado; // 'activa' o 'inactiva'
    
    // Constructor vacío
    public Categoria() {
        this.estado = "activa";
    }
    
    // Constructor con parámetros
    public Categoria(String nombre, String descripcion) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.estado = "activa";
    }
    
    // Constructor completo
    public Categoria(int idCategoria, String nombre, String descripcion, String estado) {
        this.idCategoria = idCategoria;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.estado = estado;
    }
    
    // Getters y Setters
    public int getIdCategoria() {
        return idCategoria;
    }
    
    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    // Métodos de utilidad
    
    /**
     * Verifica si la categoría está activa
     * @return true si estado es 'activa'
     */
    public boolean isActiva() {
        return "activa".equalsIgnoreCase(this.estado);
    }
    
    @Override
    public String toString() {
        return "Categoria{" +
                "idCategoria=" + idCategoria +
                ", nombre='" + nombre + '\'' +
                ", estado='" + estado + '\'' +
                '}';
    }
}