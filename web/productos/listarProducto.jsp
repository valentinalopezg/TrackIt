<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Producto"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%
    // Obtener la lista de productos
    List<Producto> listaProductos = (List<Producto>) request.getAttribute("listaProductos");
    String mensaje = (String) request.getAttribute("mensaje");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inventario - Productos | Track!t</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Dashboard CSS -->
        <link href="<%= request.getContextPath() %>/css/dashboard.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/css/producto.css" rel="stylesheet">
        <!-- Favicon -->
        <link href="<%= request.getContextPath() %>/images/favicon.png" rel="icon">
        <link href="<%= request.getContextPath() %>/css/categorias.css" rel="stylesheet">
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

                <div class="nav-section-title">Sistema</div>
                <li class="nav-item">
                    <a href="#" class="nav-link">
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
                <h1 class="page-title">Gestión de Productos</h1>
            </div>

            <div class="topbar-right">
                <button class="notification-btn" id="notificationBtn">
                    <i class="fas fa-bell"></i>
                    <span class="notification-badge">3</span>
                </button>

                <div class="user-info">
                    <div class="user-avatar">A</div>
                    <div class="user-details">
                        <div class="user-name">Administrador</div>
                        <div class="user-role">Gerente</div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Contenido principal -->
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
                            <i class="fas fa-cube"></i> Productos
                        </li>
                    </ol>
                </div>
            </nav>
            <!-- Mensajes de éxito/error -->
            <% if (mensaje != null && !mensaje.isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        Lista de Productos
                    </h2>
                    <a href="<%= request.getContextPath() %>/producto?accion=nuevo" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Nuevo Producto
                    </a>
                </div>

                <%
                    int totalProductos = 0;
                    int productosActivos = 0;
                    int stockBajo = 0;
                    int agotados = 0;
                    
                    if (listaProductos != null) {
                        totalProductos = listaProductos.size();
                    }
                %>

                <!-- Estadísticas rápidas -->
                <div class="stats-grid" style="margin-bottom: 1.5rem;">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Productos</span>
                            <div class="stat-icon primary">
                                <i class="fas fa-cube"></i>
                            </div>
                        </div>
                        <div class="stat-value"><%= totalProductos %></div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Productos Activos</span>
                            <div class="stat-icon success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>
                        <div class="stat-value" id="productosActivos">0</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Stock Bajo</span>
                            <div class="stat-icon warning">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                        </div>
                        <div class="stat-value" id="stockBajo">0</div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Agotados</span>
                            <div class="stat-icon danger">
                                <i class="fas fa-times-circle"></i>
                            </div>
                        </div>
                        <div class="stat-value" id="agotados">0</div>
                    </div>
                </div>

                <!-- Barra de búsqueda y filtros -->
                <div style="display: flex; gap: 1rem; margin-bottom: 1.5rem; flex-wrap: wrap;">
                    <div class="search-box" style="flex: 1; min-width: 250px; max-width: 400px;">
                        <i class="fa-solid fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Buscar por nombre, categoría o ID..." 
                               onkeyup="filtrarProductos()">
                    </div>
                    
                    <select id="filtroCategoria" class="form-select" style="width: 200px;" onchange="filtrarProductos()">
                        <option value="">Todas las categorías</option>
                        <option value="Electrónica">Electrónica</option>
                        <option value="Audio">Audio</option>
                        <option value="Periféricos">Periféricos</option>
                        <option value="Consumibles">Consumibles</option>
                        <option value="Accesorios">Accesorios</option>
                    </select>

                    <select id="filtroStock" class="form-select" style="width: 180px;" onchange="filtrarProductos()">
                        <option value="">Todos los estados</option>
                        <option value="disponible">Disponibles</option>
                        <option value="bajo">Stock Bajo</option>
                        <option value="agotado">Agotados</option>
                    </select>
                </div>

                <!-- Tabla de productos -->
                <div class="table-responsive">
                    <% if (listaProductos == null || listaProductos.isEmpty()) { %>
                        <div style="text-align: center; padding: 3rem;">
                            <i class="fas fa-box-open" style="font-size: 4rem; color: var(--border-color); margin-bottom: 1rem;"></i>
                            <h3 style="color: var(--text-muted);">No hay productos registrados</h3>
                            <p style="color: var(--text-muted); margin-bottom: 1.5rem;">
                                Comienza agregando tu primer producto al inventario
                            </p>
                            <a href="<%= request.getContextPath() %>/producto?accion=nuevo" class="btn-info">
                                <i class="fa-solid fa-plus"></i> Agregar Producto
                            </a>
                        </div>
                    <% } else { %>
                        <table class="data-table" id="tablaProductos">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">ID</th>
                                    <th>Producto</th>
                                    <th style="width: 150px;">Categoría</th>
                                    <th style="width: 100px;">Stock</th>
                                    <th style="width: 120px;">Precio</th>
                                    <th style="width: 120px;">Estado</th>
                                    <th style="width: 110px;">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Producto producto : listaProductos) {
                                        int id = producto.getIdProducto();
                                        String nombre = producto.getNombre();
                                        String categoria = producto.getNombreCategoria();
                                        int stock = producto.getStockActual();
                                        BigDecimal precio = producto.getPrecioVenta();
                                        
                                        // Calcular estadísticas
                                        if (stock == 0) {
                                            agotados++;
                                        } else if (stock <= producto.getStockMinimo()) {
                                            stockBajo++;
                                        } else {
                                            productosActivos++;
                                        }
                                        
                                        String stockClass = stock == 0 ? "critical" : (stock <= producto.getStockMinimo() ? "low" : "normal");
                                        String badgeClass = stock > 20 ? "stock-high" : (stock > 10 ? "stock-medium" : (stock > 0 ? "stock-low" : "out"));
                                        String estadoTexto = stock > 20 ? "Disponible" : (stock > 10 ? "Stock Normal" : (stock > 0 ? "Stock Bajo" : "Agotado"));
                                        String estadoIcono = stock > 20 ? "check-circle" : (stock > 10 ? "info-circle" : (stock > 0 ? "exclamation-triangle" : "times-circle"));
                                %>
                                <tr>
                                    <td><strong>#<%= id %></strong></td>
                                    <td>
                                        <div class="product-info">
                                            <div class="product-name"><%= nombre %></div>
                                            <% if (producto.getDescripcion() != null && !producto.getDescripcion().isEmpty()) { %>
                                                <div class="product-sku" style="font-size: 0.85rem; color: var(--text-muted);">
                                                    <%= producto.getDescripcion().length() > 50 ? producto.getDescripcion().substring(0, 50) + "..." : producto.getDescripcion() %>
                                                </div>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="category-badge"><%= categoria != null ? categoria : "Sin categoría" %></span>
                                    </td>
                                    <td>
                                        <span class="stock-level <%= stockClass %>"><%= stock %></span>
                                    </td>
                                    <td>
                                        <strong style="color: var(--success-color);">
                                            $<%= String.format("%,.0f", precio) %>
                                        </strong>
                                    </td>
                                    <td>
                                        <span class="stock-badge <%= badgeClass %>">
                                            <i class="fas fa-<%= estadoIcono %>"></i> <%= estadoTexto %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons" style="display: flex; gap: 0.5rem; justify-content: center;">
                                            <a href="<%= request.getContextPath() %>/producto?accion=editar&id=<%= id %>" 
                                               class="btn-action" 
                                               title="Editar producto"
                                               style="background: var(--warning-color); color: white; padding: 0.5rem; border-radius: 6px;">
                                                <i class="fa-solid fa-pen"></i>
                                            </a>
                                            <button onclick="confirmarEliminar(<%= id %>, '<%= nombre.replace("'", "\\'") %>')" 
                                                    class="btn-action" 
                                                    title="Eliminar producto"
                                                    style="background: var(--danger-color); color: white; padding: 0.5rem; border-radius: 6px; border: none; cursor: pointer;">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <script>
                            // Actualizar estadísticas
                            document.getElementById('productosActivos').textContent = <%= productosActivos %>;
                            document.getElementById('stockBajo').textContent = <%= stockBajo %>;
                            document.getElementById('agotados').textContent = <%= agotados %>;
                        </script>

                        <!-- Mensaje cuando no hay resultados de búsqueda -->
                        <div id="noResults" style="display: none; text-align: center; padding: 2rem;">
                            <i class="fas fa-search" style="font-size: 3rem; color: var(--border-color); margin-bottom: 1rem;"></i>
                            <h4 style="color: var(--text-muted);">No se encontraron productos</h4>
                            <p style="color: var(--text-muted);">Intenta con otros términos de búsqueda</p>
                        </div>

                        <!-- Footer de tabla -->
                        <div class="table-footer" style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--border-color);">
                            <div class="table-info">
                                Mostrando <span id="cantidadVisible"><%= totalProductos %></span> de <%= totalProductos %> productos
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
<!-- Modal de confirmación de eliminación - PRODUCTOS -->
<div class="modal fade" id="modalEliminar" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-content-mejorado">
            <!-- Header con icono -->
            <div class="modal-header modal-header-danger">
                <div class="modal-header-content">
                    <div class="modal-icon-circle danger">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h5 class="modal-title">
                        Inactivar Producto
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
                    <h4 id="nombreProductoEliminar" class="modal-item-name danger">
                        ---
                    </h4>
                </div>

                <div class="modal-alert-box danger">
                    <div class="modal-alert-content">
                        <i class="fas fa-info-circle modal-alert-icon"></i>
                        <p class="modal-alert-text">
                            <strong>Advertencia:</strong> El producto será inactivado. Podrás reactivarlo posteriormente si es necesario.
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
                <a id="btnConfirmarEliminar" href="#" class="btn btn-modal-delete danger">
                    <i class="fas fa-ban"></i> Inactivar
                </a>
            </div>
        </div>
    </div>
</div>
        </main>


        <!-- Bootstrap JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Toggle sidebar
            document.getElementById('sidebarToggle').addEventListener('click', function() {
                document.getElementById('sidebar').classList.toggle('active');
            });

            // Función de búsqueda y filtrado
            function filtrarProductos() {
                const searchInput = document.getElementById('searchInput').value.toLowerCase();
                const filtroCategoria = document.getElementById('filtroCategoria').value.toLowerCase();
                const filtroStock = document.getElementById('filtroStock').value;
                
                const tabla = document.getElementById('tablaProductos');
                if (!tabla) return;
                
                const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
                let visibles = 0;

                for (let i = 0; i < filas.length; i++) {
                    const fila = filas[i];
                    const texto = fila.textContent.toLowerCase();
                    const categoria = fila.cells[2].textContent.toLowerCase();
                    const stockTexto = fila.querySelector('.stock-badge').textContent.toLowerCase();
                    
                    let mostrar = true;

                    if (searchInput && !texto.includes(searchInput)) {
                        mostrar = false;
                    }

                    if (filtroCategoria && !categoria.includes(filtroCategoria)) {
                        mostrar = false;
                    }

                    if (filtroStock) {
                        if (filtroStock === 'disponible' && stockTexto.includes('agotado')) {
                            mostrar = false;
                        } else if (filtroStock === 'bajo' && !stockTexto.includes('stock bajo')) {
                            mostrar = false;
                        } else if (filtroStock === 'agotado' && !stockTexto.includes('agotado')) {
                            mostrar = false;
                        }
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
                document.getElementById('nombreProductoEliminar').textContent = nombre;
                document.getElementById('btnConfirmarEliminar').href = 
                    '<%= request.getContextPath() %>/producto?accion=eliminar&id=' + id;
                
                const modal = new bootstrap.Modal(document.getElementById('modalEliminar'));
                modal.show();
            }

            // Auto-cerrar alertas después de 5 segundos
            document.addEventListener('DOMContentLoaded', function() {
                setTimeout(function() {
                    const alerts = document.querySelectorAll('.alert');
                    alerts.forEach(alert => {
                        const bsAlert = bootstrap.Alert.getInstance(alert);
                        if (bsAlert) bsAlert.close();
                    });
                }, 5000);
            });

            // Ordenar Columnas con indicadores visuales
            let currentSortColumn = -1;
            let currentSortOrder = 'asc';

            document.querySelectorAll('.data-table th').forEach((header, index) => {
                if (index < 6) { // Solo las primeras 6 columnas (no "Acciones")
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