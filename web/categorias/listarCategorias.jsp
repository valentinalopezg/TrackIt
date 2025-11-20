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
    <jsp:include page="/includes/head.jsp" />
    <link href="../css/categorias.css" rel="stylesheet">
    <title>Categorías - Track!t</title>
</head>
<body>
    <jsp:include page="/includes/sidebar.jsp" />
    <jsp:include page="/includes/topbar.jsp" />
    
    <main class="main-content">
        <!-- Breadcrumbs -->
        <nav aria-label="breadcrumb" style="padding: 1rem 2rem; background: #f8f9fa;">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="../dashboard.jsp">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item active">
                    <i class="fas fa-layer-group"></i> Categorías
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
                <h3 class="card-title">Lista de Categorías</h3>
                <% if (esAdmin) { %>
                <a href="agregarCategoria.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Nueva Categoría
                </a>
                <% } %>
            </div>
            
            <!-- Filtro/Búsqueda -->
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
    </main>

    <jsp:include page="/includes/scripts.jsp" />
    
    <!-- Scripts específicos de categorías -->
    <script>
        // Personalizar título de la página
        document.getElementById('pageTitle').textContent = 'Gestión de Categorías';
        
        // Filtro/Búsqueda
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('.data-table tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchValue) ? '' : 'none';
            });
        });

        // Ordenar Columnas
        let currentSortColumn = -1;
        let currentSortOrder = 'asc';

        document.querySelectorAll('.data-table th').forEach((header, index) => {
            if (index < 4) {
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
    </script>
</body>
</html>