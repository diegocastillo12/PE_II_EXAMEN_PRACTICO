<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="negocio.ClsNPeti, negocio.ClsNGrupo" %>
<%@ page import="java.util.Map, java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.io.*"%>
<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener parámetros de la URL
    String modo = request.getParameter("modo");
    String grupoParam = request.getParameter("grupo");
    String rolParam = request.getParameter("rol");
    
    // Obtener información del grupo desde la sesión
    String grupoActual = (String) session.getAttribute("grupoActual");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    
    // Si se especifica un grupo en la URL, actualizar las variables
    if (grupoParam != null && !grupoParam.trim().isEmpty()) {
        ClsNGrupo negocioGrupo = new ClsNGrupo();
        try {
            // Buscar el grupo por nombre
            List<Map<String, Object>> gruposUsuario = negocioGrupo.obtenerTodosLosGruposUsuario(usuarioId);
            for (Map<String, Object> grupo : gruposUsuario) {
                if (grupoParam.equals((String) grupo.get("nombre"))) {
                    grupoActual = (String) grupo.get("nombre");
                    grupoId = (Integer) grupo.get("id");
                    rolUsuario = (String) grupo.get("rol");
                    
                    // Actualizar la sesión con el nuevo grupo activo
                    session.setAttribute("grupoActual", grupoActual);
                    session.setAttribute("grupoId", grupoId);
                    session.setAttribute("rolUsuario", rolUsuario);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Determinar si está en modo colaborativo
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    
    // Obtener información del usuario para mostrar en el dashboard
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
    
    // Variables para mensajes
    String mensaje = "";
    String tipoMensaje = "";
    
    // Obtener todos los datos del PETI para el resumen
    Map<String, Map<String, String>> todosDatosPeti = null;
    if (modoColaborativo && grupoId != null) {
        ClsNPeti negocioPeti = new ClsNPeti();
        todosDatosPeti = negocioPeti.obtenerTodosDatos(grupoId);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resumen Ejecutivo - PETI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
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
            padding: 12px 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            text-decoration: none;
            margin-right: 12px;
        }

        .btn-primary:hover {
            background: #2c5282;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-primary i {
            margin-right: 8px;
        }

        .btn-success {
            background: var(--success-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            text-decoration: none;
        }

        .btn-success:hover {
            background: #2f855a;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-success i {
            margin-right: 8px;
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

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 24px;
            margin-bottom: 24px;
        }

        .summary-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            box-shadow: var(--shadow-sm);
        }

        .summary-card h3 {
            color: var(--text-primary);
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
        }

        .summary-card h3 i {
            margin-right: 8px;
            color: var(--accent-color);
        }

        .summary-card p {
            color: var(--text-secondary);
            line-height: 1.6;
            font-size: 14px;
        }

        .empty-state {
            text-align: center;
            padding: 48px 24px;
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-weight: 500;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 12px;
        }

        .alert-success {
            background: rgba(56, 161, 105, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(56, 161, 105, 0.2);
        }

        .alert-error {
            background: rgba(229, 62, 62, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(229, 62, 62, 0.2);
        }

        /* Estilos para el PDF */
        .pdf-content {
            display: none;
            background: white;
            padding: 40px;
            font-family: 'Times New Roman', serif;
            line-height: 1.6;
            color: #333;
        }

        .pdf-header {
            text-align: center;
            margin-bottom: 40px;
            border-bottom: 3px solid #1a365d;
            padding-bottom: 20px;
        }

        .pdf-title {
            font-size: 28px;
            font-weight: bold;
            color: #1a365d;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .pdf-subtitle {
            font-size: 16px;
            color: #666;
            margin-bottom: 20px;
        }

        .pdf-section {
            margin-bottom: 30px;
            page-break-inside: avoid;
        }

        .pdf-section-title {
            font-size: 20px;
            font-weight: bold;
            color: #1a365d;
            margin-bottom: 15px;
            border-bottom: 2px solid #3182ce;
            padding-bottom: 8px;
        }

        .pdf-subsection {
            margin-bottom: 20px;
        }

        .pdf-subsection-title {
            font-size: 16px;
            font-weight: bold;
            color: #2d3748;
            margin-bottom: 10px;
        }

        .pdf-text {
            font-size: 12px;
            text-align: justify;
            margin-bottom: 10px;
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
            
            .summary-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .dashboard-header {
                padding: 16px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
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
                        <li class="active"><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Planificación Estratégica</div>
                    <ul>
                        <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Información Empresarial</a></li>
                        <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
                        <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
                        <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
                        <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Análisis Estratégico</div>
                    <ul>
                        <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
                        <li><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
                        <li><a href="pest_colaborativo.jsp"><i class="fas fa-chart-pie"></i> Análisis PEST</a></li>
                        <li><a href="porter_colaborativo.jsp"><i class="fas fa-chess"></i> Fuerzas de Porter</a></li>
                        <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                        <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-th"></i> Matriz BCG</a></li>
                        <li><a href="matriz_came_colaborativo.jsp"><i class="fas fa-crosshairs"></i> Matriz CAME</a></li>
                        <li><a href="identificacion_estrategia_colaborativo.jsp"><i class="fas fa-lightbulb"></i> Identificación de Estrategias</a></li>
                    </ul>
                </div>
            </nav>
        </div>

        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1><i class="fas fa-file-alt"></i> Resumen Ejecutivo del PETI</h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i>
                            Modo Colaborativo - <%= grupoActual %>
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
                </div>
            </div>

            <div class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje.equals("success") ? "success" : "error" %>">
                        <i class="fas fa-<%= tipoMensaje.equals("success") ? "check-circle" : "exclamation-triangle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <div class="dashboard-section">
                    <div class="section-header">
                        <h2><i class="fas fa-file-alt"></i> Resumen Ejecutivo Completo</h2>
                        <div>
                            <button class="btn-success" onclick="generarPDF()">
                                <i class="fas fa-file-pdf"></i>
                                Generar PDF Completo
                            </button>
                            <a href="dashboard.jsp" class="btn-primary">
                                <i class="fas fa-arrow-left"></i>
                                Volver al Dashboard
                            </a>
                        </div>
                    </div>
                    <div class="section-content">
                        <% if (modoColaborativo && todosDatosPeti != null && !todosDatosPeti.isEmpty()) { %>
                            <div class="summary-grid">
                                <!-- Información Empresarial -->
                                <% if (todosDatosPeti.containsKey("empresa") && !todosDatosPeti.get("empresa").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-building"></i> Información Empresarial</h3>
                                        <% Map<String, String> empresa = todosDatosPeti.get("empresa"); %>
                                        <% if (empresa.containsKey("nombre") && !empresa.get("nombre").trim().isEmpty()) { %>
                                            <p><strong>Nombre:</strong> <%= empresa.get("nombre") %></p>
                                        <% } %>
                                        <% if (empresa.containsKey("sector") && !empresa.get("sector").trim().isEmpty()) { %>
                                            <p><strong>Sector:</strong> <%= empresa.get("sector") %></p>
                                        <% } %>
                                        <% if (empresa.containsKey("descripcion") && !empresa.get("descripcion").trim().isEmpty()) { %>
                                            <p><strong>Descripción:</strong> <%= empresa.get("descripcion") %></p>
                                        <% } %>
                                    </div>
                                <% } %>

                                <!-- Misión -->
                                <% if (todosDatosPeti.containsKey("mision") && !todosDatosPeti.get("mision").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-bullseye"></i> Misión Corporativa</h3>
                                        <% Map<String, String> mision = todosDatosPeti.get("mision"); %>
                                        <% if (mision.containsKey("mision") && !mision.get("mision").trim().isEmpty()) { %>
                                            <p><%= mision.get("mision") %></p>
                                        <% } %>
                                    </div>
                                <% } %>

                                <!-- Visión -->
                                <% if (todosDatosPeti.containsKey("vision") && !todosDatosPeti.get("vision").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-eye"></i> Visión Estratégica</h3>
                                        <% Map<String, String> vision = todosDatosPeti.get("vision"); %>
                                        <% if (vision.containsKey("vision") && !vision.get("vision").trim().isEmpty()) { %>
                                            <p><%= vision.get("vision") %></p>
                                        <% } %>
                                    </div>
                                <% } %>

                                <!-- Valores -->
                                <% if (todosDatosPeti.containsKey("valores") && !todosDatosPeti.get("valores").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-heart"></i> Valores Organizacionales</h3>
                                        <% Map<String, String> valores = todosDatosPeti.get("valores"); %>
                                        <% if (valores.containsKey("valores") && !valores.get("valores").trim().isEmpty()) { %>
                                            <p><%= valores.get("valores") %></p>
                                        <% } %>
                                    </div>
                                <% } %>

                                <!-- Objetivos -->
                                <% if (todosDatosPeti.containsKey("objetivos") && !todosDatosPeti.get("objetivos").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-target"></i> Objetivos Estratégicos</h3>
                                        <% Map<String, String> objetivos = todosDatosPeti.get("objetivos"); %>
                                        <% for (Map.Entry<String, String> entry : objetivos.entrySet()) { %>
                                            <% if (!entry.getValue().trim().isEmpty()) { %>
                                                <p><strong><%= entry.getKey().replace("_", " ").toUpperCase() %>:</strong> <%= entry.getValue() %></p>
                                            <% } %>
                                        <% } %>
                                    </div>
                                <% } %>

                                <!-- Análisis PEST -->
                                <% if (todosDatosPeti.containsKey("pest") && !todosDatosPeti.get("pest").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-chart-pie"></i> Análisis PEST</h3>
                                        <% Map<String, String> pest = todosDatosPeti.get("pest"); %>
                                        <% if (pest.containsKey("politico") && !pest.get("politico").trim().isEmpty()) { %>
                                            <p><strong>Político:</strong> <%= pest.get("politico") %></p>
                                        <% } %>
                                        <% if (pest.containsKey("economico") && !pest.get("economico").trim().isEmpty()) { %>
                                            <p><strong>Económico:</strong> <%= pest.get("economico") %></p>
                                        <% } %>
                                        <% if (pest.containsKey("social") && !pest.get("social").trim().isEmpty()) { %>
                                            <p><strong>Social:</strong> <%= pest.get("social") %></p>
                                        <% } %>
                                        <% if (pest.containsKey("tecnologico") && !pest.get("tecnologico").trim().isEmpty()) { %>
                                            <p><strong>Tecnológico:</strong> <%= pest.get("tecnologico") %></p>
                                        <% } %>
                                    </div>
                                <% } %>

                                <!-- Fuerzas de Porter -->
                                <% if (todosDatosPeti.containsKey("porter") && !todosDatosPeti.get("porter").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-chess"></i> Fuerzas de Porter</h3>
                                        <% Map<String, String> porter = todosDatosPeti.get("porter"); %>
                                        <% for (Map.Entry<String, String> entry : porter.entrySet()) { %>
                                            <% if (!entry.getValue().trim().isEmpty()) { %>
                                                <p><strong><%= entry.getKey().replace("_", " ").toUpperCase() %>:</strong> <%= entry.getValue() %></p>
                                            <% } %>
                                        <% } %>
                                    </div>
                                <% } %>

                                <!-- Matriz BCG -->
                                <% if (todosDatosPeti.containsKey("matriz_bcg") && !todosDatosPeti.get("matriz_bcg").isEmpty()) { %>
                                    <div class="summary-card">
                                        <h3><i class="fas fa-th"></i> Matriz BCG</h3>
                                        <% Map<String, String> bcg = todosDatosPeti.get("matriz_bcg"); %>
                                        <% for (Map.Entry<String, String> entry : bcg.entrySet()) { %>
                                            <% if (!entry.getValue().trim().isEmpty()) { %>
                                                <p><strong><%= entry.getKey().replace("_", " ").toUpperCase() %>:</strong> <%= entry.getValue() %></p>
                                            <% } %>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <div class="empty-state">
                                <i class="fas fa-file-alt"></i>
                                <h3>No hay datos disponibles</h3>
                                <p>
                                    <% if (!modoColaborativo) { %>
                                        Para generar el resumen ejecutivo, debe estar en modo colaborativo.
                                    <% } else { %>
                                        Aún no se han guardado datos en las diferentes secciones del PETI.
                                        Complete las secciones del menú para generar el resumen ejecutivo.
                                    <% } %>
                                </p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Contenido oculto para PDF -->
    <div id="pdf-content" class="pdf-content">
        <div class="pdf-header">
            <div class="pdf-title">Plan Estratégico de Tecnologías de Información</div>
            <div class="pdf-subtitle">Resumen Ejecutivo Completo</div>
            <div class="pdf-subtitle">Generado el: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %></div>
            <% if (modoColaborativo) { %>
                <div class="pdf-subtitle">Grupo: <%= grupoActual %></div>
            <% } %>
        </div>

        <% if (modoColaborativo && todosDatosPeti != null && !todosDatosPeti.isEmpty()) { %>
            <!-- Información Empresarial -->
            <% if (todosDatosPeti.containsKey("empresa") && !todosDatosPeti.get("empresa").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">1. INFORMACIÓN EMPRESARIAL</div>
                    <% Map<String, String> empresa = todosDatosPeti.get("empresa"); %>
                    <% if (empresa.containsKey("nombre") && !empresa.get("nombre").trim().isEmpty()) { %>
                        <div class="pdf-subsection">
                            <div class="pdf-subsection-title">Nombre de la Empresa</div>
                            <div class="pdf-text"><%= empresa.get("nombre") %></div>
                        </div>
                    <% } %>
                    <% if (empresa.containsKey("sector") && !empresa.get("sector").trim().isEmpty()) { %>
                        <div class="pdf-subsection">
                            <div class="pdf-subsection-title">Sector</div>
                            <div class="pdf-text"><%= empresa.get("sector") %></div>
                        </div>
                    <% } %>
                    <% if (empresa.containsKey("descripcion") && !empresa.get("descripcion").trim().isEmpty()) { %>
                        <div class="pdf-subsection">
                            <div class="pdf-subsection-title">Descripción</div>
                            <div class="pdf-text"><%= empresa.get("descripcion") %></div>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <!-- Misión -->
            <% if (todosDatosPeti.containsKey("mision") && !todosDatosPeti.get("mision").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">2. MISIÓN CORPORATIVA</div>
                    <% Map<String, String> mision = todosDatosPeti.get("mision"); %>
                    <% if (mision.containsKey("mision") && !mision.get("mision").trim().isEmpty()) { %>
                        <div class="pdf-text"><%= mision.get("mision") %></div>
                    <% } %>
                </div>
            <% } %>

            <!-- Visión -->
            <% if (todosDatosPeti.containsKey("vision") && !todosDatosPeti.get("vision").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">3. VISIÓN ESTRATÉGICA</div>
                    <% Map<String, String> vision = todosDatosPeti.get("vision"); %>
                    <% if (vision.containsKey("vision") && !vision.get("vision").trim().isEmpty()) { %>
                        <div class="pdf-text"><%= vision.get("vision") %></div>
                    <% } %>
                </div>
            <% } %>

            <!-- Valores -->
            <% if (todosDatosPeti.containsKey("valores") && !todosDatosPeti.get("valores").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">4. VALORES ORGANIZACIONALES</div>
                    <% Map<String, String> valores = todosDatosPeti.get("valores"); %>
                    <% if (valores.containsKey("valores") && !valores.get("valores").trim().isEmpty()) { %>
                        <div class="pdf-text"><%= valores.get("valores") %></div>
                    <% } %>
                </div>
            <% } %>

            <!-- Objetivos -->
            <% if (todosDatosPeti.containsKey("objetivos") && !todosDatosPeti.get("objetivos").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">5. OBJETIVOS ESTRATÉGICOS</div>
                    <% Map<String, String> objetivos = todosDatosPeti.get("objetivos"); %>
                    <% for (Map.Entry<String, String> entry : objetivos.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            <div class="pdf-subsection">
                                <div class="pdf-subsection-title"><%= entry.getKey().replace("_", " ").toUpperCase() %></div>
                                <div class="pdf-text"><%= entry.getValue() %></div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            <% } %>

            <!-- Análisis PEST -->
            <% if (todosDatosPeti.containsKey("pest") && !todosDatosPeti.get("pest").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">6. ANÁLISIS PEST</div>
                    <% Map<String, String> pest = todosDatosPeti.get("pest"); %>
                    <% if (pest.containsKey("politico") && !pest.get("politico").trim().isEmpty()) { %>
                        <div class="pdf-subsection">
                            <div class="pdf-subsection-title">Factores Políticos</div>
                            <div class="pdf-text"><%= pest.get("politico") %></div>
                        </div>
                    <% } %>
                    <% if (pest.containsKey("economico") && !pest.get("economico").trim().isEmpty()) { %>
                        <div class="pdf-subsection">
                            <div class="pdf-subsection-title">Factores Económicos</div>
                            <div class="pdf-text"><%= pest.get("economico") %></div>
                        </div>
                    <% } %>
                    <% if (pest.containsKey("social") && !pest.get("social").trim().isEmpty()) { %>
                        <div class="pdf-subsection">
                            <div class="pdf-subsection-title">Factores Sociales</div>
                            <div class="pdf-text"><%= pest.get("social") %></div>
                        </div>
                    <% } %>
                    <% if (pest.containsKey("tecnologico") && !pest.get("tecnologico").trim().isEmpty()) { %>
                        <div class="pdf-subsection">
                            <div class="pdf-subsection-title">Factores Tecnológicos</div>
                            <div class="pdf-text"><%= pest.get("tecnologico") %></div>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <!-- Fuerzas de Porter -->
            <% if (todosDatosPeti.containsKey("porter") && !todosDatosPeti.get("porter").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">7. ANÁLISIS DE LAS CINCO FUERZAS DE PORTER</div>
                    <% Map<String, String> porter = todosDatosPeti.get("porter"); %>
                    <% for (Map.Entry<String, String> entry : porter.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            <div class="pdf-subsection">
                                <div class="pdf-subsection-title"><%= entry.getKey().replace("_", " ").toUpperCase() %></div>
                                <div class="pdf-text"><%= entry.getValue() %></div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            <% } %>

            <!-- Matriz BCG -->
            <% if (todosDatosPeti.containsKey("matriz_bcg") && !todosDatosPeti.get("matriz_bcg").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">8. MATRIZ BCG</div>
                    <% Map<String, String> bcg = todosDatosPeti.get("matriz_bcg"); %>
                    <% for (Map.Entry<String, String> entry : bcg.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            <div class="pdf-subsection">
                                <div class="pdf-subsection-title"><%= entry.getKey().replace("_", " ").toUpperCase() %></div>
                                <div class="pdf-text"><%= entry.getValue() %></div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            <% } %>

            <!-- Análisis Interno -->
            <% if (todosDatosPeti.containsKey("analisis_interno") && !todosDatosPeti.get("analisis_interno").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">9. ANÁLISIS INTERNO</div>
                    <% Map<String, String> interno = todosDatosPeti.get("analisis_interno"); %>
                    <% for (Map.Entry<String, String> entry : interno.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            <div class="pdf-subsection">
                                <div class="pdf-subsection-title"><%= entry.getKey().replace("_", " ").toUpperCase() %></div>
                                <div class="pdf-text"><%= entry.getValue() %></div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            <% } %>

            <!-- Análisis Externo -->
            <% if (todosDatosPeti.containsKey("analisis_externo") && !todosDatosPeti.get("analisis_externo").isEmpty()) { %>
                <div class="pdf-section">
                    <div class="pdf-section-title">10. ANÁLISIS EXTERNO</div>
                    <% Map<String, String> externo = todosDatosPeti.get("analisis_externo"); %>
                    <% for (Map.Entry<String, String> entry : externo.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            <div class="pdf-subsection">
                                <div class="pdf-subsection-title"><%= entry.getKey().replace("_", " ").toUpperCase() %></div>
                                <div class="pdf-text"><%= entry.getValue() %></div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>

    <script>
        function generarPDF() {
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4');
            
            // Configuración del PDF
            const pageWidth = pdf.internal.pageSize.getWidth();
            const pageHeight = pdf.internal.pageSize.getHeight();
            const margin = 20;
            const lineHeight = 7;
            let yPosition = margin;
            
            // Función para agregar nueva página si es necesario
            function checkNewPage(requiredHeight = lineHeight) {
                if (yPosition + requiredHeight > pageHeight - margin) {
                    pdf.addPage();
                    yPosition = margin;
                }
            }
            
            // Función para agregar texto con salto de línea automático
            function addText(text, fontSize = 10, isBold = false, isTitle = false) {
                pdf.setFontSize(fontSize);
                pdf.setFont('helvetica', isBold ? 'bold' : 'normal');
                
                if (isTitle) {
                    checkNewPage(lineHeight * 2);
                    yPosition += lineHeight;
                }
                
                const lines = pdf.splitTextToSize(text, pageWidth - 2 * margin);
                
                for (let i = 0; i < lines.length; i++) {
                    checkNewPage();
                    pdf.text(lines[i], margin, yPosition);
                    yPosition += lineHeight;
                }
                
                if (isTitle) {
                    yPosition += lineHeight / 2;
                }
            }
            
            // Título principal
            pdf.setFillColor(26, 54, 93);
            pdf.rect(0, 0, pageWidth, 40, 'F');
            pdf.setTextColor(255, 255, 255);
            pdf.setFontSize(20);
            pdf.setFont('helvetica', 'bold');
            pdf.text('PLAN ESTRATÉGICO DE TECNOLOGÍAS DE INFORMACIÓN', pageWidth / 2, 20, { align: 'center' });
            pdf.setFontSize(14);
            pdf.text('Resumen Ejecutivo Completo', pageWidth / 2, 30, { align: 'center' });
            
            // Información del documento
            pdf.setTextColor(0, 0, 0);
            yPosition = 50;
            pdf.setFontSize(10);
            pdf.text('Generado el: ' + new Date().toLocaleDateString('es-ES'), margin, yPosition);
            yPosition += lineHeight;
            <% if (modoColaborativo) { %>
            pdf.text('Grupo: <%= grupoActual %>', margin, yPosition);
            yPosition += lineHeight * 2;
            <% } %>
            
            <% if (modoColaborativo && todosDatosPeti != null && !todosDatosPeti.isEmpty()) { %>
                // Información Empresarial
                <% if (todosDatosPeti.containsKey("empresa") && !todosDatosPeti.get("empresa").isEmpty()) { %>
                    addText('1. INFORMACIÓN EMPRESARIAL', 16, true, true);
                    <% Map<String, String> empresa = todosDatosPeti.get("empresa"); %>
                    <% if (empresa.containsKey("nombre") && !empresa.get("nombre").trim().isEmpty()) { %>
                        addText('Nombre de la Empresa', 12, true);
                        addText('<%= empresa.get("nombre").replace("'", "\\'") %>');
                        yPosition += lineHeight / 2;
                    <% } %>
                    <% if (empresa.containsKey("sector") && !empresa.get("sector").trim().isEmpty()) { %>
                        addText('Sector', 12, true);
                        addText('<%= empresa.get("sector").replace("'", "\\'") %>');
                        yPosition += lineHeight / 2;
                    <% } %>
                    <% if (empresa.containsKey("descripcion") && !empresa.get("descripcion").trim().isEmpty()) { %>
                        addText('Descripción', 12, true);
                        addText('<%= empresa.get("descripcion").replace("'", "\\'") %>');
                        yPosition += lineHeight;
                    <% } %>
                <% } %>
                
                // Misión
                <% if (todosDatosPeti.containsKey("mision") && !todosDatosPeti.get("mision").isEmpty()) { %>
                    addText('2. MISIÓN CORPORATIVA', 16, true, true);
                    <% Map<String, String> mision = todosDatosPeti.get("mision"); %>
                    <% if (mision.containsKey("mision") && !mision.get("mision").trim().isEmpty()) { %>
                        addText('<%= mision.get("mision").replace("'", "\\'") %>');
                        yPosition += lineHeight;
                    <% } %>
                <% } %>
                
                // Visión
                <% if (todosDatosPeti.containsKey("vision") && !todosDatosPeti.get("vision").isEmpty()) { %>
                    addText('3. VISIÓN ESTRATÉGICA', 16, true, true);
                    <% Map<String, String> vision = todosDatosPeti.get("vision"); %>
                    <% if (vision.containsKey("vision") && !vision.get("vision").trim().isEmpty()) { %>
                        addText('<%= vision.get("vision").replace("'", "\\'") %>');
                        yPosition += lineHeight;
                    <% } %>
                <% } %>
                
                // Valores
                <% if (todosDatosPeti.containsKey("valores") && !todosDatosPeti.get("valores").isEmpty()) { %>
                    addText('4. VALORES ORGANIZACIONALES', 16, true, true);
                    <% Map<String, String> valores = todosDatosPeti.get("valores"); %>
                    <% if (valores.containsKey("valores") && !valores.get("valores").trim().isEmpty()) { %>
                        addText('<%= valores.get("valores").replace("'", "\\'") %>');
                        yPosition += lineHeight;
                    <% } %>
                <% } %>
                
                // Objetivos
                <% if (todosDatosPeti.containsKey("objetivos") && !todosDatosPeti.get("objetivos").isEmpty()) { %>
                    addText('5. OBJETIVOS ESTRATÉGICOS', 16, true, true);
                    <% Map<String, String> objetivos = todosDatosPeti.get("objetivos"); %>
                    <% for (Map.Entry<String, String> entry : objetivos.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            addText('<%= entry.getKey().replace("_", " ").toUpperCase() %>', 12, true);
                            addText('<%= entry.getValue().replace("'", "\\'") %>');
                            yPosition += lineHeight / 2;
                        <% } %>
                    <% } %>
                <% } %>
                
                // Análisis PEST
                <% if (todosDatosPeti.containsKey("pest") && !todosDatosPeti.get("pest").isEmpty()) { %>
                    addText('6. ANÁLISIS PEST', 16, true, true);
                    <% Map<String, String> pest = todosDatosPeti.get("pest"); %>
                    <% if (pest.containsKey("politico") && !pest.get("politico").trim().isEmpty()) { %>
                        addText('Factores Políticos', 12, true);
                        addText('<%= pest.get("politico").replace("'", "\\'") %>');
                        yPosition += lineHeight / 2;
                    <% } %>
                    <% if (pest.containsKey("economico") && !pest.get("economico").trim().isEmpty()) { %>
                        addText('Factores Económicos', 12, true);
                        addText('<%= pest.get("economico").replace("'", "\\'") %>');
                        yPosition += lineHeight / 2;
                    <% } %>
                    <% if (pest.containsKey("social") && !pest.get("social").trim().isEmpty()) { %>
                        addText('Factores Sociales', 12, true);
                        addText('<%= pest.get("social").replace("'", "\\'") %>');
                        yPosition += lineHeight / 2;
                    <% } %>
                    <% if (pest.containsKey("tecnologico") && !pest.get("tecnologico").trim().isEmpty()) { %>
                        addText('Factores Tecnológicos', 12, true);
                        addText('<%= pest.get("tecnologico").replace("'", "\\'") %>');
                        yPosition += lineHeight;
                    <% } %>
                <% } %>
                
                // Fuerzas de Porter
                <% if (todosDatosPeti.containsKey("porter") && !todosDatosPeti.get("porter").isEmpty()) { %>
                    addText('7. ANÁLISIS DE LAS CINCO FUERZAS DE PORTER', 16, true, true);
                    <% Map<String, String> porter = todosDatosPeti.get("porter"); %>
                    <% for (Map.Entry<String, String> entry : porter.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            addText('<%= entry.getKey().replace("_", " ").toUpperCase() %>', 12, true);
                            addText('<%= entry.getValue().replace("'", "\\'") %>');
                            yPosition += lineHeight / 2;
                        <% } %>
                    <% } %>
                <% } %>
                
                // Matriz BCG
                <% if (todosDatosPeti.containsKey("matriz_bcg") && !todosDatosPeti.get("matriz_bcg").isEmpty()) { %>
                    addText('8. MATRIZ BCG', 16, true, true);
                    <% Map<String, String> bcg = todosDatosPeti.get("matriz_bcg"); %>
                    <% for (Map.Entry<String, String> entry : bcg.entrySet()) { %>
                        <% if (!entry.getValue().trim().isEmpty()) { %>
                            addText('<%= entry.getKey().replace("_", " ").toUpperCase() %>', 12, true);
                            addText('<%= entry.getValue().replace("'", "\\'") %>');
                            yPosition += lineHeight / 2;
                        <% } %>
                    <% } %>
                <% } %>
            <% } %>
            
            // Pie de página
            const totalPages = pdf.internal.getNumberOfPages();
            for (let i = 1; i <= totalPages; i++) {
                pdf.setPage(i);
                pdf.setFontSize(8);
                pdf.setTextColor(128, 128, 128);
                pdf.text('Página ' + i + ' de ' + totalPages, pageWidth - margin, pageHeight - 10, { align: 'right' });
                pdf.text('PETI - Plan Estratégico de Tecnologías de Información', margin, pageHeight - 10);
            }
            
            // Guardar el PDF
            const fileName = 'PETI_Resumen_Ejecutivo_' + new Date().toISOString().slice(0, 10) + '.pdf';
            pdf.save(fileName);
        }
        
        // Auto-actualización en modo colaborativo
        <% if (modoColaborativo) { %>
        let lastUpdate = new Date().getTime();
        
        function checkForUpdates() {
            fetch('api/checkUpdates.jsp?grupo=<%= grupoId %>&lastUpdate=' + lastUpdate)
                .then(response => response.json())
                .then(data => {
                    if (data.hasUpdates) {
                        showUpdateNotification();
                        lastUpdate = new Date().getTime();
                    }
                })
                .catch(error => console.log('Error checking updates:', error));
        }
        
        function showUpdateNotification() {
            const notification = document.createElement('div');
            notification.className = 'alert alert-success';
            notification.innerHTML = '<i class="fas fa-sync-alt"></i> Se han detectado actualizaciones. <a href="javascript:location.reload()" style="color: inherit; text-decoration: underline;">Actualizar página</a>';
            document.querySelector('.dashboard-main').insertBefore(notification, document.querySelector('.dashboard-main').firstChild);
            
            setTimeout(() => {
                notification.remove();
            }, 10000);
        }
        
        // Verificar actualizaciones cada 30 segundos
        setInterval(checkForUpdates, 30000);
        <% } %>
        
        // Navegación entre secciones
        function updateNavLinks() {
            const currentPage = window.location.pathname.split('/').pop();
            const navLinks = document.querySelectorAll('.dashboard-nav a');
            
            navLinks.forEach(link => {
                const linkPage = link.getAttribute('href');
                const listItem = link.parentElement;
                
                if (linkPage === currentPage) {
                    listItem.classList.add('active');
                } else {
                    listItem.classList.remove('active');
                }
                
                // Actualizar enlaces para modo colaborativo
                <% if (modoColaborativo) { %>
                if (!linkPage.includes('?')) {
                    link.href = linkPage + '?modo=colaborativo&grupo=<%= grupoActual %>';
                }
                <% } %>
            });
        }
        
        // Ejecutar al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            updateNavLinks();
        });
    </script>
</body>
</html>