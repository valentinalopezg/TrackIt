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
    <jsp:include page="/includes/head.jsp" />
    <link href="<%= request.getContextPath() %>/css/producto.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/categorias.css" rel="stylesheet">
    <title>Gestión de Usuarios - Track!t</title>
</head>
<body>
    <jsp:include page="/includes/sidebar.jsp" />
    <jsp:include page="/includes/topbar.jsp" />
    
    <main class="main-content">
        <!-- Breadcrumbs -->
        <nav aria-label="breadcrumb" class="breadcrumb-container">
            <div style="padding: 1rem 2rem;">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="<%= request.getContextPath() %>/dashboard.jsp">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <i class="fas fa-users"></i> Usuarios
                    </li>
                </ol>
            </div>
        </nav>

        <!-- Alertas de éxito -->
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
            <i class="fas fa-check-circle"></i> <%= mensajeSuccess %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Alertas de error -->
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
            <i class="fas fa-exclamation-circle"></i> <%= mensajeError %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Card Principal -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Lista de Usuarios</h3>
                <a href="<%= request.getContextPath() %>/usuarios/agregarUsuario.jsp" class="btn btn-primary">
                    <i class="fas fa-user-plus"></i> Nuevo Usuario
                </a>
            </div>

            <%
                int totalUsuarios = listaUsuarios != null ? listaUsuarios.size() : 0;
                int admins = 0;
                int vendedores = 0;
                int activos = 0;
                int inactivos = 0;

                if (listaUsuarios != null) {
                    for (Usuario u : listaUsuarios) {
                        if (u.isAdmin()) {
                            admins++;
                        } else {
                            vendedores++;
                        }
                        if (u.isActivo()) {
                            activos++;
                        } else {
                            inactivos++;
                        }
                    }
                }
            %>

            <!-- Estadísticas rápidas -->
            <div class="stats-grid" style="margin-bottom: 1.5rem;">
                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Total Usuarios</span>
                        <div class="stat-icon primary">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-value"><%= totalUsuarios %></div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Administradores</span>
                        <div class="stat-icon danger">
                            <i class="fas fa-user-shield"></i>
                        </div>
                    </div>
                    <div class="stat-value"><%= admins %></div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Vendedores</span>
                        <div class="stat-icon info">
                            <i class="fas fa-user-tie"></i>
                        </div>
                    </div>
                    <div class="stat-value"><%= vendedores %></div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Usuarios Activos</span>
                        <div class="stat-icon success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="stat-value"><%= activos %></div>
                </div>
            </div>

            <!-- Filtros y búsqueda -->
            <div style="display: flex; gap: 1rem; margin-bottom: 1.5rem; flex-wrap: wrap; padding: 0 1.5rem;">
                <div class="search-box" style="flex: 1; min-width: 250px; max-width: 400px;">
                    <i class="fa-solid fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Buscar por nombre, usuario o email..." 
                           onkeyup="filtrarUsuarios()">
                </div>
                
                <select id="filtroRol" class="form-select" style="width: 180px;" onchange="filtrarUsuarios()">
                    <option value="">Todos los roles</option>
                    <option value="Administrador">Administradores</option>
                    <option value="Vendedor">Vendedores</option>
                </select>

                <select id="filtroEstado" class="form-select" style="width: 160px;" onchange="filtrarUsuarios()">
                    <option value="">Todos los estados</option>
                    <option value="Activo">Activos</option>
                    <option value="Inactivo">Inactivos</option>
                </select>
            </div>

            <!-- Tabla de usuarios -->
            <div class="table-responsive">
                <% if (listaUsuarios == null || listaUsuarios.isEmpty()) { %>
                    <div style="text-align: center; padding: 3rem;">
                        <i class="fas fa-users" style="font-size: 4rem; color: var(--border-color); margin-bottom: 1rem;"></i>
                        <h3 style="color: var(--text-muted);">No hay usuarios registrados</h3>
                        <p style="color: var(--text-muted); margin-bottom: 1.5rem;">
                            Comienza agregando el primer usuario al sistema
                        </p>
                        <a href="<%= request.getContextPath() %>/usuarios/agregarUsuario.jsp" class="btn btn-primary">
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
                                <th style="width: 110px;">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Usuario user : listaUsuarios) { %>
                            <tr>
                                <td><strong>#<%= user.getIdUsuario() %></strong></td>
                                <td>
                                    <div class="product-info">
                                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                                            <div class="user-avatar" style="width: 40px; height: 40px; font-size: 0.9rem;">
                                                <%= user.getIniciales() %>
                                            </div>
                                            <div>
                                                <div class="product-name"><%= user.getNombreCompleto() %></div>
                                                <div class="product-sku" style="font-size: 0.85rem; color: var(--text-muted);">
                                                    @<%= user.getUsuario() %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size: 0.9rem;">
                                        <div><i class="fas fa-id-card" style="color: var(--text-muted);"></i> <%= user.getIdentificacion() %></div>
                                        <div style="margin-top: 0.25rem;">
                                            <i class="fas fa-envelope" style="color: var(--text-muted);"></i> <%= user.getEmail() %>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-<%= user.getRolColor() %>">
                                        <i class="fas <%= user.getRolIcono() %>"></i> <%= user.getRolNombre() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="stock-badge <%= user.isActivo() ? "stock-high" : "out" %>">
                                        <i class="fas <%= user.isActivo() ? "fa-check-circle" : "fa-times-circle" %>"></i>
                                        <%= user.isActivo() ? "Activo" : "Inactivo" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<%= request.getContextPath() %>/usuarios/editarUsuario.jsp?id=<%= user.getIdUsuario() %>" 
                                           class="btn btn-sm btn-warning" 
                                           title="Editar">
                                            <i class="fa-solid fa-pen"></i>
                                        </a>
                                        <% if (user.getIdUsuario() != usuarioLogueado.getIdUsuario()) { %>
                                        <button onclick="confirmarEliminar(<%= user.getIdUsuario() %>, '<%= user.getNombreCompleto().replace("'", "\\'") %>')" 
                                                class="btn btn-sm btn-danger" 
                                                title="Eliminar">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                        <% } else { %>
                                        <button class="btn-action" 
                                                style="background: var(--secondary-color); color: white; padding: 0.5rem; border-radius: 6px; border: none; cursor: not-allowed;"
                                                disabled 
                                                title="No puede eliminarse a sí mismo">
                                            <i class="fas fa-lock"></i>
                                        </button>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <!-- Mensaje cuando no hay resultados -->
                    <div id="noResults" style="display: none; text-align: center; padding: 2rem;">
                        <i class="fas fa-search" style="font-size: 3rem; color: var(--border-color); margin-bottom: 1rem;"></i>
                        <h4 style="color: var(--text-muted);">No se encontraron usuarios</h4>
                        <p style="color: var(--text-muted);">Intenta con otros términos de búsqueda</p>
                    </div>

                    <!-- Footer de tabla -->
                    <div class="card-footer">
                        <div class="table-info">
                            Mostrando <span id="cantidadVisible"><%= totalUsuarios %></span> de <%= totalUsuarios %> usuarios
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Modal de confirmación de eliminación -->
        <div class="modal fade" id="modalEliminar" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-mejorado">
                    <div class="modal-header modal-header-danger">
                        <div class="modal-header-content">
                            <div class="modal-icon-circle danger">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <h5 class="modal-title">Inactivar Usuario</h5>
                        </div>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body modal-body-mejorado">
                        <div class="modal-text-center">
                            <p class="modal-label">Estás a punto de inactivar:</p>
                            <h4 id="nombreUsuarioEliminar" class="modal-item-name danger">---</h4>
                        </div>

                        <div class="modal-alert-box danger">
                            <div class="modal-alert-content">
                                <i class="fas fa-info-circle modal-alert-icon"></i>
                                <p class="modal-alert-text">
                                    <strong>Advertencia:</strong> El usuario será inactivado y no podrá acceder al sistema. 
                                    Podrás reactivarlo posteriormente si es necesario.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer modal-footer-mejorado">
                        <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i> Cancelar
                        </button>
                        <a id="btnConfirmarEliminar" href="#" class="btn btn-modal-delete danger">
                            <i class="fas fa-ban"></i> Inactivar
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/includes/scripts.jsp" />
    
    <!-- Scripts específicos -->
    <script>
        // Personalizar título
        document.getElementById('pageTitle').textContent = 'Gestión de Usuarios';

        // Función de búsqueda y filtrado
        function filtrarUsuarios() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            const filtroRol = document.getElementById('filtroRol').value;
            const filtroEstado = document.getElementById('filtroEstado').value;
            
            const tabla = document.getElementById('tablaUsuarios');
            if (!tabla) return;
            
            const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            let visibles = 0;

            for (let i = 0; i < filas.length; i++) {
                const fila = filas[i];
                const texto = fila.textContent.toLowerCase();
                const rolTexto = fila.cells[3].textContent.trim();
                const estadoTexto = fila.cells[4].textContent.trim();
                
                let mostrar = true;

                // Filtro de búsqueda
                if (searchInput && !texto.includes(searchInput)) {
                    mostrar = false;
                }

                // Filtro de rol
                if (filtroRol && !rolTexto.includes(filtroRol)) {
                    mostrar = false;
                }

                // Filtro de estado
                if (filtroEstado && !estadoTexto.includes(filtroEstado)) {
                    mostrar = false;
                }

                fila.style.display = mostrar ? '' : 'none';
                if (mostrar) visibles++;
            }

            document.getElementById('cantidadVisible').textContent = visibles;
            
            const noResults = document.getElementById('noResults');
            if (noResults) {
                noResults.style.display = visibles === 0 ? 'block' : 'none';
            }
            if (tabla) {
                tabla.style.display = visibles === 0 ? 'none' : 'table';
            }
        }

        // Función para confirmar eliminación
        function confirmarEliminar(id, nombre) {
            document.getElementById('nombreUsuarioEliminar').textContent = nombre;
            document.getElementById('btnConfirmarEliminar').href = 
                '<%= request.getContextPath() %>/usuario?accion=eliminar&id=' + id;
            
            const modal = new bootstrap.Modal(document.getElementById('modalEliminar'));
            modal.show();
        }

        // Ordenar columnas
        let currentSortColumn = -1;
        let currentSortOrder = 'asc';

        document.querySelectorAll('.data-table th').forEach((header, index) => {
            if (index < 5) {
                header.classList.add('sortable');
                header.addEventListener('click', () => {
                    sortTable(index, header);
                });
            }
        });

        function sortTable(columnIndex, headerElement) {
            const table = document.querySelector('.data-table tbody');
            const rows = Array.from(table.querySelectorAll('tr'));

            if (currentSortColumn === columnIndex) {
                currentSortOrder = currentSortOrder === 'asc' ? 'desc' : 'asc';
            } else {
                currentSortOrder = 'asc';
            }
            currentSortColumn = columnIndex;

            rows.sort((a, b) => {
                const aText = a.cells[columnIndex].textContent.trim();
                const bText = b.cells[columnIndex].textContent.trim();
                let comparison = aText.localeCompare(bText, 'es', { numeric: true });
                return currentSortOrder === 'asc' ? comparison : -comparison;
            });

            rows.forEach(row => table.appendChild(row));

            document.querySelectorAll('.data-table th').forEach(th => {
                th.classList.remove('sorted-asc', 'sorted-desc');
            });

            headerElement.classList.add(currentSortOrder === 'asc' ? 'sorted-asc' : 'sorted-desc');
        }

        // Auto-cerrar alertas
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = bootstrap.Alert.getInstance(alert);
                if (bsAlert) bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>