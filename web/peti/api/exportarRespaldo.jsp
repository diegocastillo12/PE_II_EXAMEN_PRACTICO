<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti"%>
<%@page import="entidad.ClsEPeti"%>
<%@page import="java.util.*, java.text.SimpleDateFormat"%>

<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.setStatus(401);
        out.print("{\"success\": false, \"error\": \"No autorizado\"}");
        return;
    }
    
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    
    if (grupoId == null) {
        out.print("{\"success\": false, \"error\": \"No hay grupo activo\"}");
        return;
    }
    
    // Solo el admin puede exportar
    if (!"admin".equals(rolUsuario)) {
        response.setStatus(403);
        out.print("{\"success\": false, \"error\": \"Solo el administrador puede exportar datos\"}");
        return;
    }
    
    try {
        response.setContentType("application/json");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        Map<String, Map<String, String>> datosPeti = negocioPeti.obtenerTodosDatos(grupoId);
        
        // Construir JSON manualmente (sin librería externa)
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true,");
        json.append("\"grupoId\": ").append(grupoId).append(",");
        json.append("\"fechaExportacion\": \"").append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())).append("\",");
        json.append("\"usuarioExportacion\": \"").append(escapeJson(usuario)).append("\",");
        json.append("\"version\": \"1.0\",");
        json.append("\"datos\": {");
        
        boolean firstSection = true;
        for (Map.Entry<String, Map<String, String>> seccionEntry : datosPeti.entrySet()) {
            if (!firstSection) json.append(",");
            firstSection = false;
            
            String seccion = seccionEntry.getKey();
            Map<String, String> campos = seccionEntry.getValue();
            
            json.append("\"").append(escapeJson(seccion)).append("\": {");
            
            boolean firstField = true;
            for (Map.Entry<String, String> campoEntry : campos.entrySet()) {
                if (!firstField) json.append(",");
                firstField = false;
                
                json.append("\"").append(escapeJson(campoEntry.getKey())).append("\": ");
                json.append("\"").append(escapeJson(campoEntry.getValue())).append("\"");
            }
            
            json.append("}");
        }
        
        json.append("}");
        json.append("}");
        
        // Configurar headers para descarga
        String grupoNombre = (String) session.getAttribute("grupoActual");
        String filename = "PETI_Respaldo_" + (grupoNombre != null ? grupoNombre.replaceAll("[^a-zA-Z0-9]", "_") : "Grupo") + 
                         "_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".json";
        
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        out.print(json.toString());
        
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"success\": false, \"error\": \"Error al exportar: " + escapeJson(e.getMessage()) + "\"}");
        e.printStackTrace();
    }
%>

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
