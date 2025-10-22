<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNGrupo, negocio.ClsNPeti"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Test Notificaciones</title>
</head>
<body>
    <h1>Test de Notificaciones</h1>
    
    <%
    try {
        String usuario = (String) session.getAttribute("usuario");
        Integer usuarioId = (Integer) session.getAttribute("usuarioId");
        Integer grupoId = (Integer) session.getAttribute("grupoId");
        
        out.println("<h2>Datos de Sesión:</h2>");
        out.println("<p>Usuario: " + usuario + "</p>");
        out.println("<p>Usuario ID: " + usuarioId + "</p>");
        out.println("<p>Grupo ID: " + grupoId + "</p>");
        
        if (grupoId != null) {
            out.println("<hr>");
            out.println("<h2>Test obtenerCambiosRecientes:</h2>");
            
            ClsNPeti negocioPeti = new ClsNPeti();
            List<Map<String, Object>> cambios = negocioPeti.obtenerCambiosRecientes(grupoId, 5);
            
            out.println("<p>Total cambios: " + cambios.size() + "</p>");
            
            if (cambios.size() > 0) {
                out.println("<ul>");
                for (Map<String, Object> cambio : cambios) {
                    out.println("<li>");
                    out.println("Usuario: " + cambio.get("usuario") + ", ");
                    out.println("Sección: " + cambio.get("seccion") + ", ");
                    out.println("Campo: " + cambio.get("campo") + ", ");
                    out.println("Fecha: " + cambio.get("fecha"));
                    out.println("</li>");
                }
                out.println("</ul>");
            }
            
            out.println("<hr>");
            out.println("<h2>Test obtenerMiembrosGrupoParaNotificaciones:</h2>");
            
            ClsNGrupo negocioGrupo = new ClsNGrupo();
            List<Map<String, Object>> miembros = negocioGrupo.obtenerMiembrosGrupoParaNotificaciones(grupoId);
            
            out.println("<p>Total miembros: " + miembros.size() + "</p>");
            
            if (miembros.size() > 0) {
                out.println("<ul>");
                for (Map<String, Object> miembro : miembros) {
                    out.println("<li>");
                    out.println("Username: " + miembro.get("username") + ", ");
                    out.println("Rol: " + miembro.get("rol") + ", ");
                    out.println("Activo: " + miembro.get("activo"));
                    out.println("</li>");
                }
                out.println("</ul>");
            }
        } else {
            out.println("<p style='color:red;'>No hay grupo activo en la sesión</p>");
        }
        
    } catch (Exception e) {
        out.println("<h2 style='color:red;'>ERROR:</h2>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
    %>
    
</body>
</html>
