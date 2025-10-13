package controlador;

import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Producto;
import modelo.ProductoDAO;

/**
 * Servlet para gestionar productos (Agregar, Editar, Eliminar)
 * Track!t - Sistema de Gestión de Inventarios
 */
@WebServlet(name = "ProductoServlet", urlPatterns = {"/producto"})
public class ProductoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Obtener la acción a realizar
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "listar";
        }
        
        switch (accion) {
            case "agregar":
                agregarProducto(request, response);
                break;
            case "editar":
                editarProducto(request, response);
                break;
            case "eliminar":
                eliminarProducto(request, response);
                break;
            default:
                response.sendRedirect("productos/listarProductos.jsp");
                break;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if ("eliminar".equals(accion)) {
            eliminarProducto(request, response);
        } else {
            response.sendRedirect("productos/listarProductos.jsp");
        }
    }
    
    /**
     * Método para agregar un nuevo producto
     */
    private void agregarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obtener datos del formulario
            String codigo = request.getParameter("codigo");
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
            BigDecimal precioCompra = new BigDecimal(request.getParameter("precioCompra"));
            BigDecimal precioVenta = new BigDecimal(request.getParameter("precioVenta"));
            int stockActual = Integer.parseInt(request.getParameter("stockActual"));
            int stockMinimo = Integer.parseInt(request.getParameter("stockMinimo"));
            int stockMaximo = Integer.parseInt(request.getParameter("stockMaximo"));
            
            // Validar que el código no exista
            ProductoDAO productoDAO = new ProductoDAO();
            if (productoDAO.existeCodigo(codigo)) {
                request.setAttribute("error", "El código de producto ya existe");
                request.getRequestDispatcher("productos/agregarProducto.jsp").forward(request, response);
                return;
            }
            
            // Crear objeto Producto
            Producto producto = new Producto();
            producto.setCodigo(codigo);
            producto.setNombre(nombre);
            producto.setDescripcion(descripcion);
            producto.setIdCategoria(idCategoria);
            producto.setPrecioCompra(precioCompra);
            producto.setPrecioVenta(precioVenta);
            producto.setStockActual(stockActual);
            producto.setStockMinimo(stockMinimo);
            producto.setStockMaximo(stockMaximo);
            producto.setEstado("activo");
            
            // Guardar en la base de datos
            int resultado = productoDAO.agregarProducto(producto);
            
            if (resultado > 0) {
                request.setAttribute("success", "Producto agregado exitosamente");
                response.sendRedirect("productos/listarProductos.jsp?success=agregado");
            } else {
                request.setAttribute("error", "Error al agregar el producto");
                request.getRequestDispatcher("productos/agregarProducto.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error en los datos numéricos: " + e.getMessage());
            request.getRequestDispatcher("productos/agregarProducto.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error al agregar producto: " + e.getMessage());
            request.getRequestDispatcher("productos/agregarProducto.jsp").forward(request, response);
        }
    }
    
    /**
     * Método para editar un producto existente
     */
    private void editarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obtener datos del formulario
            int idProducto = Integer.parseInt(request.getParameter("idProducto"));
            String codigo = request.getParameter("codigo");
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
            BigDecimal precioCompra = new BigDecimal(request.getParameter("precioCompra"));
            BigDecimal precioVenta = new BigDecimal(request.getParameter("precioVenta"));
            int stockActual = Integer.parseInt(request.getParameter("stockActual"));
            int stockMinimo = Integer.parseInt(request.getParameter("stockMinimo"));
            int stockMaximo = Integer.parseInt(request.getParameter("stockMaximo"));
            String estado = request.getParameter("estado");
            
            // Crear objeto Producto con los datos actualizados
            Producto producto = new Producto();
            producto.setIdProducto(idProducto);
            producto.setCodigo(codigo);
            producto.setNombre(nombre);
            producto.setDescripcion(descripcion);
            producto.setIdCategoria(idCategoria);
            producto.setPrecioCompra(precioCompra);
            producto.setPrecioVenta(precioVenta);
            producto.setStockActual(stockActual);
            producto.setStockMinimo(stockMinimo);
            producto.setStockMaximo(stockMaximo);
            producto.setEstado(estado);
            
            // Actualizar en la base de datos
            ProductoDAO productoDAO = new ProductoDAO();
            int resultado = productoDAO.actualizarProducto(producto);
            
            if (resultado > 0) {
                response.sendRedirect("productos/listarProductos.jsp?success=editado");
            } else {
                request.setAttribute("error", "Error al actualizar el producto");
                request.getRequestDispatcher("productos/editarProducto.jsp?id=" + idProducto).forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error en los datos numéricos: " + e.getMessage());
            request.getRequestDispatcher("productos/listarProductos.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error al editar producto: " + e.getMessage());
            request.getRequestDispatcher("productos/listarProductos.jsp").forward(request, response);
        }
    }
    
    /**
     * Método para eliminar un producto (soft delete)
     */
    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idProducto = Integer.parseInt(request.getParameter("id"));
            
            ProductoDAO productoDAO = new ProductoDAO();
            int resultado = productoDAO.eliminarProducto(idProducto);
            
            if (resultado > 0) {
                response.sendRedirect("productos/listarProductos.jsp?success=eliminado");
            } else {
                response.sendRedirect("productos/listarProductos.jsp?error=noEliminado");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("productos/listarProductos.jsp?error=idInvalido");
        } catch (Exception e) {
            response.sendRedirect("productos/listarProductos.jsp?error=" + e.getMessage());
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para gestión de productos en Track!t";
    }
}