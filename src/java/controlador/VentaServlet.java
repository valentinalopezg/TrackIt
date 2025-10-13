package controlador;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.DetalleVenta;
import modelo.Producto;
import modelo.ProductoDAO;
import modelo.Venta;
import modelo.VentaDAO;

/**
 * Servlet para procesar ventas (CRÍTICO)
 * Track!t - Sistema de Gestión de Inventarios
 */
@WebServlet(name = "VentaServlet", urlPatterns = {"/venta"})
public class VentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "listar";
        }
        
        switch (accion) {
            case "procesar":
                procesarVenta(request, response, session);
                break;
            case "cancelar":
                cancelarVenta(request, response);
                break;
            default:
                response.sendRedirect("ventas/historialVentas.jsp");
                break;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        response.sendRedirect("ventas/historialVentas.jsp");
    }
    
    /**
     * Método CRÍTICO: Procesa una venta completa
     * 1. Crea la venta
     * 2. Guarda los detalles
     * 3. Actualiza el stock AUTOMÁTICAMENTE
     */
    private void procesarVenta(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        
        try {
            // Obtener ID del usuario logueado
            int idUsuario = (int) session.getAttribute("idUsuario");
            
            // Obtener datos de la venta
            String metodoPago = request.getParameter("metodoPago");
            
            // Obtener arrays de productos del carrito
            String[] idsProductos = request.getParameterValues("idProducto[]");
            String[] cantidades = request.getParameterValues("cantidad[]");
            String[] precios = request.getParameterValues("precioUnitario[]");
            
            // Validar que haya productos
            if (idsProductos == null || idsProductos.length == 0) {
                response.sendRedirect("ventas/nuevaVenta.jsp?error=sinProductos");
                return;
            }
            
            // Generar número de venta
            VentaDAO ventaDAO = new VentaDAO();
            String numeroVenta = ventaDAO.generarNumeroVenta();
            
            // Crear objeto Venta
            Venta venta = new Venta();
            venta.setNumeroVenta(numeroVenta);
            venta.setIdUsuario(idUsuario);
            venta.setMetodoPago(metodoPago);
            venta.setEstado("completada");
            
            // Crear lista de detalles
            List<DetalleVenta> detalles = new ArrayList<>();
            BigDecimal subtotalGeneral = BigDecimal.ZERO;
            
            ProductoDAO productoDAO = new ProductoDAO();
            
            // Procesar cada producto del carrito
            for (int i = 0; i < idsProductos.length; i++) {
                int idProducto = Integer.parseInt(idsProductos[i]);
                int cantidad = Integer.parseInt(cantidades[i]);
                BigDecimal precioUnitario = new BigDecimal(precios[i]);
                
                // Verificar que hay stock suficiente
                Producto producto = productoDAO.obtenerProductoPorId(idProducto);
                if (producto == null) {
                    response.sendRedirect("ventas/nuevaVenta.jsp?error=productoNoExiste");
                    return;
                }
                
                if (producto.getStockActual() < cantidad) {
                    response.sendRedirect("ventas/nuevaVenta.jsp?error=stockInsuficiente&producto=" + producto.getNombre());
                    return;
                }
                
                // Crear detalle de venta
                DetalleVenta detalle = new DetalleVenta();
                detalle.setIdProducto(idProducto);
                detalle.setNombreProducto(producto.getNombre());
                detalle.setCantidad(cantidad);
                detalle.setPrecioUnitario(precioUnitario);
                detalle.setSubtotal(precioUnitario.multiply(new BigDecimal(cantidad)));
                
                detalles.add(detalle);
                subtotalGeneral = subtotalGeneral.add(detalle.getSubtotal());
            }
            
            // Establecer totales
            venta.setSubtotal(subtotalGeneral);
            venta.setTotal(subtotalGeneral); // En Colombia generalmente no hay IVA adicional
            venta.setDetalles(detalles);
            
            // PROCESAR LA VENTA (inserta venta, detalles y actualiza stock)
            int idVentaGenerada = ventaDAO.procesarVenta(venta);
            
            if (idVentaGenerada > 0) {
                // Venta exitosa
                System.out.println("VENTA PROCESADA EXITOSAMENTE: " + numeroVenta);
                
                // Guardar información de la venta en sesión para mostrarla
                session.setAttribute("ultimaVenta", venta);
                session.setAttribute("idUltimaVenta", idVentaGenerada);
                
                // Redirigir a confirmación
                response.sendRedirect("ventas/confirmacionVenta.jsp?numero=" + numeroVenta);
                
            } else {
                // Error al procesar venta
                System.err.println("ERROR: No se pudo procesar la venta");
                response.sendRedirect("ventas/nuevaVenta.jsp?error=errorProcesar");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Error en formato de números: " + e.getMessage());
            response.sendRedirect("ventas/nuevaVenta.jsp?error=formatoInvalido");
            
        } catch (Exception e) {
            System.err.println("Error al procesar venta: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ventas/nuevaVenta.jsp?error=exception&msg=" + e.getMessage());
        }
    }
    
    /**
     * Cancela una venta (solo cambia el estado, NO devuelve stock)
     */
    private void cancelarVenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idVenta = Integer.parseInt(request.getParameter("id"));
            
            VentaDAO ventaDAO = new VentaDAO();
            int resultado = ventaDAO.cancelarVenta(idVenta);
            
            if (resultado > 0) {
                response.sendRedirect("ventas/historialVentas.jsp?success=cancelada");
            } else {
                response.sendRedirect("ventas/historialVentas.jsp?error=noCancelada");
            }
            
        } catch (Exception e) {
            response.sendRedirect("ventas/historialVentas.jsp?error=" + e.getMessage());
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para procesamiento de ventas en Track!t";
    }
}