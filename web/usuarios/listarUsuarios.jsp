<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="java.util.List"%>
<%
    // Verificar sesión y permisos
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!usuarioLogueado.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=noAutorizado");
        return;
    }

    // Obtener la lista de usuarios
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    List<Usuario> listaUsuarios = usuarioDAO.listarUsuarios();

    // Mensajes
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Usuarios - Track!t</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Dashboard CSS -->
        <link href="<%= request.getContextPath()%>/css/dashboard.css" rel="stylesheet">
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
                    <a href="<%= request.getContextPath()%>/dashboard.jsp" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        Dashboard
                    </a>
                </li>

                <div class="nav-section-title">Inventario</div>
                <li class="nav-item">
                    <a href="<%= request.getContextPath()%>/producto?accion=listar" class="nav-link">
                        <i class="fas fa-cube"></i>
                        Productos
                    </a>
                </li>

                <div class="nav-section-title">Sistema</div>
                <li class="nav-item">
                    <a href="<%= request.getContextPath()%>/usuarios/listarUsuarios.jsp" class="nav-link active">
                        <i class="fas fa-users"></i>
                        Usuarios
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%= request.getContextPath()%>/index.jsp" class="nav-link">
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
                <h1 class="page-title">Gestión de Usuarios</h1>
            </div>

            <div class="topbar-right">
                <div class="user-info">
                    <div class="user-avatar"><%= usuarioLogueado.getIniciales()%></div>
                    <div class="user-details">
                        <div class="user-name"><%= usuarioLogueado.getNombreCompleto()%></div>
                        <div class="user-role"><%= usuarioLogueado.getRolNombre()%></div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Contenido principal -->
        <main class="main-content">
            <!-- Mensajes -->
            <% if (success != null) {
                    String mensajeSuccess = "";
                    switch (success) {
                        case "agregado":
                            mensajeSuccess = "Usuario agregado exitosamente";
                            break;
                        case "editado":
                            mensajeSuccess = "Usuario actualizado exitosamente";
                            break;
                        case "eliminado":
                            mensajeSuccess = "Usuario eliminado exitosamente";
                            break;
                    }
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> <%= mensajeSuccess%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <% if (error != null) {
                    String mensajeError = "";
                    switch (error) {
                        case "noAutorizado":
                            mensajeError = "No tiene permisos para realizar esta acción";
                            break;
                        case "noAutoEliminar":
                            mensajeError = "No puede eliminarse a sí mismo";
                            break;
                        default:
                            mensajeError = "Error: " + error;
                            break;
                    }
            %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle"></i> <%= mensajeError%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% }%>

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-users"></i> Lista de Usuarios
                    </h2>
                    <a href="<%= request.getContextPath()%>/usuarios/agregarUsuario.jsp" class="btn-info">
                        <i class="fas fa-user-plus"></i> Nuevo Usuario
                    </a>
                </div>

                <%
                    int totalUsuarios = listaUsuarios != null ? listaUsuarios.size() : 0;
                    int admins = 0;
                    int vendedores = 0;

                    if (listaUsuarios != null) {
                        for (Usuario u : listaUsuarios) {
                            if (u.isAdmin()) {
                                admins++;
                            } else {
                                vendedores++;
                            }
                        }
                    }
                %>

                <!-- Estadísticas -->
                <div class="stats-grid" style="margin-bottom: 1.5rem;">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Usuarios</span>
                            <div class="stat-icon primary">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-value"><%= totalUsuarios%></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Administradores</span>
                            <div class="stat-icon danger">
                                <i class="fas fa-user-shield"></i>
                            </div>
                        </div>
                        <div class="stat-value"><%= admins%></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Vendedores</span>
                            <div class="stat-icon info">
                                <i class="fas fa-user"></i>
                            </div>
                        </div>
                        <div class="stat-value"><%= vendedores%></div>
                    </div>
                </div>

                <!-- Barra de búsqueda -->
                <div style="margin-bottom: 1.5rem;">
                    <div class="search-box" style="max-width: 400px;">
                        <i class="fa-solid fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Buscar usuario..." onkeyup="filtrarUsuarios()">
                    </div>
                </div>

                <!-- Tabla de usuarios -->
                <div class="table-responsive">
                    <% if (listaUsuarios == null || listaUsuarios.isEmpty()) {%>
                    <div style="text-align: center; padding: 3rem;">
                        <i class="fas fa-users" style="font-size: 4rem; color: var(--border-color); margin-bottom: 1rem;"></i>
                        <h3 style="color: var(--text-muted);">No hay usuarios registrados</h3>
                        <p style="color: var(--text-muted); margin-bottom: 1.5rem;">
                            Comienza agregando el primer usuario al sistema
                        </p>
                        <a href="<%= request.getContextPath()%>/usuarios/agregarUsuario.jsp" class="btn-info">
                            <i class="fas fa-user-plus"></i> Agregar Usuario
                        </a>
                    </div>
                    <% } else { %>
                    <table class="data-table" id="tablaUsuarios">
                        <thead>
                            <tr>
                                <th style="width: 80px;">ID</th>
                                <th>Usuario</th>
                                <th>Información</th>
                                <th style="width: 150px;">Rol</th>
                                <th style="width: 120px;">Estado</th>
                                <th style="width: 160px;">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Usuario user : listaUsuarios) {%>
                            <tr>
                                <td><strong>#<%= user.getIdUsuario()%></strong></td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                        <div class="user-avatar" style="width: 40px; height: 40px; font-size: 0.9rem;">
                                            <%= user.getIniciales()%>
                                        </div>
                                        <div>
                                            <div class="product-name"><%= user.getNombreCompleto()%></div>
                                            <div class="product-sku" style="font-size: 0.85rem; color: var(--text-muted);">
                                                @<%= user.getUsuario()%>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size: 0.9rem;">
                                        <div><i class="fas fa-id-card" style="color: var(--text-muted);"></i> <%= user.getIdentificacion()%></div>
                                        <div style="margin-top: 0.25rem;"><i class="fas fa-envelope" style="color: var(--text-muted);"></i> <%= user.getEmail()%></div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-<%= user.getRolColor()%>">
                                        <i class="fas <%= user.getRolIcono()%>"></i> <%= user.getRolNombre()%>
                                    </span>
                                </td>
                                <td>
                                    <span class="stock-badge <%= user.isActivo() ? "stock-high" : "out"%>">
                                        <i class="fas <%= user.isActivo() ? "fa-check-circle" : "fa-times-circle"%>"></i>
                                        <%= user.isActivo() ? "Activo" : "Inactivo"%>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons" style="display: flex; gap: 0.5rem;">
                                        <a href="<%= request.getContextPath()%>/usuarios/editarUsuario.jsp?id=<%= user.getIdUsuario()%>" 
                                           class="btn-action" 
                                           title="Editar usuario"
                                           style="background: var(--warning-color); color: white; padding: 0.5rem; border-radius: 6px;">
                                            <i class="fas fa-pen"></i>
                                        </a>
                                        <% if (user.getIdUsuario() != usuarioLogueado.getIdUsuario()) {%>
                                        <button onclick="confirmarEliminar(<%= user.getIdUsuario()%>, '<%= user.getNombreCompleto()%>')" 
                                                class="btn-action" 
                                                title="Eliminar usuario"
                                                style="background: var(--danger-color); color: white; padding: 0.5rem; border-radius: 6px; border: none; cursor: pointer;">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>

                    <div class="table-footer" style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--border-color);">
                        <div class="table-info">
                            Mostrando <span id="cantidadVisible"><%= totalUsuarios%></span> de <%= totalUsuarios%> usuarios
                        </div>
                    </div>
                    <% }%>
                </div>
            </div>
        </main>

        <!-- Modal de confirmación -->
        <div class="modal fade" id="modalEliminar" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header" style="background: var(--danger-color); color: white;">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle"></i> Confirmar Eliminación
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>¿Estás seguro de que deseas eliminar al usuario:</p>
                        <h5 id="nombreUsuarioEliminar" style="color: var(--danger-color);"></h5>
                        <p class="text-muted">Esta acción cambiará el estado del usuario a inactivo.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i> Cancelar
                        </button>
                        <a id="btnConfirmarEliminar" href="#" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Eliminar
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                // Toggle sidebar
                                                document.getElementById('sidebarToggle').addEventListener('click', function () {
                                                    document.getElementById('sidebar').classList.toggle('active');
                                                });

                                                // Filtrar usuarios
                                                function filtrarUsuarios() {
                                                    const searchInput = document.getElementById('searchInput').value.toLowerCase();
                                                    const tabla = document.getElementById('tablaUsuarios');
                                                    if (!tabla)
                                                        return;

                                                    const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
                                                    let visibles = 0;

                                                    for (let i = 0; i < filas.length; i++) {
                                                        const texto = filas[i].textContent.toLowerCase();
                                                        const mostrar = texto.includes(searchInput);
                                                        filas[i].style.display = mostrar ? '' : 'none';
                                                        if (mostrar)
                                                            visibles++;
                                                    }

                                                    document.getElementById('cantidadVisible').textContent = visibles;
                                                }

                                                // Confirmar eliminación
                                                function confirmarEliminar(id, nombre) {
                                                    document.getElementById('nombreUsuarioEliminar').textContent = nombre;
                                                    document.getElementById('btnConfirmarEliminar').href =
                                                            '<%= request.getContextPath()%>/usuario?accion=eliminar&id=' + id;

                                                    const modal = new bootstrap.Modal(document.getElementById('modalEliminar'));
                                                    modal.show();
                                                }

                                                // Auto-cerrar alertas
                                                setTimeout(function () {
                                                    const alerts = document.querySelectorAll('.alert');
                                                    alerts.forEach(alert => {
                                                        const bsAlert = bootstrap.Alert.getInstance(alert);
                                                        if (bsAlert)
                                                            bsAlert.close();
                                                    });
                                                }, 5000);
        </script>
    </body>
</html>