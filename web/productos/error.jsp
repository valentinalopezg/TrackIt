<%-- 
    Document   : error
    Created on : 15/11/2025, 4:58:12 p. m.
    Author     : camiloprieto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error - Track!t</title>
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Dashboard CSS -->
        <link href="<%= request.getContextPath() %>/css/dashboard.css" rel="stylesheet">
        
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Inter', sans-serif;
            }
            
            .error-container {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 2rem;
            }
            
            .error-card {
                background: white;
                border-radius: 20px;
                padding: 3rem;
                max-width: 600px;
                width: 100%;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                text-align: center;
                animation: slideUp 0.5s ease-out;
            }
            
            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            .error-icon {
                font-size: 5rem;
                color: #ef4444;
                margin-bottom: 1.5rem;
                animation: pulse 2s infinite;
            }
            
            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.1); }
            }
            
            .error-title {
                font-size: 2rem;
                font-weight: 700;
                color: #2d3748;
                margin-bottom: 1rem;
            }
            
            .error-message {
                font-size: 1.1rem;
                color: #718096;
                margin-bottom: 2rem;
                line-height: 1.6;
            }
            
            .error-details {
                background: #fef2f2;
                border-left: 4px solid #ef4444;
                padding: 1rem;
                margin: 1.5rem 0;
                text-align: left;
                border-radius: 4px;
            }
            
            .error-details strong {
                color: #dc2626;
                display: block;
                margin-bottom: 0.5rem;
                font-size: 0.95rem;
            }
            
            .error-details code {
                color: #991b1b;
                font-size: 0.9rem;
                word-break: break-word;
                display: block;
                background: white;
                padding: 0.5rem;
                border-radius: 4px;
                margin-top: 0.5rem;
            }
            
            .btn-home {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 0.85rem 2rem;
                border: none;
                border-radius: 50px;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s;
                font-size: 1rem;
            }
            
            .btn-home:hover {
                transform: translateY(-2px);
                color: white;
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
            }
            
            .btn-back {
                background: #e2e8f0;
                color: #4a5568;
                padding: 0.85rem 2rem;
                border: none;
                border-radius: 50px;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                margin-left: 1rem;
                transition: all 0.3s;
                font-size: 1rem;
            }
            
            .btn-back:hover {
                background: #cbd5e0;
                color: #2d3748;
                transform: translateY(-2px);
            }
            
            .footer-info {
                margin-top: 2rem;
                padding-top: 2rem;
                border-top: 1px solid #e2e8f0;
            }
            
            .footer-info p {
                color: #a0aec0;
                font-size: 0.9rem;
                margin: 0;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <div class="error-card">
                <div class="error-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                
                <h1 class="error-title">¡Oops! Algo salió mal</h1>
                
                <p class="error-message">
                    Lo sentimos, ha ocurrido un error al procesar tu solicitud.
                    Por favor, intenta nuevamente o contacta al administrador si el problema persiste.
                </p>
                
                <% 
                    String errorMsg = (String) request.getAttribute("error");
                    Exception errorException = (Exception) request.getAttribute("exception");
                    
                    if (errorMsg != null && !errorMsg.isEmpty()) {
                %>
                    <div class="error-details">
                        <strong><i class="fas fa-info-circle"></i> Detalles del error:</strong>
                        <code><%= errorMsg %></code>
                    </div>
                <% 
                    }
                    
                    // Mostrar stack trace solo en desarrollo
                    String showDebug = request.getParameter("debug");
                    if (errorException != null && "true".equals(showDebug)) {
                %>
                    <div class="error-details">
                        <strong><i class="fas fa-bug"></i> Información técnica (modo debug):</strong>
                        <code><%= errorException.getClass().getName() %>: <%= errorException.getMessage() %></code>
                    </div>
                <% } %>
                
                <div style="margin-top: 2rem;">
                    <a href="<%= request.getContextPath() %>/dashboard.jsp" class="btn-home">
                        <i class="fas fa-home"></i>
                        Ir al Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/producto?accion=listar" class="btn-back">
                        <i class="fas fa-list"></i>
                        Ver Productos
                    </a>
                </div>
                
                <div class="footer-info">
                    <p>
                        <i class="fas fa-shield-alt"></i> Track!t Sistema de Inventarios
                    </p>
                    <p style="font-size: 0.8rem; margin-top: 0.5rem;">
                        Si el problema persiste, contacta al soporte técnico
                    </p>
                </div>
            </div>
        </div>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>