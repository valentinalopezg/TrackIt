package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet para cerrar sesión
 * Track!t - Sistema de Gestión de Inventarios
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtener la sesión actual
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Obtener nombre de usuario antes de invalidar
            String nombreUsuario = (String) session.getAttribute("nombreUsuario");
            
            // Invalidar la sesión
            session.invalidate();
            
            System.out.println("✓ Sesión cerrada para: " + 
                             (nombreUsuario != null ? nombreUsuario : "usuario desconocido"));
        }
        
        // Redirigir al login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para cerrar sesión en Track!t";
    }
}