<%-- 
    Document   : reportes
    Created on : 20/11/2025, 11:51:07 a. m.
    Author     : camiloprieto
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<head>
    <jsp:include page="../includes/head.jsp" />
    <title>Reportes - Track!t</title>
</head>

<body id="page-top">

    <div id="wrapper">

        <!-- Sidebar -->
        <jsp:include page="../includes/sidebar.jsp" />

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <jsp:include page="../includes/topbar.jsp" />

                <%
                    modelo.Usuario user = (modelo.Usuario) session.getAttribute("usuario");
                    String rol = user.getRol();
                %>

                <div class="container-fluid">

                    <h1 class="h3 mb-4 text-gray-800">Reportes</h1>

                    <!-- ADMIN -->
                    <% if (rol.equals("admin")) { %>

                    <!-- Ventas por día -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Ventas por Día (Global)</h6>
                        </div>
                        <div class="card-body">
                            <canvas id="chartVentasDia"></canvas>
                        </div>
                    </div>

                    <!-- Productos más vendidos -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Productos Más Vendidos</h6>
                        </div>
                        <div class="card-body">
                            <canvas id="chartProductos"></canvas>
                        </div>
                    </div>

                    <!-- Tabla de ventas -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Historial de Ventas</h6>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Producto</th>
                                        <th>Cantidad</th>
                                        <th>Total</th>
                                        <th>Fecha</th>
                                        <th>Vendedor</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Map<String, Object>> ventas
                                                = (List<Map<String, Object>>) request.getAttribute("ventasTotales");
                                        if (ventas != null) {
                                            for (Map<String, Object> v : ventas) {
                                    %>
                                    <tr>
                                        <td><%= v.get("id")%></td>
                                        <td><%= v.get("producto")%></td>
                                        <td><%= v.get("cantidad")%></td>
                                        <td><%= v.get("total")%></td>
                                        <td><%= v.get("fecha")%></td>
                                        <td><%= v.get("vendedor")%></td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <% } %>

                    <!-- VENDEDOR -->
                    <% if (rol.equals("vendedor")) { %>

                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Tus Ventas por Día</h6>
                        </div>
                        <div class="card-body">
                            <canvas id="chartVentasDia"></canvas>
                        </div>
                    </div>

                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Tus Ventas Registradas</h6>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Producto</th>
                                        <th>Cantidad</th>
                                        <th>Total</th>
                                        <th>Fecha</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Map<String, Object>> ventasU
                                                = (List<Map<String, Object>>) request.getAttribute("ventasUsuario");

                                        if (ventasU != null) {
                                            for (Map<String, Object> v : ventasU) {
                                    %>
                                    <tr>
                                        <td><%= v.get("id")%></td>
                                        <td><%= v.get("producto")%></td>
                                        <td><%= v.get("cantidad")%></td>
                                        <td><%= v.get("total")%></td>
                                        <td><%= v.get("fecha")%></td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <% }%>

                </div>

            </div>

        </div>

    </div>

    <jsp:include page="../includes/scripts.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        // Datos dinámicos para ChartJS (CORREGIDOS)
        const ventasPorDia = JSON.parse('<%= request.getAttribute("ventasPorDiaJSON") != null
                ? request.getAttribute("ventasPorDiaJSON")
                : "{}"%>');

        const productosMasVendidos = JSON.parse('<%= request.getAttribute("productosMasVendidosJSON") != null
                ? request.getAttribute("productosMasVendidosJSON")
                : "{}"%>');

        const labelsVentas = Object.keys(ventasPorDia);
        const dataVentas = Object.values(ventasPorDia);

        const labelsProd = Object.keys(productosMasVendidos);
        const dataProd = Object.values(productosMasVendidos);

        // Gráfica de ventas por día
        if (document.getElementById('chartVentasDia')) {
            new Chart(document.getElementById('chartVentasDia'), {
                type: "line",
                data: {
                    labels: labelsVentas,
                    datasets: [{
                            label: "Ventas",
                            data: dataVentas
                        }]
                }
            });
        }

        // Gráfica productos más vendidos (solo admin)
        if (document.getElementById('chartProductos')) {
            new Chart(document.getElementById('chartProductos'), {
                type: "bar",
                data: {
                    labels: labelsProd,
                    datasets: [{
                            label: "Cantidad",
                            data: dataProd
                        }]
                }
            });
        }
    </script>

</body>
</html>

<style>
    /* Recupera los valores originales del template */
    #content-wrapper {
        margin-left: 224px !important;
    }

    .container-fluid {
        padding: 1.5rem !important;
    }
</style>