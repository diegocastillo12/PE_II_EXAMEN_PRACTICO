<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti"%>
<%@page import="entidad.ClsEPeti"%>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.setStatus(401);
        out.print("{\"success\": false, \"error\": \"No autorizado\"}");
        return;
    }
    
    // Obtener parámetros
    String grupoIdParam = request.getParameter("grupoId");
    String seccion = request.getParameter("seccion");
    String campo = request.getParameter("campo");
    String valor = request.getParameter("valor");
    String usuarioIdParam = request.getParameter("usuarioId");
    
    // Validar parámetros obligatorios
    if (grupoIdParam == null || seccion == null || campo == null || 
        valor == null || usuarioIdParam == null) {
        response.setStatus(400);
        out.print("{\"success\": false, \"error\": \"Parámetros faltantes\"}");
        return;
    }
    
    try {
        int grupoId = Integer.parseInt(grupoIdParam);
        int usuarioId = Integer.parseInt(usuarioIdParam);
        
        // Verificar que el usuario pertenece al grupo
        ClsNPeti negocioPeti = new ClsNPeti();
        
        if (!negocioPeti.tienePermisos(usuarioId, grupoId)) {
            response.setStatus(403);
            out.print("{\"success\": false, \"error\": \"Sin permisos para editar este grupo\"}");
            return;
        }
        
        // Crear objeto PETI
        ClsEPeti datosPeti = new ClsEPeti(grupoId, seccion, campo, valor, usuarioId);
        
        // Guardar en la base de datos
        boolean resultado = negocioPeti.guardarDato(datosPeti);
        
        if (resultado) {
            response.setContentType("application/json");
            out.print("{\"success\": true, \"message\": \"Datos guardados exitosamente\"}");
        } else {
            response.setStatus(500);
            out.print("{\"success\": false, \"error\": \"Error al guardar en la base de datos\"}");
        }
        
    } catch (NumberFormatException e) {
        response.setStatus(400);
        out.print("{\"success\": false, \"error\": \"Formato de ID inválido\"}");
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"success\": false, \"error\": \"Error interno del servidor: " + e.getMessage() + "\"}");
        
        // Log del error para debug
        System.err.println("Error al guardar dato PETI: " + e.getMessage());
        e.printStackTrace();
    }
%>