package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Categoria;
import modelo.CategoriaDAO;
import modelo.Usuario;

/**
 * Servlet para gestionar categorías (Solo Admin)
 * Track!t - Sistema de Gestión de Inventarios
 */
@WebServlet(name = "CategoriaServlet", urlPatterns = {"/categoria"})
public class CategoriaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Verificar sesión y rol de admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!usuario.isAdmin()) {
            response.sendRedirect("dashboard.jsp?error=noAutorizado");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "listar";
        }
        
        switch (accion) {
            case "agregar":
                agregarCategoria(request, response);
                break;
            case "editar":
                editarCategoria(request, response);
                break;
            case "eliminar":
                eliminarCategoria(request, response);
                break;
            default:
                response.sendRedirect("categorias/listarCategorias.jsp");
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
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!usuario.isAdmin()) {
            response.sendRedirect("dashboard.jsp?error=noAutorizado");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if ("eliminar".equals(accion)) {
            eliminarCategoria(request, response);
        } else {
            response.sendRedirect("categorias/listarCategorias.jsp");
        }
    }
    
    private void agregarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");

            // DEBUG
            System.out.println("=== AGREGAR CATEGORÍA ===");
            System.out.println("Nombre recibido: " + nombre);
            System.out.println("Descripción recibida: " + descripcion);

            // Validaciones
            if (nombre == null || nombre.trim().isEmpty()) {
                System.err.println("ERROR: Nombre vacío");
                request.setAttribute("error", "El nombre de la categoría es obligatorio");
                request.getRequestDispatcher("categorias/agregarCategoria.jsp").forward(request, response);
                return;
            }

            if (nombre.trim().length() < 3) {
                System.err.println("ERROR: Nombre muy corto");
                request.setAttribute("error", "El nombre debe tener al menos 3 caracteres");
                request.getRequestDispatcher("categorias/agregarCategoria.jsp").forward(request, response);
                return;
            }

            // Crear objeto
            Categoria categoria = new Categoria();
            categoria.setNombre(nombre.trim());
            categoria.setDescripcion(descripcion != null && !descripcion.trim().isEmpty() ? descripcion.trim() : null);
            categoria.setEstado("activa");

            System.out.println("Objeto Categoria creado: " + categoria.getNombre());

            // Guardar en BD
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            int resultado = categoriaDAO.agregarCategoria(categoria);

            System.out.println("Resultado de agregar: " + resultado);

            if (resultado > 0) {
                System.out.println("Categoría agregada exitosamente");
                response.sendRedirect("categorias/listarCategorias.jsp?success=agregada");
            } else {
                System.err.println("ERROR: resultado = 0");
                request.setAttribute("error", "No se pudo agregar la categoría");
                request.getRequestDispatcher("categorias/agregarCategoria.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("ERROR: " + e.getMessage());
            e.printStackTrace();

            String mensajeError = "Error al agregar la categoría";

            // Verificar si es SQLException
            if (e instanceof java.sql.SQLException) {
                java.sql.SQLException sqlEx = (java.sql.SQLException) e;
                System.err.println("SQLState: " + sqlEx.getSQLState());
                System.err.println("Error Code: " + sqlEx.getErrorCode());

                if (sqlEx.getSQLState() != null && sqlEx.getSQLState().startsWith("23")) {
                    mensajeError = "Ya existe una categoría con ese nombre";
                } else if (sqlEx.getErrorCode() == 1406) {
                    mensajeError = "El nombre o descripción es demasiado largo";
                } else {
                    mensajeError = "Error de base de datos: " + sqlEx.getMessage();
                }
            }

            request.setAttribute("error", mensajeError);
            request.getRequestDispatcher("categorias/agregarCategoria.jsp").forward(request, response);
        }
    }
    
    private void editarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String estado = request.getParameter("estado");
            
            Categoria categoria = new Categoria();
            categoria.setIdCategoria(idCategoria);
            categoria.setNombre(nombre.trim());
            categoria.setDescripcion(descripcion != null ? descripcion.trim() : "");
            categoria.setEstado(estado);
            
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            int resultado = categoriaDAO.actualizarCategoria(categoria);
            
            if (resultado > 0) {
                response.sendRedirect("categorias/listarCategorias.jsp?success=editada");
            } else {
                response.sendRedirect("categorias/listarCategorias.jsp?error=noEditada");
            }
            
        } catch (Exception e) {
            response.sendRedirect("categorias/listarCategorias.jsp?error=" + e.getMessage());
        }
    }
    
    private void eliminarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idCategoria = Integer.parseInt(request.getParameter("id"));
            
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            int resultado = categoriaDAO.eliminarCategoria(idCategoria);
            
            if (resultado > 0) {
                response.sendRedirect("categorias/listarCategorias.jsp?success=eliminada");
            } else {
                response.sendRedirect("categorias/listarCategorias.jsp?error=noEliminada");
            }
            
        } catch (Exception e) {
            response.sendRedirect("categorias/listarCategorias.jsp?error=" + e.getMessage());
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para gestión de categorías en Track!t";
    }
}