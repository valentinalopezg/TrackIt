package modelo;

import java.math.BigDecimal;

/**
 * Clase modelo para representar el detalle de una venta
 * (Productos incluidos en la venta)
 * Track!t - Sistema de Gestión de Inventarios
 */
public class DetalleVenta {
    
    // Atributos
    private int idDetalle;
    private int idVenta;
    private int idProducto;
    private String nombreProducto; // Para mostrar en listados
    private String codigoProducto; // Para mostrar en listados
    private int cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal subtotal;
    
    // Constructor vacío
    public DetalleVenta() {
        this.cantidad = 0;
        this.precioUnitario = BigDecimal.ZERO;
        this.subtotal = BigDecimal.ZERO;
    }
    
    // Constructor con parámetros principales
    public DetalleVenta(int idVenta, int idProducto, int cantidad, BigDecimal precioUnitario) {
        this.idVenta = idVenta;
        this.idProducto = idProducto;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.subtotal = precioUnitario.multiply(new BigDecimal(cantidad));
    }
    
    // Constructor completo
    public DetalleVenta(int idDetalle, int idVenta, int idProducto, 
                        String nombreProducto, String codigoProducto,
                        int cantidad, BigDecimal precioUnitario, BigDecimal subtotal) {
        this.idDetalle = idDetalle;
        this.idVenta = idVenta;
        this.idProducto = idProducto;
        this.nombreProducto = nombreProducto;
        this.codigoProducto = codigoProducto;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.subtotal = subtotal;
    }
    
    // Getters y Setters
    public int getIdDetalle() {
        return idDetalle;
    }
    
    public void setIdDetalle(int idDetalle) {
        this.idDetalle = idDetalle;
    }
    
    public int getIdVenta() {
        return idVenta;
    }
    
    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }
    
    public int getIdProducto() {
        return idProducto;
    }
    
    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }
    
    public String getNombreProducto() {
        return nombreProducto;
    }
    
    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }
    
    public String getCodigoProducto() {
        return codigoProducto;
    }
    
    public void setCodigoProducto(String codigoProducto) {
        this.codigoProducto = codigoProducto;
    }
    
    public int getCantidad() {
        return cantidad;
    }
    
    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
        recalcularSubtotal();
    }
    
    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }
    
    public void setPrecioUnitario(BigDecimal precioUnitario) {
        this.precioUnitario = precioUnitario;
        recalcularSubtotal();
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    // Métodos de utilidad
    
    /**
     * Recalcula el subtotal basándose en cantidad y precio unitario
     */
    private void recalcularSubtotal() {
        if (precioUnitario != null && cantidad > 0) {
            this.subtotal = precioUnitario.multiply(new BigDecimal(cantidad));
        }
    }
    
    /**
     * Calcula el subtotal manualmente
     * @return BigDecimal con el subtotal calculado
     */
    public BigDecimal calcularSubtotal() {
        return precioUnitario.multiply(new BigDecimal(cantidad));
    }
    
    @Override
    public String toString() {
        return "DetalleVenta{" +
                "idDetalle=" + idDetalle +
                ", producto='" + nombreProducto + '\'' +
                ", cantidad=" + cantidad +
                ", precioUnitario=" + precioUnitario +
                ", subtotal=" + subtotal +
                '}';
    }
}