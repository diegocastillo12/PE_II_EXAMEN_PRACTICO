<%-- 
    Document   : unirseGrupo
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="conexion.conexion"%>
<%@page import="entidad.ClsEGrupo"%>
<%@page import="negocio.ClsNGrupo"%>
<%@page import="negocio.ClsNLogin"%>
<%@page import="entidad.ClsELogin"%>

<%
    // Verificar que el usuario esté logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // REMOVIDO: Verificación de grupo único - ahora permitimos múltiples grupos
    
    // Obtener el código del formulario
    String codigoUnirse = request.getParameter("codigoGrupo");
    
    // Validar parámetro
    if (codigoUnirse == null || codigoUnirse.trim().isEmpty()) {
        response.sendRedirect("menuprincipal.jsp?error=codigo_vacio");
        return;
    }
    
    codigoUnirse = codigoUnirse.trim().toUpperCase();
    
    // Unirse a grupo usando las nuevas clases
    ClsNGrupo negocioGrupo = new ClsNGrupo();
    
    try {
        // Obtener el ID del usuario usando la clase de negocio
        ClsNLogin negocioLogin = new ClsNLogin();
        int idUsuario = negocioLogin.obtenerIdUsuario(usuario);
        
        if (idUsuario <= 0) {
            response.sendRedirect("menuprincipal.jsp?error=usuario_no_encontrado");
            return;
        }
        
        // Buscar el grupo por código usando la clase de negocio
        ClsEGrupo grupo = negocioGrupo.obtenerGrupoPorCodigo(codigoUnirse);
        
        if (grupo == null) {
            response.sendRedirect("menuprincipal.jsp?error=codigo_no_encontrado");
            return;
        }
        
        // Unirse al grupo usando la clase de negocio
        boolean resultado = negocioGrupo.unirseGrupo(idUsuario, codigoUnirse);
        
        if (resultado) {
            // Redirigir al menú principal con mensaje de éxito
            response.sendRedirect("menuprincipal.jsp?success=unido_grupo&grupo=" + java.net.URLEncoder.encode(grupo.getNombre(), "UTF-8"));
        } else {
            // Verificar el motivo del fallo
            if (negocioGrupo.usuarioYaPerteneceAGrupo(idUsuario, grupo.getId())) {
                response.sendRedirect("menuprincipal.jsp?error=ya_es_miembro");
            } else {
                response.sendRedirect("menuprincipal.jsp?error=grupo_lleno");
            }
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("menuprincipal.jsp?error=error_base_datos");
    }
%>