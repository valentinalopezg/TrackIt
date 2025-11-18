<%-- 
    Document   : editarCategoria
    Created on : 12/10/2025, 10:09:11 p. m.
    Author     : Valentina
--%>

<%@page import="modelo.Categoria"%>
<%@page import="modelo.CategoriaDAO"%>
<%@page import="modelo.Usuario"%>
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
    
    // Obtener ID de la categoría a editar
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    int id = Integer.parseInt(request.getParameter("id"));
    Categoria categoria = categoriaDAO.obtenerCategoriaPorId(id);
    
    // Si no existe la categoría, redirigir
    if (categoria == null) {
        response.sendRedirect("listarCategorias.jsp?error=noEncontrada");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Categoría - Track!t</title>
    
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
                <a href="../dashboard.jsp" class="nav-link">
                    <i class="fas fa-chart-pie"></i>
                    Dashboard
                </a>
            </li>

            <div class="nav-section-title">Inventario</div>
            <li class="nav-item">
                <a href="../productos/listarProductos.jsp" class="nav-link">
                    <i class="fas fa-cube"></i>
                    Productos
                </a>
            </li>
            <li class="nav-item">
                <a href="listarCategorias.jsp" class="nav-link active">
                    <i class="fas fa-layer-group"></i>
                    Categorías
                </a>
            </li>

            <div class="nav-section-title">Ventas</div>
            <li class="nav-item">
                <a href="../ventas/nuevaVenta.jsp" class="nav-link">
                    <i class="fas fa-cash-register"></i>
                    Nueva Venta
                </a>
            </li>
            <li class="nav-item">
                <a href="../ventas/historialVentas.jsp" class="nav-link">
                    <i class="fas fa-receipt"></i>
                    Historial Ventas
                </a>
            </li>

            <div class="nav-section-title">Administración</div>
            <li class="nav-item">
                <a href="../usuarios/listarUsuarios.jsp" class="nav-link">
                    <i class="fas fa-users"></i>
                    Usuarios
                </a>
            </li>

            <div class="nav-section-title">Sistema</div>
            <li class="nav-item">
                <a href="../logout" class="nav-link">
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
            <h1 class="page-title">Editar Categoría</h1>
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
        <div class="container-edicion">
            <div class="header-edicion">
                <h1>
                    <i class="fas fa-edit"></i> Editar Categoría
                    <span class="badge-estado <%= categoria.getEstado() %>">
                        <%= categoria.getEstado().toUpperCase() %>
                    </span>
                </h1>
                <p>Modifique los datos de la categoría según sea necesario</p>
            </div>
            
            <form method="post" action="${pageContext.request.contextPath}/categoria" id="formEditarCategoria">
                <input type="hidden" name="accion" value="editar">
                <input type="hidden" name="idCategoria" value="<%= categoria.getIdCategoria() %>">
                
                <div class="form-group">
                    <label for="nombre">
                        <i class="fas fa-tag"></i> Nombre de la Categoría 
                        <span class="text-danger">*</span>
                    </label>
                    <input type="text" 
                           name="nombre" 
                           id="nombre" 
                           value="<%= categoria.getNombre() %>"
                           placeholder="Nombre de la categoría"
                           required 
                           maxlength="100"
                           pattern="[A-Za-zÀ-ÿ0-9\s]{3,100}"
                           title="Mínimo 3 caracteres, solo letras y números">
                    <small class="form-text">
                        Este nombre debe ser único y descriptivo (3-100 caracteres)
                    </small>
                </div>
                
                <div class="form-group">
                    <label for="descripcion">
                        <i class="fas fa-align-left"></i> Descripción
                    </label>
                    <textarea name="descripcion" 
                              id="descripcion" 
                              rows="4"
                              placeholder="Descripción de la categoría"
                              maxlength="500"><%= categoria.getDescripcion() != null ? categoria.getDescripcion() : "" %></textarea>
                    <small class="form-text">
                        Opcional - Máximo 500 caracteres
                    </small>
                </div>
                
                <div class="form-group">
                    <label for="estado">
                        <i class="fas fa-toggle-on"></i> Estado 
                        <span class="text-danger">*</span>
                    </label>
                    <select name="estado" id="estado" required>
                        <option value="activa" <%= "activa".equals(categoria.getEstado()) ? "selected" : "" %>>
                            ✓ Activa
                        </option>
                        <option value="inactiva" <%= "inactiva".equals(categoria.getEstado()) ? "selected" : "" %>>
                            ✗ Inactiva
                        </option>
                    </select>
                    <small class="form-text">
                        Las categorías inactivas no aparecerán al crear productos
                    </small>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Actualizar Categoría
                    </button>
                    <a href="listarCategorias.jsp" class="btn-secondary">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle sidebar
        document.getElementById('sidebarToggle')?.addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('active');
        });

        // Validación del formulario
        document.getElementById('formEditarCategoria').addEventListener('submit', function(e) {
            const nombre = document.getElementById('nombre').value.trim();
            
            if (nombre.length < 3) {
                e.preventDefault();
                alert('El nombre debe tener al menos 3 caracteres');
                document.getElementById('nombre').focus();
                return false;
            }
        });

        // Confirmación al cambiar estado a inactivo
        document.getElementById('estado').addEventListener('change', function() {
            if (this.value === 'inactiva') {
                const confirmar = confirm('⚠️ Al inactivar esta categoría, no podrá asignarla a nuevos productos.\n\n¿Está seguro de continuar?');
                if (!confirmar) {
                    this.value = 'activa';
                }
            }
        });
    </script>
</body>
</html>