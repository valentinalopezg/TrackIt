<%-- 
    Document   : editarUsuario
    Created on : 12/10/2025, 10:11:12 p. m.
    Author     : Valentina
--%>

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
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Editar Usuario - Track!t</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Dashboard CSS -->
        <link href="<%= request.getContextPath() %>/css/dashboard.css" rel="stylesheet">
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

                <div class="nav-section-title">Sistema</div>
                <li class="nav-item">
                    <a href="<%= request.getContextPath() %>/usuarios/listarUsuarios.jsp" class="nav-link active">
                        <i class="fas fa-users"></i>
                        Usuarios
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
                <h1 class="page-title">Editar Usuario</h1>
            </div>

            <div class="topbar-right">
                <div class="user-info">
                    <div class="user-avatar"><%= usuarioLogueado.getIniciales() %></div>
                    <div class="user-details">
                        <div class="user-name"><%= usuarioLogueado.getNombreCompleto() %></div>
                        <div class="user-role"><%= usuarioLogueado.getRolNombre() %></div>
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
                        <a href="<%= request.getContextPath() %>/usuarios/listarUsuarios.jsp" style="color: var(--primary-color);">
                            Usuarios
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Editar Usuario</li>
                </ol>
            </nav>

            <!-- Mensajes de error -->
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="card">
                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <h2 class="card-title">
                        <i class="fas fa-edit"></i> Editar: <%= usuario.getNombreCompleto() %>
                    </h2>
                    <a href="<%= request.getContextPath() %>/usuarios/listarUsuarios.jsp" class="btn-back" 
                       style="background: #e2e8f0; color: #4a5568; padding: 0.5rem 1rem; border-radius: 8px; text-decoration: none;">
                        <i class="fas fa-arrow-left"></i> Volver
                    </a>
                </div>

                <div style="padding: 2rem;">
                    <form action="<%= request.getContextPath() %>/usuario" method="POST" id="formUsuario">
                        <input type="hidden" name="accion" value="editar">
                        <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>">

                        <div class="row">
                            <!-- Columna izquierda -->
                            <div class="col-md-6">
                                <h5 style="color: var(--primary-color); margin-bottom: 1rem;">
                                    <i class="fas fa-id-card"></i> Información Personal
                                </h5>

                                <!-- Identificación -->
                                <div class="mb-3">
                                    <label for="identificacion" class="form-label">
                                        Identificación (CC/DNI) <span style="color: red;">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="identificacion" name="identificacion" 
                                           required value="<%= usuario.getIdentificacion() %>" maxlength="20">
                                </div>

                                <!-- Nombre -->
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">
                                        Nombre <span style="color: red;">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                           required value="<%= usuario.getNombre() %>" maxlength="100">
                                </div>

                                <!-- Apellido -->
                                <div class="mb-3">
                                    <label for="apellido" class="form-label">
                                        Apellido <span style="color: red;">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="apellido" name="apellido" 
                                           required value="<%= usuario.getApellido() %>" maxlength="100">
                                </div>

                                <!-- Email -->
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        Email <span style="color: red;">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           required value="<%= usuario.getEmail() %>" maxlength="100">
                                </div>

                                <!-- Estado -->
                                <div class="mb-3">
                                    <label for="estado" class="form-label">Estado del Usuario</label>
                                    <select class="form-select" id="estado" name="estado">
                                        <option value="activo" <%= "activo".equals(usuario.getEstado()) ? "selected" : "" %>>
                                            Activo - Usuario puede acceder
                                        </option>
                                        <option value="inactivo" <%= "inactivo".equals(usuario.getEstado()) ? "selected" : "" %>>
                                            Inactivo - Usuario bloqueado
                                        </option>
                                    </select>
                                </div>
                            </div>

                            <!-- Columna derecha -->
                            <div class="col-md-6">
                                <h5 style="color: var(--success-color); margin-bottom: 1rem;">
                                    <i class="fas fa-key"></i> Credenciales de Acceso
                                </h5>

                                <!-- Usuario -->
                                <div class="mb-3">
                                    <label for="usuario" class="form-label">
                                        Nombre de Usuario <span style="color: red;">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <input type="text" class="form-control" id="usuario" name="usuario" 
                                               required value="<%= usuario.getUsuario() %>" maxlength="50" 
                                               pattern="[a-zA-Z0-9_]+">
                                    </div>
                                </div>

                                <!-- Contraseña -->
                                <div class="mb-3">
                                    <label for="clave" class="form-label">
                                        Contraseña <span style="color: red;">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="clave" name="clave" 
                                               required value="<%= usuario.getClave() %>" minlength="6" maxlength="255">
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <small class="form-text text-muted">Cambiar si desea actualizar la contraseña</small>
                                </div>

                                <!-- Rol -->
                                <div class="mb-3">
                                    <label for="rol" class="form-label">
                                        Rol del Usuario <span style="color: red;">*</span>
                                    </label>
                                    <select class="form-select" id="rol" name="rol" required>
                                        <option value="admin" <%= "admin".equals(usuario.getRol()) ? "selected" : "" %>>
                                            Administrador - Acceso total
                                        </option>
                                        <option value="vendedor" <%= "vendedor".equals(usuario.getRol()) ? "selected" : "" %>>
                                            Vendedor - Acceso limitado
                                        </option>
                                    </select>
                                </div>

                                <!-- Info fecha registro -->
                                <div class="alert alert-info" style="font-size: 0.9rem;">
                                    <i class="fas fa-calendar"></i> <strong>Registro:</strong><br>
                                    <%= usuario.getFechaRegistro() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(usuario.getFechaRegistro()) : "No disponible" %>
                                </div>

                                <% if (usuario.getIdUsuario() == usuarioLogueado.getIdUsuario()) { %>
                                <div class="alert alert-warning" style="font-size: 0.9rem;">
                                    <i class="fas fa-exclamation-triangle"></i> Estás editando tu propio perfil
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Botones -->
                        <div style="border-top: 1px solid var(--border-color); padding-top: 1.5rem; margin-top: 1.5rem;">
                            <button type="submit" class="btn btn-primary" style="padding: 0.75rem 2rem;" id="btnGuardar">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                            <a href="<%= request.getContextPath() %>/usuarios/listarUsuarios.jsp" 
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

            // Validación antes de enviar
            document.getElementById('formUsuario').addEventListener('submit', function(e) {
                const clave = document.getElementById('clave').value;
                
                if (clave.length < 6) {
                    e.preventDefault();
                    alert('❌ La contraseña debe tener al menos 6 caracteres');
                    document.getElementById('clave').focus();
                    return false;
                }
                
                // Deshabilitar botón para evitar doble envío
                document.getElementById('btnGuardar').disabled = true;
                document.getElementById('btnGuardar').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Guardando...';
            });

            // Validar formato de usuario
            document.getElementById('usuario').addEventListener('input', function() {
                this.value = this.value.toLowerCase().replace(/[^a-z0-9_]/g, '');
            });
        </script>
    </body>
</html>
