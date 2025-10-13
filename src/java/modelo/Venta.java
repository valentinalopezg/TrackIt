package modelo;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase modelo para representar una Venta
 * Track!t - Sistema de Gestión de Inventarios
 */
public class Venta {
    
    // Atributos
    private int idVenta;
    private String numeroVenta;
    private int idUsuario;
    private String nombreUsuario; // Para mostrar en listados
    private Timestamp fechaVenta;
    private BigDecimal subtotal;
    private BigDecimal total;
    private String metodoPago;
    private String estado; // 'completada' o 'cancelada'
    
    // Lista de detalles de la venta
    private List<DetalleVenta> detalles;
    
    // Constructor vacío
    public Venta() {
        this.subtotal = BigDecimal.ZERO;
        this.total = BigDecimal.ZERO;
        this.estado = "completada";
        this.detalles = new ArrayList<>();
    }
    
    // Constructor con parámetros principales
    public Venta(String numeroVenta, int idUsuario, BigDecimal subtotal, 
                 BigDecimal total, String metodoPago) {
        this.numeroVenta = numeroVenta;
        this.idUsuario = idUsuario;
        this.subtotal = subtotal;
        this.total = total;
        this.metodoPago = metodoPago;
        this.estado = "completada";
        this.detalles = new ArrayList<>();
    }
    
    // Getters y Setters
    public int getIdVenta() {
        return idVenta;
    }
    
    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }
    
    public String getNumeroVenta() {
        return numeroVenta;
    }
    
    public void setNumeroVenta(String numeroVenta) {
        this.numeroVenta = numeroVenta;
    }
    
    public int getIdUsuario() {
        return idUsuario;
    }
    
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public String getNombreUsuario() {
        return nombreUsuario;
    }
    
    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }
    
    public Timestamp getFechaVenta() {
        return fechaVenta;
    }
    
    public void setFechaVenta(Timestamp fechaVenta) {
        this.fechaVenta = fechaVenta;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public BigDecimal getTotal() {
        return total;
    }
    
    public void setTotal(BigDecimal total) {
        this.total = total;
    }
    
    public String getMetodoPago() {
        return metodoPago;
    }
    
    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public List<DetalleVenta> getDetalles() {
        return detalles;
    }
    
    public void setDetalles(List<DetalleVenta> detalles) {
        this.detalles = detalles;
    }
    
    // Métodos de utilidad
    
    /**
     * Agrega un detalle a la venta
     * @param detalle DetalleVenta a agregar
     */
    public void agregarDetalle(DetalleVenta detalle) {
        this.detalles.add(detalle);
        recalcularTotales();
    }
    
    /**
     * Recalcula los totales de la venta basándose en los detalles
     */
    public void recalcularTotales() {
        BigDecimal suma = BigDecimal.ZERO;
        for (DetalleVenta detalle : detalles) {
            suma = suma.add(detalle.getSubtotal());
        }
        this.subtotal = suma;
        this.total = suma; // En Colombia no hay impuesto adicional en la mayoría de casos
    }
    
    /**
     * Obtiene la cantidad total de productos vendidos
     * @return int con la cantidad total
     */
    public int getCantidadTotalProductos() {
        int total = 0;
        for (DetalleVenta detalle : detalles) {
            total += detalle.getCantidad();
        }
        return total;
    }
    
    /**
     * Verifica si la venta está completada
     * @return true si estado es 'completada'
     */
    public boolean isCompletada() {
        return "completada".equalsIgnoreCase(this.estado);
    }
    
    /**
     * Genera un número de venta automático
     * Formato: V-YYYY-NNNN
     * @param correlativo número correlativo
     * @return String con el número de venta
     */
    public static String generarNumeroVenta(int correlativo) {
        int anio = java.time.Year.now().getValue();
        return String.format("V-%d-%04d", anio, correlativo);
    }
    
    @Override
    public String toString() {
        return "Venta{" +
                "idVenta=" + idVenta +
                ", numeroVenta='" + numeroVenta + '\'' +
                ", usuario='" + nombreUsuario + '\'' +
                ", total=" + total +
                ", metodoPago='" + metodoPago + '\'' +
                ", estado='" + estado + '\'' +
                ", cantidadProductos=" + detalles.size() +
                '}';
    }
}