<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNGrupo, negocio.ClsNPeti"%>
<%@page import="java.util.*, java.io.*"%>
<%
response.setContentType("application/json");

try {
    // Test 1: Verificar sesión
    String usuario = (String) session.getAttribute("usuario");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    if (usuario == null) {
        out.print("{\"success\": false, \"paso\": 1, \"error\": \"Usuario no autenticado\"}");
        return;
    }
    
    if (grupoId == null) {
        out.print("{\"success\": false, \"paso\": 2, \"error\": \"Sin grupo activo\", \"usuario\": \"" + usuario + "\"}");
        return;
    }
    
    // Test 2: Crear instancias
    ClsNPeti negocioPeti = new ClsNPeti();
    ClsNGrupo negocioGrupo = new ClsNGrupo();
    
    // Test 3: Obtener cambios
    List<Map<String, Object>> cambios = negocioPeti.obtenerCambiosRecientes(grupoId, 5);
    
    // Test 4: Obtener miembros
    List<Map<String, Object>> miembros = negocioGrupo.obtenerMiembrosGrupoParaNotificaciones(grupoId);
    
    // Test 5: Construir respuesta simple
    out.print("{");
    out.print("\"success\": true,");
    out.print("\"paso\": 5,");
    out.print("\"usuario\": \"" + usuario + "\",");
    out.print("\"grupoId\": " + grupoId + ",");
    out.print("\"totalCambios\": " + cambios.size() + ",");
    out.print("\"totalMiembros\": " + miembros.size());
    out.print("}");
    
} catch (Exception e) {
    String errorMsg = e.getMessage();
    if (errorMsg == null) errorMsg = "Error desconocido";
    errorMsg = errorMsg.replace("\"", "'").replace("\\", "/");
    out.print("{\"success\": false, \"error\": \"" + e.getClass().getSimpleName() + ": " + errorMsg + "\"}");
}
%>
