<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
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
    
    // Obtener el usuario a editar
    int idUsuario = 0;
    try {
        idUsuario = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + "/usuarios/listarUsuarios.jsp?error=idInvalido");
        return;
    }
    
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    Usuario usuario = usuarioDAO.obtenerUsuarioPorId(idUsuario);
    
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/usuarios/listarUsuarios.jsp?error=usuarioNoEncontrado");
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
    <title>Editar Usuario - Track!t</title>
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
                        <i class="fas fa-edit"></i> Editar Usuario
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
        <div class="container-edicion">
            <div class="header-edicion">
                <h1>
                    <i class="fas fa-edit"></i> Editar: <%= usuario.getNombreCompleto() %>
                    <span class="badge-estado <%= usuario.isActivo() ? "activa" : "inactiva" %>">
                        <%= usuario.isActivo() ? "ACTIVO" : "INACTIVO" %>
                    </span>
                </h1>
                <p>Modifique los datos del usuario según sea necesario</p>
            </div>

            <form action="<%= request.getContextPath() %>/usuario" method="POST" id="formEditarUsuario">
                <input type="hidden" name="accion" value="editar">
                <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>">

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
                                   value="<%= usuario.getIdentificacion() %>"
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
                                   value="<%= usuario.getNombre() %>"
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
                                   value="<%= usuario.getApellido() %>"
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
                                   value="<%= usuario.getEmail() %>"
                                   required 
                                   maxlength="100">
                            <small class="form-text">Correo electrónico único</small>
                        </div>

                        <div class="form-group">
                            <label for="estado">
                                <i class="fas fa-toggle-on"></i> Estado
                                <span class="text-danger">*</span>
                            </label>
                            <select id="estado" name="estado" required>
                                <option value="activo" <%= "activo".equals(usuario.getEstado()) ? "selected" : "" %>>
                                    ✓ Activo - Usuario puede acceder
                                </option>
                                <option value="inactivo" <%= "inactivo".equals(usuario.getEstado()) ? "selected" : "" %>>
                                    ✗ Inactivo - Usuario bloqueado
                                </option>
                            </select>
                            <small class="form-text">
                                Los usuarios inactivos no podrán acceder al sistema
                            </small>
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
                                       value="<%= usuario.getUsuario() %>"
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
                                       value="<%= usuario.getClave() %>"
                                       required 
                                       minlength="6" 
                                       maxlength="255">
                                <button class="btn btn-outline-secondary" 
                                        type="button" 
                                        id="togglePassword"
                                        style="border: 2px solid var(--medium-gray); border-left: none; border-radius: 0 8px 8px 0;">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <small class="form-text">Cambiar si desea actualizar la contraseña</small>
                        </div>

                        <div class="form-group">
                            <label for="rol">
                                <i class="fas fa-user-shield"></i> Rol del Usuario
                                <span class="text-danger">*</span>
                            </label>
                            <select id="rol" name="rol" required>
                                <option value="admin" <%= "admin".equals(usuario.getRol()) ? "selected" : "" %>>
                                    👑 Administrador - Acceso total
                                </option>
                                <option value="vendedor" <%= "vendedor".equals(usuario.getRol()) ? "selected" : "" %>>
                                    👤 Vendedor - Acceso limitado
                                </option>
                            </select>
                            <small class="form-text">
                                <strong>Admin:</strong> Gestión completa | 
                                <strong>Vendedor:</strong> Solo consultas
                            </small>
                        </div>

                        <!-- Info fecha registro -->
                        <div style="background: #dbeafe; border-left: 4px solid #3b82f6; padding: 1rem; border-radius: 6px; margin-top: 1rem;">
                            <div style="display: flex; gap: 0.5rem; align-items: flex-start;">
                                <i class="fas fa-calendar" style="color: #3b82f6; margin-top: 2px;"></i>
                                <div style="font-size: 0.9rem; line-height: 1.5;">
                                    <strong style="color: #1e40af;">Fecha de registro:</strong><br>
                                    <span style="color: #1e3a8a;">
                                        <%= usuario.getFechaRegistro() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(usuario.getFechaRegistro()) : "No disponible" %>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <% if (usuario.getIdUsuario() == usuarioLogueado.getIdUsuario()) { %>
                        <div style="background: #fef3c7; border-left: 4px solid #f59e0b; padding: 1rem; border-radius: 6px; margin-top: 1rem;">
                            <div style="display: flex; gap: 0.5rem; align-items: flex-start;">
                                <i class="fas fa-exclamation-triangle" style="color: #f59e0b; margin-top: 2px;"></i>
                                <span style="font-size: 0.9rem; color: #92400e;">
                                    <strong>Advertencia:</strong> Estás editando tu propio perfil
                                </span>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-primary" id="btnGuardar">
                        <i class="fas fa-save"></i> Actualizar Usuario
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
        document.getElementById('pageTitle').textContent = 'Editar Usuario';

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

        // Confirmación al cambiar estado a inactivo
        document.getElementById('estado').addEventListener('change', function() {
            if (this.value === 'inactivo') {
                const confirmar = confirm('⚠️ Al inactivar este usuario, no podrá acceder al sistema.\n\n¿Está seguro de continuar?');
                if (!confirmar) {
                    this.value = 'activo';
                }
            }
        });

        // Validar formato de usuario (solo minúsculas, números y guión bajo)
        document.getElementById('usuario').addEventListener('input', function() {
            this.value = this.value.toLowerCase().replace(/[^a-z0-9_]/g, '');
        });

        // Validación antes de enviar
        document.getElementById('formEditarUsuario').addEventListener('submit', function(e) {
            const clave = document.getElementById('clave').value;
            
            if (clave.length < 6) {
                e.preventDefault();
                alert('❌ La contraseña debe tener al menos 6 caracteres');
                document.getElementById('clave').focus();
                return false;
            }
            
            // Deshabilitar botón para evitar doble envío
            const btnGuardar = document.getElementById('btnGuardar');
            btnGuardar.disabled = true;
            btnGuardar.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Actualizando...';
        });
    </script>
</body>
</html>