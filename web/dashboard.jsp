
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    if (sesion.getAttribute("usuario") == null) {
        sesion.setAttribute("usuario", "admin"); // usuario predeterminado temporal
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
                    <a href="#" class="nav-link active" data-section="dashboard">
                        <i class="fas fa-chart-pie"></i>
                        Dashboard
                    </a>
                </li>

                <div class="nav-section-title">Inventario</div>
                <li class="nav-item">
                    <a href="producto?accion=listar" class="nav-link" data-section="products">
                        <i class="fas fa-cube"></i>
                        Productos
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="categories">
                        <i class="fas fa-layer-group"></i>
                        Categorías
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="stock">
                        <i class="fas fa-boxes"></i>
                        Control de Stock
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="suppliers">
                        <i class="fas fa-truck"></i>
                        Proveedores
                    </a>
                </li>

                <div class="nav-section-title">Ventas</div>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="sales">
                        <i class="fas fa-cash-register"></i>
                        Nueva Venta
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="sales-history">
                        <i class="fas fa-receipt"></i>
                        Historial Ventas
                    </a>
                </li>

                <div class="nav-section-title">Reportes</div>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="reports">
                        <i class="fas fa-chart-bar"></i>
                        Reportes
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="analytics">
                        <i class="fas fa-chart-line"></i>
                        Análisis
                    </a>
                </li>

                <div class="nav-section-title">Sistema</div>
                <li class="nav-item">
                    <a href="#" class="nav-link" data-section="settings">
                        <i class="fas fa-cog"></i>
                        Configuración
                    </a>
                </li>
                <li class="nav-item">
                    <a href="index.jsp" class="nav-link" onclick="logout()">
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
                    <div class="user-avatar">A</div>
                    <div class="user-details">
                        <div class="user-name">Administrador</div>
                        <div class="user-role">Gerente</div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
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

            <!-- Alert Cards Section -->
            <div class="alert-cards-section">
                <div class="alert-cards-grid">
                    <div class="alert-card critical">
                        <div class="alert-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="alert-content">
                            <h4>Productos Agotados</h4>
                            <p>5 productos requieren reabastecimiento inmediato</p>
                            <div class="alert-products">
                                <span class="product-tag urgent">Auriculares BT</span>
                                <span class="product-tag urgent">Tinta HP Negro</span>
                                <span class="alert-more">+3 más</span>
                            </div>
                        </div>
                        <div class="alert-action">
                            <button class="btn-urgent">Ver Detalles</button>
                        </div>
                    </div>

                    <div class="alert-card warning">
                        <div class="alert-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="alert-content">
                            <h4>Stock Próximo a Agotarse</h4>
                            <p>23 productos con menos de 10 unidades</p>
                            <div class="alert-products">
                                <span class="product-tag warning">Mouse Logitech</span>
                                <span class="product-tag warning">Cable USB</span>
                                <span class="alert-more">+21 más</span>
                            </div>
                        </div>
                        <div class="alert-action">
                            <button class="btn-warning">Revisar</button>
                        </div>
                    </div>

                    <div class="alert-card info">
                        <div class="alert-icon">
                            <i class="fas fa-truck"></i>
                        </div>
                        <div class="alert-content">
                            <h4>Pedidos Pendientes</h4>
                            <p>3 pedidos esperando confirmación de llegada</p>
                            <div class="alert-timeline">
                                <div class="timeline-item">
                                    <span class="timeline-date">Hoy</span>
                                    <span class="timeline-desc">Teclados mecánicos (50 uds)</span>
                                </div>
                            </div>
                        </div>
                        <div class="alert-action">
                            <button class="btn-info">Gestionar</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content Grid -->
            <div class="content-grid">
                <!-- Enhanced Sales Chart -->
                <div class="card chart-container">
                    <div class="chart-header">
                        <h3 class="card-title">Movimiento de Inventario - Últimos 30 días</h3>
                        <div class="chart-filters">
                            <button class="filter-btn active">Entradas</button>
                            <button class="filter-btn">Salidas</button>
                            <button class="filter-btn">Neto</button>
                        </div>
                    </div>
                    <div class="chart-visual">
                        <div class="chart-legend">
                            <div class="legend-item">
                                <div class="legend-color entries"></div>
                                <span>Entradas</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color exits"></div>
                                <span>Salidas</span>
                            </div>
                        </div>
                        <div class="chart-bars">
                            <div class="bar-group">
                                <div class="bar entries" style="height: 60%"><span>45</span></div>
                                <div class="bar exits" style="height: 40%"></div>
                            </div>
                            <div class="bar-group">
                                <div class="bar entries" style="height: 80%"><span>67</span></div>
                                <div class="bar exits" style="height: 60%"></div>
                            </div>
                            <div class="bar-group">
                                <div class="bar entries" style="height: 45%"><span>32</span></div>
                                <div class="bar exits" style="height: 55%"></div>
                            </div>
                            <div class="bar-group">
                                <div class="bar entries active" style="height: 95%"><span>89</span></div>
                                <div class="bar exits" style="height: 70%"></div>
                            </div>
                            <div class="bar-group">
                                <div class="bar entries" style="height: 70%"><span>52</span></div>
                                <div class="bar exits" style="height: 45%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Enhanced Recent Activities -->
                <div class="card activities-card">
                    <div class="card-header">
                        <h3 class="card-title">Actividad Reciente</h3>
                        <div class="activity-filter">
                            <select class="form-select form-select-sm">
                                <option>Todas</option>
                                <option>Ventas</option>
                                <option>Inventario</option>
                                <option>Alertas</option>
                            </select>
                        </div>
                    </div>
                    <div class="activity-timeline">
                        <div class="activity-item recent">
                            <div class="activity-time">5 min</div>
                            <div class="activity-indicator success"></div>
                            <div class="activity-content">
                                <h5>Venta Procesada</h5>
                                <p>Laptop HP Pavilion - <strong>$899</strong></p>
                                <span class="activity-meta">Cliente: Juan Pérez</span>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-time">12 min</div>
                            <div class="activity-indicator warning"></div>
                            <div class="activity-content">
                                <h5>Alerta de Stock</h5>
                                <p>Mouse Inalámbrico - Solo <strong>3 unidades</strong></p>
                                <span class="activity-meta">Límite mínimo: 10 unidades</span>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-time">1 hora</div>
                            <div class="activity-indicator info"></div>
                            <div class="activity-content">
                                <h5>Producto Agregado</h5>
                                <p>Teclado Mecánico RGB - <strong>50 unidades</strong></p>
                                <span class="activity-meta">Proveedor: TechSupplies</span>
                            </div>
                        </div>

                        <div class="activity-item">
                            <div class="activity-time">2 horas</div>
                            <div class="activity-indicator danger"></div>
                            <div class="activity-content">
                                <h5>Producto Agotado</h5>
                                <p>Auriculares Bluetooth Sony</p>
                                <span class="activity-meta">Último vendido: 14:30</span>
                            </div>
                        </div>
                    </div>
                    <div class="activity-footer">
                        <button class="btn-link">Ver todas las actividades</button>
                    </div>
                </div>
            </div>

            <!-- Enhanced Critical Stock Table -->
            <div class="card stock-table-card">
                <div class="card-header">
                    <h3 class="card-title">Productos Críticos - Requieren Atención</h3>
                    <div class="table-actions">
                        <button class="btn-export">
                            <i class="fas fa-download"></i> Exportar
                        </button>
                        <button class="btn-restock-all">
                            <i class="fas fa-plus"></i> Reabastecer Todo
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" class="select-all">
                                </th>
                                <th>Producto</th>
                                <th>Categoría</th>
                                <th>Stock Actual</th>
                                <th>Stock Mínimo</th>
                                <th>Última Venta</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="criticalStockTable">
                            <tr class="critical-row">
                                <td>
                                    <input type="checkbox" class="row-select">
                                </td>
                                <td>
                                    <div class="product-info">
                                        <div class="product-name">Auriculares Bluetooth Sony WH-1000XM4</div>
                                        <div class="product-sku">SKU: AUD003</div>
                                    </div>
                                </td>
                                <td>
                                    <span class="category-badge audio">Audio</span>
                                </td>
                                <td>
                                    <span class="stock-level critical">0</span>
                                </td>
                                <td>5</td>
                                <td>Ayer 14:30</td>
                                <td>
                                    <span class="stock-badge out">Agotado</span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn-urgent btn-sm">
                                            <i class="fas fa-exclamation"></i> Urgente
                                        </button>
                                        <button class="btn-action" title="Ver detalles">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>

                            <tr class="warning-row">
                                <td>
                                    <input type="checkbox" class="row-select">
                                </td>
                                <td>
                                    <div class="product-info">
                                        <div class="product-name">Mouse Inalámbrico Logitech MX Master 3</div>
                                        <div class="product-sku">SKU: MOU001</div>
                                    </div>
                                </td>
                                <td>
                                    <span class="category-badge peripherals">Periféricos</span>
                                </td>
                                <td>
                                    <span class="stock-level low">3</span>
                                </td>
                                <td>10</td>
                                <td>Hoy 09:15</td>
                                <td>
                                    <span class="stock-badge low">Stock Bajo</span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn-warning btn-sm">
                                            <i class="fas fa-truck"></i> Reabastecer
                                        </button>
                                        <button class="btn-action" title="Ver detalles">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>

                            <tr class="warning-row">
                                <td>
                                    <input type="checkbox" class="row-select">
                                </td>
                                <td>
                                    <div class="product-info">
                                        <div class="product-name">Tinta HP 664 Negro Original</div>
                                        <div class="product-sku">SKU: INK002</div>
                                    </div>
                                </td>
                                <td>
                                    <span class="category-badge consumables">Consumibles</span>
                                </td>
                                <td>
                                    <span class="stock-level low">2</span>
                                </td>
                                <td>15</td>
                                <td>Hace 3 horas</td>
                                <td>
                                    <span class="stock-badge low">Stock Bajo</span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn-warning btn-sm">
                                            <i class="fas fa-truck"></i> Reabastecer
                                        </button>
                                        <button class="btn-action" title="Ver detalles">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="table-footer">
                    <div class="table-info">
                        Mostrando 3 de 28 productos críticos
                    </div>
                    <div class="table-pagination">
                        <button class="btn-pagination">Anterior</button>
                        <span class="pagination-info">1 de 10</span>
                        <button class="btn-pagination">Siguiente</button>
                    </div>
                </div>
            </div>
        </main>



        <!-- Alert Container -->
        <div class="alert-container" id="alertContainer"></div>

        <!-- Bootstrap JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                        // [Mantener el JavaScript existente pero agregar nuevas funciones para los componentes mejorados]

                        // Variables globales mejoradas
                        let sidebarActive = false;
                        let alertTimeout;
                        // Datos simulados expandidos
                        const dashboardData = {
                        inventoryValue: 87420,
                                totalProducts: 847,
                                todaySales: 2456,
                                activeProducts: 734,
                                lowStock: 108,
                                outOfStock: 5,
                                criticalAlerts: 5,
                                salesData: [1200, 1900, 3000, 5000, 2000, 3000, 2500],
                                inventoryMovement: {
                                entries: [45, 67, 32, 89, 52],
                                        exits: [38, 54, 41, 67, 43]
                                }
                        };
                        // Inicialización mejorada
                        document.addEventListener('DOMContentLoaded', function() {
                        initializeDashboard();
                        setupEventListeners();
                        setupEnhancedFeatures();
                        showWelcomeAlert();
                        simulateRealTimeUpdates();
                        });
                        // Nuevas funciones para características mejoradas
                        function setupEnhancedFeatures() {
                        // Configurar filtros de gráfico
                        const filterButtons = document.querySelectorAll('.filter-btn');
                        filterButtons.forEach(btn => {
                        btn.addEventListener('click', function() {
                        filterButtons.forEach(b => b.classList.remove('active'));
                        this.classList.add('active');
                        updateChartData(this.textContent.toLowerCase());
                        });
                        });
                        // Configurar selección múltiple en tabla
                        const selectAll = document.querySelector('.select-all');
                        if (selectAll) {
                        selectAll.addEventListener('change', function() {
                        const rowSelects = document.querySelectorAll('.row-select');
                        rowSelects.forEach(checkbox => {
                        checkbox.checked = this.checked;
                        });
                        });
                        }

                        // Configurar búsqueda
                        const searchInput = document.querySelector('.search-box input');
                        if (searchInput) {
                        searchInput.addEventListener('input', debounce(function() {
                        performSearch(this.value);
                        }, 300));
                        }
                        }

                        function updateChartData(filter) {
                        // Simular actualización de gráfico
                        showAlert(`Actualizando vista: ${filter}`, 'info', 2000);
                        }

                        function performSearch(query) {
                        if (query.length > 2) {
                        showAlert(`Buscando: "${query}"...`, 'info', 2000);
                        }
                        }

                        function debounce(func, wait) {
                        let timeout;
                        return function executedFunction(...args) {
                        const later = () => {
                        clearTimeout(timeout);
                        func(...args);
                        };
                        clearTimeout(timeout);
                        timeout = setTimeout(later, wait);
                        };
                        }

                        // Mantener funciones existentes y agregar las mejoras
                        // [Resto del JavaScript existente...]

                        // Funciones existentes
                        function setupEventListeners() {
                        const sidebarToggle = document.getElementById('sidebarToggle');
                        if (sidebarToggle) {
                        sidebarToggle.addEventListener('click', toggleSidebar);
                        }

                        const navLinks = document.querySelectorAll('.nav-link[data-section]');
                        navLinks.forEach(link => {
                        link.addEventListener('click', function(e) {
                        e.preventDefault();
                        handleNavigation(this);
                        });
                        });
                        const notificationBtn = document.getElementById('notificationBtn');
                        if (notificationBtn) {
                        notificationBtn.addEventListener('click', showNotifications);
                        }

                        document.addEventListener('click', function(e) {
                        if (window.innerWidth <= 768 && sidebarActive) {
                        const sidebar = document.getElementById('sidebar');
                        if (!sidebar.contains(e.target) && !e.target.closest('#sidebarToggle')) {
                        closeSidebar();
                        }
                        }
                        });
                        window.addEventListener('resize', handleResize);
                        }

                        function toggleSidebar() {
                        const sidebar = document.getElementById('sidebar');
                        sidebarActive = !sidebarActive;
                        if (sidebarActive) {
                        sidebar.classList.add('active');
                        } else {
                        sidebar.classList.remove('active');
                        }
                        }

                        function closeSidebar() {
                        const sidebar = document.getElementById('sidebar');
                        sidebar.classList.remove('active');
                        sidebarActive = false;
                        }

                        function handleNavigation(clickedLink) {
                        document.querySelectorAll('.nav-link').forEach(link => {
                        link.classList.remove('active');
                        });
                        clickedLink.classList.add('active');
                        const section = clickedLink.dataset.section;
                        const sectionTitles = {
                        'dashboard': 'Dashboard - Centro de Control',
                                'products': 'Gestión de Productos',
                                'categories': 'Categorías',
                                'stock': 'Control de Stock',
                                'suppliers': 'Gestión de Proveedores',
                                'sales': 'Nueva Venta',
                                'sales-history': 'Historial de Ventas',
                                'reports': 'Reportes',
                                'analytics': 'Análisis y Estadísticas',
                                'settings': 'Configuración'
                        };
                        document.getElementById('pageTitle').textContent = sectionTitles[section] || 'Dashboard';
                        if (window.innerWidth <= 768) {
                        closeSidebar();
                        }

                        if (section !== 'dashboard') {
                        showAlert(`Navegando a: ${sectionTitles[section]}`, 'info');
                        }
                        }

                        function showNotifications() {
                        showAlert('5 notificaciones: 5 productos agotados, 23 con stock bajo, 3 pedidos pendientes', 'info');
                        }

                        function showAlert(message, type = 'info', duration = 4000) {
                        const alertContainer = document.getElementById('alertContainer');
                        const alertDiv = document.createElement('div');
                        alertDiv.className = `alert-custom alert-${type}`;
                        let icon = '';
                        switch (type) {
                        case 'success': icon = 'fas fa-check-circle'; break;
                        case 'warning': icon = 'fas fa-exclamation-triangle'; break;
                        case 'danger': icon = 'fas fa-times-circle'; break;
                        default: icon = 'fas fa-info-circle';
                        }

                        alertDiv.innerHTML = `
                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                        <i class="${icon}"></i>
                        <span>${message}</span>
                    </div>
                    <button type="button" class="btn-close" onclick="closeAlert(this)"></button>
                `;
                        alertContainer.appendChild(alertDiv);
                        setTimeout(() => {
                        if (alertDiv && alertDiv.parentElement) {
                        closeAlert(alertDiv.querySelector('.btn-close'));
                        }
                        }, duration);
                        }

                        function closeAlert(button) {
                        const alert = button.closest('.alert-custom');
                        alert.classList.add('alert-fade-out');
                        setTimeout(() => {
                        if (alert.parentElement) {
                        alert.remove();
                        }
                        }, 300);
                        }

                        function initializeDashboard() {
                        updateStats();
                        simulateDataLoading();
                        }

                        function updateStats() {
                        document.getElementById('inventoryValue').textContent = ' + dashboardData.inventoryValue.toLocaleString();
                                document.getElementById('todaySales').textContent = ' + dashboardData.todaySales.toLocaleString();
                                document.getElementById('activeProducts').textContent = dashboardData.totalProducts;
                        document.getElementById('criticalAlerts').textContent = dashboardData.criticalAlerts;
                        }

                        function simulateDataLoading() {
                        const cards = document.querySelectorAll('.stat-card, .card');
                        cards.forEach((card, index) => {
                        card.style.opacity = '0';
                        card.style.transform = 'translateY(20px)';
                        setTimeout(() => {
                        card.style.transition = 'all 0.5s ease';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                        }, index * 100);
                        });
                        }

                        function simulateRealTimeUpdates() {
                        setInterval(() => {
                        const increment = Math.floor(Math.random() * 200) + 50;
                        dashboardData.todaySales += increment;
                        document.getElementById('todaySales').textContent = ' + dashboardData.todaySales.toLocaleString();

                                if (Math.random() < 0.3) {
                        const products = ['Laptop Dell', 'Mouse Logitech', 'Teclado Mecánico', 'Monitor Samsung', 'Impresora HP'];
                        const randomProduct = products[Math.floor(Math.random() * products.length)];
                        const randomPrice = (Math.random() * 500 + 50).toFixed(0);
                        showAlert(`Nueva venta: ${randomProduct} - ${randomPrice}`, 'success', 3000);
                        }
                        }, 15000);
                        setInterval(() => {
                        if (Math.random() < 0.2) {
                        const products = ['Tinta Color', 'Cables USB', 'Memoria RAM', 'Disco Duro'];
                        const randomProduct = products[Math.floor(Math.random() * products.length)];
                        showAlert(`⚠️ Stock crítico: ${randomProduct} - Requiere reabastecimiento`, 'warning', 5000);
                        }
                        }, 25000);
                        }

                        function showWelcomeAlert() {
                        setTimeout(() => {
                        showAlert('¡Sistema Track!t iniciado correctamente! Monitoreo en tiempo real activo.', 'success', 5000);
                        }, 1000);
                        }

                        function handleResize() {
                        if (window.innerWidth > 768) {
                        const sidebar = document.getElementById('sidebar');
                        sidebar.classList.remove('active');
                        sidebarActive = false;
                        }
                        }

                        function logout() {
                        if (confirm('¿Está seguro que desea cerrar sesión?')) {
                        showAlert('Cerrando sesión...', 'info', 2000);
                        setTimeout(() => {
                        window.location.href = 'index.jsp';
                        }, 2000);
                        }
                        }

                        // Exponer funciones globalmente
                        window.logout = logout;
                        window.closeAlert = closeAlert;
        </script>
    </body>
</html>