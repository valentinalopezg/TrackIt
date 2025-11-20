<%@page import="modelo.Producto"%>
<%@page import="modelo.CategoriaDAO"%>
<%@page import="modelo.Categoria"%>
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
    
    // Verificar si es admin
    if (!usuarioLogueado.isAdmin()) {
        response.sendRedirect("../dashboard.jsp?error=noAutorizado");
        return;
    }
    
    // Obtener producto a editar
    Producto producto = (Producto) request.getAttribute("producto");
    if (producto == null) {
        response.sendRedirect(request.getContextPath() + "/producto?accion=listar");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/head.jsp" />
    <link href="<%= request.getContextPath() %>/css/producto.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/categorias.css" rel="stylesheet">
    <title>Editar Producto - Track!t</title>
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
                    <li class="breadcrumb-item">
                        <a href="<%= request.getContextPath() %>/producto?accion=listar">
                            <i class="fas fa-cube"></i> Productos
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <i class="fas fa-edit"></i> Editar Producto
                    </li>
                </ol>
            </div>
        </nav>

        <!-- Alertas de error -->
        <% 
        String error = (String) request.getAttribute("error");
        if (error != null && !error.isEmpty()) { 
        %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Formulario -->
        <div class="container-edicion">
            <div class="header-edicion">
                <h1>
                    <i class="fas fa-edit"></i> Editar: <%= producto.getNombre() %>
                    <span class="badge-estado <%= producto.getEstado() %>">
                        <%= producto.getEstado().toUpperCase() %>
                    </span>
                </h1>
                <p>Modifique los datos del producto según sea necesario</p>
            </div>

            <form action="<%= request.getContextPath() %>/producto" method="POST" id="formEditarProducto">
                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" name="idProducto" value="<%= producto.getIdProducto() %>">

                <div class="row">
                    <!-- Columna izquierda -->
                    <div class="col-md-6">
                        <h5 class="form-section-title">
                            <i class="fas fa-info-circle"></i> Información Básica
                        </h5>

                        <div class="form-group">
                            <label for="codigo">
                                <i class="fas fa-barcode"></i> Código del Producto 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" 
                                   id="codigo" 
                                   name="codigo" 
                                   value="<%= producto.getCodigo() %>"
                                   required 
                                   maxlength="50">
                            <small class="form-text">Código único e identificador</small>
                        </div>

                        <div class="form-group">
                            <label for="nombre">
                                <i class="fas fa-tag"></i> Nombre del Producto 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" 
                                   id="nombre" 
                                   name="nombre" 
                                   value="<%= producto.getNombre() %>"
                                   required 
                                   maxlength="200">
                        </div>

                        <div class="form-group">
                            <label for="descripcion">
                                <i class="fas fa-align-left"></i> Descripción
                            </label>
                            <textarea id="descripcion" 
                                      name="descripcion" 
                                      rows="3"><%= producto.getDescripcion() != null ? producto.getDescripcion() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="idCategoria">
                                <i class="fas fa-layer-group"></i> Categoría 
                                <span class="text-danger">*</span>
                            </label>
                            <select id="idCategoria" name="idCategoria" required>
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

                        <div class="form-group">
                            <label for="estado">
                                <i class="fas fa-toggle-on"></i> Estado 
                                <span class="text-danger">*</span>
                            </label>
                            <select id="estado" name="estado" required>
                                <option value="activo" <%= "activo".equals(producto.getEstado()) ? "selected" : "" %>>
                                    ✓ Activo
                                </option>
                                <option value="inactivo" <%= "inactivo".equals(producto.getEstado()) ? "selected" : "" %>>
                                    ✗ Inactivo
                                </option>
                            </select>
                            <small class="form-text">
                                Los productos inactivos no aparecerán en el sistema de ventas
                            </small>
                        </div>
                    </div>

                    <!-- Columna derecha -->
                    <div class="col-md-6">
                        <h5 class="form-section-title" style="color: var(--success-color);">
                            <i class="fas fa-dollar-sign"></i> Precios y Stock
                        </h5>

                        <div class="form-group">
                            <label for="precioCompra">
                                <i class="fas fa-shopping-cart"></i> Precio de Compra 
                                <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" 
                                       id="precioCompra" 
                                       name="precioCompra" 
                                       value="<%= producto.getPrecioCompra() %>"
                                       required 
                                       min="0" 
                                       step="0.01"
                                       onchange="calcularMargen()">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="precioVenta">
                                <i class="fas fa-hand-holding-usd"></i> Precio de Venta 
                                <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" 
                                       id="precioVenta" 
                                       name="precioVenta" 
                                       value="<%= producto.getPrecioVenta() %>"
                                       required 
                                       min="0" 
                                       step="0.01"
                                       onchange="calcularMargen()">
                            </div>
                            <small id="margenGanancia" class="form-text"></small>
                        </div>

                        <div class="form-group">
                            <label for="stockActual">
                                <i class="fas fa-boxes"></i> Stock Actual 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="number" 
                                   id="stockActual" 
                                   name="stockActual" 
                                   value="<%= producto.getStockActual() %>"
                                   required 
                                   min="0">
                            <% if (producto.tieneStockBajo()) { %>
                                <small class="form-text" style="color: #f59e0b;">
                                    <i class="fas fa-exclamation-triangle"></i> Stock bajo - Reabastecimiento recomendado
                                </small>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label for="stockMinimo">
                                <i class="fas fa-exclamation-triangle"></i> Stock Mínimo 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="number" 
                                   id="stockMinimo" 
                                   name="stockMinimo" 
                                   value="<%= producto.getStockMinimo() %>"
                                   required 
                                   min="1">
                            <small class="form-text">Alerta cuando el stock llegue a este nivel</small>
                        </div>

                        <div class="form-group">
                            <label for="stockMaximo">
                                <i class="fas fa-warehouse"></i> Stock Máximo 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="number" 
                                   id="stockMaximo" 
                                   name="stockMaximo" 
                                   value="<%= producto.getStockMaximo() %>"
                                   required 
                                   min="1">
                        </div>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Actualizar Producto
                    </button>
                    <a href="<%= request.getContextPath() %>/producto?accion=listar" class="btn-secondary">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/includes/scripts.jsp" />
    
    <!-- Scripts específicos -->
    <script>
        // Personalizar título
        document.getElementById('pageTitle').textContent = 'Editar Producto';

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
                    margenSpan.innerHTML = '<span style="color: #22c55e;"><i class="fas fa-arrow-up"></i> Ganancia: $' + margen.toFixed(2) + ' (' + porcentaje + '%)</span>';
                } else if (margen < 0) {
                    margenSpan.innerHTML = '<span style="color: #ef4444;"><i class="fas fa-exclamation-triangle"></i> Pérdida: $' + Math.abs(margen).toFixed(2) + '</span>';
                } else {
                    margenSpan.innerHTML = '<span style="color: #f59e0b;">Sin ganancia</span>';
                }
            }
        }

        // Confirmación al cambiar estado a inactivo
        document.getElementById('estado').addEventListener('change', function() {
            if (this.value === 'inactivo') {
                const confirmar = confirm('⚠️ Al inactivar este producto, no aparecerá en el sistema de ventas.\n\n¿Está seguro de continuar?');
                if (!confirmar) {
                    this.value = 'activo';
                }
            }
        });

        // Validación antes de enviar
        document.getElementById('formEditarProducto').addEventListener('submit', function(e) {
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