<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Track!t - Sistema de Inventarios</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- login.css -->
        <link href="css/login.css" rel="stylesheet">
        <!-- Favicon -->
        <link href="images/favicon.png" rel="icon">
    </head>
    <body>
        <div class="login-container">
            <div class="login-card">
                <!-- Panel de marca -->
                <div class="brand-panel">
                    <img src="images/logo.png" alt="TrackIT Logo" class="logo-image">
                    <div class="brand-subtitle">Sistema Integral de Inventarios</div>

                    <ul class="features-list">
                        <li><i class="fas fa-boxes"></i> Control de inventario en tiempo real</li>
                        <li><i class="fas fa-shopping-cart"></i> Gestión de ventas integrada</li>
                        <li><i class="fas fa-chart-bar"></i> Reportes automáticos</li>
                        <li><i class="fas fa-bell"></i> Alertas de stock bajo</li>
                        <li><i class="fas fa-shield-alt"></i> Datos seguros y respaldados</li>
                    </ul>
                </div>

                <!-- Panel de login -->
                <div class="login-panel">
                    <div class="login-header">
                        <h1 class="login-title">Iniciar Sesión</h1>
                        <p class="login-description">Ingrese sus credenciales para continuar</p>
                    </div>

                    <div id="alertContainer"></div>

                    <!-- FORMULARIO CONECTADO AL SERVLET -->
                    <form id="loginForm" action="login" method="POST">
                        <div class="form-group">
                            <label for="usuario" class="form-label">Usuario</label>
                            <div class="input-container">
                                <i class="fas fa-user input-icon"></i>
                                <input type="text" 
                                       class="form-control" 
                                       id="usuario" 
                                       name="usuario" 
                                       placeholder="Ingrese su usuario"
                                       required 
                                       autocomplete="username">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Contraseña</label>
                            <div class="input-container">
                                <i class="fas fa-lock input-icon"></i>
                                <input type="password" 
                                       class="form-control" 
                                       id="password" 
                                       name="password" 
                                       placeholder="Ingrese su contraseña"
                                       required 
                                       autocomplete="current-password">
                                <button type="button" class="password-toggle" id="passwordToggle">
                                    <i class="fas fa-eye" id="toggleIcon"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn-login" id="loginBtn">
                            <i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión
                        </button>
                    </form>

                    <div class="footer-section">
                        <div class="copyright">
                            <p>&copy; 2025 Track!t - Todos los derechos reservados</p>
                            <p>Desarrollado por Laura Valentina López Garcia y Juan Camilo Prieto Mestizo</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JavaScript -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script type="text/javascript">
            // Variables globales
            let alertTimeout;

            // Función para alternar visibilidad de la contraseña
            function togglePassword() {
                const passwordField = document.getElementById('password');
                const toggleIcon = document.getElementById('toggleIcon');

                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    passwordField.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }

            // Función para mostrar alertas
            function showAlert(message, type) {
                const alertContainer = document.getElementById('alertContainer');

                // Limpiar alertas existentes
                alertContainer.innerHTML = '';

                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert-custom alert-' + type;

                let icon = '';
                switch (type) {
                    case 'success':
                        icon = 'fas fa-check-circle';
                        break;
                    case 'danger':
                        icon = 'fas fa-exclamation-circle';
                        break;
                    default:
                        icon = 'fas fa-info-circle';
                }

                alertDiv.innerHTML = '<div class="alert-content"><i class="' + icon + '"></i><span>' + message + '</span></div><button type="button" class="alert-close" onclick="closeAlert(this)"><i class="fas fa-times"></i></button>';

                alertContainer.appendChild(alertDiv);

                // Auto-remove after 5 seconds
                alertTimeout = setTimeout(function () {
                    if (alertDiv && alertDiv.parentElement) {
                        closeAlert(alertDiv.querySelector('.alert-close'));
                    }
                }, 5000);
            }

            // Función para cerrar alertas
            function closeAlert(button) {
                const alert = button.closest('.alert-custom');
                alert.classList.add('alert-fade-out');
                setTimeout(function () {
                    if (alert.parentElement) {
                        alert.remove();
                    }
                }, 300);

                if (alertTimeout) {
                    clearTimeout(alertTimeout);
                }
            }

            // Función para limpiar todas las alertas
            function clearAlerts() {
                const alertContainer = document.getElementById('alertContainer');
                const alerts = alertContainer.querySelectorAll('.alert-custom');
                alerts.forEach(function (alert) {
                    alert.classList.add('alert-fade-out');
                    setTimeout(function () {
                        if (alert.parentElement) {
                            alert.remove();
                        }
                    }, 300);
                });

                if (alertTimeout) {
                    clearTimeout(alertTimeout);
                }
            }

            /* Función de validación de login (versión mejorada)
            function handleLogin(e) {
                

                const usuario = document.getElementById('usuario').value.trim();
                const password = document.getElementById('password').value.trim();
                const loginBtn = document.getElementById('loginBtn');

                // Limpiar alertas anteriores
                clearAlerts();

                // Validación básica (para pruebas locales)
                if (usuario === 'admin' && password === 'admin123') {
                    loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Verificando...';
                    loginBtn.disabled = true;

                    setTimeout(function () {
                        loginBtn.innerHTML = '<i class="fas fa-check me-2"></i>Acceso Concedido';
                        showAlert('¡Acceso exitoso! Redirigiendo al dashboard...', 'success');

                        setTimeout(function () {
                            // Redirigir al dashboard
                            window.location.href = "dashboard.jsp";
                        }, 2000);
                    }, 1500);
                } else {
                    showAlert('Credenciales incorrectas. Verifique su usuario y contraseña.', 'danger');

                    // Efecto de error en los campos
                    const fields = document.querySelectorAll('#usuario, #password');
                    fields.forEach(function (field) {
                        field.style.borderColor = '#dc2626';
                        field.style.backgroundColor = '#fef2f2';
                        setTimeout(function () {
                            field.style.borderColor = '#e2e8f0';
                            field.style.backgroundColor = '#ffffff';
                        }, 3000);
                    });

                    // Reset button
                    loginBtn.disabled = false;
                }
            }*/

            // Función para efectos de interacción en inputs
            function addInputEffects() {
                const formControls = document.querySelectorAll('.form-control');
                formControls.forEach(function (input) {
                    input.addEventListener('focus', function () {
                        this.parentNode.style.transform = 'translateY(-1px)';
                        this.parentNode.style.transition = 'all 0.2s ease';
                    });

                    input.addEventListener('blur', function () {
                        this.parentNode.style.transform = 'translateY(0)';
                    });
                });
            }

            /* Función de inicialización
            function initializePage() {
                // Event listeners
                const loginForm = document.getElementById('loginForm');
                if (loginForm) {
                    loginForm.addEventListener('submit', handleLogin);
                }

                const passwordToggle = document.getElementById('passwordToggle');
                if (passwordToggle) {
                    passwordToggle.addEventListener('click', togglePassword);
                }

                // Agregar efectos de interacción
                addInputEffects();

                // Mostrar mensaje de bienvenida
                setTimeout(function () {
                    showAlert('Bienvenido a Track!t. Por favor inicia sesión para continuar.', 'info');
                }, 1000);
            }

            // Inicializar cuando el DOM esté listo
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initializePage);
            } else {
                initializePage();
            }*/
        </script>
    </body>
</html>