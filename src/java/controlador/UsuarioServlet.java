package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuario;
import modelo.UsuarioDAO;

/**
 * Servlet para gestionar usuarios (Solo Admin)
 * Track!t - Sistema de Gestión de Inventarios
 */
@WebServlet(name = "UsuarioServlet", urlPatterns = {"/usuario"})
public class UsuarioServlet extends HttpServlet {

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
        
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        if (!usuarioLogueado.isAdmin()) {
            response.sendRedirect("dashboard.jsp?error=noAutorizado");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "listar";
        }
        
        switch (accion) {
            case "agregar":
                agregarUsuario(request, response);
                break;
            case "editar":
                editarUsuario(request, response);
                break;
            case "eliminar":
                eliminarUsuario(request, response);
                break;
            default:
                response.sendRedirect("usuarios/listarUsuarios.jsp");
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
        
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        if (!usuarioLogueado.isAdmin()) {
            response.sendRedirect("dashboard.jsp?error=noAutorizado");
            return;
        }
        
        String accion = request.getParameter("accion");
        
        if ("eliminar".equals(accion)) {
            eliminarUsuario(request, response);
        } else {
            response.sendRedirect("usuarios/listarUsuarios.jsp");
        }
    }
    
    /**
     * Agregar nuevo usuario
     */
    private void agregarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obtener datos del formulario
            String identificacion = request.getParameter("identificacion");
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String email = request.getParameter("email");
            String usuario = request.getParameter("usuario");
            String clave = request.getParameter("clave");
            String rol = request.getParameter("rol");
            
            // Validar que el usuario no exista
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            if (usuarioDAO.existeUsuario(usuario)) {
                request.setAttribute("error", "El nombre de usuario ya existe");
                request.getRequestDispatcher("usuarios/agregarUsuario.jsp").forward(request, response);
                return;
            }
            
            // Crear objeto Usuario
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setIdentificacion(identificacion);
            nuevoUsuario.setNombre(nombre);
            nuevoUsuario.setApellido(apellido);
            nuevoUsuario.setEmail(email);
            nuevoUsuario.setUsuario(usuario);
            nuevoUsuario.setClave(clave);
            nuevoUsuario.setRol(rol);
            nuevoUsuario.setEstado("activo");
            
            // Guardar en la base de datos
            int resultado = usuarioDAO.agregarUsuario(nuevoUsuario);
            
            if (resultado > 0) {
                response.sendRedirect("usuarios/listarUsuarios.jsp?success=agregado");
            } else {
                request.setAttribute("error", "Error al agregar el usuario");
                request.getRequestDispatcher("usuarios/agregarUsuario.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Error al agregar usuario: " + e.getMessage());
            request.getRequestDispatcher("usuarios/agregarUsuario.jsp").forward(request, response);
        }
    }
    
    /**
     * Editar usuario existente
     */
    private void editarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obtener datos del formulario
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String identificacion = request.getParameter("identificacion");
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String email = request.getParameter("email");
            String usuario = request.getParameter("usuario");
            String clave = request.getParameter("clave");
            String rol = request.getParameter("rol");
            String estado = request.getParameter("estado");
            
            // Crear objeto Usuario con datos actualizados
            Usuario usuarioEditado = new Usuario();
            usuarioEditado.setIdUsuario(idUsuario);
            usuarioEditado.setIdentificacion(identificacion);
            usuarioEditado.setNombre(nombre);
            usuarioEditado.setApellido(apellido);
            usuarioEditado.setEmail(email);
            usuarioEditado.setUsuario(usuario);
            usuarioEditado.setClave(clave);
            usuarioEditado.setRol(rol);
            usuarioEditado.setEstado(estado);
            
            // Actualizar en la base de datos
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            int resultado = usuarioDAO.actualizarUsuario(usuarioEditado);
            
            if (resultado > 0) {
                response.sendRedirect("usuarios/listarUsuarios.jsp?success=editado");
            } else {
                response.sendRedirect("usuarios/listarUsuarios.jsp?error=noEditado");
            }
            
        } catch (Exception e) {
            response.sendRedirect("usuarios/listarUsuarios.jsp?error=" + e.getMessage());
        }
    }
    
    /**
     * Eliminar usuario (soft delete)
     */
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            
            // Verificar que no se elimine a sí mismo
            HttpSession session = request.getSession();
            int idUsuarioLogueado = (int) session.getAttribute("idUsuario");
            
            if (idUsuario == idUsuarioLogueado) {
                response.sendRedirect("usuarios/listarUsuarios.jsp?error=noAutoEliminar");
                return;
            }
            
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            int resultado = usuarioDAO.eliminarUsuario(idUsuario);
            
            if (resultado > 0) {
                response.sendRedirect("usuarios/listarUsuarios.jsp?success=eliminado");
            } else {
                response.sendRedirect("usuarios/listarUsuarios.jsp?error=noEliminado");
            }
            
        } catch (Exception e) {
            response.sendRedirect("usuarios/listarUsuarios.jsp?error=" + e.getMessage());
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para gestión de usuarios en Track!t";
    }
}