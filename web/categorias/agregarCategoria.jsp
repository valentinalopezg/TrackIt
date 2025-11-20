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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/head.jsp" />
    <link href="../css/categorias.css" rel="stylesheet">
    <title>Agregar Categoría - Track!t</title>
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
                        <i class="fas fa-plus-circle"></i> Agregar Categoría
                    </li>
                </ol>
            </div>
        </nav>
        
        <!-- Alertas de error -->
        <% 
        String error = (String) request.getAttribute("error");
        if (error != null) { 
        %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <!-- Formulario -->
        <div class="container-registro">
            <div class="header">
                <h1><i class="fas fa-plus-circle"></i> Agregar Categoría</h1>
                <p>Complete el formulario para agregar una nueva categoría al sistema</p>
            </div>
            
            <form method="post" action="${pageContext.request.contextPath}/categoria" id="formCategoria">
                <input type="hidden" name="accion" value="agregar">
                
                <div class="form-group">
                    <label for="nombre">
                        <i class="fas fa-tag"></i> Nombre de la Categoría 
                        <span class="text-danger">*</span>
                    </label>
                    <input type="text" 
                           name="nombre" 
                           id="nombre" 
                           placeholder="Ej: Electrónica, Papelería, Consumibles"
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
                              placeholder="Descripción opcional de la categoría"
                              maxlength="500"></textarea>
                    <div class="char-counter">
                        <span id="charCount">0</span>/500 caracteres
                    </div>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Guardar Categoría
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
        document.getElementById('pageTitle').textContent = 'Agregar Categoría';

        // Validación del formulario
        document.getElementById('formCategoria').addEventListener('submit', function(e) {
            const nombre = document.getElementById('nombre').value.trim();
            
            if (nombre.length < 3) {
                e.preventDefault();
                alert('El nombre debe tener al menos 3 caracteres');
                document.getElementById('nombre').focus();
                return false;
            }
        });
        
        // Contador de caracteres para descripción
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