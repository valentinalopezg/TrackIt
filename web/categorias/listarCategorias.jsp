<%-- 
    Document   : listarCategorias
    Created on : 12/10/2025, 9:14:49 p. m.
    Author     : Valentina
--%>

<%@page import="modelo.Categoria"%>
<%@page import="modelo.CategoriaDAO"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar sesión
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    if (usuarioLogueado == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Obtener lista de categorías
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    List<Categoria> categorias = categoriaDAO.listarCategorias();
    
    // Verificar si es admin
    boolean esAdmin = usuarioLogueado.isAdmin();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categorías - Track!t</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="../css/dashboard.css" rel="stylesheet">
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">Track!t</div>
            <div class="sidebar-subtitle">Sistema de Inventarios</div>
        </div>

        <ul class="sidebar-nav">
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/dashboard.jsp" class="nav-link">
                    <i class="fas fa-chart-pie"></i>
                    Dashboard
                </a>
            </li>

            <div class="nav-section-title">Inventario</div>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/producto?accion=listar" class="nav-link active">
                    <i class="fas fa-cube"></i>
                    Productos
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/categorias/listarCategorias.jsp" class="nav-link">
                    <i class="fas fa-layer-group"></i>
                    Categorías
                </a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link">
                    <i class="fas fa-boxes"></i>
                    Control de Stock
                </a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link">
                    <i class="fas fa-truck"></i>
                    Proveedores
                </a>
            </li>

            <div class="nav-section-title">Ventas</div>
            <li class="nav-item">
                <a href="#" class="nav-link">
                    <i class="fas fa-cash-register"></i>
                    Nueva Venta
                </a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link">
                    <i class="fas fa-receipt"></i>
                    Historial Ventas
                </a>
            </li>

            <div class="nav-section-title">Sistema</div>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link">
                    <i class="fas fa-cog"></i>
                    Configuración
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i>
                    Cerrar Sesión
                </a>
            </li>
        </ul>
    </nav>

    <!-- Top Bar -->
    <header class="topbar">
        <div class="topbar-left">
            <button class="sidebar-toggle" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>
            <h1 class="page-title">Gestión de Categorías</h1>
        </div>

        <div class="topbar-right">
            <div class="user-info">
                <div class="user-avatar"><%= usuarioLogueado.getNombre().substring(0, 1).toUpperCase() %></div>
                <div class="user-details">
                    <div class="user-name"><%= usuarioLogueado.getNombreCompleto() %></div>
                    <div class="user-role"><%= usuarioLogueado.getRol().toUpperCase() %></div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Alertas -->
        <% 
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        
        if (success != null) {
            String mensaje = "";
            switch(success) {
                case "agregada": mensaje = "Categoría agregada exitosamente"; break;
                case "editada": mensaje = "Categoría actualizada exitosamente"; break;
                case "eliminada": mensaje = "Categoría eliminada exitosamente"; break;
            }
        %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle"></i> <%= mensaje %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if (error != null) { 
            String mensaje = "";
            if ("noAutorizado".equals(error)) {
                mensaje = "No tienes permisos para realizar esta acción";
            } else if ("noEditada".equals(error)) {
                mensaje = "No se pudo actualizar la categoría";
            } else if ("noEliminada".equals(error)) {
                mensaje = "No se pudo eliminar la categoría";
            } else {
                mensaje = "Ocurrió un error: " + error;
            }
        %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> <%= mensaje %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Card Principal -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    Lista de Categorías
                </h3>
                <% if (esAdmin) { %>
                <a href="agregarCategoria.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Nueva Categoría
                </a>
                <% } %>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        if (categorias != null && !categorias.isEmpty()) {
                            for (Categoria cat : categorias) { 
                        %>
                        <tr>
                            <td><%= cat.getIdCategoria() %></td>
                            <td><strong><%= cat.getNombre() %></strong></td>
                            <td><%= cat.getDescripcion() != null ? cat.getDescripcion() : "-" %></td>
                            <td>
                                <% if ("activa".equals(cat.getEstado())) { %>
                                    <span class="badge bg-success">Activa</span>
                                <% } else { %>
                                    <span class="badge bg-secondary">Inactiva</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <% if (esAdmin) { %>
                                    <a href="editarCategoria.jsp?id=<%= cat.getIdCategoria() %>" 
                                       class="btn btn-sm btn-warning" 
                                       title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="../categoria?accion=eliminar&id=<%= cat.getIdCategoria() %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('¿Está seguro de eliminar esta categoría?')"
                                       title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                    <% } else { %>
                                    <button class="btn btn-sm btn-secondary" disabled title="Sin permisos">
                                        <i class="fas fa-lock"></i>
                                    </button>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% 
                            }
                        } else { 
                        %>
                        <tr>
                            <td colspan="5" class="text-center">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <p>No hay categorías registradas</p>
                                <% if (esAdmin) { %>
                                <a href="agregarCategoria.jsp" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Crear Primera Categoría
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="card-footer">
                <div class="table-info">
                    Total de categorías: <strong><%= categorias != null ? categorias.size() : 0 %></strong>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle sidebar
        document.getElementById('sidebarToggle')?.addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('active');
        });

        // Auto-hide alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>