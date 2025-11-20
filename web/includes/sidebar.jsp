<%-- 
    Document   : sidebar
    Created on : 20/11/2025, 7:18:03 a. m.
    Author     : Valentina
--%>


<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Obtener usuario de la sesión
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    
    // Si no hay usuario, redirigir al login
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    boolean esAdmin = usuarioLogueado.isAdmin();
    
    // Obtener la página actual para marcar el item activo
    String currentPage = request.getRequestURI();
%>

<!-- Sidebar -->
<nav class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">Track!t</div>
        <div class="sidebar-subtitle">Sistema de Inventarios</div>
    </div>

    <ul class="sidebar-nav">
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/dashboard.jsp" 
               class="nav-link <%= currentPage.contains("dashboard.jsp") ? "active" : "" %>">
                <i class="fas fa-chart-pie"></i>
                Dashboard
            </a>
        </li>

        <div class="nav-section-title">Inventario</div>
        
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/producto?accion=listar" 
               class="nav-link <%= currentPage.contains("producto") || currentPage.contains("Producto") ? "active" : "" %>">
                <i class="fas fa-cube"></i>
                Productos
            </a>
        </li>
        
        <% if (esAdmin) { %>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/categorias/listarCategorias.jsp" 
               class="nav-link <%= currentPage.contains("Categorias") ? "active" : "" %>">
                <i class="fas fa-layer-group"></i>
                Categorías
            </a>
        </li>
        <% } %>
        
        <li class="nav-item">
            <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                <i class="fas fa-boxes"></i>
                Control de Stock
            </a>
        </li>
        
        <% if (esAdmin) { %>
        <li class="nav-item">
            <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                <i class="fas fa-truck"></i>
                Proveedores
            </a>
        </li>
        <% } %>
        
        <div class="nav-section-title">Ventas</div>
        
        <li class="nav-item">
            <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                <i class="fas fa-cash-register"></i>
                Nueva Venta
            </a>
        </li>
        <li class="nav-item">
            <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                <i class="fas fa-receipt"></i>
                Historial Ventas
            </a>
        </li>

        <% if (esAdmin) { %>
        <div class="nav-section-title">Reportes</div>
        
        <li class="nav-item">
            <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                <i class="fas fa-chart-bar"></i>
                Reportes
            </a>
        </li>
        <li class="nav-item">
            <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                <i class="fas fa-chart-line"></i>
                Análisis
            </a>
        </li>
        <% } %>

        <div class="nav-section-title">Sistema</div>
        
        <% if (esAdmin) { %>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/usuarios/listarUsuarios.jsp" 
               class="nav-link <%= currentPage.contains("Usuarios") ? "active" : "" %>">
                <i class="fas fa-users"></i>
                Usuarios
            </a>
        </li>
        <% } %>
        
        <li class="nav-item">
            <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                <i class="fas fa-cog"></i>
                Configuración
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/logout" 
               class="nav-link" 
               onclick="return confirm('¿Está seguro que desea cerrar sesión?');">
                <i class="fas fa-sign-out-alt"></i>
                Cerrar Sesión
            </a>
        </li>
    </ul>
</nav>
