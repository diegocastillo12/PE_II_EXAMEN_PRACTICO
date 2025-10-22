<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="negocio.ClsNPeti" %>
<%@ page import="java.util.Map" %>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener parámetros de modo
    String modo = request.getParameter("modo");
    String grupoParam = request.getParameter("grupo");
    String rolParam = request.getParameter("rol");
    
    // Obtener información del grupo desde la sesión
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    // Determinar si está en modo colaborativo
    boolean modoColaborativo = "colaborativo".equals(modo) && grupoActual != null;
    boolean puedeEditar = modoColaborativo; // En modo individual no se puede editar
    
    // Obtener información del usuario
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        userEmail = "usuario@ejemplo.com";
    }
    
    // Generar iniciales del usuario
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
    
    // Obtener datos de misión si está en modo colaborativo
    String misionActual = "";
    String visionActual = "";
    String ultimaModificacion = "";
    String usuarioModificacion = "";
    
    if (modoColaborativo && grupoId != null) {
        ClsNPeti negocioPeti = new ClsNPeti();
        Map<String, String> datosMision = negocioPeti.obtenerDatosSeccion(grupoId, "mision");
        Map<String, String> datosVision = negocioPeti.obtenerDatosSeccion(grupoId, "vision");
        
        if (datosMision.containsKey("declaracion")) {
            misionActual = datosMision.get("declaracion");
        }
        if (datosVision.containsKey("declaracion")) {
            visionActual = datosVision.get("declaracion");
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Misión - Plan Estratégico</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
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

        .mission-section {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        .mission-section h2 {
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

        .mission-preview {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .mission-preview h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .mission-preview p {
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
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
        }

        .guidelines h4 {
            color: #1976d2;
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
                    <li class="active"><a href="mision.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                    <li><a href="vision.jsp"><i class="fas fa-eye"></i> Visión</a></li>
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
                <h1>
                    Misión de la Empresa
                    <% if (modoColaborativo) { %>
                        <span style="font-size: 14px; color: #666; font-weight: normal;">
                            - Grupo: <%= grupoActual %> 
                            <% if ("admin".equals(rolUsuario)) { %>
                                <span style="color: #ffc107;">👑</span>
                            <% } %>
                        </span>
                    <% } else { %>
                        <span style="font-size: 14px; color: #666; font-weight: normal;">- Modo Individual</span>
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (puedeEditar) { %>
                        <button class="btn-primary" onclick="guardarMision()">
                            <i class="fas fa-save"></i> Guardar
                        </button>
                    <% } else { %>
                        <button class="btn-primary" disabled style="opacity: 0.5;">
                            <i class="fas fa-lock"></i> Solo Lectura
                        </button>
                    <% } %>
                </div>
            </header>
            <main class="dashboard-main">
                <% if (!modoColaborativo) { %>
                    <!-- Alerta para modo individual -->
                    <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 15px; margin-bottom: 20px;">
                        <div style="display: flex; align-items: center;">
                            <i class="fas fa-exclamation-triangle" style="color: #856404; margin-right: 10px; font-size: 18px;"></i>
                            <div>
                                <strong style="color: #856404;">Modo Individual</strong><br>
                                <small style="color: #856404;">Los cambios no se guardarán. <a href="../menuprincipal.jsp" style="color: #856404; text-decoration: underline;">Únete a un grupo</a> para trabajar colaborativamente.</small>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <div class="mission-section">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2>Definición de la Misión</h2>
                        <% if (modoColaborativo) { %>
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <span style="font-size: 12px; color: #666;">
                                    <i class="fas fa-users"></i> Editando colaborativamente
                                </span>
                                <button onclick="verHistorialSeccion('mision')" style="background: #17a2b8; color: white; border: none; padding: 5px 10px; border-radius: 4px; font-size: 12px;">
                                    <i class="fas fa-history"></i> Historial
                                </button>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="guidelines">
                        <h4>Guía para redactar la misión:</h4>
                        <ul>
                            <li>¿Qué hace la empresa? (productos/servicios)</li>
                            <li>¿Para quién lo hace? (clientes/mercado)</li>
                            <li>¿Cómo lo hace? (ventaja competitiva)</li>
                            <li>¿Por qué lo hace? (propósito/valores)</li>
                        </ul>
                    </div>
                    
                    <div class="form-group">
                        <label for="mision">
                            Declaración de la Misión:
                            <% if (modoColaborativo && !misionActual.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px;">
                                    <i class="fas fa-check-circle"></i> Datos guardados del grupo
                                </span>
                            <% } %>
                        </label>
                        <textarea 
                            id="mision" 
                            placeholder="Redacte la misión de su empresa de manera clara y concisa..." 
                            oninput="actualizarPreview()"
                            <%= puedeEditar ? "" : "readonly" %>
                            style="<%= puedeEditar ? "" : "background-color: #f8f9fa; cursor: not-allowed;" %>"
                        ><%= misionActual %></textarea>
                        
                        <% if (modoColaborativo) { %>
                            <div style="font-size: 12px; color: #666; margin-top: 5px;">
                                <i class="fas fa-info-circle"></i> 
                                Los cambios se guardan automáticamente y son visibles para todos los miembros del grupo.
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="mission-preview">
                        <h3>Vista Previa de la Misión:</h3>
                        <p id="misionPreview">
                            <%= !misionActual.isEmpty() ? misionActual : "La misión aparecerá aquí mientras la escribes..." %>
                        </p>
                    </div>
                    
                    <!-- Sección de Visión relacionada -->
                    <div style="margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 8px;">
                        <h3>Visión de la Empresa <small style="color: #666;">(Relacionada)</small></h3>
                        <div class="form-group">
                            <label for="vision">Declaración de la Visión:</label>
                            <textarea 
                                id="vision" 
                                placeholder="Redacte la visión de su empresa..." 
                                oninput="actualizarPreviewVision()"
                                <%= puedeEditar ? "" : "readonly" %>
                                style="<%= puedeEditar ? "" : "background-color: #f8f9fa; cursor: not-allowed;" %>"
                            ><%= visionActual %></textarea>
                        </div>
                        <div class="mission-preview">
                            <h4>Vista Previa de la Visión:</h4>
                            <p id="visionPreview">
                                <%= !visionActual.isEmpty() ? visionActual : "La visión aparecerá aquí mientras la escribes..." %>
                            </p>
                        </div>
                    </div>
                    
                    <% if (puedeEditar) { %>
                        <div style="display: flex; gap: 15px; margin-top: 20px;">
                            <button class="btn-save" onclick="guardarMision()">
                                <i class="fas fa-save"></i> Guardar Misión
                            </button>
                            <button class="btn-save" onclick="guardarVision()">
                                <i class="fas fa-save"></i> Guardar Visión
                            </button>
                            <button class="btn-save" onclick="guardarAmbas()" style="background: #28a745;">
                                <i class="fas fa-save"></i> Guardar Ambas
                            </button>
                        </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>
    
    <script>
        // Variables globales
        const modoColaborativo = <%= modoColaborativo %>;
        const puedeEditar = <%= puedeEditar %>;
        const grupoId = <%= grupoId != null ? grupoId : "null" %>;
        const usuarioId = <%= usuarioId != null ? usuarioId : "null" %>;
        
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
        
        function actualizarPreview() {
            const mision = document.getElementById('mision').value;
            const preview = document.getElementById('misionPreview');
            
            if (mision.trim()) {
                preview.textContent = mision;
                preview.style.fontStyle = 'normal';
            } else {
                preview.textContent = 'La misión aparecerá aquí mientras la escribes...';
                preview.style.fontStyle = 'italic';
            }
        }
        
        function actualizarPreviewVision() {
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
        
        function guardarMision() {
            if (!puedeEditar) {
                alert('No tienes permisos para editar. Únete a un grupo para trabajar colaborativamente.');
                return;
            }
            
            const mision = document.getElementById('mision').value;
            
            if (!mision.trim()) {
                alert('Por favor, ingrese la declaración de la misión.');
                return;
            }
            
            if (modoColaborativo) {
                guardarDatoColaborativo('mision', 'declaracion', mision);
            } else {
                alert('Modo individual - Los cambios no se pueden guardar.');
            }
        }
        
        function guardarVision() {
            if (!puedeEditar) {
                alert('No tienes permisos para editar. Únete a un grupo para trabajar colaborativamente.');
                return;
            }
            
            const vision = document.getElementById('vision').value;
            
            if (!vision.trim()) {
                alert('Por favor, ingrese la declaración de la visión.');
                return;
            }
            
            if (modoColaborativo) {
                guardarDatoColaborativo('vision', 'declaracion', vision);
            } else {
                alert('Modo individual - Los cambios no se pueden guardar.');
            }
        }
        
        function guardarAmbas() {
            if (!puedeEditar) {
                alert('No tienes permisos para editar.');
                return;
            }
            
            const mision = document.getElementById('mision').value;
            const vision = document.getElementById('vision').value;
            
            if (!mision.trim() || !vision.trim()) {
                alert('Por favor, complete tanto la misión como la visión.');
                return;
            }
            
            if (modoColaborativo) {
                // Guardar ambas secuencialmente
                guardarDatoColaborativo('mision', 'declaracion', mision, function() {
                    guardarDatoColaborativo('vision', 'declaracion', vision, function() {
                        mostrarNotificacion('Misión y Visión guardadas exitosamente', 'success');
                    });
                });
            } else {
                alert('Modo individual - Los cambios no se pueden guardar.');
            }
        }
        
        function guardarDatoColaborativo(seccion, campo, valor, callback) {
            if (!modoColaborativo || !grupoId || !usuarioId) {
                alert('Error: Información de grupo no disponible');
                return;
            }
            
            // Mostrar indicador de guardado
            mostrarNotificacion('Guardando...', 'info');
            
            fetch('api/guardarDato.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'grupoId=' + encodeURIComponent(grupoId) + 
                      '&seccion=' + encodeURIComponent(seccion) +
                      '&campo=' + encodeURIComponent(campo) +
                      '&valor=' + encodeURIComponent(valor) +
                      '&usuarioId=' + encodeURIComponent(usuarioId)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    mostrarNotificacion(seccion.charAt(0).toUpperCase() + seccion.slice(1) + ' guardada exitosamente', 'success');
                    if (callback) callback();
                } else {
                    mostrarNotificacion('Error al guardar: ' + (data.error || 'Error desconocido'), 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                mostrarNotificacion('Error de conexión al guardar', 'error');
            });
        }
        
        function mostrarNotificacion(mensaje, tipo) {
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 1000;
                max-width: 300px;
                color: white;
                font-weight: 500;
            `;
            
            switch (tipo) {
                case 'success':
                    notification.style.background = '#28a745';
                    break;
                case 'error':
                    notification.style.background = '#dc3545';
                    break;
                case 'info':
                    notification.style.background = '#17a2b8';
                    break;
                default:
                    notification.style.background = '#6c757d';
            }
            
            notification.innerHTML = `
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <span>${mensaje}</span>
                    <button onclick="this.parentElement.parentElement.remove()" 
                            style="background: none; border: none; color: white; margin-left: 10px; cursor: pointer; font-size: 16px;">×</button>
                </div>
            `;
            
            document.body.appendChild(notification);
            
            // Auto-remover después de 3 segundos para mensajes de éxito
            if (tipo === 'success' || tipo === 'info') {
                setTimeout(() => {
                    if (notification.parentElement) {
                        notification.remove();
                    }
                }, 3000);
            }
        }
        
        function verHistorialSeccion(seccion) {
            if (!modoColaborativo) {
                alert('Historial no disponible en modo individual');
                return;
            }
            
            // Abrir ventana de historial (por implementar)
            alert('Historial de ' + seccion + ' - Funcionalidad por implementar');
        }
        
        // Auto-guardado cada 30 segundos si hay cambios
        let cambiosPendientes = false;
        let ultimoGuardado = Date.now();
        
        function marcarCambiosPendientes() {
            if (puedeEditar && modoColaborativo) {
                cambiosPendientes = true;
            }
        }
        
        // Agregar listeners para detectar cambios
        document.addEventListener('DOMContentLoaded', function() {
            const misionTextarea = document.getElementById('mision');
            const visionTextarea = document.getElementById('vision');
            
            if (misionTextarea) {
                misionTextarea.addEventListener('input', marcarCambiosPendientes);
            }
            if (visionTextarea) {
                visionTextarea.addEventListener('input', marcarCambiosPendientes);
            }
            
            // Auto-guardado cada 30 segundos
            if (modoColaborativo && puedeEditar) {
                setInterval(function() {
                    if (cambiosPendientes && (Date.now() - ultimoGuardado > 30000)) {
                        const mision = misionTextarea ? misionTextarea.value : '';
                        const vision = visionTextarea ? visionTextarea.value : '';
                        
                        if (mision.trim()) {
                            guardarDatoColaborativo('mision', 'declaracion', mision);
                        }
                        if (vision.trim()) {
                            guardarDatoColaborativo('vision', 'declaracion', vision);
                        }
                        
                        cambiosPendientes = false;
                        ultimoGuardado = Date.now();
                    }
                }, 30000);
            }
        });
        
        // Cargar datos guardados al cargar la página
        window.onload = function() {
            actualizarPreview();
            actualizarPreviewVision();
            
            // Mostrar información del modo actual
            if (modoColaborativo) {
                console.log('Modo colaborativo activo - Grupo ID: ' + grupoId);
            } else {
                console.log('Modo individual - Solo lectura');
            }
        };
    </script>
</body>
</html>