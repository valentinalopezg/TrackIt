<%-- 
    Document   : listarUsuarios
    Created on : 12/10/2025, 9:24:22 p. m.
    Author     : Valentina
--%>

<%@page import="modelo.UsuarioDAO"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar sesión y rol de admin
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    if (!usuarioLogueado.isAdmin()) {
        response.sendRedirect("../dashboard.jsp?error=noAutorizado");
        return;
    }
    
    // Obtener usuarios
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    List<Usuario> usuarios = usuarioDAO.listarUsuarios();
    
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuarios - Track!t</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/dashboard.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="row mb-4">
            <div class="col-md-6">
                <h2><i class="fas fa-users me-2"></i>Gestión de Usuarios</h2>
                <p class="text-muted">Administre los usuarios del sistema</p>
            </div>
            <div class="col-md-6 text-end">
                <a href="agregarUsuario.jsp" class="btn btn-primary">
                    <i class="fas fa-user-plus me-2"></i>Nuevo Usuario
                </a>
                <a href="../dashboard.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Volver
                </a>
            </div>
        </div>

        <!-- Alertas -->
        <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            if (success != null) {
                String mensaje = "";
                switch(success) {
                    case "agregado": mensaje = "Usuario agregado exitosamente"; break;
                    case "editado": mensaje = "Usuario actualizado exitosamente"; break;
                    case "eliminado": mensaje = "Usuario eliminado exitosamente"; break;
                }
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (error != null) { 
            String mensajeError = "";
            switch(error) {
                case "noAutoEliminar": mensajeError = "No puede eliminarse a sí mismo"; break;
                default: mensajeError = "Error al procesar la operación";
            }
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><%= mensajeError %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Filtros -->
        <div class="card mb-3">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <input type="text" 
                                   class="form-control" 
                                   id="buscarUsuario" 
                                   placeholder="Buscar por nombre o usuario">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroRol">
                            <option value="">Todos los roles</option>
                            <option value="admin">Administradores</option>
                            <option value="vendedor">Vendedores</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroEstado">
                            <option value="">Todos los estados</option>
                            <option value="activo">Activos</option>
                            <option value="inactivo">Inactivos</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de usuarios -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover" id="tablaUsuarios">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Identificación</th>
                                <th>Nombre Completo</th>
                                <th>Email</th>
                                <th>Usuario</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th>Fecha Registro</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (usuarios != null && !usuarios.isEmpty()) {
                                    for (Usuario u : usuarios) {
                            %>
                            <tr>
                                <td><strong>#<%= u.getIdUsuario() %></strong></td>
                                <td><%= u.getIdentificacion() %></td>
                                <td>
                                    <div>
                                        <strong><%= u.getNombreCompleto() %></strong>
                                        <% if (u.getIdUsuario() == usuarioLogueado.getIdUsuario()) { %>
                                            <br><small class="badge bg-primary">Tú</small>
                                        <% } %>
                                    </div>
                                </td>
                                <td><%= u.getEmail() %></td>
                                <td><code><%= u.getUsuario() %></code></td>
                                <td>
                                    <% if (u.isAdmin()) { %>
                                        <span class="badge bg-danger">
                                            <i class="fas fa-crown me-1"></i>Admin
                                        </span>
                                    <% } else { %>
                                        <span class="badge bg-info">
                                            <i class="fas fa-user me-1"></i>Vendedor
                                        </span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (u.isActivo()) { %>
                                        <span class="badge bg-success">Activo</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary">Inactivo</span>
                                    <% } %>
                                </td>
                                <td><%= u.getFechaCreacion() != null ? formatoFecha.format(u.getFechaCreacion()) : "-" %></td>
                                <td class="text-center">
                                    <a href="editarUsuario.jsp?id=<%= u.getIdUsuario() %>" 
                                       class="btn btn-sm btn-warning" 
                                       title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <% if (u.getIdUsuario() != usuarioLogueado.getIdUsuario()) { %>
                                    <a href="../usuario?accion=eliminar&id=<%= u.getIdUsuario() %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('¿Está seguro de eliminar este usuario?')"
                                       title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="text-center py-4">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <p class="text-muted">No hay usuarios registrados</p>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Estadísticas -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="text-primary"><%= usuarios != null ? usuarios.size() : 0 %></h3>
                        <p class="text-muted mb-0">Total Usuarios</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="text-danger">
                            <%= usuarios != null ? usuarios.stream().filter(u -> u.isAdmin()).count() : 0 %>
                        </h3>
                        <p class="text-muted mb-0">Administradores</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h3 class="text-info">
                            <%= usuarios != null ? usuarios.stream().filter(u -> u.isVendedor()).count() : 0 %>
                        </h3>
                        <p class="text-muted mb-0">Vendedores</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Búsqueda en tiempo real
        document.getElementById('buscarUsuario').addEventListener('keyup', function() {
            const filtro = this.value.toLowerCase();
            const filas = document.querySelectorAll('#tablaUsuarios tbody tr');
            
            filas.forEach(fila => {
                const texto = fila.textContent.toLowerCase();
                fila.style.display = texto.includes(filtro) ? '' : 'none';
            });
        });

        // Filtro por rol
        document.getElementById('filtroRol').addEventListener('change', function() {
            const filtro = this.value.toLowerCase();
            const filas = document.querySelectorAll('#tablaUsuarios tbody tr');
            
            if (filtro === '') {
                filas.forEach(fila => fila.style.display = '');
                return;
            }
            
            filas.forEach(fila => {
                const rolCell = fila.cells[5];
                if (rolCell) {
                    const texto = rolCell.textContent.toLowerCase();
                    fila.style.display = texto.includes(filtro) ? '' : 'none';
                }
            });
        });

        // Filtro por estado
        document.getElementById('filtroEstado').addEventListener('change', function() {
            const filtro = this.value.toLowerCase();
            const filas = document.querySelectorAll('#tablaUsuarios tbody tr');
            
            if (filtro === '') {
                filas.forEach(fila => fila.style.display = '');
                return;
            }
            
            filas.forEach(fila => {
                const estadoCell = fila.cells[6];
                if (estadoCell) {
                    const texto = estadoCell.textContent.toLowerCase();
                    fila.style.display = texto.includes(filtro) ? '' : 'none';
                }
            });
        });
    </script>
</body>
</html>
