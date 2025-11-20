<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%
    // Verificar sesión
    HttpSession sesion = request.getSession(false);
    Usuario usuarioLogueado = null;

    if (sesion != null && sesion.getAttribute("usuario") != null) {
        usuarioLogueado = (Usuario) sesion.getAttribute("usuario");
    } else {
        // Si no hay sesión, redirigir al login
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Track!t Sistema de Inventarios</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- dashboard.css -->
        <link href="css/dashboard.css" rel="stylesheet">
        <!-- Favicon -->
        <link href="images/favicon.png" rel="icon">    
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
                    <a href="dashboard.jsp" class="nav-link active">
                        <i class="fas fa-chart-pie"></i>
                        Dashboard
                    </a>
                </li>

                <div class="nav-section-title">Inventario</div>
                <li class="nav-item">
                    <a href="producto?accion=listar" class="nav-link">
                        <i class="fas fa-cube"></i>
                        Productos
                    </a>
                </li>

                <% if (usuarioLogueado.isAdmin()) { %>
                <li class="nav-item">
                    <a href="categorias/listarCategorias.jsp" class="nav-link">
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

                <% if (usuarioLogueado.isAdmin()) { %>
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

                <% if (usuarioLogueado.isAdmin()) { %>
                <div class="nav-section-title">Reportes</div>

                <li class="nav-item">
                    <a class="nav-link" href="ReporteServlet">
                        <i class="fas fa-chart-bar"></i>
                        Reportes
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="ReporteServlet">
                        <i class="fas fa-chart-bar"></i>
                        Análisis
                    </a>
                </li>
                <% } %>

                <div class="nav-section-title">Sistema</div>

                <% if (usuarioLogueado.isAdmin()) { %>
                <li class="nav-item">
                    <a href="usuarios/listarUsuarios.jsp" class="nav-link">
                        <i class="fas fa-users"></i>
                        Usuarios
                    </a>
                </li>
                <% }%>

                <li class="nav-item">
                    <a href="#" class="nav-link" onclick="showAlert('Módulo en desarrollo', 'info'); return false;">
                        <i class="fas fa-cog"></i>
                        Configuración
                    </a>
                </li>
                <li class="nav-item">
                    <a href="logout" class="nav-link" onclick="return confirm('¿Está seguro que desea cerrar sesión?');">
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
                <h1 class="page-title" id="pageTitle">Dashboard - Centro de Control</h1>
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
                    <div class="user-avatar"><%= usuarioLogueado.getIniciales()%></div>
                    <div class="user-details">
                        <div class="user-name"><%= usuarioLogueado.getNombreCompleto()%></div>
                        <div class="user-role"><%= usuarioLogueado.getRolNombre()%></div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Resto del contenido igual... -->
        <main class="main-content">
            <!-- Mensaje de bienvenida personalizado -->
            <div class="alert alert-info alert-dismissible fade show" role="alert" style="margin-bottom: 1.5rem;">
                <i class="fas fa-hand-wave"></i> 
                <strong>¡Bienvenido, <%= usuarioLogueado.getNombre()%>!</strong> 
                Has iniciado sesión como <strong><%= usuarioLogueado.getRolNombre()%></strong>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>

            <!-- Key Metrics Row -->
            <div class="stats-grid">
                <div class="stat-card inventory">
                    <div class="stat-header">
                        <span class="stat-title">Valor Total Inventario</span>
                        <div class="stat-icon primary">
                            <i class="fas fa-coins"></i>
                        </div>
                    </div>
                    <div class="stat-value" id="inventoryValue">$87,420</div>
                    <div class="stat-progress">
                        <div class="progress-bar" style="width: 78%"></div>
                    </div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>+5.2% vs mes anterior</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Ventas del Día</span>
                        <div class="stat-icon success">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>
                    <div class="stat-value" id="todaySales">$2,456</div>
                    <div class="stat-mini-chart">
                        <div class="mini-bars">
                            <div class="mini-bar" style="height: 40%"></div>
                            <div class="mini-bar" style="height: 60%"></div>
                            <div class="mini-bar" style="height: 80%"></div>
                            <div class="mini-bar" style="height: 55%"></div>
                            <div class="mini-bar active" style="height: 95%"></div>
                        </div>
                    </div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>+8% vs ayer</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Productos Activos</span>
                        <div class="stat-icon accent">
                            <i class="fas fa-cube"></i>
                        </div>
                    </div>
                    <div class="stat-value" id="activeProducts">847</div>
                    <div class="stat-breakdown">
                        <div class="breakdown-item">
                            <span class="breakdown-label">En stock:</span>
                            <span class="breakdown-value success">734</span>
                        </div>
                        <div class="breakdown-item">
                            <span class="breakdown-label">Stock bajo:</span>
                            <span class="breakdown-value warning">108</span>
                        </div>
                        <div class="breakdown-item">
                            <span class="breakdown-label">Agotados:</span>
                            <span class="breakdown-value danger">5</span>
                        </div>
                    </div>
                </div>

                <div class="stat-card alert-card">
                    <div class="stat-header">
                        <span class="stat-title">Alertas Críticas</span>
                        <div class="stat-icon danger pulse">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                    </div>
                    <div class="stat-value text-danger" id="criticalAlerts">5</div>
                    <div class="alert-summary">
                        <div class="alert-item urgent">
                            <i class="fas fa-circle"></i>
                            <span>Productos agotados</span>
                        </div>
                        <div class="alert-item warning">
                            <i class="fas fa-circle"></i>
                            <span>23 con stock crítico</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alert Container -->
            <div class="alert-container" id="alertContainer"></div>
        </main>

        <!-- Bootstrap JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                        // Toggle sidebar
                        document.getElementById('sidebarToggle').addEventListener('click', function () {
                            document.getElementById('sidebar').classList.toggle('active');
                        });

                        // Función showAlert necesaria para los links
                        function showAlert(message, type = 'info', duration = 4000) {
                            const alertContainer = document.getElementById('alertContainer');
                            const alertDiv = document.createElement('div');
                            alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
                            alertDiv.setAttribute('role', 'alert');
                            alertDiv.innerHTML = '<i class="fas fa-info-circle"></i> ' + message +
                                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
                            alertContainer.appendChild(alertDiv);

                            setTimeout(function () {
                                if (alertDiv.parentElement) {
                                    const bsAlert = bootstrap.Alert.getInstance(alertDiv);
                                    if (bsAlert)
                                        bsAlert.close();
                                }
                            }, duration);
                        }

                        // Auto-cerrar alerta de bienvenida
                        setTimeout(function () {
                            const alerts = document.querySelectorAll('.alert');
                            alerts.forEach(alert => {
                                if (alert.classList.contains('alert-info')) {
                                    const bsAlert = bootstrap.Alert.getInstance(alert);
                                    if (bsAlert)
                                        bsAlert.close();
                                }
                            });
                        }, 5000);

                        console.log('Dashboard cargado para: <%= usuarioLogueado.getNombreCompleto()%> (<%= usuarioLogueado.getRol()%>)');
        </script>
    </body>
</html>