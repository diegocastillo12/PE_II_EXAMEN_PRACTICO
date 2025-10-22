<%@page import="negocio.ClsNLogin"%>
<%@page import="entidad.ClsELogin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Login</title>
</head>
<body>
    <h1>Debug del Sistema de Login</h1>
    
    <%
        try {
            out.println("<h2>Probando Login con usuario 'admin' y password '123'</h2>");
            
            // Crear instancia del negocio
            ClsNLogin negocioLogin = new ClsNLogin();
            out.println("<p>✓ ClsNLogin creado exitosamente</p>");
            
            // Crear objeto usuario
            ClsELogin usuarioLogin = new ClsELogin("admin", "123");
            out.println("<p>✓ ClsELogin creado para: " + usuarioLogin.getUsername() + "</p>");
            
            // Validar datos
            if (usuarioLogin.validarDatosLogin()) {
                out.println("<p>✓ Datos de login válidos</p>");
            } else {
                out.println("<p>✗ Datos de login inválidos</p>");
            }
            
            // Intentar validación
            out.println("<p>Iniciando validación...</p>");
            ClsELogin usuarioValidado = negocioLogin.validarLogin(usuarioLogin);
            
            if (usuarioValidado != null) {
                out.println("<p style='color: green;'>✓ LOGIN EXITOSO!</p>");
                out.println("<p>ID: " + usuarioValidado.getId() + "</p>");
                out.println("<p>Username: " + usuarioValidado.getUsername() + "</p>");
                out.println("<p>Email: " + usuarioValidado.getEmail() + "</p>");
                out.println("<p>Activo: " + usuarioValidado.isActivo() + "</p>");
                
                // Probar redirección
                out.println("<hr>");
                out.println("<p><a href='menuprincipal.jsp'>Ir a Menú Principal</a></p>");
                
            } else {
                out.println("<p style='color: red;'>✗ LOGIN FALLÓ</p>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>ERROR: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
    
    <hr>
    <p><a href="index.jsp">Volver al Login</a></p>
</body>
</html>