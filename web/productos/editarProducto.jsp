<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Producto"%>
<%@page import="modelo.CategoriaDAO"%>
<%@page import="modelo.Categoria"%>
<%@page import="java.util.List"%>
<%
    Producto producto = (Producto) request.getAttribute("producto");
    if (producto == null) {
        response.sendRedirect(request.getContextPath() + "/producto?accion=listar");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Editar Producto - Track!t</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Dashboard CSS -->
        <link href="<%= request.getContextPath() %>/css/dashboard.css" rel="stylesheet">
        <!-- Favicon -->
        <link href="<%= request.getContextPath() %>/images/favicon.png" rel="icon">
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
                <a href="<%= request.getContextPath() %>/ventas/nuevaVenta.jsp" class="nav-link">
                    <i class="fas fa-cash-register"></i>
                    Nueva Venta
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/ventas/historialVentas.jsp" class="nav-link">
                    <i class="fas fa-receipt"></i>
                    Historial Ventas
                </a>
            </li>

            <div class="nav-section-title">Sistema</div>
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
                <h1 class="page-title">Editar Producto</h1>
            </div>

            <div class="topbar-right">
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
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb" style="margin-bottom: 1.5rem;">
                <ol class="breadcrumb" style="background: transparent; padding: 0; margin: 0;">
                    <li class="breadcrumb-item">
                        <a href="<%= request.getContextPath() %>/dashboard.jsp" style="color: var(--primary-color);">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="<%= request.getContextPath() %>/producto?accion=listar" style="color: var(--primary-color);">
                            Productos
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Editar Producto</li>
                </ol>
            </nav>

            <!-- Mensajes -->
            <% String error = (String) request.getAttribute("error");
               if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="card">
                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <h2 class="card-title">
                        <i class="fas fa-edit"></i> Editar: <%= producto.getNombre() %>
                    </h2>
                    <a href="<%= request.getContextPath() %>/producto?accion=listar" class="btn-back" 
                       style="background: #e2e8f0; color: #4a5568; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none;">
                        <i class="fas fa-arrow-left"></i> Volver
                    </a>
                </div>

                <div style="padding: 2rem;">
                    <form action="<%= request.getContextPath() %>/producto" method="POST" id="formProducto">
                        <input type="hidden" name="accion" value="actualizar">
                        <input type="hidden" name="idProducto" value="<%= producto.getIdProducto() %>">

                        <div class="row">
                            <!-- Columna izquierda -->
                            <div class="col-md-6">
                                <h5 style="color: var(--primary-color); margin-bottom: 1rem;">
                                    <i class="fas fa-info-circle"></i> Información Básica
                                </h5>

                                <!-- Código -->
                                <div class="mb-3">
                                    <label for="codigo" class="form-label">
                                        Código del Producto <span style="color: red;">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="codigo" name="codigo" 
                                           required value="<%= producto.getCodigo() %>" maxlength="50">
                                    <small class="form-text text-muted">Código único e identificador</small>
                                </div>

                                <!-- Nombre -->
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">
                                        Nombre del Producto <span style="color: red;">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                           required value="<%= producto.getNombre() %>" maxlength="200">
                                </div>

                                <!-- Descripción -->
                                <div class="mb-3">
                                    <label for="descripcion" class="form-label">Descripción</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" 
                                              rows="3"><%= producto.getDescripcion() != null ? producto.getDescripcion() : "" %></textarea>
                                </div>

                                <!-- Categoría -->
                                <div class="mb-3">
                                    <label for="idCategoria" class="form-label">
                                        Categoría <span style="color: red;">*</span>
                                    </label>
                                    <select class="form-select" id="idCategoria" name="idCategoria" required>
                                        <%
                                            CategoriaDAO categoriaDAO = new CategoriaDAO();
                                            List<Categoria> categorias = categoriaDAO.listarCategorias();
                                            for (Categoria cat : categorias) {
                                                String selected = (cat.getIdCategoria() == producto.getIdCategoria()) ? "selected" : "";
                                        %>
                                            <option value="<%= cat.getIdCategoria() %>" <%= selected %>><%= cat.getNombre() %></option>
                                        <% } %>
                                    </select>
                                </div>

                                <!-- Estado -->
                                <div class="mb-3">
                                    <label for="estado" class="form-label">Estado</label>
                                    <select class="form-select" id="estado" name="estado">
                                        <option value="activo" <%= "activo".equals(producto.getEstado()) ? "selected" : "" %>>Activo</option>
                                        <option value="inactivo" <%= "inactivo".equals(producto.getEstado()) ? "selected" : "" %>>Inactivo</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Columna derecha -->
                            <div class="col-md-6">
                                <h5 style="color: var(--success-color); margin-bottom: 1rem;">
                                    <i class="fas fa-dollar-sign"></i> Precios y Stock
                                </h5>

                                <!-- Precio de Compra -->
                                <div class="mb-3">
                                    <label for="precioCompra" class="form-label">
                                        Precio de Compra <span style="color: red;">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control" id="precioCompra" 
                                               name="precioCompra" required min="0" step="0.01" 
                                               value="<%= producto.getPrecioCompra() %>" onchange="calcularMargen()">
                                    </div>
                                </div>

                                <!-- Precio de Venta -->
                                <div class="mb-3">
                                    <label for="precioVenta" class="form-label">
                                        Precio de Venta <span style="color: red;">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" class="form-control" id="precioVenta" 
                                               name="precioVenta" required min="0" step="0.01" 
                                               value="<%= producto.getPrecioVenta() %>" onchange="calcularMargen()">
                                    </div>
                                    <small id="margenGanancia" class="form-text"></small>
                                </div>

                                <!-- Stock Actual -->
                                <div class="mb-3">
                                    <label for="stockActual" class="form-label">
                                        Stock Actual <span style="color: red;">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="stockActual" 
                                           name="stockActual" required min="0" 
                                           value="<%= producto.getStockActual() %>">
                                    <% if (producto.tieneStockBajo()) { %>
                                        <small class="form-text" style="color: #f59e0b;">
                                            <i class="fas fa-exclamation-triangle"></i> Stock bajo - Reabastecimiento recomendado
                                        </small>
                                    <% } %>
                                </div>

                                <!-- Stock Mínimo -->
                                <div class="mb-3">
                                    <label for="stockMinimo" class="form-label">
                                        Stock Mínimo <span style="color: red;">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="stockMinimo" 
                                           name="stockMinimo" required min="1" 
                                           value="<%= producto.getStockMinimo() %>">
                                </div>

                                <!-- Stock Máximo -->
                                <div class="mb-3">
                                    <label for="stockMaximo" class="form-label">
                                        Stock Máximo <span style="color: red;">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="stockMaximo" 
                                           name="stockMaximo" required min="1" 
                                           value="<%= producto.getStockMaximo() %>">
                                </div>
                            </div>
                        </div>

                        <!-- Botones -->
                        <div style="border-top: 1px solid var(--border-color); padding-top: 1.5rem; margin-top: 1.5rem;">
                            <button type="submit" class="btn btn-primary" style="padding: 0.75rem 2rem;">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                            <a href="<%= request.getContextPath() %>/producto?accion=listar" 
                               class="btn btn-light" style="padding: 0.75rem 2rem; margin-left: 0.5rem;">
                                <i class="fas fa-times"></i> Cancelar
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Toggle sidebar
            document.getElementById('sidebarToggle').addEventListener('click', function() {
                document.getElementById('sidebar').classList.toggle('active');
            });

            // Calcular margen al cargar la página
            window.addEventListener('load', calcularMargen);

            // Calcular margen de ganancia
            function calcularMargen() {
                const precioCompra = parseFloat(document.getElementById('precioCompra').value) || 0;
                const precioVenta = parseFloat(document.getElementById('precioVenta').value) || 0;
                const margenSpan = document.getElementById('margenGanancia');
                
                if (precioCompra > 0 && precioVenta > 0) {
                    const margen = precioVenta - precioCompra;
                    const porcentaje = ((margen / precioCompra) * 100).toFixed(2);
                    
                    if (margen > 0) {
                        margenSpan.innerHTML = '<span style="color: #22c55e;"><i class="fas fa-arrow-up"></i> Ganancia: 

            // Validación
            document.getElementById('formProducto').addEventListener('submit', function(e) {
                const precioCompra = parseFloat(document.getElementById('precioCompra').value);
                const precioVenta = parseFloat(document.getElementById('precioVenta').value);
                const stockMinimo = parseInt(document.getElementById('stockMinimo').value);
                const stockMaximo = parseInt(document.getElementById('stockMaximo').value);
                
                if (precioVenta < precioCompra) {
                    if (!confirm('⚠️ El precio de venta es menor que el precio de compra. ¿Continuar?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                
                if (stockMaximo < stockMinimo) {
                    alert('❌ El stock máximo debe ser mayor que el stock mínimo');
                    e.preventDefault();
                    return false;
                }
            });
        </script>
    </body>
</html> + margen.toFixed(2) + ' (' + porcentaje + '%)</span>';
                    } else if (margen < 0) {
                        margenSpan.innerHTML = '<span style="color: #ef4444;"><i class="fas fa-exclamation-triangle"></i> Pérdida: 

            // Validación
            document.getElementById('formProducto').addEventListener('submit', function(e) {
                const precioCompra = parseFloat(document.getElementById('precioCompra').value);
                const precioVenta = parseFloat(document.getElementById('precioVenta').value);
                const stockMinimo = parseInt(document.getElementById('stockMinimo').value);
                const stockMaximo = parseInt(document.getElementById('stockMaximo').value);
                
                if (precioVenta < precioCompra) {
                    if (!confirm('⚠️ El precio de venta es menor que el precio de compra. ¿Continuar?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                
                if (stockMaximo < stockMinimo) {
                    alert('❌ El stock máximo debe ser mayor que el stock mínimo');
                    e.preventDefault();
                    return false;
                }
            });
        </script>
    </body>
</html> + Math.abs(margen).toFixed(2) + '</span>';
                    } else {
                        margenSpan.innerHTML = '<span style="color: #f59e0b;">Sin ganancia</span>';
                    }
                }
            }

            // Validación
            document.getElementById('formProducto').addEventListener('submit', function(e) {
                const precioCompra = parseFloat(document.getElementById('precioCompra').value);
                const precioVenta = parseFloat(document.getElementById('precioVenta').value);
                const stockMinimo = parseInt(document.getElementById('stockMinimo').value);
                const stockMaximo = parseInt(document.getElementById('stockMaximo').value);
                
                if (precioVenta < precioCompra) {
                    if (!confirm('⚠️ El precio de venta es menor que el precio de compra. ¿Continuar?')) {
                        e.preventDefault();
                        return false;
                    }
                }
                
                if (stockMaximo < stockMinimo) {
                    alert('❌ El stock máximo debe ser mayor que el stock mínimo');
                    e.preventDefault();
                    return false;
                }
            });
        </script>
    </body>
</html>