<%-- 
    Document   : gestionarGrupo
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="conexion.conexion"%>

<%
    // Verificar que el usuario esté logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Verificar que el usuario tenga un grupo y sea admin
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    
    if (grupoActual == null) {
        response.sendRedirect("menuprincipal.jsp?error=sin_grupo");
        return;
    }
    
    if (!"admin".equals(rolUsuario)) {
        response.sendRedirect("menuprincipal.jsp?error=sin_permisos");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String adminGrupo = null;
    String codigoGrupo = null;
    java.sql.Date fechaCreacion = null;
    Integer limite = null;
    List<String> miembros = new ArrayList<>();
    
    try {
        conn = conexion.getConexion();
        
        // Verificar que el grupo existe y obtener información
        String sqlGrupo = "SELECT admin_id, codigo, fecha_creacion, limite_usuarios FROM grupos WHERE nombre = ?";
        pstmt = conn.prepareStatement(sqlGrupo);
        pstmt.setString(1, grupoActual);
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            response.sendRedirect("menuprincipal.jsp?error=grupo_no_encontrado");
            return;
        }
        
        int adminId = rs.getInt("admin_id");
        codigoGrupo = rs.getString("codigo");
        fechaCreacion = rs.getDate("fecha_creacion");
        limite = rs.getInt("limite_usuarios");
        
        // Obtener el nombre del admin
        PreparedStatement pstmtAdmin = conn.prepareStatement("SELECT username FROM usuarios WHERE id = ?");
        pstmtAdmin.setInt(1, adminId);
        ResultSet rsAdmin = pstmtAdmin.executeQuery();
        
        if (rsAdmin.next()) {
            adminGrupo = rsAdmin.getString("username");
        }
        rsAdmin.close();
        pstmtAdmin.close();
        
        // Verificar que el usuario es realmente el admin del grupo
        if (!usuario.equals(adminGrupo)) {
            response.sendRedirect("menuprincipal.jsp?error=sin_permisos");
            return;
        }
        
        rs.close();
        pstmt.close();
        
        // Obtener lista de miembros usando el ID del grupo
        String sqlMiembros = "SELECT u.username FROM miembros_grupo mg JOIN usuarios u ON mg.usuario_id = u.id WHERE mg.grupo_id = (SELECT id FROM grupos WHERE nombre = ?)";
        pstmt = conn.prepareStatement(sqlMiembros);
        pstmt.setString(1, grupoActual);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            miembros.add(rs.getString("username"));
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("menuprincipal.jsp?error=error_bd");
        return;
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Procesar eliminación de miembro si se envió el formulario
    String accion = request.getParameter("accion");
    String miembroEliminar = request.getParameter("miembroEliminar");
    
    if ("eliminar".equals(accion) && miembroEliminar != null && !miembroEliminar.trim().isEmpty()) {
        // No permitir que el admin se elimine a sí mismo
        if (!usuario.equals(miembroEliminar.trim())) {
            try {
                conn = conexion.getConexion();
                
                // Eliminar miembro del grupo usando IDs
                String sqlEliminar = "DELETE FROM miembros_grupo WHERE grupo_id = (SELECT id FROM grupos WHERE nombre = ?) AND usuario_id = (SELECT id FROM usuarios WHERE usuario = ?)";
                pstmt = conn.prepareStatement(sqlEliminar);
                pstmt.setString(1, grupoActual);
                pstmt.setString(2, miembroEliminar.trim());
                
                int filasAfectadas = pstmt.executeUpdate();
                
                if (filasAfectadas > 0) {
                    response.sendRedirect("gestionarGrupo.jsp?success=miembro_eliminado&miembro=" + java.net.URLEncoder.encode(miembroEliminar.trim(), "UTF-8"));
                } else {
                    response.sendRedirect("gestionarGrupo.jsp?error=miembro_no_encontrado");
                }
                return;
                
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("gestionarGrupo.jsp?error=error_bd");
                return;
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            response.sendRedirect("gestionarGrupo.jsp?error=no_puede_eliminarse");
            return;
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestionar Grupo - <%= grupoActual %></title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 2rem;
            }
            
            .header {
                background: white;
                padding: 1rem 2rem;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .header h1 {
                color: #333;
                font-size: 1.8rem;
            }
            
            .btn-back {
                background: #6c757d;
                color: white;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                cursor: pointer;
                text-decoration: none;
                font-size: 0.9rem;
            }
            
            .btn-back:hover {
                background: #5a6268;
            }
            
            .main-container {
                max-width: 800px;
                margin: 0 auto;
            }
            
            .card {
                background: white;
                padding: 2rem;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }
            
            .card h3 {
                color: #333;
                margin-bottom: 1rem;
                font-size: 1.5rem;
            }
            
            .grupo-stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin-bottom: 2rem;
            }
            
            .stat-item {
                background: #f8f9fa;
                padding: 1rem;
                border-radius: 8px;
                text-align: center;
                border-left: 4px solid #667eea;
            }
            
            .stat-number {
                font-size: 2rem;
                font-weight: bold;
                color: #667eea;
            }
            
            .stat-label {
                color: #666;
                font-size: 0.9rem;
                margin-top: 0.5rem;
            }
            
            .miembros-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 1rem;
            }
            
            .miembros-table th,
            .miembros-table td {
                padding: 1rem;
                text-align: left;
                border-bottom: 1px solid #dee2e6;
            }
            
            .miembros-table th {
                background: #f8f9fa;
                font-weight: 600;
                color: #333;
            }
            
            .miembros-table tr:hover {
                background: #f8f9fa;
            }
            
            .admin-badge {
                background: #ffc107;
                color: #212529;
                padding: 0.2rem 0.5rem;
                border-radius: 4px;
                font-size: 0.8rem;
                font-weight: bold;
            }
            
            .btn-eliminar {
                background: #dc3545;
                color: white;
                border: none;
                padding: 0.3rem 0.8rem;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.8rem;
            }
            
            .btn-eliminar:hover {
                background: #c82333;
            }
            
            .btn-eliminar:disabled {
                background: #6c757d;
                cursor: not-allowed;
            }
            
            .alert {
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
                font-size: 0.9rem;
            }
            
            .alert-error {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }
            
            .alert-success {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }
            
            .info-box {
                background: #e3f2fd;
                border-left: 4px solid #2196f3;
                padding: 1rem;
                border-radius: 0 8px 8px 0;
                margin-bottom: 1rem;
            }
            
            .codigo-display {
                background: #f8f9fa;
                border: 2px dashed #667eea;
                padding: 1rem;
                border-radius: 8px;
                text-align: center;
                margin: 1rem 0;
            }
            
            .codigo {
                font-size: 1.5rem;
                font-weight: bold;
                color: #667eea;
                letter-spacing: 0.2rem;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>🛠️ Gestionar Grupo: <%= grupoActual %></h1>
            <a href="menuprincipal.jsp" class="btn-back">← Volver al Menú</a>
        </div>
        
        <div class="main-container">
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                String miembroParam = request.getParameter("miembro");
                
                if (error != null) {
                    String mensajeError = "";
                    switch (error) {
                        case "no_puede_eliminarse":
                            mensajeError = "No puedes eliminarte a ti mismo del grupo.";
                            break;
                        default:
                            mensajeError = "Ha ocurrido un error. Inténtalo de nuevo.";
                    }
            %>
                    <div class="alert alert-error">
                        <%= mensajeError %>
                    </div>
            <%
                }
                
                if (success != null) {
                    String mensajeExito = "";
                    switch (success) {
                        case "miembro_eliminado":
                            mensajeExito = "El miembro \"" + (miembroParam != null ? miembroParam : "desconocido") + "\" ha sido eliminado del grupo.";
                            break;
                        default:
                            mensajeExito = "Operación realizada con éxito.";
                    }
            %>
                    <div class="alert alert-success">
                        <%= mensajeExito %>
                    </div>
            <%
                }
            %>
            
            <div class="card">
                <h3>📊 Estadísticas del Grupo</h3>
                
                <div class="grupo-stats">
                    <div class="stat-item">
                        <div class="stat-number"><%= miembros.size() %></div>
                        <div class="stat-label">Miembros Actuales</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number"><%= limite %></div>
                        <div class="stat-label">Límite Máximo</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number"><%= limite - miembros.size() %></div>
                        <div class="stat-label">Espacios Disponibles</div>
                    </div>
                </div>
                
                <div class="info-box">
                    <p><strong>Código actual del grupo:</strong></p>
                    <div class="codigo-display">
                        <div class="codigo"><%= codigoGrupo %></div>
                    </div>
                    <p style="font-size: 0.9rem; color: #666; margin: 0;">
                        Comparte este código con usuarios que quieras invitar al grupo
                    </p>
                </div>
            </div>
            
            <div class="card">
                <h3>👥 Lista de Miembros</h3>
                <p style="color: #666; margin-bottom: 1rem;">Gestiona los miembros de tu grupo. Puedes eliminar miembros (excepto a ti mismo).</p>
                
                <table class="miembros-table">
                    <thead>
                        <tr>
                            <th>Usuario</th>
                            <th>Rol</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (String miembro : miembros) {
                                boolean esAdmin = miembro.equals(adminGrupo);
                        %>
                        <tr>
                            <td><%= miembro %></td>
                            <td>
                                <% if (esAdmin) { %>
                                    <span class="admin-badge">ADMINISTRADOR</span>
                                <% } else { %>
                                    Miembro
                                <% } %>
                            </td>
                            <td>
                                <% if (!esAdmin) { %>
                                    <form method="post" style="display: inline;" onsubmit="return confirm('¿Estás seguro de que quieres eliminar a <%= miembro %> del grupo?')">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <input type="hidden" name="miembroEliminar" value="<%= miembro %>">
                                        <button type="submit" class="btn-eliminar">Eliminar</button>
                                    </form>
                                <% } else { %>
                                    <button class="btn-eliminar" disabled>No disponible</button>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                
                <% if (miembros.size() == 1) { %>
                    <div style="text-align: center; padding: 2rem; color: #666;">
                        <p>Eres el único miembro del grupo. Comparte el código para invitar a más usuarios.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </body>
</html>