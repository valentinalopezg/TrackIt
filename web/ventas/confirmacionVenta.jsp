<%-- 
    Document   : confirmacionVenta
    Created on : 12/10/2025, 9:23:43 p. m.
    Author     : Valentina
--%>

<%@page import="modelo.Venta"%>
<%@page import="modelo.DetalleVenta"%>
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
    
    // Obtener venta de la sesión
    Venta venta = (Venta) session.getAttribute("ultimaVenta");
    String numeroVenta = request.getParameter("numero");
    
    if (venta == null) {
        response.sendRedirect("nuevaVenta.jsp");
        return;
    }
    
    NumberFormat formatoMoneda = NumberFormat.getCurrencyInstance(new Locale("es", "CO"));
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Venta Exitosa - Track!t</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/dashboard.css" rel="stylesheet">
    <style>
        .success-animation {
            text-align: center;
            padding: 2rem;
        }
        .success-checkmark {
            width: 80px;
            height: 80px;
            margin: 0 auto;
        }
        .success-checkmark .check-icon {
            width: 80px;
            height: 80px;
            position: relative;
            border-radius: 50%;
            box-sizing: content-box;
            border: 4px solid #4CAF50;
        }
        .success-checkmark .check-icon::before {
            top: 3px;
            left: -2px;
            width: 30px;
            transform-origin: 100% 50%;
            border-radius: 100px 0 0 100px;
        }
        .success-checkmark .check-icon::after {
            top: 0;
            left: 30px;
            width: 60px;
            transform-origin: 0 50%;
            border-radius: 0 100px 100px 0;
            animation: rotate-circle 4.25s ease-in;
        }
        .success-checkmark .check-icon::before,
        .success-checkmark .check-icon::after {
            content: '';
            height: 100px;
            position: absolute;
            background: #FFFFFF;
            transform: rotate(-45deg);
        }
        .success-checkmark .check-icon .icon-line {
            height: 5px;
            background-color: #4CAF50;
            display: block;
            border-radius: 2px;
            position: absolute;
            z-index: 10;
        }
        .success-checkmark .check-icon .icon-line.line-tip {
            top: 46px;
            left: 14px;
            width: 25px;
            transform: rotate(45deg);
            animation: icon-line-tip 0.75s;
        }
        .success-checkmark .check-icon .icon-line.line-long {
            top: 38px;
            right: 8px;
            width: 47px;
            transform: rotate(-45deg);
            animation: icon-line-long 0.75s;
        }
        @keyframes icon-line-tip {
            0% { width: 0; left: 1px; top: 19px; }
            54% { width: 0; left: 1px; top: 19px; }
            70% { width: 50px; left: -8px; top: 37px; }
            84% { width: 17px; left: 21px; top: 48px; }
            100% { width: 25px; left: 14px; top: 45px; }
        }
        @keyframes icon-line-long {
            0% { width: 0; right: 46px; top: 54px; }
            65% { width: 0; right: 46px; top: 54px; }
            84% { width: 55px; right: 0px; top: 35px; }
            100% { width: 47px; right: 8px; top: 38px; }
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <!-- Animación de éxito -->
                <div class="success-animation">
                    <div class="success-checkmark">
                        <div class="check-icon">
                            <span class="icon-line line-tip"></span>
                            <span class="icon-line line-long"></span>
                            <div class="icon-circle"></div>
                            <div class="icon-fix"></div>
                        </div>
                    </div>
                    <h2 class="text-success mt-4">¡Venta Procesada Exitosamente!</h2>
                    <p class="text-muted">La venta ha sido registrada correctamente</p>
                </div>

                <!-- Detalles de la venta -->
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-receipt me-2"></i>Resumen de la Venta</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <p><strong>Número de Venta:</strong><br>
                                   <span class="fs-5 text-primary"><%= venta.getNumeroVenta() %></span></p>
                            </div>
                            <div class="col-md-6 text-end">
                                <p><strong>Fecha:</strong><br>
                                   <%= formatoFecha.format(new java.util.Date()) %></p>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <p><strong>Método de Pago:</strong><br>
                                   <span class="badge bg-info fs-6"><%= venta.getMetodoPago() %></span></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Vendedor:</strong><br>
                                   <%= session.getAttribute("nombreUsuario") %></p>
                            </div>
                        </div>

                        <hr>

                        <h6 class="mb-3"><i class="fas fa-shopping-cart me-2"></i>Productos Vendidos</h6>
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead class="table-light">
                                    <tr>
                                        <th>Producto</th>
                                        <th class="text-center">Cantidad</th>
                                        <th class="text-end">Precio Unit.</th>
                                        <th class="text-end">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        if (venta.getDetalles() != null) {
                                            for (DetalleVenta detalle : venta.getDetalles()) {
                                    %>
                                    <tr>
                                        <td><%= detalle.getNombreProducto() %></td>
                                        <td class="text-center"><%= detalle.getCantidad() %></td>
                                        <td class="text-end"><%= formatoMoneda.format(detalle.getPrecioUnitario()) %></td>
                                        <td class="text-end"><strong><%= formatoMoneda.format(detalle.getSubtotal()) %></strong></td>
                                    </tr>
                                    <% 
                                            }
                                        }
                                    %>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                        <td class="text-end"><strong><%= formatoMoneda.format(venta.getSubtotal()) %></strong></td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong class="fs-5">TOTAL:</strong></td>
                                        <td class="text-end"><strong class="fs-5 text-success"><%= formatoMoneda.format(venta.getTotal()) %></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                        <div class="alert alert-success mt-4">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong>Stock actualizado automáticamente</strong><br>
                            El inventario ha sido actualizado con las cantidades vendidas.
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button class="btn btn-primary btn-lg" onclick="imprimirTicket()">
                                <i class="fas fa-print me-2"></i>Imprimir Ticket
                            </button>
                            <a href="nuevaVenta.jsp" class="btn btn-success">
                                <i class="fas fa-plus me-2"></i>Nueva Venta
                            </a>
                            <a href="historialVentas.jsp" class="btn btn-outline-primary">
                                <i class="fas fa-list me-2"></i>Ver Historial
                            </a>
                            <a href="../dashboard.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-home me-2"></i>Volver al Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function imprimirTicket() {
            window.print();
        }

        // Limpiar la venta de la sesión después de 5 minutos
        setTimeout(function() {
            <% session.removeAttribute("ultimaVenta"); %>
        }, 300000);
    </script>
</body>
</html>
