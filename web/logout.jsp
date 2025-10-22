<%-- 
    Document   : logout
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Invalidar la sesión actual
    if (session != null) {
        session.invalidate();
    }
    
    // Redirigir al login con mensaje de logout exitoso
    response.sendRedirect("index.jsp?success=logout");
%>