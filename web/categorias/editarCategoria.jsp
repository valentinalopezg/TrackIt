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
    <jsp:include page="/includes/head.jsp" />
    <link href="../css/categorias.css" rel="stylesheet">
    <title>Editar Categoría - Track!t</title>
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
                        <a href="../dashboard.jsp">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="listarCategorias.jsp">
                            <i class="fas fa-layer-group"></i> Categorías
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <i class="fas fa-edit"></i> Editar Categoría
                    </li>
                </ol>
            </div>
        </nav>
        
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
                    <div class="char-counter">
                        <span id="charCount"><%= categoria.getDescripcion() != null ? categoria.getDescripcion().length() : 0 %></span>/500 caracteres
                    </div>
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

    <jsp:include page="/includes/scripts.jsp" />
    
    <!-- Scripts específicos -->
    <script>
        // Personalizar título
        document.getElementById('pageTitle').textContent = 'Editar Categoría';

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
        
        // Contador de caracteres
        const descripcionTextarea = document.getElementById('descripcion');
        const charCountSpan = document.getElementById('charCount');

        if (descripcionTextarea && charCountSpan) {
            descripcionTextarea.addEventListener('input', function() {
                const count = this.value.length;
                charCountSpan.textContent = count;

                const counterDiv = charCountSpan.parentElement;
                counterDiv.className = 'char-counter';

                if (count > 450) {
                    counterDiv.classList.add('warning');
                }
                if (count >= 490) {
                    counterDiv.classList.remove('warning');
                    counterDiv.classList.add('danger');
                }
            });
        }
    </script>
</body>
</html>