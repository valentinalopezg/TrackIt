<%-- 
    Document   : topbar
    Created on : 20/11/2025, 7:18:35 a. m.
    Author     : Valentina
--%>

<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
    if (usuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!-- Top Bar -->
<header class="topbar">
    <div class="topbar-left">
        <button class="sidebar-toggle" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>
        <h1 class="page-title" id="pageTitle">
            <!-- El título se puede personalizar en cada página -->
        </h1>
    </div>

    <div class="topbar-right">
        <div class="search-box">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Buscar producto...">
        </div>

        <button class="notification-btn" id="notificationBtn">
            <i class="fas fa-bell"></i>
            <span class="notification-badge">5</span>
        </button>

        <div class="user-info">
            <div class="user-avatar"><%= usuarioLogueado.getIniciales() %></div>
            <div class="user-details">
                <div class="user-name"><%= usuarioLogueado.getNombreCompleto() %></div>
                <div class="user-role"><%= usuarioLogueado.getRolNombre() %></div>
            </div>
        </div>
    </div>
</header>
