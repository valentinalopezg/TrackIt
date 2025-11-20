<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%
    // Verificar sesión y permisos
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    if (!usuarioLogueado.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=noAutorizado");
        return;
    }
    
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/head.jsp" />
    <link href="<%= request.getContextPath() %>/css/producto.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/categorias.css" rel="stylesheet">
    <title>Agregar Usuario - Track!t</title>
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
                        <a href="<%= request.getContextPath() %>/usuarios/listarUsuarios.jsp">
                            <i class="fas fa-users"></i> Usuarios
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <i class="fas fa-user-plus"></i> Agregar Usuario
                    </li>
                </ol>
            </div>
        </nav>

        <!-- Alertas de error -->
        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Formulario -->
        <div class="container-registro">
            <div class="header">
                <h1><i class="fas fa-user-plus"></i> Agregar Nuevo Usuario</h1>
                <p>Complete el formulario para agregar un nuevo usuario al sistema</p>
            </div>

            <form action="<%= request.getContextPath() %>/usuario" method="POST" id="formUsuario">
                <input type="hidden" name="accion" value="agregar">

                <div class="row">
                    <!-- Columna izquierda -->
                    <div class="col-md-6">
                        <h5 class="form-section-title">
                            <i class="fas fa-id-card"></i> Información Personal
                        </h5>

                        <div class="form-group">
                            <label for="identificacion">
                                <i class="fas fa-id-card"></i> Identificación (CC/DNI)
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" 
                                   id="identificacion" 
                                   name="identificacion" 
                                   placeholder="Ej: 1234567890"
                                   required 
                                   maxlength="20">
                            <small class="form-text">Número de documento de identidad</small>
                        </div>

                        <div class="form-group">
                            <label for="nombre">
                                <i class="fas fa-user"></i> Nombre
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" 
                                   id="nombre" 
                                   name="nombre" 
                                   placeholder="Ej: Juan"
                                   required 
                                   maxlength="100">
                        </div>

                        <div class="form-group">
                            <label for="apellido">
                                <i class="fas fa-user"></i> Apellido
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" 
                                   id="apellido" 
                                   name="apellido" 
                                   placeholder="Ej: Pérez"
                                   required 
                                   maxlength="100">
                        </div>

                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i> Email
                                <span class="text-danger">*</span>
                            </label>
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   placeholder="Ej: juan.perez@example.com"
                                   required 
                                   maxlength="100">
                            <small class="form-text">Correo electrónico único</small>
                        </div>
                    </div>

                    <!-- Columna derecha -->
                    <div class="col-md-6">
                        <h5 class="form-section-title" style="color: var(--success-color);">
                            <i class="fas fa-key"></i> Credenciales de Acceso
                        </h5>

                        <div class="form-group">
                            <label for="usuario">
                                <i class="fas fa-at"></i> Nombre de Usuario
                                <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">@</span>
                                <input type="text" 
                                       id="usuario" 
                                       name="usuario" 
                                       placeholder="usuario123"
                                       required 
                                       maxlength="50" 
                                       pattern="[a-zA-Z0-9_]+" 
                                       title="Solo letras, números y guión bajo">
                            </div>
                            <small class="form-text">Solo letras, números y guión bajo</small>
                        </div>

                        <div class="form-group">
                            <label for="clave">
                                <i class="fas fa-lock"></i> Contraseña
                                <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="password" 
                                       id="clave" 
                                       name="clave" 
                                       placeholder="••••••••"
                                       required 
                                       minlength="6" 
                                       maxlength="255">
                                <button class="btn btn-outline-secondary" 
                                        type="button" 
                                        id="togglePassword"
                                        style="border: 2px solid var(--medium-gray); border-left: none;">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <small class="form-text">Mínimo 6 caracteres</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmarClave">
                                <i class="fas fa-lock"></i> Confirmar Contraseña
                                <span class="text-danger">*</span>
                            </label>
                            <input type="password" 
                                   id="confirmarClave" 
                                   placeholder="••••••••"
                                   required 
                                   minlength="6">
                            <small id="passwordMatch" class="form-text"></small>
                        </div>

                        <div class="form-group">
                            <label for="rol">
                                <i class="fas fa-user-shield"></i> Rol del Usuario
                                <span class="text-danger">*</span>
                            </label>
                            <select id="rol" name="rol" required>
                                <option value="">Seleccione un rol</option>
                                <option value="admin">
                                    👑 Administrador - Acceso total al sistema
                                </option>
                                <option value="vendedor" selected>
                                    👤 Vendedor - Acceso limitado a consultas
                                </option>
                            </select>
                            <small class="form-text">
                                <strong>Admin:</strong> Gestión completa | 
                                <strong>Vendedor:</strong> Solo consultas
                            </small>
                        </div>

                        <!-- Info sobre permisos -->
                        <div style="background: #dbeafe; border-left: 4px solid #3b82f6; padding: 1rem; border-radius: 6px; margin-top: 1rem;">
                            <div style="display: flex; gap: 0.5rem; align-items: flex-start;">
                                <i class="fas fa-info-circle" style="color: #3b82f6; margin-top: 2px;"></i>
                                <div style="font-size: 0.9rem; line-height: 1.5;">
                                    <strong style="color: #1e40af;">Permisos del sistema:</strong><br>
                                    <span style="color: #1e3a8a;">
                                        • <strong>Administrador:</strong> CRUD completo de productos, categorías y usuarios<br>
                                        • <strong>Vendedor:</strong> Solo puede consultar productos del inventario
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-primary" id="btnGuardar">
                        <i class="fas fa-save"></i> Guardar Usuario
                    </button>
                    <a href="<%= request.getContextPath() %>/usuarios/listarUsuarios.jsp" class="btn-secondary">
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
        document.getElementById('pageTitle').textContent = 'Agregar Usuario';

        // Mostrar/ocultar contraseña
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('clave');
            const icon = this.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });

        // Validar que las contraseñas coincidan
        document.getElementById('confirmarClave').addEventListener('keyup', function() {
            const clave = document.getElementById('clave').value;
            const confirmar = this.value;
            const matchSpan = document.getElementById('passwordMatch');
            
            if (confirmar === '') {
                matchSpan.innerHTML = '';
                return;
            }
            
            if (clave === confirmar) {
                matchSpan.innerHTML = '<span style="color: #22c55e;"><i class="fas fa-check-circle"></i> Las contraseñas coinciden</span>';
            } else {
                matchSpan.innerHTML = '<span style="color: #ef4444;"><i class="fas fa-times-circle"></i> Las contraseñas no coinciden</span>';
            }
        });

        // Validar formato de usuario (solo minúsculas, números y guión bajo)
        document.getElementById('usuario').addEventListener('input', function() {
            this.value = this.value.toLowerCase().replace(/[^a-z0-9_]/g, '');
        });

        // Validación antes de enviar
        document.getElementById('formUsuario').addEventListener('submit', function(e) {
            const clave = document.getElementById('clave').value;
            const confirmar = document.getElementById('confirmarClave').value;
            
            if (clave !== confirmar) {
                e.preventDefault();
                alert('❌ Las contraseñas no coinciden');
                document.getElementById('confirmarClave').focus();
                return false;
            }
            
            if (clave.length < 6) {
                e.preventDefault();
                alert('❌ La contraseña debe tener al menos 6 caracteres');
                document.getElementById('clave').focus();
                return false;
            }
            
            // Deshabilitar botón para evitar doble envío
            const btnGuardar = document.getElementById('btnGuardar');
            btnGuardar.disabled = true;
            btnGuardar.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Guardando...';
        });
    </script>
</body>
</html>