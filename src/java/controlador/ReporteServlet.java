package controlador;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.VentaDAO;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Usuario user = (Usuario) request.getSession().getAttribute("usuario");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String rol = user.getRol();
            VentaDAO ventaDAO = new VentaDAO();
            Gson gson = new Gson();

            // ------------------------------
            // REPORTES GLOBAL (ADMIN)
            // ------------------------------
            if (rol.equals("admin")) {

                Map<String, Integer> ventasPorDia = ventaDAO.obtenerVentasPorDia();
                Map<String, Integer> productosMasVendidos = ventaDAO.obtenerProductosMasVendidos();
                List<Map<String, Object>> ventasTotales = ventaDAO.obtenerTablaVentas();

                // Convertir a JSON
                request.setAttribute("ventasPorDiaJSON", gson.toJson(ventasPorDia));
                request.setAttribute("productosMasVendidosJSON", gson.toJson(productosMasVendidos));

                // Enviar tabla
                request.setAttribute("ventasTotales", ventasTotales);
            }

            // ------------------------------
            // REPORTES DE VENDEDOR (SOLO SUS VENTAS)
            // ------------------------------
            if (rol.equals("vendedor")) {

                Map<String, Integer> ventasUsuarioPorDia = ventaDAO.obtenerVentasPorDiaUsuario(user.getIdUsuario());
                List<Map<String, Object>> ventasUsuario = ventaDAO.obtenerVentasUsuario(user.getIdUsuario());

                // Convertir a JSON
                request.setAttribute("ventasPorDiaJSON", gson.toJson(ventasUsuarioPorDia));

                // Enviar tabla
                request.setAttribute("ventasUsuario", ventasUsuario);
            }

            request.getRequestDispatcher("reportes/reportes.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error en ReporteServlet: " + e.getMessage());
        }
    }
}