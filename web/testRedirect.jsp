<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Redirect</title>
</head>
<body>
    <h1>Probando Redirección</h1>
    
    <%
        // Test simple de redirección
        String action = request.getParameter("action");
        
        if ("redirect".equals(action)) {
            out.println("<p>Redirigiendo a menuprincipal.jsp...</p>");
            response.sendRedirect("menuprincipal.jsp");
            return;
        }
    %>
    
    <p>Haz clic en el enlace para probar la redirección:</p>
    <a href="testRedirect.jsp?action=redirect">Probar Redirección</a>
    
    <hr>
    <p><a href="index.jsp">Volver al Login</a></p>
</body>
</html>