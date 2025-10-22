<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map"%>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener información del grupo desde la sesión
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    // Verificar modo colaborativo
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    
    // Variables para los datos
    String vision = "";
    String caracteristicas = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevaVision = request.getParameter("vision");
        String nuevasCaracteristicas = request.getParameter("caracteristicas");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevaVision != null && !nuevaVision.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "vision", "vision", nuevaVision.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevasCaracteristicas != null && !nuevasCaracteristicas.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "vision", "caracteristicas", nuevasCaracteristicas.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Visión guardada exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar algunos datos";
                tipoMensaje = "error";
            }
        } catch (Exception e) {
            mensaje = "Error interno: " + e.getMessage();
            tipoMensaje = "error";
        }
    }
    
    // Cargar datos existentes
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            Map<String, String> datosVision = negocioPeti.obtenerDatosSeccion(grupoId, "vision");
            
            vision = datosVision.getOrDefault("vision", "");
            caracteristicas = datosVision.getOrDefault("caracteristicas", "");
        } catch (Exception e) {
            System.err.println("Error al cargar datos: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visión Empresarial - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: #333;
            font-weight: 600;
            font-size: 16px;
        }

        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
            min-height: 120px;
            resize: vertical;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .vision-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 5px solid #667eea;
        }

        .caracteristicas-section {
            background: #fff8e1;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 5px solid #ff9800;
        }

        .preview-section {
            background: #e3f2fd;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-section h3 {
            color: #1976d2;
            margin-bottom: 15px;
        }

        .vision-preview {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #667eea;
        }

        .caracteristicas-preview {
            background: white;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #ff9800;
        }

        .tips-box {
            background: #e8f5e8;
            border: 1px solid #4caf50;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .tips-box h4 {
            color: #2e7d32;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .tips-box ul {
            color: #2e7d32;
            margin-left: 20px;
        }

        .tips-box li {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-telescope"></i> Visión Empresarial
                    <small style="font-size: 14px; color: #666;">- Grupo: <%= grupoActual %> 
                    <% if ("admin".equals(rolUsuario)) { %>
                        <span style="color: #ffc107;">👑</span>
                    <% } %>
                    </small>
                </h1>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="dashboard.jsp" class="btn" style="background: #6c757d; color: white;">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="../menuprincipal.jsp" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Menú Principal
                </a>
            </div>
        </div>

        <div class="content">
            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-<%= tipoMensaje %>">
                    <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-triangle" %>"></i>
                    <%= mensaje %>
                </div>
            <% } %>

            <% if (!modoColaborativo) { %>
                <div class="alert" style="background: #fff3cd; border: 1px solid #ffeaa7; color: #856404;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Error:</strong> Debes estar en un grupo para acceder a esta página.
                    <a href="../menuprincipal.jsp" style="color: #856404; text-decoration: underline;">Ir al menú principal</a>
                </div>
            <% } else { %>

            <div class="tips-box">
                <h4><i class="fas fa-lightbulb"></i> Tips para definir la Visión</h4>
                <ul>
                    <li>Describe dónde quiere estar la empresa en el futuro (5-10 años)</li>
                    <li>Debe ser inspiradora y motivadora para todos los empleados</li>
                    <li>Enfócate en los resultados deseados, no en los métodos</li>
                    <li>Debe ser específica pero lo suficientemente amplia para permitir crecimiento</li>
                    <li>Debe ser realista pero ambiciosa</li>
                </ul>
            </div>

            <form method="post" action="">
                <div class="vision-section">
                    <div class="form-group">
                        <label for="vision">
                            <i class="fas fa-eye"></i> Declaración de Visión
                        </label>
                        <textarea id="vision" name="vision" 
                                  placeholder="Describe la visión de futuro de la empresa. ¿Dónde se ve la organización en los próximos 5-10 años? ¿Cuál es el impacto que quiere generar en el mundo?"
                                  style="min-height: 150px;"><%= vision %></textarea>
                    </div>
                </div>

                <div class="caracteristicas-section">
                    <div class="form-group">
                        <label for="caracteristicas">
                            <i class="fas fa-star"></i> Características de la Visión
                        </label>
                        <textarea id="caracteristicas" name="caracteristicas" 
                                  placeholder="Describe las características distintivas que tendrá la empresa cuando alcance su visión. ¿Qué la hará única? ¿Qué reconocimientos espera obtener?"
                                  style="min-height: 120px;"><%= caracteristicas %></textarea>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                        <i class="fas fa-save"></i> Guardar Visión Empresarial
                    </button>
                </div>
            </form>

            <!-- Vista Previa -->
            <div class="preview-section">
                <h3><i class="fas fa-eye"></i> Vista Previa de la Visión</h3>
                
                <div class="vision-preview">
                    <h4 style="color: #333; margin-bottom: 10px;">
                        <i class="fas fa-telescope" style="color: #667eea;"></i> Nuestra Visión
                    </h4>
                    <p id="visionPreview" style="font-size: 16px; line-height: 1.6; color: #555;">
                        <%= !vision.isEmpty() ? vision : "La declaración de visión aparecerá aquí..." %>
                    </p>
                </div>

                <div class="caracteristicas-preview">
                    <h4 style="color: #333; margin-bottom: 10px;">
                        <i class="fas fa-star" style="color: #ff9800;"></i> Características Distintivas
                    </h4>
                    <p id="caracteristicasPreview" style="font-size: 16px; line-height: 1.6; color: #555;">
                        <%= !caracteristicas.isEmpty() ? caracteristicas : "Las características de la visión aparecerán aquí..." %>
                    </p>
                </div>
            </div>

            <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                <p style="color: #2d5a3d; margin: 0;">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Modo Colaborativo:</strong> La visión se guarda automáticamente y es visible 
                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                </p>
            </div>

            <% } %>
        </div>
    </div>

    <script>
        function actualizarPreview() {
            const visionText = document.getElementById('vision').value;
            const caracteristicasText = document.getElementById('caracteristicas').value;
            const visionPreview = document.getElementById('visionPreview');
            const caracteristicasPreview = document.getElementById('caracteristicasPreview');
            
            visionPreview.textContent = visionText || 'La declaración de visión aparecerá aquí...';
            caracteristicasPreview.textContent = caracteristicasText || 'Las características de la visión aparecerán aquí...';
        }

        // Agregar listeners
        document.addEventListener('DOMContentLoaded', function() {
            const vision = document.getElementById('vision');
            const caracteristicas = document.getElementById('caracteristicas');
            
            if (vision) {
                vision.addEventListener('input', actualizarPreview);
            }
            if (caracteristicas) {
                caracteristicas.addEventListener('input', actualizarPreview);
            }
            
            // Actualizar preview inicial
            actualizarPreview();
        });

        // Auto-refresh cada 15 segundos
        setInterval(function() {
            const inputs = document.querySelectorAll('textarea');
            let hayChanged = false;
            inputs.forEach(input => {
                if (input.dataset.changed === 'true') {
                    hayChanged = true;
                }
            });
            
            if (!hayChanged) {
                location.reload();
            }
        }, 15000);

        // Marcar como cambiado
        document.querySelectorAll('textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });
    </script>
</body>
</html>
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: #f8f9fa;
            height: 100vh;
            overflow: hidden;
        }

        .dashboard-container {
            width: 100vw;
            height: 100vh;
            display: flex;
            overflow: hidden;
        }

        .dashboard-sidebar {
            width: 280px;
            min-width: 280px;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        .user-profile {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            padding: 20px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            margin-bottom: 30px;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
            backdrop-filter: blur(10px);
        }

        .user-info h3 {
            margin-bottom: 5px;
            font-size: 18px;
            font-weight: 600;
        }

        .user-info p {
            font-size: 14px;
            opacity: 0.8;
        }

        .dashboard-nav ul {
            list-style: none;
            padding: 0;
        }

        .dashboard-nav li {
            margin-bottom: 5px;
        }

        .dashboard-nav a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 12px 15px;
            display: flex;
            align-items: center;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .dashboard-nav a i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        .dashboard-nav a:hover,
        .dashboard-nav li.active a {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            transform: translateX(5px);
        }

        .dashboard-content {
            flex: 1;
            background: #f8f9fa;
            overflow-y: auto;
            height: 100vh;
        }

        .dashboard-header {
            background: white;
            padding: 20px 30px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .dashboard-header h1 {
            color: #2c3e50;
            font-size: 28px;
            font-weight: 600;
            margin: 0;
        }

        .dashboard-main {
            padding: 30px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-primary i {
            margin-right: 8px;
        }

        .vision-section {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        .vision-section h2 {
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 20px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
            min-height: 120px;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .vision-preview {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .vision-preview h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .vision-preview p {
            color: #555;
            line-height: 1.6;
            font-size: 16px;
            font-style: italic;
        }

        .btn-save {
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            background: #218838;
            transform: translateY(-1px);
        }

        .guidelines {
            background: #e8f5e8;
            border-left: 4px solid #28a745;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
        }

        .guidelines h4 {
            color: #155724;
            margin-bottom: 10px;
        }

        .guidelines ul {
            color: #555;
            padding-left: 20px;
        }

        .guidelines li {
            margin-bottom: 5px;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
                height: auto;
                min-height: 100vh;
            }
            
            .dashboard-sidebar {
                width: 100%;
                order: 2;
                padding: 15px;
            }
            
            .dashboard-content {
                order: 1;
                height: auto;
            }
            
            .dashboard-main {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="user-profile">
                <div class="user-avatar">
                    <span><%= userInitials %></span>
                </div>
                <div class="user-info">
                    <h3><%= usuario %></h3>
                    <p><%= userEmail %></p>
                </div>
            </div>
            <nav class="dashboard-nav">
                <ul>
                    <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                    <li><a href="empresa.jsp"><i class="fas fa-building"></i> Empresa</a></li>
                    <li><a href="mision.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                    <li class="active"><a href="vision.jsp"><i class="fas fa-eye"></i> Visión</a></li>
                    <li><a href="valores.jsp"><i class="fas fa-heart"></i> Valores</a></li>
                    <li><a href="analisis-externo.jsp"><i class="fas fa-search"></i> Análisis Externo</a></li>
                    <li><a href="analisis-interno.jsp"><i class="fas fa-chart-bar"></i> Análisis Interno</a></li>
                    <li><a href="pest.jsp"><i class="fas fa-list"></i> Análisis PEST</a></li>
                    <li><a href="porter.jsp"><i class="fas fa-shield-alt"></i> Porter</a></li>
                    <li><a href="matriz-came.jsp"><i class="fas fa-th"></i> Matriz CAME</a></li>
                    <li><a href="cadena-valor.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                    <li><a href="objetivos.jsp"><i class="fas fa-target"></i> Objetivos</a></li>
                    <li><a href="identificacion-estrategia.jsp"><i class="fas fa-lightbulb"></i> Estrategias</a></li>
                    <li><a href="matriz-participacion.jsp"><i class="fas fa-users"></i> Matriz Participación</a></li>
                    <li><a href="resumen-ejecutivo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                </ul>
            </nav>
        </div>
        <div class="dashboard-content">
            <header class="dashboard-header">
                <h1>Visión de la Empresa</h1>
                <div class="header-actions">
                    <button class="btn-primary" onclick="guardarVision()"><i class="fas fa-save"></i> Guardar</button>
                </div>
            </header>
            <main class="dashboard-main">
                <div class="vision-section">
                    <h2>Definición de la Visión</h2>
                    
                    <div class="guidelines">
                        <h4>Guía para redactar la visión:</h4>
                        <ul>
                            <li>¿Dónde quiere estar la empresa en el futuro?</li>
                            <li>¿Qué aspira a lograr en los próximos años?</li>
                            <li>¿Cómo se ve la empresa en su estado ideal?</li>
                            <li>¿Qué impacto quiere tener en su industria/sociedad?</li>
                        </ul>
                    </div>
                    
                    <div class="form-group">
                        <label for="vision">Declaración de la Visión:</label>
                        <textarea id="vision" placeholder="Redacte la visión de su empresa, describiendo sus aspiraciones futuras..." oninput="actualizarPreview()"></textarea>
                    </div>
                    
                    <div class="vision-preview">
                        <h3>Vista Previa de la Visión:</h3>
                        <p id="visionPreview">La visión aparecerá aquí mientras la escribes...</p>
                    </div>
                    
                    <button class="btn-save" onclick="guardarVision()">
                        <i class="fas fa-save"></i> Guardar Visión
                    </button>
                </div>
            </main>
        </div>
    </div>
    
    <script>
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
        
        function actualizarPreview() {
            const vision = document.getElementById('vision').value;
            const preview = document.getElementById('visionPreview');
            
            if (vision.trim()) {
                preview.textContent = vision;
                preview.style.fontStyle = 'normal';
            } else {
                preview.textContent = 'La visión aparecerá aquí mientras la escribes...';
                preview.style.fontStyle = 'italic';
            }
        }
        
        function guardarVision() {
            const vision = document.getElementById('vision').value;
            
            if (!vision.trim()) {
                alert('Por favor, ingrese la declaración de la visión.');
                return;
            }
            
            // Aquí se puede agregar la lógica para guardar en la base de datos
            alert('Visión guardada exitosamente.');
        }
        
        // Cargar datos guardados al cargar la página
        window.onload = function() {
            // Aquí se puede agregar la lógica para cargar datos existentes
            actualizarPreview();
        };
    </script>
</body>
</html>