<%-- 
    Document   : nuevaVenta
    Created on : 12/10/2025, 9:21:25 p. m.
    Author     : Valentina
--%>

<%@page import="modelo.ProductoDAO"%>
<%@page import="modelo.Producto"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar sesión
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Obtener productos activos
    ProductoDAO productoDAO = new ProductoDAO();
    List<Producto> productos = productoDAO.listarProductosActivos();
    
    NumberFormat formatoMoneda = NumberFormat.getCurrencyInstance(new Locale("es", "CO"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Venta - Track!t</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/dashboard.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="row mb-4">
            <div class="col-md-6">
                <h2><i class="fas fa-cash-register me-2"></i>Nueva Venta</h2>
                <p class="text-muted">Procesar una nueva venta</p>
            </div>
            <div class="col-md-6 text-end">
                <a href="historialVentas.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-history me-2"></i>Ver Historial
                </a>
                <a href="../dashboard.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Volver
                </a>
            </div>
        </div>

        <!-- Alertas -->
        <% 
            String error = request.getParameter("error");
            if (error != null) {
                String mensaje = "";
                switch(error) {
                    case "sinProductos": mensaje = "Debe agregar al menos un producto"; break;
                    case "stockInsuficiente": mensaje = "Stock insuficiente para: " + request.getParameter("producto"); break;
                    case "productoNoExiste": mensaje = "El producto seleccionado no existe"; break;
                    default: mensaje = "Error al procesar la venta";
                }
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <!-- Panel de productos -->
            <div class="col-md-5">
                <div class="card mb-3">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-search me-2"></i>Buscar Productos</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <input type="text" 
                                   class="form-control" 
                                   id="buscarProducto" 
                                   placeholder="Buscar por nombre o código">
                        </div>
                        
                        <div style="max-height: 500px; overflow-y: auto;" id="listaProductos">
                            <% 
                                if (productos != null && !productos.isEmpty()) {
                                    for (Producto p : productos) {
                            %>
                            <div class="producto-item border-bottom py-2 px-2" 
                                 data-nombre="<%= p.getNombre().toLowerCase() %>"
                                 data-codigo="<%= p.getCodigo().toLowerCase() %>">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="flex-grow-1">
                                        <strong><%= p.getNombre() %></strong>
                                        <br>
                                        <small class="text-muted">
                                            <%= p.getCodigo() %> | 
                                            Stock: <span class="<%= p.tieneStockBajo() ? "text-danger" : "text-success" %>">
                                                <%= p.getStockActual() %>
                                            </span>
                                        </small>
                                        <br>
                                        <strong class="text-primary"><%= formatoMoneda.format(p.getPrecioVenta()) %></strong>
                                    </div>
                                    <button type="button" 
                                            class="btn btn-sm btn-success"
                                            onclick="agregarAlCarrito(<%= p.getIdProducto() %>, '<%= p.getCodigo() %>', '<%= p.getNombre() %>', <%= p.getPrecioVenta() %>, <%= p.getStockActual() %>)"
                                            <%= p.getStockActual() == 0 ? "disabled" : "" %>>
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                            </div>
                            <% 
                                    }
                                } else {
                            %>
                            <div class="text-center py-4">
                                <p class="text-muted">No hay productos disponibles</p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Carrito de compras -->
            <div class="col-md-7">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>Carrito de Compras</h5>
                    </div>
                    <div class="card-body">
                        <form action="../venta" method="POST" id="formVenta">
                            <input type="hidden" name="accion" value="procesar">
                            
                            <div style="max-height: 350px; overflow-y: auto;" class="mb-3">
                                <table class="table table-sm" id="tablaCarrito">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Producto</th>
                                            <th width="100">Cantidad</th>
                                            <th width="120">Precio</th>
                                            <th width="120">Subtotal</th>
                                            <th width="50"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="carritoBody">
                                        <tr id="carritoVacio">
                                            <td colspan="5" class="text-center text-muted py-4">
                                                <i class="fas fa-shopping-cart fa-3x mb-3"></i>
                                                <p>El carrito está vacío</p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <hr>

                            <!-- Totales -->
                            <div class="row mb-3">
                                <div class="col-md-8">
                                    <div class="mb-3">
                                        <label for="metodoPago" class="form-label">Método de Pago *</label>
                                        <select class="form-select" id="metodoPago" name="metodoPago" required>
                                            <option value="">Seleccione...</option>
                                            <option value="Efectivo">Efectivo</option>
                                            <option value="Tarjeta">Tarjeta</option>
                                            <option value="Transferencia">Transferencia</option>
                                            <option value="Mixto">Mixto</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Subtotal:</span>
                                                <strong id="subtotalDisplay">$0</strong>
                                            </div>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <strong>Total:</strong>
                                                <strong class="text-success fs-4" id="totalDisplay">$0</strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success btn-lg" id="btnProcesar" disabled>
                                    <i class="fas fa-check-circle me-2"></i>Procesar Venta
                                </button>
                                <button type="button" class="btn btn-outline-danger" onclick="limpiarCarrito()">
                                    <i class="fas fa-trash me-2"></i>Limpiar Carrito
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
        let carrito = [];
        let idCarrito = 1;

        // Buscar productos
        document.getElementById('buscarProducto').addEventListener('keyup', function() {
            const filtro = this.value.toLowerCase();
            const productos = document.querySelectorAll('.producto-item');
            
            productos.forEach(producto => {
                const nombre = producto.dataset.nombre;
                const codigo = producto.dataset.codigo;
                
                if (nombre.includes(filtro) || codigo.includes(filtro)) {
                    producto.style.display = '';
                } else {
                    producto.style.display = 'none';
                }
            });
        });

        // Agregar producto al carrito
        function agregarAlCarrito(idProducto, codigo, nombre, precio, stockDisponible) {
            // Verificar si ya está en el carrito
            const itemExistente = carrito.find(item => item.idProducto === idProducto);
            
            if (itemExistente) {
                if (itemExistente.cantidad < stockDisponible) {
                    itemExistente.cantidad++;
                    itemExistente.subtotal = itemExistente.cantidad * itemExistente.precio;
                } else {
                    alert('No hay suficiente stock disponible');
                    return;
                }
            } else {
                carrito.push({
                    id: idCarrito++,
                    idProducto: idProducto,
                    codigo: codigo,
                    nombre: nombre,
                    precio: precio,
                    cantidad: 1,
                    subtotal: precio,
                    stockDisponible: stockDisponible
                });
            }
            
            actualizarCarrito();
        }

        // Actualizar visualización del carrito
        function actualizarCarrito() {
            const tbody = document.getElementById('carritoBody');
            const carritoVacio = document.getElementById('carritoVacio');
            
            if (carrito.length === 0) {
                carritoVacio.style.display = '';
                document.getElementById('btnProcesar').disabled = true;
            } else {
                carritoVacio.style.display = 'none';
                document.getElementById('btnProcesar').disabled = false;
                
                let html = '';
                carrito.forEach(item => {
                    html += `
                        <tr>
                            <td>
                                <strong>${item.nombre}</strong><br>
                                <small class="text-muted">${item.codigo}</small>
                            </td>
                            <td>
                                <input type="number" 
                                       class="form-control form-control-sm" 
                                       value="${item.cantidad}"
                                       min="1"
                                       max="${item.stockDisponible}"
                                       onchange="actualizarCantidad(${item.id}, this.value)">
                            </td>
                            <td>$${item.precio.toFixed(2)}</td>
                            <td><strong>$${item.subtotal.toFixed(2)}</strong></td>
                            <td>
                                <button type="button" 
                                        class="btn btn-sm btn-danger" 
                                        onclick="eliminarDelCarrito(${item.id})">
                                    <i class="fas fa-times"></i>
                                </button>
                            </td>
                        </tr>
                    `;
                });
                
                tbody.innerHTML = html;
            }
            
            calcularTotales();
        }

        // Actualizar cantidad
        function actualizarCantidad(id, nuevaCantidad) {
            const item = carrito.find(i => i.id === id);
            if (item) {
                const cantidad = parseInt(nuevaCantidad);
                if (cantidad > 0 && cantidad <= item.stockDisponible) {
                    item.cantidad = cantidad;
                    item.subtotal = item.cantidad * item.precio;
                    actualizarCarrito();
                } else {
                    alert('Cantidad no válida');
                    actualizarCarrito();
                }
            }
        }

        // Eliminar del carrito
        function eliminarDelCarrito(id) {
            carrito = carrito.filter(item => item.id !== id);
            actualizarCarrito();
        }

        // Limpiar carrito
        function limpiarCarrito() {
            if (carrito.length > 0) {
                if (confirm('¿Está seguro de limpiar el carrito?')) {
                    carrito = [];
                    actualizarCarrito();
                }
            }
        }

        // Calcular totales
        function calcularTotales() {
            const subtotal = carrito.reduce((sum, item) => sum + item.subtotal, 0);
            const total = subtotal;
            
            document.getElementById('subtotalDisplay').textContent = '$' + subtotal.toFixed(2);
            document.getElementById('totalDisplay').textContent = '$' + total.toFixed(2);
        }

        // Procesar venta
        document.getElementById('formVenta').addEventListener('submit', function(e) {
            if (carrito.length === 0) {
                e.preventDefault();
                alert('Debe agregar al menos un producto');
                return false;
            }
            
            // Agregar items del carrito como campos hidden
            carrito.forEach(item => {
                const inputId = document.createElement('input');
                inputId.type = 'hidden';
                inputId.name = 'idProducto[]';
                inputId.value = item.idProducto;
                this.appendChild(inputId);
                
                const inputCant = document.createElement('input');
                inputCant.type = 'hidden';
                inputCant.name = 'cantidad[]';
                inputCant.value = item.cantidad;
                this.appendChild(inputCant);
                
                const inputPrecio = document.createElement('input');
                inputPrecio.type = 'hidden';
                inputPrecio.name = 'precioUnitario[]';
                inputPrecio.value = item.precio;
                this.appendChild(inputPrecio);
            });
            
            return true;
        });
    </script>
</body>
</html>