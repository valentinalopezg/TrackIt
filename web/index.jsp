<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Track!t - Sistema de Inventarios | Inicio</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- AOS Animation Library -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
        <!-- index.css -->
        <link href="css/index.css" rel="stylesheet">
        <!-- Favicon -->
        <link href="images/favicon.png" rel="icon">



    </head>

    <body>
        <!-- Navigation -->
        <nav class="navbar" id="navbar">
            <div class="container">
                <div class="row w-100 align-items-center">
                    <div class="col-lg-3 col-md-4 col-6">
                        <a href="#" class="navbar-brand">
                            <div class="brand-logo">T!</div>
                            Track!t
                        </a>
                    </div>
                    <div class="col-lg-6 col-md-4 d-none d-md-block">
                        <div class="d-flex justify-content-center">
                            <a href="#inicio" class="nav-link active">Inicio</a>
                            <a href="#funcionalidades" class="nav-link">Funcionalidades</a>
                            <a href="#reportes" class="nav-link">Reportes</a>
                            <a href="#contacto" class="nav-link">Contacto</a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-4 col-6 text-end">
                        <a href="login.jsp" class="btn-login">
                            <i class="fas fa-sign-in-alt"></i>
                            Iniciar Sesión
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section id="inicio" class="hero-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6" data-aos="fade-right">
                        <div class="hero-content">
                            <h1 class="hero-title">Bienvenido a Track!t<br>Sistema de Inventarios</h1>
                            <p class="hero-subtitle">
                                Una solución simple y eficiente para pequeñas empresas. 
                                Controla tu stock, procesa ventas y genera reportes automáticos con nuestra plataforma intuitiva.
                            </p>
                            <div class="hero-buttons">
                                <a href="login.jsp" class="btn-primary">
                                    <i class="fas fa-rocket"></i>
                                    Comenzar Ahora
                                </a>
                                <a href="#funcionalidades" class="btn-outline">
                                    <i class="fas fa-play"></i>
                                    Ver más
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6" data-aos="fade-left">
                        <div class="hero-image text-center">
                            <div style="width: 100%; max-width: 500px; height: 400px; background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); border-radius: 20px; display: flex; align-items: center; justify-content: center; margin: 0 auto; box-shadow: var(--shadow-heavy);">
                                <div style="text-align: center; color: var(--white);">
                                    <i class="fas fa-boxes" style="font-size: 4rem; margin-bottom: 1rem; opacity: 0.9;"></i>
                                    <h3 style="margin: 0; font-weight: 600;">Dashboard Interactivo</h3>
                                    <p style="margin: 0.5rem 0 0; opacity: 0.8;">Control total de tu inventario</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section id="funcionalidades" class="features-section">
            <div class="container">
                <div class="row">
                    <div class="col-12" data-aos="fade-up">
                        <h2 class="section-title">Funcionalidades</h2>
                        <p class="section-subtitle">
                            Track!t ofrece todas las herramientas necesarias para optimizar la gestión de inventarios 
                            y ventas de tu empresa con tecnología moderna y fácil de usar.
                        </p>
                    </div>
                </div>
                <div class="row g-4">
                    <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-boxes"></i>
                            </div>
                            <h3 class="feature-title">Registro de Productos</h3>
                            <p class="feature-description">
                                Agrega, edita y gestiona tu inventario de manera sencilla. 
                                Control completo de productos y categorías.
                            </p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h3 class="feature-title">Procesamiento de Ventas</h3>
                            <p class="feature-description">
                                Actualiza el stock automáticamente con cada venta registrada. 
                                Historial completo de transacciones.
                            </p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                            <h3 class="feature-title">Reportes Detallados</h3>
                            <p class="feature-description">
                                Genera reportes detallados de ventas e inventario. 
                                Estadísticas en tiempo real y análisis de tendencias.
                            </p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="400">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-bell"></i>
                            </div>
                            <h3 class="feature-title">Alertas de Bajo Stock</h3>
                            <p class="feature-description">
                                Recibe notificaciones cuando un producto esté por agotarse. 
                                Alertas personalizables y automáticas.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Reports Section -->
        <section id="reportes" class="features-section">
            <div class="container">
                <div class="row">
                    <div class="col-12" data-aos="fade-up">
                        <h2 class="section-title">Reportes Inteligentes</h2>
                        <p class="section-subtitle">
                            Visualiza el rendimiento de tu negocio en tiempo real con reportes automáticos y estadísticas detalladas.
                        </p>
                    </div>
                </div>
                <div class="row g-4 justify-content-center">
                    <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="100">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
                            <h3 class="feature-title">Reportes de Ventas</h3>
                            <p class="feature-description">Análisis completo de ventas diarias, semanales y mensuales</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-warehouse"></i></div>
                            <h3 class="feature-title">Control de Inventario</h3>
                            <p class="feature-description">Seguimiento en tiempo real del estado de tu inventario</p>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-chart-pie"></i></div>
                            <h3 class="feature-title">Análisis Predictivo</h3>
                            <p class="feature-description">Predicción de demanda y optimización de stock</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- CTA Section -->
        <section class="cta-section">
            <div class="container">
                <div class="cta-content" data-aos="fade-up">
                    <h2 class="cta-title">¿Listo para optimizar tu inventario?</h2>
                    <p class="cta-description">
                        Comienza a usar Track!t hoy y transforma la gestión de tu empresa con nuestra solución integral.
                    </p>
                    <a href="login.jsp" class="btn-cta">
                        <i class="fas fa-arrow-right"></i>
                        Acceder al Sistema
                    </a>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer id="contacto" class="footer">
            <div class="container">
                <div class="footer-content">
                    <h3 class="footer-logo">Track!t</h3>
                    <p class="footer-text">
                        Sistema de Gestión de Inventarios desarrollado como proyecto académico<br>
                        Fundación Universitaria Konrad Lorenz - Diseño de Interfaces de Usuario
                    </p>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2025 Track!t - Todos los derechos reservados</p>
                    <p>Desarrollado por Laura Valentina López Garcia  Juan Camilo Prieto Mestizo</p>
                    <p>laurav.lopez@konradlorenz.edu.co & juanc.prietom@konradlorenz.edu.co</p>
                </div>
            </div>
        </footer>

        <!-- Scroll to top button -->
        <button class="scroll-top" id="scrollTop">
            <i class="fas fa-arrow-up"></i>
        </button>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>

        <script>
            // Initialize AOS (Animate On Scroll)
            AOS.init({
                duration: 1000,
                once: true,
                offset: 100
            });

            // Navbar scroll effect
            window.addEventListener('scroll', function () {
                const navbar = document.getElementById('navbar');
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });

            // Smooth scrolling for navigation links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // Scroll to top button
            const scrollTopBtn = document.getElementById('scrollTop');

            window.addEventListener('scroll', function () {
                if (window.scrollY > 300) {
                    scrollTopBtn.classList.add('visible');
                } else {
                    scrollTopBtn.classList.remove('visible');
                }
            });

            scrollTopBtn.addEventListener('click', function () {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });

            // Update active navigation link on scroll
            window.addEventListener('scroll', function () {
                const sections = document.querySelectorAll('section[id]');
                const navLinks = document.querySelectorAll('.nav-link');

                let current = '';
                sections.forEach(section => {
                    const sectionTop = section.offsetTop;
                    const sectionHeight = section.clientHeight;
                    if (scrollY >= (sectionTop - 200)) {
                        current = section.getAttribute('id');
                    }
                });

                navLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === '#' + current) {
                        link.classList.add('active');
                    }
                });
            });
        </script>
    </body>
</html>