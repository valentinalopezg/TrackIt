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
            
            Categoria categoria = new Categoria();
            categoria.setNombre(nombre);
            categoria.setDescripcion(descripcion);
            categoria.setEstado("activa");
            
            CategoriaDAO categoriaDAO = new CategoriaDAO();
            int resultado = categoriaDAO.agregarCategoria(categoria);
            
            if (resultado > 0) {
                response.sendRedirect("categorias/listarCategorias.jsp?success=agregada");
            } else {
                request.setAttribute("error", "Error al agregar la categoría");
                request.getRequestDispatcher("categorias/agregarCategoria.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
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
            categoria.setNombre(nombre);
            categoria.setDescripcion(descripcion);
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