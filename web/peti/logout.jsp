<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Invalidar la sesión
    if (session != null) {
        session.invalidate();
    }
    
    // Redirigir al login
    response.sendRedirect("index.jsp");
%>