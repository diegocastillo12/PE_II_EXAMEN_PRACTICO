<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.*"%>

<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.setStatus(401);
        out.print("{\"success\": false, \"error\": \"No autorizado\"}");
        return;
    }
    
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    String action = request.getParameter("action");
    String grupoIdStr = request.getParameter("grupoId");
    
    if (grupoIdStr == null || grupoIdStr.isEmpty() || "null".equals(grupoIdStr)) {
        response.setStatus(400);
        out.print("{\"success\": false, \"error\": \"Grupo no especificado\"}");
        return;
    }
    
    Integer grupoId = Integer.parseInt(grupoIdStr);
    ClsNPeti negocioPeti = new ClsNPeti();
    
    if ("guardarCampo".equals(action)) {
        String campo = request.getParameter("campo");
        String valor = request.getParameter("valor");
        
        if (campo != null && valor != null) {
            try {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", campo, valor, usuarioId);
                boolean exito = negocioPeti.guardarDato(dato);
                
                if (exito) {
                    out.print("{\"success\": true}");
                } else {
                    out.print("{\"success\": false, \"error\": \"Error al guardar\"}");
                }
            } catch (Exception e) {
                response.setStatus(500);
                out.print("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
            }
        } else {
            response.setStatus(400);
            out.print("{\"success\": false, \"error\": \"Parámetros faltantes\"}");
        }
        
    } else if ("sincronizar".equals(action)) {
        try {
            Map<String, String> datos = negocioPeti.obtenerDatosSeccion(grupoId, "matriz_participacion");
            
            // Construir JSON manualmente
            StringBuilder json = new StringBuilder();
            json.append("{\"success\": true, \"matriz\": {");
            
            boolean first = true;
            for (Map.Entry<String, String> entry : datos.entrySet()) {
                if (!first) json.append(",");
                json.append("\"").append(entry.getKey()).append("\": \"");
                // Escapar comillas en el valor
                String valor = entry.getValue().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
                json.append(valor).append("\"");
                first = false;
            }
            
            json.append("}}");
            out.print(json.toString());
        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
        
    } else {
        response.setStatus(400);
        out.print("{\"success\": false, \"error\": \"Acción no válida\"}");
    }
%>