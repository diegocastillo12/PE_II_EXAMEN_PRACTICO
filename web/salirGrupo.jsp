<%-- 
    Document   : salirGrupo
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
    
    // Verificar que el usuario tenga un grupo
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    
    if (grupoActual == null) {
        response.sendRedirect("menuprincipal.jsp?error=sin_grupo");
        return;
    }
    
    
    // Salir del grupo usando las nuevas clases
    ClsNGrupo negocioGrupo = new ClsNGrupo();
    
    try {
        // Obtener el ID del usuario usando la clase de negocio
        ClsNLogin negocioLogin = new ClsNLogin();
        int idUsuario = negocioLogin.obtenerIdUsuario(usuario);
        
        if (idUsuario <= 0) {
            response.sendRedirect("menuprincipal.jsp?error=usuario_no_encontrado");
            return;
        }
        
        // Salir del grupo usando la clase de negocio
        boolean resultado = negocioGrupo.salirGrupo(idUsuario);
        
        if (resultado) {
            // Limpiar atributos de sesión
            session.removeAttribute("grupoActual");
            session.removeAttribute("rolUsuario");
            session.removeAttribute("codigoGrupo");
            session.removeAttribute("idGrupo");
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("menuprincipal.jsp?success=salir_grupo");
        } else {
            response.sendRedirect("menuprincipal.jsp?error=no_se_pudo_salir");
        }
        
    } catch (Exception e) {
        // Error al salir del grupo
        e.printStackTrace();
        response.sendRedirect("menuprincipal.jsp?error=error_base_datos");
    }
%>