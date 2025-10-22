<%@page contentType="application/json" pageEncoding="UTF-8" errorPage="" isErrorPage="false" %>
<%@page import="negocio.ClsNGrupo, negocio.ClsNPeti"%>
<%@page import="java.util.*, java.text.SimpleDateFormat"%>
<%!
    // Método para escapar caracteres especiales en JSON
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
%>
<%
    try {
        response.setContentType("application/json");
        response.setHeader("Cache-Control", "no-cache");
        
        // Verificar si el usuario está logueado
        String usuario = (String) session.getAttribute("usuario");
        if (usuario == null) {
            out.print("{\"success\": false, \"error\": \"No autorizado\"}");
            return;
        }
        
        Integer usuarioId = (Integer) session.getAttribute("usuarioId");
        Integer grupoId = (Integer) session.getAttribute("grupoId");
        
        if (grupoId == null) {
            out.print("{\"success\": false, \"error\": \"No hay grupo activo. Usuario: " + usuario + "\"}");
            return;
        }
        
        // Obtener información de notificaciones
        ClsNPeti negocioPeti = new ClsNPeti();
        ClsNGrupo negocioGrupo = new ClsNGrupo();
        
        // Obtener cambios recientes (últimos 10)
        List<Map<String, Object>> cambiosRecientes = negocioPeti.obtenerCambiosRecientes(grupoId, 10);
        
        // Obtener miembros activos del grupo (MEJORA 1: método específico para notificaciones)
        List<Map<String, Object>> miembrosActivos = negocioGrupo.obtenerMiembrosGrupoParaNotificaciones(grupoId);
        
        // Construir respuesta JSON manualmente (sin librería externa)
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true,");
        json.append("\"timestamp\": ").append(System.currentTimeMillis()).append(",");
        
        // Agregar cambios recientes
        json.append("\"cambiosRecientes\": [");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        for (int i = 0; i < cambiosRecientes.size(); i++) {
            Map<String, Object> cambio = cambiosRecientes.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"usuario\": \"").append(escapeJson(String.valueOf(cambio.get("usuario")))).append("\",");
            json.append("\"seccion\": \"").append(escapeJson(String.valueOf(cambio.get("seccion")))).append("\",");
            json.append("\"campo\": \"").append(escapeJson(String.valueOf(cambio.get("campo")))).append("\",");
            json.append("\"fecha\": \"").append(sdf.format(cambio.get("fecha"))).append("\",");
            json.append("\"accion\": \"modificar\"");
            json.append("}");
        }
        json.append("],");
        
        // Agregar miembros activos
        json.append("\"miembrosActivos\": [");
        for (int i = 0; i < miembrosActivos.size(); i++) {
            Map<String, Object> miembro = miembrosActivos.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"username\": \"").append(escapeJson(String.valueOf(miembro.get("username")))).append("\",");
            json.append("\"rol\": \"").append(escapeJson(String.valueOf(miembro.get("rol")))).append("\",");
            json.append("\"activo\": true");
            json.append("}");
        }
        json.append("],");
        
        // Estadísticas
        json.append("\"estadisticas\": {");
        json.append("\"totalCambios\": ").append(cambiosRecientes.size()).append(",");
        json.append("\"totalMiembros\": ").append(miembrosActivos.size());
        json.append("}");
        
        json.append("}");
        
        out.print(json.toString());
        
    } catch (Exception e) {
        // Enviar JSON de error al cliente
        response.setContentType("application/json");
        String errorMsg = e.getMessage();
        if (errorMsg == null) errorMsg = "Error desconocido";
        out.print("{\"success\": false, \"error\": \"" + escapeJson(errorMsg) + "\", \"errorType\": \"" + e.getClass().getSimpleName() + "\"}");
    }
%>
