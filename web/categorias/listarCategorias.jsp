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
    <link href="../css/categorias.css" rel="stylesheet">
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
                <a href="<%= request.getContextPath() %>/producto?accion=listar" class="nav-link">
                    <i class="fas fa-cube"></i>
                    Productos
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/categorias/listarCategorias.jsp" class="nav-link active">
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
        <!-- Breadcrumbs (navegación visual) -->
        <nav aria-label="breadcrumb" style="padding: 1rem 2rem; background: #f8f9fa;">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="../dashboard.jsp">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item active"
                    <a href="listarCategorias.jsp">
                        <i class="fas fa-layer-group"></i> Categorías
                    </a>
                </li>
            </ol>
        </nav>  
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
            
        <!-- Filtro/Búsqueda  --> 
        <div class="search-container" style="padding: 1.5rem; border-bottom: 1px solid #e2e8f0;">
            <div class="input-group">
                <span class="input-group-text" style="background: #f7fafc; border-right: none;">
                    <i class="fas fa-search" style="color: #718096;"></i>
                </span>
                <input type="text" 
                       id="searchInput" 
                       class="form-control" 
                       style="border-left: none;"
                       placeholder="Buscar categoría por nombre o descripción...">
            </div>
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
                                        <i class="fas fa-pen"></i>
                                    </a>
                                    <a href="../categoria?accion=eliminar&id=<%= cat.getIdCategoria() %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('¿Está seguro de inactivar esta categoría?')"
                                       title="Inactivar">
                                        <i class="fa-solid fa-trash"></i>
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
                <!-- Modal de confirmación de eliminación - CATEGORÍAS -->
<div class="modal fade" id="modalEliminarCategoria" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-mejorado">
            <!-- Header con icono -->
            <div class="modal-header modal-header-warning">
                <div class="modal-header-content">
                    <div class="modal-icon-circle warning">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h5 class="modal-title">
                        Inactivar Categoría
                    </h5>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <!-- Body mejorado -->
            <div class="modal-body modal-body-mejorado">
                <div class="modal-text-center">
                    <p class="modal-label">
                        Estás a punto de inactivar:
                    </p>
                    <h4 id="nombreCategoriaEliminar" class="modal-item-name warning">
                        ---
                    </h4>
                </div>

                <div class="modal-alert-box warning">
                    <div class="modal-alert-content">
                        <i class="fas fa-info-circle modal-alert-icon"></i>
                        <p class="modal-alert-text">
                            <strong>Advertencia:</strong> Esta categoría será inactivada. Los productos asociados seguirán en el sistema.
                        </p>
                    </div>
                </div>

                <div class="modal-info-box">
                    <p class="modal-info-text">
                        <i class="fas fa-check-circle modal-info-icon"></i>
                        Asegúrate antes de continuar
                    </p>
                </div>
            </div>

            <!-- Footer mejorado -->
            <div class="modal-footer modal-footer-mejorado">
                <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> Cancelar
                </button>
                <a id="btnConfirmarEliminarCategoria" href="#" class="btn btn-modal-delete warning">
                    <i class="fas fa-ban"></i> Inactivar
                </a>
            </div>
        </div>
    </div>
</div>

    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // Función para confirmar eliminación de categoría
    function confirmarEliminarCategoria(id, nombre) {
        document.getElementById('nombreCategoriaEliminar').textContent = nombre;
        document.getElementById('btnConfirmarEliminarCategoria').href = 
            '<%= request.getContextPath() %>/categoria?accion=eliminar&id=' + id;
        
        const modal = new bootstrap.Modal(document.getElementById('modalEliminarCategoria'));
        modal.show();
    }

    // Interceptar clics en botones de eliminar
    document.querySelectorAll('a[href*="accion=eliminar"]').forEach(link => {
        link.onclick = function(e) {
            e.preventDefault();
            const url = this.href;
            const id = new URLSearchParams(new URL(url, window.location.origin).search).get('id');
            const nombre = this.closest('tr').querySelector('td:nth-child(2)').textContent.trim();
            
            confirmarEliminarCategoria(id, nombre);
        };
    });
</script>
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

        // Filtro/Búsqueda
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('.data-table tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchValue) ? '' : 'none';
            });
        });

        // Ordenar Columnas con indicadores visuales
        let currentSortColumn = -1;
        let currentSortOrder = 'asc';

        document.querySelectorAll('.data-table th').forEach((header, index) => {
            if (index < 4) { // Solo las primeras 4 columnas (no "Acciones")
                header.classList.add('sortable');
                header.addEventListener('click', () => {
                    sortTable(index, header);
                });
            }
        });

        function sortTable(columnIndex, headerElement) {
            const table = document.querySelector('.data-table tbody');
            const rows = Array.from(table.querySelectorAll('tr'));

            // Determinar orden
            if (currentSortColumn === columnIndex) {
                currentSortOrder = currentSortOrder === 'asc' ? 'desc' : 'asc';
            } else {
                currentSortOrder = 'asc';
            }
            currentSortColumn = columnIndex;

            // Ordenar filas
            rows.sort((a, b) => {
                const aText = a.cells[columnIndex].textContent.trim();
                const bText = b.cells[columnIndex].textContent.trim();

                let comparison = aText.localeCompare(bText, 'es', { numeric: true });
                return currentSortOrder === 'asc' ? comparison : -comparison;
            });

            // Actualizar tabla
            rows.forEach(row => table.appendChild(row));

            // Actualizar indicadores visuales
            document.querySelectorAll('.data-table th').forEach(th => {
                th.classList.remove('sorted-asc', 'sorted-desc');
            });

            headerElement.classList.add(currentSortOrder === 'asc' ? 'sorted-asc' : 'sorted-desc');
        }
    </script>
</body>
</html>