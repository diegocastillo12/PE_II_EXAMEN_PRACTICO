<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="conexion.conexion"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Debug - Gestionar Grupo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-section { border: 1px solid #ccc; padding: 15px; margin: 10px 0; }
        .error { color: red; }
        .success { color: green; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>Debug - Gestionar Grupo</h1>
    
    <div class="debug-section">
        <h2>Variables de Sesión</h2>
        <%
            String usuario = (String) session.getAttribute("usuario");
            String grupoActual = (String) session.getAttribute("grupoActual");
            String rolUsuario = (String) session.getAttribute("rolUsuario");
        %>
        <p><strong>Usuario:</strong> <%= usuario != null ? usuario : "NULL" %></p>
        <p><strong>Grupo Actual:</strong> <%= grupoActual != null ? grupoActual : "NULL" %></p>
        <p><strong>Rol Usuario:</strong> <%= rolUsuario != null ? rolUsuario : "NULL" %></p>
    </div>
    
    <div class="debug-section">
        <h2>Verificación de Acceso</h2>
        <%
            if (usuario == null) {
                out.println("<p class='error'>❌ Usuario no está logueado</p>");
            } else {
                out.println("<p class='success'>✅ Usuario logueado: " + usuario + "</p>");
            }
            
            if (grupoActual == null) {
                out.println("<p class='error'>❌ No hay grupo actual en sesión</p>");
            } else {
                out.println("<p class='success'>✅ Grupo actual: " + grupoActual + "</p>");
            }
            
            if (!"admin".equals(rolUsuario)) {
                out.println("<p class='error'>❌ Usuario no es admin (rol: " + rolUsuario + ")</p>");
            } else {
                out.println("<p class='success'>✅ Usuario es admin</p>");
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Prueba de Conexión a Base de Datos</h2>
        <%
            Connection conn = null;
            try {
                conn = conexion.getConexion();
                if (conn != null) {
                    out.println("<p class='success'>✅ Conexión a BD exitosa</p>");
                } else {
                    out.println("<p class='error'>❌ Conexión a BD falló</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>❌ Error de conexión: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Verificación de Grupo en BD</h2>
        <%
            if (grupoActual != null && conn != null) {
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    String sqlGrupo = "SELECT id, admin_id, codigo, fecha_creacion, limite_usuarios FROM grupos WHERE nombre = ?";
                    pstmt = conn.prepareStatement(sqlGrupo);
                    pstmt.setString(1, grupoActual);
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        out.println("<p class='success'>✅ Grupo encontrado en BD</p>");
                        out.println("<p><strong>ID:</strong> " + rs.getInt("id") + "</p>");
                        out.println("<p><strong>Admin ID:</strong> " + rs.getInt("admin_id") + "</p>");
                        out.println("<p><strong>Código:</strong> " + rs.getString("codigo") + "</p>");
                        out.println("<p><strong>Fecha:</strong> " + rs.getDate("fecha_creacion") + "</p>");
                        out.println("<p><strong>Límite:</strong> " + rs.getInt("limite_usuarios") + "</p>");
                        
                        int adminId = rs.getInt("admin_id");
                        // Obtener el nombre del admin
                        PreparedStatement pstmtAdmin = conn.prepareStatement("SELECT username FROM usuarios WHERE id = ?");
                        pstmtAdmin.setInt(1, adminId);
                        ResultSet rsAdmin = pstmtAdmin.executeQuery();
                        
                        if (rsAdmin.next()) {
                            String adminGrupo = rsAdmin.getString("username");
                            out.println("<p><strong>Admin:</strong> " + adminGrupo + "</p>");
                            
                            if (usuario.equals(adminGrupo)) {
                                out.println("<p class='success'>✅ Usuario es el admin del grupo</p>");
                            } else {
                                out.println("<p class='error'>❌ Usuario NO es el admin del grupo (admin: " + adminGrupo + ")</p>");
                            }
                        }
                        rsAdmin.close();
                        pstmtAdmin.close();
                    } else {
                        out.println("<p class='error'>❌ Grupo NO encontrado en BD</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p class='error'>❌ Error SQL al buscar grupo: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                }
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Verificación de Miembros - Consulta Detallada</h2>
        <%
            if (grupoActual != null && conn != null) {
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    // Primero verificar el ID del grupo
                    String sqlGrupoId = "SELECT id FROM grupos WHERE nombre = ?";
                    pstmt = conn.prepareStatement(sqlGrupoId);
                    pstmt.setString(1, grupoActual);
                    rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        int grupoId = rs.getInt("id");
                        out.println("<p class='info'>🔍 ID del grupo '" + grupoActual + "': " + grupoId + "</p>");
                        
                        rs.close();
                        pstmt.close();
                        
                        // Verificar registros en miembros_grupo
                        String sqlMiembrosRaw = "SELECT * FROM miembros_grupo WHERE grupo_id = ?";
                        pstmt = conn.prepareStatement(sqlMiembrosRaw);
                        pstmt.setInt(1, grupoId);
                        rs = pstmt.executeQuery();
                        
                        out.println("<p class='info'>📊 Registros en miembros_grupo para grupo_id " + grupoId + ":</p>");
                        boolean hayMiembros = false;
                        while (rs.next()) {
                            hayMiembros = true;
                            out.println("<p>- usuario_id: " + rs.getInt("usuario_id") + ", grupo_id: " + rs.getInt("grupo_id") + ", rol: " + rs.getString("rol") + "</p>");
                        }
                        
                        if (!hayMiembros) {
                            out.println("<p class='error'>❌ No hay registros en miembros_grupo para este grupo</p>");
                        }
                        
                        rs.close();
                        pstmt.close();
                        
                        // Ahora la consulta completa con JOIN
                        String sqlMiembros = "SELECT u.username, u.id as usuario_id, mg.rol FROM miembros_grupo mg JOIN usuarios u ON mg.usuario_id = u.id WHERE mg.grupo_id = ?";
                        pstmt = conn.prepareStatement(sqlMiembros);
                        pstmt.setInt(1, grupoId);
                        rs = pstmt.executeQuery();
                        
                        List<String> miembrosEncontrados = new ArrayList<>();
                        out.println("<p class='info'>👥 Miembros encontrados con JOIN:</p>");
                        while (rs.next()) {
                            String nombreUsuario = rs.getString("username");
                            int usuarioId = rs.getInt("usuario_id");
                            String rol = rs.getString("rol");
                            miembrosEncontrados.add(nombreUsuario);
                            out.println("<p>- " + nombreUsuario + " (ID: " + usuarioId + ", Rol: " + rol + ")</p>");
                        }
                        
                        if (miembrosEncontrados.isEmpty()) {
                            out.println("<p class='error'>❌ No se encontraron miembros con la consulta JOIN</p>");
                        } else {
                            out.println("<p class='success'>✅ Total miembros encontrados: " + miembrosEncontrados.size() + "</p>");
                        }
                        
                    } else {
                        out.println("<p class='error'>❌ No se encontró el grupo en la tabla grupos</p>");
                    }
                    
                } catch (SQLException e) {
                    out.println("<p class='error'>❌ Error SQL en consulta detallada: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                }
            }
        %>
    </div>
    
    <div class="debug-section">
        <h2>Acciones</h2>
        <a href="menuprincipal.jsp">← Volver al Menú Principal</a><br>
        <a href="gestionarGrupo.jsp">🔄 Intentar Gestionar Grupo</a>%>
    </div>
    
    <%
        // Cerrar conexión al final
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>