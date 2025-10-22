<%@page import="negocio.ClsNLogin"%>
<%@page import="entidad.ClsELogin"%>
<%@page import="conexion.conexion"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test de Conexión</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>Test de Conexión y Login</h1>
    
    <%
        out.println("<h2>1. Probando conexión a la base de datos...</h2>");
        
        try {
            Connection conn = conexion.getConexion();
            if (conn != null && !conn.isClosed()) {
                out.println("<p class='success'>✓ Conexión exitosa a la base de datos</p>");
                
                // Verificar si existen usuarios
                out.println("<h2>2. Verificando usuarios en la base de datos...</h2>");
                String sql = "SELECT id, username, password, email FROM usuarios WHERE activo = TRUE";
                PreparedStatement pst = conn.prepareStatement(sql);
                ResultSet rs = pst.executeQuery();
                
                boolean hayUsuarios = false;
                out.println("<table border='1'>");
                out.println("<tr><th>ID</th><th>Usuario</th><th>Password</th><th>Email</th></tr>");
                
                while (rs.next()) {
                    hayUsuarios = true;
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("username") + "</td>");
                    out.println("<td>" + rs.getString("password") + "</td>");
                    out.println("<td>" + rs.getString("email") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
                
                if (!hayUsuarios) {
                    out.println("<p class='error'>✗ No hay usuarios en la base de datos</p>");
                    out.println("<p class='info'>Necesitas ejecutar el script SQL para crear los usuarios de prueba.</p>");
                } else {
                    out.println("<p class='success'>✓ Se encontraron usuarios en la base de datos</p>");
                }
                
                // Probar login con usuario admin
                out.println("<h2>3. Probando login con usuario 'admin' y contraseña '123'...</h2>");
                
                ClsNLogin negocioLogin = new ClsNLogin();
                ClsELogin usuarioTest = new ClsELogin("admin", "123");
                ClsELogin resultado = negocioLogin.validarLogin(usuarioTest);
                
                if (resultado != null) {
                    out.println("<p class='success'>✓ Login exitoso!</p>");
                    out.println("<p>Usuario: " + resultado.getUsername() + "</p>");
                    out.println("<p>Email: " + resultado.getEmail() + "</p>");
                    out.println("<p>ID: " + resultado.getId() + "</p>");
                } else {
                    out.println("<p class='error'>✗ Login falló</p>");
                    out.println("<p class='info'>Verifica que el usuario 'admin' con contraseña '123' exista en la base de datos.</p>");
                }
                
            } else {
                out.println("<p class='error'>✗ No se pudo conectar a la base de datos</p>");
            }
            
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error: " + e.getMessage() + "</p>");
            out.println("<p class='info'>Stack trace:</p>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
    
    <hr>
    <p><a href="index.jsp">← Volver al login</a></p>
</body>
</html>