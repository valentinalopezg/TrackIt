<%-- 
    Document   : head
    Created on : 20/11/2025, 7:18:45 a. m.
    Author     : Valentina
--%>
<%-- 
    head.jsp
    Meta tags, CSS y recursos comunes para todas las páginas
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- Dashboard CSS común -->
<link href="<%= request.getContextPath() %>/css/dashboard.css" rel="stylesheet">

<!-- Favicon -->
<link href="<%= request.getContextPath() %>/images/favicon.png" rel="icon"></nav>