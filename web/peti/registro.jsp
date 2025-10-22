<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuario</title>
    <link rel="stylesheet" href="estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="container">
        <h2 class="form-title">Crear Cuenta</h2>
        <form id="registerForm">
            <div class="form-group">
                <label for="nombre"><i class="fas fa-user"></i> Nombre Completo</label>
                <input type="text" id="nombre" name="nombre" class="form-control" placeholder="Ingresa tu nombre completo" required>
            </div>
            <div class="form-group">
                <label for="email"><i class="fas fa-envelope"></i> Correo Electrónico</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Ingresa tu correo electrónico" required>
            </div>
            <div class="form-group">
                <label for="password"><i class="fas fa-lock"></i> Contraseña</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Crea una contraseña" required>
            </div>
            <div class="form-group">
                <label for="confirm-password"><i class="fas fa-check-circle"></i> Confirmar Contraseña</label>
                <input type="password" id="confirm-password" name="confirm-password" class="form-control" placeholder="Confirma tu contraseña" required>
            </div>
            <div class="form-group">
                <button type="submit" class="btn">Registrarse <i class="fas fa-user-plus"></i></button>
            </div>
            <div id="registerMessage" class="message"></div>
        </form>
        <div class="form-footer">
            ¿Ya tienes una cuenta? <a href="index.jsp">Inicia sesión aquí</a>
        </div>
    </div>
    
    <script src="js/auth.js"></script>
</body>
</html>