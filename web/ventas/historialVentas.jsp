<%-- 
    Document   : historialVentas
    Created on : 12/10/2025, 9:23:20 p. m.
    Author     : Valentina
--%>

<%@page import="modelo.VentaDAO"%>
<%@page import="modelo.Venta"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar sesión
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Obtener ventas
    VentaDAO ventaDAO = new VentaDAO();
    List<Venta> ventas = ventaDAO.listarVentas();
    
    NumberFormat formatoMoneda = NumberFormat.getCurrencyInstance(new Locale("es", "CO"));
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Ventas - Track!t</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/dashboard.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="row mb-4">
            <div class="col-md-6">
                <h2><i class="fas fa-receipt me-2"></i>Historial de Ventas</h2>
                <p class="text-muted">Registro completo de todas las ventas</p>
            </div>
            <div class="col-md-6 text-end">
                <a href="nuevaVenta.jsp" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Nueva Venta
                </a>
                <a href="../dashboard.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Volver
                </a>
            </div>
        </div>

        <!-- Alertas -->
        <% 
            String success = request.getParameter("success");
            if (success != null) {
                String mensaje = "";
                switch(success) {
                    case "procesada": mensaje = "Venta procesada exitosamente"; break;
                    case "cancelada": mensaje = "Venta cancelada"; break;
                }
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Estadísticas rápidas -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="text-primary"><%= ventas != null ? ventas.size() : 0 %></h3>
                        <p class="text-muted mb-0">Total Ventas</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="text-success"><%= ventaDAO.contarVentasDelDia() %></h3>
                        <p class="text-muted mb-0">Ventas Hoy</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="text-success"><%= formatoMoneda.format(ventaDAO.obtenerTotalVentasDelDia()) %></h3>
                        <p class="text-muted mb-0">Total Hoy</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="text-info">
                            <%= formatoMoneda.format(
                                ventas != null && !ventas.isEmpty() ? 
                                ventas.stream()
                                      .filter(v -> v.isCompletada())
                                      .mapToDouble(v -> v.getTotal().doubleValue())
                                      .average()
                                      .orElse(0.0) 
                                : 0.0
                            ) %>
                        </h3>
                        <p class="text-muted mb-0">Promedio Venta</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filtros -->
        <div class="card mb-3">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <input type="text" 
                                   class="form-control" 
                                   id="buscarVenta" 
                                   placeholder="Buscar por número o usuario">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroEstado">
                            <option value="">Todos los estados</option>
                            <option value="completada">Completadas</option>
                            <option value="cancelada">Canceladas</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroMetodoPago">
                            <option value="">Todos los métodos</option>
                            <option value="Efectivo">Efectivo</option>
                            <option value="Tarjeta">Tarjeta</option>
                            <option value="Transferencia">Transferencia</option>
                            <option value="Mixto">Mixto</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-outline-primary w-100" onclick="exportarExcel()">
                            <i class="fas fa-file-excel me-2"></i>Exportar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de ventas -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="tablaVentas">
                        <thead class="table-dark">
                            <tr>
                                <th>Número Venta</th>
                                <th>Fecha</th>
                                <th>Usuario</th>
                                <th>Total</th>
                                <th>Método Pago</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (ventas != null && !ventas.isEmpty()) {
                                    for (Venta v : ventas) {
                            %>
                            <tr>
                                <td><strong><%= v.getNumeroVenta() %></strong></td>
                                <td><%= formatoFecha.format(v.getFechaVenta()) %></td>
                                <td><%= v.getNombreUsuario() %></td>
                                <td><strong class="text-success"><%= formatoMoneda.format(v.getTotal()) %></strong></td>
                                <td>
                                    <span class="badge bg-info"><%= v.getMetodoPago() %></span>
                                </td>
                                <td>
                                    <% if (v.isCompletada()) { %>
                                        <span class="badge bg-success">Completada</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary">Cancelada</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <a href="detalleVenta.jsp?id=<%= v.getIdVenta() %>" 
                                       class="btn btn-sm btn-info" 
                                       title="Ver Detalle">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <% if (v.isCompletada()) { %>
                                    <button class="btn btn-sm btn-primary" 
                                            onclick="imprimirTicket(<%= v.getIdVenta() %>)"
                                            title="Imprimir">
                                        <i class="fas fa-print"></i>
                                    </button>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" class="text-center py-4">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <p class="text-muted">No hay ventas registradas</p>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Búsqueda en tiempo real
        document.getElementById('buscarVenta').addEventListener('keyup', function() {
            const filtro = this.value.toLowerCase();
            const filas = document.querySelectorAll('#tablaVentas tbody tr');
            
            filas.forEach(fila => {
                const texto = fila.textContent.toLowerCase();
                fila.style.display = texto.includes(filtro) ? '' : 'none';
            });
        });

        // Filtro por estado
        document.getElementById('filtroEstado').addEventListener('change', function() {
            const filtro = this.value.toLowerCase();
            const filas = document.querySelectorAll('#tablaVentas tbody tr');
            
            if (filtro === '') {
                filas.forEach(fila => fila.style.display = '');
                return;
            }
            
            filas.forEach(fila => {
                const estadoCell = fila.cells[5];
                if (estadoCell) {
                    const texto = estadoCell.textContent.toLowerCase();
                    fila.style.display = texto.includes(filtro) ? '' : 'none';
                }
            });
        });

        // Filtro por método de pago
        document.getElementById('filtroMetodoPago').addEventListener('change', function() {
            const filtro = this.value;
            const filas = document.querySelectorAll('#tablaVentas tbody tr');
            
            if (filtro === '') {
                filas.forEach(fila => fila.style.display = '');
                return;
            }
            
            filas.forEach(fila => {
                const metodoCell = fila.cells[4];
                if (metodoCell) {
                    const texto = metodoCell.textContent;
                    fila.style.display = texto.includes(filtro) ? '' : 'none';
                }
            });
        });

        // Función para imprimir ticket
        function imprimirTicket(idVenta) {
            window.open('imprimirTicket.jsp?id=' + idVenta, '_blank', 'width=300,height=600');
        }

        // Función para exportar (simulada)
        function exportarExcel() {
            alert('Función de exportación en desarrollo. Los datos se exportarán a Excel.');
        }
    </script>
</body>
</html>
