<%-- 
    Document   : agregarProducto
    Created on : 12/10/2025, 9:18:28 p. m.
    Author     : Valentina
--%>

<%@page import="modelo.CategoriaDAO"%>
<%@page import="modelo.Categoria"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar sesión
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Obtener categorías para el select
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    List<Categoria> categorias = categoriaDAO.listarCategoriasActivas();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo Producto - Track!t</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/dashboard.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-md-12">
                <h2><i class="fas fa-plus-circle me-2"></i>Nuevo Producto</h2>
                <p class="text-muted">Registre un nuevo producto en el inventario</p>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-body">
                        <form action="../producto" method="POST" id="formProducto">
                            <input type="hidden" name="accion" value="agregar">
                            
                            <div class="row">
                                <!-- Información básica -->
                                <div class="col-md-6">
                                    <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>Información Básica</h5>
                                    
                                    <div class="mb-3">
                                        <label for="codigo" class="form-label">Código del Producto *</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="codigo" 
                                               name="codigo" 
                                               required
                                               maxlength="50"
                                               placeholder="Ej: PROD001">
                                        <div class="form-text">Código único de identificación</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="nombre" class="form-label">Nombre del Producto *</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="nombre" 
                                               name="nombre" 
                                               required
                                               maxlength="150"
                                               placeholder="Ej: Mouse Inalámbrico">
                                    </div>

                                    <div class="mb-3">
                                        <label for="descripcion" class="form-label">Descripción</label>
                                        <textarea class="form-control" 
                                                  id="descripcion" 
                                                  name="descripcion" 
                                                  rows="3"
                                                  maxlength="500"
                                                  placeholder="Descripción detallada del producto"></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label for="idCategoria" class="form-label">Categoría *</label>
                                        <select class="form-select" id="idCategoria" name="idCategoria" required>
                                            <option value="">Seleccione una categoría</option>
                                            <% 
                                                if (categorias != null && !categorias.isEmpty()) {
                                                    for (Categoria c : categorias) {
                                            %>
                                                <option value="<%= c.getIdCategoria() %>"><%= c.getNombre() %></option>
                                            <% 
                                                    }
                                                } else {
                                            %>
                                                <option value="" disabled>No hay categorías disponibles</option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>

                                <!-- Precios y Stock -->
                                <div class="col-md-6">
                                    <h5 class="mb-3"><i class="fas fa-dollar-sign me-2"></i>Precios y Stock</h5>
                                    
                                    <div class="mb-3">
                                        <label for="precioCompra" class="form-label">Precio de Compra *</label>
                                        <div class="input-group">
                                            <span class="input-group-text">$</span>
                                            <input type="number" 
                                                   class="form-control" 
                                                   id="precioCompra" 
                                                   name="precioCompra" 
                                                   required
                                                   min="0"
                                                   step="0.01"
                                                   placeholder="0.00">
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="precioVenta" class="form-label">Precio de Venta *</label>
                                        <div class="input-group">
                                            <span class="input-group-text">$</span>
                                            <input type="number" 
                                                   class="form-control" 
                                                   id="precioVenta" 
                                                   name="precioVenta" 
                                                   required
                                                   min="0"
                                                   step="0.01"
                                                   placeholder="0.00">
                                        </div>
                                        <div id="margenGanancia" class="form-text"></div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="stockActual" class="form-label">Stock Actual *</label>
                                        <input type="number" 
                                               class="form-control" 
                                               id="stockActual" 
                                               name="stockActual" 
                                               required
                                               min="0"
                                               value="0"
                                               placeholder="0">
                                    </div>

                                    <div class="mb-3">
                                        <label for="stockMinimo" class="form-label">Stock Mínimo *</label>
                                        <input type="number" 
                                               class="form-control" 
                                               id="stockMinimo" 
                                               name="stockMinimo" 
                                               required
                                               min="0"
                                               value="10"
                                               placeholder="10">
                                        <div class="form-text">Nivel mínimo antes de alerta</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="stockMaximo" class="form-label">Stock Máximo *</label>
                                        <input type="number" 
                                               class="form-control" 
                                               id="stockMaximo" 
                                               name="stockMaximo" 
                                               required
                                               min="0"
                                               value="1000"
                                               placeholder="1000">
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                El producto se creará con estado <strong>Activo</strong> por defecto
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="listarProductos.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Guardar Producto
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calcular margen de ganancia
        function calcularMargen() {
            const precioCompra = parseFloat(document.getElementById('precioCompra').value) || 0;
            const precioVenta = parseFloat(document.getElementById('precioVenta').value) || 0;
            const margenDiv = document.getElementById('margenGanancia');
            
            if (precioCompra > 0 && precioVenta > 0) {
                const margen = precioVenta - precioCompra;
                const porcentaje = ((margen / precioCompra) * 100).toFixed(2);
                
                if (margen > 0) {
                    margenDiv.innerHTML = `<span class="text-success"><i class="fas fa-arrow-up"></i> Margen: ${margen.toFixed(2)} (${porcentaje}%)</span>`;
                } else if (margen < 0) {
                    margenDiv.innerHTML = `<span class="text-danger"><i class="fas fa-arrow-down"></i> Pérdida: ${Math.abs(margen).toFixed(2)} (${porcentaje}%)</span>`;
                } else {
                    margenDiv.innerHTML = `<span class="text-warning">Sin margen de ganancia</span>`;
                }
            } else {
                margenDiv.innerHTML = '';
            }
        }

        document.getElementById('precioCompra').addEventListener('input', calcularMargen);
        document.getElementById('precioVenta').addEventListener('input', calcularMargen);

        // Validación del formulario
        document.getElementById('formProducto').addEventListener('submit', function(e) {
            const precioCompra = parseFloat(document.getElementById('precioCompra').value) || 0;
            const precioVenta = parseFloat(document.getElementById('precioVenta').value) || 0;
            const stockMinimo = parseInt(document.getElementById('stockMinimo').value) || 0;
            const stockMaximo = parseInt(document.getElementById('stockMaximo').value) || 0;
            
            if (precioVenta < precioCompra) {
                if (!confirm('El precio de venta es menor que el precio de compra. ¿Desea continuar?')) {
                    e.preventDefault();
                    return false;
                }
            }
            
            if (stockMaximo < stockMinimo) {
                e.preventDefault();
                alert('El stock máximo debe ser mayor o igual al stock mínimo');
                return false;
            }
        });
    </script>
</body>
</html>
