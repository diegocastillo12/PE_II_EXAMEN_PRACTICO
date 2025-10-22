<%-- 
    Document   : registrarUsuario
    Created on : 15 set. 2025, 11:35:00 p. m.
    Author     : Mi Equipo
    Description: Procesa el registro de nuevos usuarios
--%>

<%@page import="negocio.ClsNLogin"%>
<%@page import="entidad.ClsELogin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Obtener parámetros del formulario
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String email = request.getParameter("email");
    
    // Validar que los campos obligatorios no estén vacíos
    if (username == null || password == null || confirmPassword == null ||
        username.trim().isEmpty() || password.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
        response.sendRedirect("index.jsp?error=campos_vacios_registro");
        return;
    }
    
    // Limpiar datos de entrada
    username = username.trim();
    password = password.trim();
    confirmPassword = confirmPassword.trim();
    if (email != null) {
        email = email.trim();
    }
    
    try {
        // Validaciones del lado del servidor
        
        // 1. Verificar que las contraseñas coincidan
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("index.jsp?error=passwords_no_coinciden");
            return;
        }
        
        // 2. Verificar longitud mínima de contraseña
        if (password.length() < 3) {
            response.sendRedirect("index.jsp?error=password_muy_corta");
            return;
        }
        
        // 3. Verificar longitud del nombre de usuario
        if (username.length() < 3 || username.length() > 50) {
            response.sendRedirect("index.jsp?error=username_invalido");
            return;
        }
        
        // 4. Verificar formato del email si se proporcionó
        if (email != null && !email.isEmpty()) {
            String emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$";
            if (!email.matches(emailRegex)) {
                response.sendRedirect("index.jsp?error=email_invalido");
                return;
            }
        } else {
            // Si no se proporcionó email, usar uno por defecto
            email = username + "@sistema.local";
        }
        
        // Crear instancia del negocio de login
        ClsNLogin negocioLogin = new ClsNLogin();
        
        // Verificar si el usuario ya existe
        if (negocioLogin.existeUsuario(username)) {
            response.sendRedirect("index.jsp?error=usuario_ya_existe");
            return;
        }
        
        // Crear objeto usuario para registro
        ClsELogin nuevoUsuario = new ClsELogin(username, password, email);
        
        // Validar datos del usuario
        if (!nuevoUsuario.validarDatosRegistro()) {
            response.sendRedirect("index.jsp?error=datos_invalidos");
            return;
        }
        
        // Intentar registrar el usuario
        boolean registroExitoso = negocioLogin.registrarUsuario(nuevoUsuario);
        
        if (registroExitoso) {
            // Registro exitoso - redirigir con mensaje de éxito
            response.sendRedirect("index.jsp?success=registro_exitoso&username=" + 
                                java.net.URLEncoder.encode(username, "UTF-8"));
            return;
            
        } else {
            // Error en el registro
            response.sendRedirect("index.jsp?error=error_registro");
            return;
        }
        
    } catch (Exception e) {
        // Error interno del servidor
        // Log del error (los detalles se manejan en las clases de negocio)
        
        // Determinar tipo de error para mensaje más específico
        String errorMessage = e.getMessage().toLowerCase();
        
        if (errorMessage.contains("duplicate") || errorMessage.contains("unique")) {
            // Error de duplicado en base de datos
            if (errorMessage.contains("username")) {
                response.sendRedirect("index.jsp?error=usuario_ya_existe");
            } else if (errorMessage.contains("email")) {
                response.sendRedirect("index.jsp?error=email_ya_existe");
            } else {
                response.sendRedirect("index.jsp?error=datos_duplicados");
            }
        } else if (errorMessage.contains("connection") || errorMessage.contains("sql")) {
            // Error de base de datos
            response.sendRedirect("index.jsp?error=error_base_datos");
        } else {
            // Error genérico
            response.sendRedirect("index.jsp?error=error_interno");
        }
        return;
        
    } finally {
        // Limpiar recursos si es necesario
        // La conexión se maneja dentro de ClsNLogin
    }
%>