package controlador;

import modelo.Producto;
import modelo.ProductoDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet para gestionar las operaciones CRUD de productos Track!t - Sistema de
 * Gestión de Inventarios
 */
@WebServlet(name = "ProductoServlet", urlPatterns = {"/producto"})
public class ProductoServlet extends HttpServlet {

    private ProductoDAO productoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productoDAO = new ProductoDAO();
        System.out.println("ProductoServlet inicializado correctamente");
    }

    /**
     * Maneja las peticiones GET (listar, ver, editar)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Establecer codificación UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        // Si no hay acción, por defecto listar
        if (accion == null || accion.isEmpty()) {
            accion = "listar";
        }

        System.out.println("Acción solicitada: " + accion);

        try {
            switch (accion) {
                case "listar":
                    listarProductos(request, response);
                    break;
                case "nuevo":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "editar":
                    mostrarFormularioEditar(request, response);
                    break;
                case "ver":
                    verDetalleProducto(request, response);
                    break;
                case "eliminar":
                    eliminarProducto(request, response);
                    break;
                case "buscar":
                    buscarProductos(request, response);
                    break;
                case "stockBajo":
                    listarStockBajo(request, response);
                    break;
                default:
                    listarProductos(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error en ProductoServlet (GET): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.setAttribute("exception", e);
            try {
                request.getRequestDispatcher("/vistas/error.jsp").forward(request, response);
            } catch (Exception ex) {
                // Si error.jsp no existe, redirigir al dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            }
        }
    }

    /**
     * Maneja las peticiones POST (agregar, actualizar)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Establecer codificación UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        System.out.println("Acción POST solicitada: " + accion);

        try {
            switch (accion) {
                case "agregar":
                    agregarProducto(request, response);
                    break;
                case "actualizar":
                    actualizarProducto(request, response);
                    break;
                default:
                    listarProductos(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error en ProductoServlet (POST): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            listarProductos(request, response);
        }
    }

    /**
     * Lista todos los productos
     */
    private void listarProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Listando productos...");

        List<Producto> listaProductos = productoDAO.listarProductos();

        System.out.println("Productos recuperados: " + listaProductos.size());

        request.setAttribute("listaProductos", listaProductos);
        request.getRequestDispatcher("/productos/listarProducto.jsp").forward(request, response);
    }

    /**
     * Muestra el formulario para crear un nuevo producto
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Mostrando formulario de nuevo producto");
        request.getRequestDispatcher("/productos/agregarProducto.jsp").forward(request, response);
    }

    /**
     * Muestra el formulario para editar un producto existente
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProducto = Integer.parseInt(request.getParameter("id"));
            System.out.println("Editando producto ID: " + idProducto);

            Producto producto = productoDAO.obtenerProductoPorId(idProducto);

            if (producto != null) {
                request.setAttribute("producto", producto);
                request.getRequestDispatcher("/productos/editarProducto.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Producto no encontrado");
                listarProductos(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de producto inválido");
            listarProductos(request, response);
        }
    }

    /**
     * Muestra los detalles de un producto
     */
    private void verDetalleProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProducto = Integer.parseInt(request.getParameter("id"));
            System.out.println("Viendo detalles del producto ID: " + idProducto);

            Producto producto = productoDAO.obtenerProductoPorId(idProducto);

            if (producto != null) {
                request.setAttribute("producto", producto);
                request.getRequestDispatcher("/productos/verProducto.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Producto no encontrado");
                listarProductos(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de producto inválido");
            listarProductos(request, response);
        }
    }

    /**
     * Agrega un nuevo producto
     */
    private void agregarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Crear objeto Producto con los datos del formulario
            Producto producto = new Producto();
            producto.setCodigo(request.getParameter("codigo"));
            producto.setNombre(request.getParameter("nombre"));
            producto.setDescripcion(request.getParameter("descripcion"));
            producto.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
            producto.setPrecioCompra(new BigDecimal(request.getParameter("precioCompra")));
            producto.setPrecioVenta(new BigDecimal(request.getParameter("precioVenta")));
            producto.setStockActual(Integer.parseInt(request.getParameter("stockActual")));
            producto.setStockMinimo(Integer.parseInt(request.getParameter("stockMinimo")));
            producto.setStockMaximo(Integer.parseInt(request.getParameter("stockMaximo")));
            producto.setEstado("activo");

            System.out.println("Agregando producto: " + producto.getNombre());

            // Verificar si el código ya existe
            if (productoDAO.existeCodigo(producto.getCodigo())) {
                request.setAttribute("error", "El código '" + producto.getCodigo() + "' ya existe. Use otro código.");
                request.setAttribute("producto", producto);
                request.getRequestDispatcher("/vistas/crearProducto.jsp").forward(request, response);
                return;
            }

            // Guardar en la base de datos
            int resultado = productoDAO.agregarProducto(producto);

            if (resultado > 0) {
                request.setAttribute("mensaje", "✓ Producto '" + producto.getNombre() + "' agregado exitosamente");
                System.out.println("Producto agregado con éxito");
            } else {
                request.setAttribute("error", "No se pudo agregar el producto");
                System.err.println("Error al agregar producto");
            }

            listarProductos(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error en los datos numéricos: " + e.getMessage());
            request.getRequestDispatcher("/vistas/crearProducto.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error al agregar producto: " + e.getMessage());
            request.getRequestDispatcher("/vistas/crearProducto.jsp").forward(request, response);
        }
    }

    /**
     * Actualiza un producto existente
     */
    private void actualizarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Crear objeto Producto con los datos actualizados
            Producto producto = new Producto();
            producto.setIdProducto(Integer.parseInt(request.getParameter("idProducto")));
            producto.setCodigo(request.getParameter("codigo"));
            producto.setNombre(request.getParameter("nombre"));
            producto.setDescripcion(request.getParameter("descripcion"));
            producto.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
            producto.setPrecioCompra(new BigDecimal(request.getParameter("precioCompra")));
            producto.setPrecioVenta(new BigDecimal(request.getParameter("precioVenta")));
            producto.setStockActual(Integer.parseInt(request.getParameter("stockActual")));
            producto.setStockMinimo(Integer.parseInt(request.getParameter("stockMinimo")));
            producto.setStockMaximo(Integer.parseInt(request.getParameter("stockMaximo")));
            producto.setEstado(request.getParameter("estado"));

            System.out.println("Actualizando producto ID: " + producto.getIdProducto());

            // Actualizar en la base de datos
            int resultado = productoDAO.actualizarProducto(producto);

            if (resultado > 0) {
                request.setAttribute("mensaje", "✓ Producto '" + producto.getNombre() + "' actualizado exitosamente");
                System.out.println("Producto actualizado con éxito");
            } else {
                request.setAttribute("error", "No se pudo actualizar el producto");
                System.err.println("Error al actualizar producto");
            }

            listarProductos(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error en los datos numéricos: " + e.getMessage());
            request.getRequestDispatcher("/vistas/editarProducto.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error al actualizar producto: " + e.getMessage());
            request.getRequestDispatcher("/vistas/editarProducto.jsp").forward(request, response);
        }
    }

    /**
     * Elimina un producto (soft delete - cambia estado a inactivo)
     */
    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProducto = Integer.parseInt(request.getParameter("id"));
            System.out.println("Eliminando producto ID: " + idProducto);

            // Obtener el nombre del producto antes de eliminarlo
            Producto producto = productoDAO.obtenerProductoPorId(idProducto);
            String nombreProducto = (producto != null) ? producto.getNombre() : "Producto";

            int resultado = productoDAO.eliminarProducto(idProducto);

            if (resultado > 0) {
                request.setAttribute("mensaje", "✓ Producto '" + nombreProducto + "' eliminado exitosamente");
                System.out.println("Producto eliminado con éxito");
            } else {
                request.setAttribute("error", "No se pudo eliminar el producto");
                System.err.println("Error al eliminar producto");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de producto inválido");
        } catch (Exception e) {
            request.setAttribute("error", "Error al eliminar producto: " + e.getMessage());
        }

        listarProductos(request, response);
    }

    /**
     * Busca productos por término
     */
    private void buscarProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String termino = request.getParameter("termino");
        System.out.println("Buscando productos con término: " + termino);

        List<Producto> listaProductos;

        if (termino != null && !termino.trim().isEmpty()) {
            listaProductos = productoDAO.buscarProductos(termino);
        } else {
            listaProductos = productoDAO.listarProductos();
        }

        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("terminoBusqueda", termino);
        request.getRequestDispatcher("/vistas/listarProducto.jsp").forward(request, response);
    }

    /**
     * Lista productos con stock bajo
     */
    private void listarStockBajo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Listando productos con stock bajo");

        List<Producto> listaProductos = productoDAO.listarProductosStockBajo();

        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("mensaje", "Mostrando " + listaProductos.size() + " productos con stock bajo");
        request.getRequestDispatcher("/vistas/listarProducto.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestionar productos del inventario Track!t";
    }
}
