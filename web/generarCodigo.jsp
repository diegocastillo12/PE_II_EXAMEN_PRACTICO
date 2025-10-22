<%-- 
    Document   : generarCodigo
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.security.SecureRandom"%>

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
    
    if (grupoActual == null || !"admin".equals(rolUsuario)) {
        response.sendRedirect("menuprincipal.jsp?error=sin_permisos");
        return;
    }
    
    // Obtener la "base de datos" de grupos
    Map<String, Map<String, Object>> gruposDB = (Map<String, Map<String, Object>>) application.getAttribute("gruposDB");
    if (gruposDB == null) {
        response.sendRedirect("menuprincipal.jsp?error=grupo_no_encontrado");
        return;
    }
    
    // Verificar que el grupo existe
    Map<String, Object> grupoInfo = gruposDB.get(grupoActual);
    if (grupoInfo == null) {
        response.sendRedirect("menuprincipal.jsp?error=grupo_no_encontrado");
        return;
    }
    
    // Verificar que el usuario es realmente el admin del grupo
    String adminGrupo = (String) grupoInfo.get("admin");
    if (!usuario.equals(adminGrupo)) {
        response.sendRedirect("menuprincipal.jsp?error=sin_permisos");
        return;
    }
    
    // Generar nuevo código único
    String nuevoCodigo = generarCodigoUnico(gruposDB);
    
    // Actualizar el código del grupo
    grupoInfo.put("codigo", nuevoCodigo);
    grupoInfo.put("fechaUltimoCodigo", new Date());
    
    // Actualizar el código en la sesión
    session.setAttribute("codigoGrupo", nuevoCodigo);
    
    // Redirigir al menú principal con mensaje de éxito
    response.sendRedirect("menuprincipal.jsp?success=codigo_generado&codigo=" + nuevoCodigo);
%>

<%!
    // Método para generar un código único de 6 caracteres
    private String generarCodigoUnico(Map<String, Map<String, Object>> gruposDB) {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        SecureRandom random = new SecureRandom();
        String codigo;
        
        do {
            StringBuilder sb = new StringBuilder(6);
            for (int i = 0; i < 6; i++) {
                sb.append(caracteres.charAt(random.nextInt(caracteres.length())));
            }
            codigo = sb.toString();
        } while (codigoExiste(codigo, gruposDB));
        
        return codigo;
    }
    
    // Método para verificar si un código ya existe
    private boolean codigoExiste(String codigo, Map<String, Map<String, Object>> gruposDB) {
        for (Map<String, Object> grupoInfo : gruposDB.values()) {
            if (codigo.equals(grupoInfo.get("codigo"))) {
                return true;
            }
        }
        return false;
    }
%>