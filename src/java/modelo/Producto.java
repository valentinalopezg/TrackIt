package modelo;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Clase modelo para representar un Producto del inventario
 * Track!t - Sistema de Gestión de Inventarios
 */
public class Producto {
    
    // Atributos
    private int idProducto;
    private String codigo;
    private String nombre;
    private String descripcion;
    private int idCategoria;
    private String nombreCategoria; // Para mostrar en listados
    private BigDecimal precioCompra;
    private BigDecimal precioVenta;
    private int stockActual;
    private int stockMinimo;
    private int stockMaximo;
    private String estado; // 'activo' o 'inactivo'
    private Timestamp fechaCreacion;
    
    // Constructor vacío
    public Producto() {
        this.precioCompra = BigDecimal.ZERO;
        this.precioVenta = BigDecimal.ZERO;
        this.stockActual = 0;
        this.stockMinimo = 10;
        this.stockMaximo = 1000;
        this.estado = "activo";
    }
    
    // Constructor con parámetros principales
    public Producto(String codigo, String nombre, String descripcion, 
                    int idCategoria, BigDecimal precioCompra, 
                    BigDecimal precioVenta, int stockActual, int stockMinimo) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.idCategoria = idCategoria;
        this.precioCompra = precioCompra;
        this.precioVenta = precioVenta;
        this.stockActual = stockActual;
        this.stockMinimo = stockMinimo;
        this.estado = "activo";
    }
    
    // Getters y Setters
    public int getIdProducto() {
        return idProducto;
    }
    
    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
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
    
    public int getIdCategoria() {
        return idCategoria;
    }
    
    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }
    
    public String getNombreCategoria() {
        return nombreCategoria;
    }
    
    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }
    
    public BigDecimal getPrecioCompra() {
        return precioCompra;
    }
    
    public void setPrecioCompra(BigDecimal precioCompra) {
        this.precioCompra = precioCompra;
    }
    
    public BigDecimal getPrecioVenta() {
        return precioVenta;
    }
    
    public void setPrecioVenta(BigDecimal precioVenta) {
        this.precioVenta = precioVenta;
    }
    
    public int getStockActual() {
        return stockActual;
    }
    
    public void setStockActual(int stockActual) {
        this.stockActual = stockActual;
    }
    
    public int getStockMinimo() {
        return stockMinimo;
    }
    
    public void setStockMinimo(int stockMinimo) {
        this.stockMinimo = stockMinimo;
    }
    
    public int getStockMaximo() {
        return stockMaximo;
    }
    
    public void setStockMaximo(int stockMaximo) {
        this.stockMaximo = stockMaximo;
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
    
    // Métodos de utilidad
    
    /**
     * Calcula el margen de ganancia del producto
     * @return BigDecimal con el margen de ganancia
     */
    public BigDecimal calcularMargenGanancia() {
        if (precioCompra.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return precioVenta.subtract(precioCompra);
    }
    
    /**
     * Calcula el porcentaje de ganancia
     * @return double con el porcentaje
     */
    public double calcularPorcentajeGanancia() {
        if (precioCompra.compareTo(BigDecimal.ZERO) == 0) {
            return 0.0;
        }
        BigDecimal margen = calcularMargenGanancia();
        return margen.divide(precioCompra, 4, BigDecimal.ROUND_HALF_UP)
                .multiply(new BigDecimal("100")).doubleValue();
    }
    
    /**
     * Verifica si el producto tiene stock bajo
     * @return true si stock <= stockMinimo
     */
    public boolean tieneStockBajo() {
        return stockActual <= stockMinimo;
    }
    
    /**
     * Verifica si el producto está agotado
     * @return true si stock == 0
     */
    public boolean estaAgotado() {
        return stockActual == 0;
    }
    
    /**
     * Verifica si el producto está en stock crítico
     * @return true si stock <= stockMinimo * 0.5
     */
    public boolean estaEnStockCritico() {
        return stockActual <= (stockMinimo * 0.5);
    }
    
    /**
     * Obtiene el estado del stock como texto
     * @return String con el estado
     */
    public String getEstadoStock() {
        if (estaAgotado()) {
            return "AGOTADO";
        } else if (estaEnStockCritico()) {
            return "CRÍTICO";
        } else if (tieneStockBajo()) {
            return "BAJO";
        } else {
            return "DISPONIBLE";
        }
    }
    
    /**
     * Calcula el valor total del inventario de este producto
     * @return BigDecimal con el valor total
     */
    public BigDecimal calcularValorInventario() {
        return precioVenta.multiply(new BigDecimal(stockActual));
    }
    
    /**
     * Verifica si el producto está activo
     * @return true si estado es 'activo'
     */
    public boolean isActivo() {
        return "activo".equalsIgnoreCase(this.estado);
    }
    
    @Override
    public String toString() {
        return "Producto{" +
                "idProducto=" + idProducto +
                ", codigo='" + codigo + '\'' +
                ", nombre='" + nombre + '\'' +
                ", categoria='" + nombreCategoria + '\'' +
                ", precioVenta=" + precioVenta +
                ", stockActual=" + stockActual +
                ", estado='" + estado + '\'' +
                '}';
    }
}