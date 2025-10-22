<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.setStatus(401);
        out.print("{\"error\": \"No autorizado\"}");
        return;
    }
    
    // Obtener parámetros
    String grupoIdParam = request.getParameter("grupo");
    String lastUpdateParam = request.getParameter("last");
    
    if (grupoIdParam == null || lastUpdateParam == null) {
        response.setStatus(400);
        out.print("{\"error\": \"Parámetros faltantes\"}");
        return;
    }
    
    try {
        int grupoId = Integer.parseInt(grupoIdParam);
        long lastUpdate = Long.parseLong(lastUpdateParam);
        Date lastUpdateDate = new Date(lastUpdate);
        
        ClsNPeti negocioPeti = new ClsNPeti();
        
        // Verificar si el usuario tiene permisos
        Integer usuarioId = (Integer) session.getAttribute("usuarioId");
        if (usuarioId == null || !negocioPeti.tienePermisos(usuarioId, grupoId)) {
            response.setStatus(403);
            out.print("{\"error\": \"Sin permisos\"}");
            return;
        }
        
        // Obtener cambios recientes
        List<Map<String, Object>> historialReciente = negocioPeti.obtenerHistorial(grupoId, 10);
        
        int cambiosNuevos = 0;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        for (Map<String, Object> cambio : historialReciente) {
            java.sql.Timestamp fechaCambio = (java.sql.Timestamp) cambio.get("fecha_cambio");
            if (fechaCambio.after(lastUpdateDate)) {
                cambiosNuevos++;
            }
        }
        
        // Respuesta JSON
        response.setContentType("application/json");
        out.print("{");
        out.print("\"hasUpdates\": " + (cambiosNuevos > 0) + ",");
        out.print("\"changes\": " + cambiosNuevos + ",");
        out.print("\"timestamp\": " + System.currentTimeMillis());
        out.print("}");
        
    } catch (NumberFormatException e) {
        response.setStatus(400);
        out.print("{\"error\": \"Formato de parámetros inválido\"}");
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"error\": \"Error interno del servidor\"}");
    }
%>