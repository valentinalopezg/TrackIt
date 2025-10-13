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
 * Servlet para manejar el inicio de sesión
 * Track!t - Sistema de Gestión de Inventarios
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar encoding para caracteres especiales
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Obtener parámetros del formulario
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("password");
        
        // Validar que no vengan vacíos
        if (usuario == null || usuario.trim().isEmpty() || 
            clave == null || clave.trim().isEmpty()) {
            
            // Redirigir con mensaje de error
            request.setAttribute("error", "Por favor ingrese usuario y contraseña");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Validar credenciales en la base de datos
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuarioLogueado = usuarioDAO.validarLogin(usuario.trim(), clave.trim());
        
        if (usuarioLogueado != null) {
            // Login exitoso - Crear sesión
            HttpSession session = request.getSession();
            
            // Guardar información del usuario en la sesión
            session.setAttribute("usuario", usuarioLogueado);
            session.setAttribute("idUsuario", usuarioLogueado.getIdUsuario());
            session.setAttribute("nombreUsuario", usuarioLogueado.getNombreCompleto());
            session.setAttribute("rolUsuario", usuarioLogueado.getRol());
            session.setAttribute("usuarioLogueado", usuarioLogueado.getUsuario());
            
            // Configurar tiempo de sesión (30 minutos)
            session.setMaxInactiveInterval(30 * 60);
            
            System.out.println("Login exitoso: " + usuarioLogueado.getNombreCompleto() 
                             + " (" + usuarioLogueado.getRol() + ")");
            
            // Redirigir al dashboard
            response.sendRedirect("dashboard.jsp");
            
        } else {
            // Login fallido
            System.out.println("Login fallido para usuario: " + usuario);
            
            // Redirigir a login con mensaje de error
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si acceden por GET, redirigir al login
        response.sendRedirect("login.jsp");
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet de autenticación para Track!t";
    }
}