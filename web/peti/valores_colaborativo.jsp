<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti, entidad.ClsEPeti"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.*"%>

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
    
    // Obtener información del usuario para el perfil
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) userEmail = "usuario@sistema.local";
    
    // Generar iniciales del usuario
    String userInitials = "";
    if (usuario != null && usuario.length() > 0) {
        String[] nombres = usuario.split(" ");
        userInitials = nombres[0].substring(0, 1).toUpperCase();
        if (nombres.length > 1) {
            userInitials += nombres[nombres.length - 1].substring(0, 1).toUpperCase();
        }
    }
    
    // Variables para los datos
    String valoresActuales = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevosValores = request.getParameter("valores");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        
        try {
            if (nuevosValores != null && !nuevosValores.trim().isEmpty()) {
                ClsEPeti datoValores = new ClsEPeti(grupoId, "valores", "lista", nuevosValores.trim(), usuarioId);
                boolean exito = negocioPeti.guardarDato(datoValores);
                
                if (exito) {
                    mensaje = "Valores guardados exitosamente";
                    tipoMensaje = "success";
                } else {
                    mensaje = "Error al guardar los valores";
                    tipoMensaje = "error";
                }
            }
        } catch (Exception e) {
            mensaje = "Error interno: " + e.getMessage();
            tipoMensaje = "error";
            e.printStackTrace();
        }
    }
    
    // Cargar datos existentes
    if (modoColaborativo) {
        try {
            ClsNPeti negocioPeti = new ClsNPeti();
            Map<String, String> datosValores = negocioPeti.obtenerDatosSeccion(grupoId, "valores");
            
            if (datosValores.containsKey("lista")) {
                valoresActuales = datosValores.get("lista");
            }
        } catch (Exception e) {
            //System.err.println("Error al cargar datos: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Valores Corporativos - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a365d;
            --secondary-color: #2d3748;
            --accent-color: #3182ce;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --danger-color: #e53e3e;
            --light-bg: #f7fafc;
            --card-bg: #ffffff;
            --text-primary: #2d3748;
            --text-secondary: #4a5568;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        body {
            background: var(--light-bg);
            height: 100vh;
            overflow: hidden;
            color: var(--text-primary);
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
            background: var(--primary-color);
            color: white;
            padding: 0;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-lg);
            border-right: 1px solid var(--border-color);
            height: 100vh;
            overflow: hidden;
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
        }

        .company-logo {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
        }

        .company-logo i {
            font-size: 28px;
            margin-right: 12px;
            color: var(--accent-color);
        }

        .company-logo h2 {
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -0.025em;
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            margin-top: 8px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: var(--accent-color);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: 600;
            margin-right: 12px;
            flex-shrink: 0;
        }

        .user-info h3 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 12px;
            opacity: 0.7;
        }

        .dashboard-nav {
            flex: 1;
            padding: 20px 0;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .nav-section {
            margin-bottom: 24px;
        }

        .nav-section-title {
            padding: 0 20px 8px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: rgba(255, 255, 255, 0.6);
        }

        .dashboard-nav ul {
            list-style: none;
            padding: 0;
        }

        .dashboard-nav li {
            margin-bottom: 2px;
        }

        .dashboard-nav a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: all 0.2s ease;
            font-size: 14px;
            font-weight: 500;
            position: relative;
        }

        .dashboard-nav a i {
            margin-right: 12px;
            width: 18px;
            text-align: center;
            font-size: 16px;
        }

        .dashboard-nav a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .dashboard-nav li.active a {
            background: var(--accent-color);
            color: white;
        }

        .dashboard-nav li.active a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: white;
        }

        .dashboard-content {
            flex: 1;
            background: var(--light-bg);
            overflow-y: auto;
            height: 100vh;
        }

        .dashboard-header {
            background: var(--card-bg);
            padding: 20px 32px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow-sm);
        }

        .dashboard-header h1 {
            color: var(--text-primary);
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.025em;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            background: rgba(49, 130, 206, 0.1);
            color: var(--accent-color);
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
        }

        .status-badge i {
            margin-right: 6px;
        }

        .admin-badge {
            background: rgba(214, 158, 46, 0.1);
            color: var(--warning-color);
            margin-left: 8px;
        }

        .dashboard-main {
            padding: 32px;
        }

        .btn-primary {
            background: var(--accent-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            text-decoration: none;
        }

        .btn-primary:hover {
            background: #2c5282;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-primary i {
            margin-right: 8px;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 16px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .dashboard-section {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            margin-bottom: 24px;
            overflow: hidden;
        }

        .section-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            background: rgba(26, 54, 93, 0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section-header h2 {
            margin: 0;
            color: var(--text-primary);
            font-size: 18px;
            font-weight: 600;
        }

        .section-content {
            padding: 24px;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: rgba(56, 161, 105, 0.1);
            border: 1px solid rgba(56, 161, 105, 0.2);
            color: var(--success-color);
        }

        .alert-error {
            background: rgba(229, 62, 62, 0.1);
            border: 1px solid rgba(229, 62, 62, 0.2);
            color: var(--danger-color);
        }

        .alert-warning {
            background: rgba(214, 158, 46, 0.1);
            border: 1px solid rgba(214, 158, 46, 0.2);
            color: var(--warning-color);
        }

        .guide-section {
            background: rgba(56, 161, 105, 0.05);
            border: 1px solid rgba(56, 161, 105, 0.2);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 24px;
        }

        .guide-section h3 {
            color: var(--success-color);
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .guide-section ul {
            list-style: none;
            padding-left: 0;
        }

        .guide-section li {
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
            color: var(--text-secondary);
            font-size: 14px;
        }

        .guide-section li::before {
            content: '•';
            position: absolute;
            left: 0;
            color: var(--success-color);
            font-weight: bold;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-weight: 500;
            font-size: 14px;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.2s ease;
            background: var(--card-bg);
            min-height: 150px;
            resize: vertical;
            font-family: inherit;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .saved-indicator {
            color: var(--success-color);
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .preview-card {
            background: rgba(26, 54, 93, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-card h3 {
            color: var(--text-primary);
            margin-bottom: 16px;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .preview-values {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 16px;
        }

        .value-item {
            background: var(--card-bg);
            padding: 16px;
            border-radius: 8px;
            border-left: 4px solid var(--accent-color);
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
        }

        .value-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .value-item h4 {
            color: var(--text-primary);
            margin-bottom: 8px;
            font-size: 16px;
            font-weight: 600;
        }

        .value-item p {
            color: var(--text-secondary);
            font-size: 14px;
            line-height: 1.5;
        }

        .save-button-container {
            text-align: center;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
        }

        .mode-info {
            background: rgba(49, 130, 206, 0.1);
            border: 1px solid rgba(49, 130, 206, 0.2);
            color: var(--accent-color);
            padding: 16px;
            border-radius: 8px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
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
            
            .dashboard-header {
                padding: 16px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .preview-values {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="company-logo">
                    <i class="fas fa-building"></i>
                    <h2>PETI System</h2>
                </div>
                <div class="user-profile">
                    <div class="user-avatar">
                        <span id="userInitials"><%= userInitials %></span>
                    </div>
                    <div class="user-info">
                        <h3 id="userName"><%= usuario %></h3>
                        <p id="userEmail"><%= userEmail %></p>
                    </div>
                </div>
            </div>
            <nav class="dashboard-nav">
                <div class="nav-section">
                    <div class="nav-section-title">Principal</div>
                    <ul>
                        <li><a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Planificación Estratégica</div>
                    <ul>
                        <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Información Empresarial</a></li>
                        <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
                        <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
                        <li class="active"><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
                        <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Análisis Estratégico</div>
                    <ul>
                        <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
                        <li><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
                         <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>

                        <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>

                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Herramientas de Gestión</div>
                    <ul>

                        <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz de Participación</a></li>
                        <li><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Sistema</div>
                    <ul>
                        <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                    </ul>
                </div>
            </nav>
        </div>

        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1>
                    <i class="fas fa-heart"></i> Valores Organizacionales - <%= grupoActual != null ? grupoActual : "Modo Individual" %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i>
                            Modo Colaborativo
                        </span>
                        <% if ("admin".equals(rolUsuario)) { %>
                            <span class="status-badge admin-badge">
                                <i class="fas fa-crown"></i>
                                Administrador
                            </span>
                        <% } %>
                    <% } else { %>
                        <span class="status-badge">
                            <i class="fas fa-user"></i>
                            Modo Individual
                        </span>
                    <% } %>
                    <a href="../menuprincipal.jsp" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Menú Principal
                    </a>
                </div>
            </div>

            <div class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje %>">
                        <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-triangle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <% if (!modoColaborativo) { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Modo Individual:</strong> No puedes guardar cambios. 
                        <a href="../menuprincipal.jsp" style="color: var(--warning-color); text-decoration: underline;">Únete a un grupo</a> 
                        para trabajar colaborativamente.
                    </div>
                <% } %>

                <div class="dashboard-section">
                    <div class="section-header">
                        <h2><i class="fas fa-heart"></i> Definición de Valores Corporativos</h2>
                    </div>
                    <div class="section-content">
                        <div class="guide-section">
                            <h3><i class="fas fa-lightbulb"></i> Guía para definir valores corporativos:</h3>
                            <ul>
                                <li>Defina de 5 a 7 valores fundamentales</li>
                                <li>Cada valor debe tener una descripción clara</li>
                                <li>Use el formato: "Valor: Descripción"</li>
                                <li>Un valor por línea</li>
                                <li>Ejemplo: "Integridad: Actuamos con honestidad y transparencia en todas nuestras acciones"</li>
                            </ul>
                        </div>

                        <form method="post" action="valores_colaborativo.jsp">
                            <div class="form-group">
                                <label for="valores">
                                    Lista de Valores Corporativos:
                                    <% if (modoColaborativo && !valoresActuales.isEmpty()) { %>
                                        <span class="saved-indicator">
                                            <i class="fas fa-check-circle"></i> Guardado
                                        </span>
                                    <% } %>
                                </label>
                                <textarea 
                                    id="valores" 
                                    name="valores"
                                    placeholder="Escriba los valores corporativos, uno por línea. Ejemplo:&#10;Integridad: Actuamos con honestidad y transparencia&#10;Excelencia: Buscamos la perfección en todo lo que hacemos&#10;Innovación: Fomentamos la creatividad y el pensamiento disruptivo"
                                    oninput="actualizarPreview()"
                                    <%= modoColaborativo ? "" : "readonly" %>
                                    required><%= valoresActuales %></textarea>
                            </div>

                            <div class="preview-card">
                                <h3><i class="fas fa-eye"></i> Vista Previa de Valores</h3>
                                <div class="preview-values" id="valoresPreview">
                                    <% if (!valoresActuales.isEmpty()) { %>
                                        <%
                                            String[] lineas = valoresActuales.split("\\n");
                                            for (String linea : lineas) {
                                                if (linea.trim().length() > 0) {
                                                    String[] partes = linea.split(":", 2);
                                                    if (partes.length == 2) {
                                        %>
                                        <div class="value-item">
                                            <h4><%= partes[0].trim() %></h4>
                                            <p><%= partes[1].trim() %></p>
                                        </div>
                                        <%
                                                    } else {
                                        %>
                                        <div class="value-item">
                                            <h4>Valor</h4>
                                            <p><%= linea.trim() %></p>
                                        </div>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    <% } else { %>
                                        <div class="value-item">
                                            <h4>Los valores aparecerán aquí</h4>
                                            <p>Escriba los valores en el formato "Valor: Descripción" para verlos aquí.</p>
                                        </div>
                                    <% } %>
                                </div>
                            </div>

                            <% if (modoColaborativo) { %>
                                <div class="save-button-container">
                                    <button type="submit" class="btn-primary">
                                        <i class="fas fa-save"></i> Guardar Valores Corporativos
                                    </button>
                                </div>
                            <% } else { %>
                                <div class="mode-info">
                                    <i class="fas fa-info-circle"></i>
                                    Para guardar cambios, únete a un grupo colaborativo desde el menú principal.
                                </div>
                            <% } %>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function actualizarPreview() {
            const valores = document.getElementById('valores').value;
            const preview = document.getElementById('valoresPreview');
            
            if (valores.trim()) {
                const lineas = valores.split('\n');
                let html = '';
                
                lineas.forEach(linea => {
                    linea = linea.trim();
                    if (linea.length > 0) {
                        const partes = linea.split(':', 2);
                        if (partes.length === 2) {
                            html += `
                                <div class="value-item">
                                    <h4>${partes[0].trim()}</h4>
                                    <p>${partes[1].trim()}</p>
                                </div>
                            `;
                        } else {
                            html += `
                                <div class="value-item">
                                    <h4>Valor</h4>
                                    <p>${linea}</p>
                                </div>
                            `;
                        }
                    }
                });
                
                if (html === '') {
                    html = `
                        <div class="value-item">
                            <h4>Los valores aparecerán aquí</h4>
                            <p>Escriba los valores en el formato "Valor: Descripción" para verlos aquí.</p>
                        </div>
                    `;
                }
                
                preview.innerHTML = html;
            } else {
                preview.innerHTML = `
                    <div class="value-item">
                        <h4>Los valores aparecerán aquí</h4>
                        <p>Escriba los valores en el formato "Valor: Descripción" para verlos aquí.</p>
                    </div>
                `;
            }
        }

        function logout() {
            if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
                window.location.href = '../logout.jsp';
            }
        }

        // Auto-refresh para modo colaborativo
        <% if (modoColaborativo) { %>
            let lastUpdateTime = new Date().getTime();
            
            function checkForUpdates() {
                // Implementar lógica de actualización automática si es necesario
            }
            
            // Verificar actualizaciones cada 30 segundos
            setInterval(checkForUpdates, 30000);
        <% } %>

        // Inicializar vista previa
        document.addEventListener('DOMContentLoaded', function() {
            actualizarPreview();
        });
    </script>
</body>
</html>