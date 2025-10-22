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
    
    // Variables para los datos
    String fortalezas = "";
    String debilidades = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevasFortalezas = request.getParameter("fortalezas");
        String nuevasDebilidades = request.getParameter("debilidades");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevasFortalezas != null && !nuevasFortalezas.trim().isEmpty()) {
                ClsEPeti datoFortalezas = new ClsEPeti(grupoId, "analisis_interno", "fortalezas", nuevasFortalezas.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoFortalezas);
            }
            if (nuevasDebilidades != null && !nuevasDebilidades.trim().isEmpty()) {
                ClsEPeti datoDebilidades = new ClsEPeti(grupoId, "analisis_interno", "debilidades", nuevasDebilidades.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoDebilidades);
            }
            
            if (exito) {
                mensaje = "Análisis interno guardado exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar el análisis interno";
                tipoMensaje = "error";
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
            Map<String, String> datosAnalisis = negocioPeti.obtenerDatosSeccion(grupoId, "analisis_interno");
            
            if (datosAnalisis.containsKey("fortalezas")) {
                fortalezas = datosAnalisis.get("fortalezas");
            }
            if (datosAnalisis.containsKey("debilidades")) {
                debilidades = datosAnalisis.get("debilidades");
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
    <title>Análisis Interno - PETI Colaborativo</title>
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

        .btn-success {
            background: var(--success-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px 24px;
            font-size: 16px;
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

        /* Estilos para alertas */
        .alert {
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
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

        /* Estilos para la sección informativa */
        .info-section {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .info-header {
            text-align: center;
            margin-bottom: 24px;
        }

        .info-header h2 {
            background: #4a90a4;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 700;
            margin: 0;
            display: inline-block;
        }

        .info-content {
            color: var(--text-primary);
            line-height: 1.6;
        }

        .info-description {
            font-size: 14px;
            margin-bottom: 16px;
            text-align: justify;
        }

        .value-chain-intro {
            background: #f8f9fa;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin: 24px 0;
        }

        .value-chain-intro h3 {
            color: var(--text-primary);
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .value-chain-diagram {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin: 32px 0;
            align-items: center;
        }

        .chain-flow {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .chain-element {
            background: #4a90a4;
            color: white;
            padding: 16px 24px;
            border-radius: 50px;
            font-weight: 600;
            text-align: center;
            min-width: 160px;
        }

        .chain-arrow {
            width: 0;
            height: 0;
            border-left: 15px solid #4a90a4;
            border-top: 10px solid transparent;
            border-bottom: 10px solid transparent;
        }

        .chain-result {
            background: #4a90a4;
            color: white;
            padding: 16px 24px;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
            max-width: 300px;
            margin-top: 20px;
        }

        .activities-section {
            margin: 32px 0;
        }

        .activities-section h3 {
            color: var(--text-primary);
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #4a90a4;
        }

        .activity-icon {
            color: #4a90a4;
            font-size: 16px;
            margin-top: 2px;
            flex-shrink: 0;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .activity-description {
            font-size: 13px;
            color: var(--text-secondary);
            line-height: 1.4;
        }

        .margin-definition {
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            border-radius: 8px;
            padding: 20px;
            margin: 24px 0;
        }

        .margin-definition h4 {
            color: #1976d2;
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .value-chain-visual {
            background: #f8f9fa;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            margin: 32px 0;
            text-align: center;
        }

        .chain-structure {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .support-activities {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 16px;
        }

        .support-activity {
            background: #e3f2fd;
            color: #1976d2;
            padding: 12px 16px;
            border-radius: 6px;
            font-weight: 600;
            text-align: center;
        }

        .primary-activities {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .primary-activity {
            background: #4a90a4;
            color: white;
            padding: 12px 16px;
            border-radius: 6px;
            font-weight: 600;
            text-align: center;
            flex: 1;
            min-width: 120px;
        }

        .margin-indicator {
            background: #2c5aa0;
            color: white;
            padding: 20px;
            border-radius: 0 8px 8px 0;
            writing-mode: vertical-rl;
            text-orientation: mixed;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            position: absolute;
            right: -2px;
            top: 0;
            bottom: 0;
            width: 60px;
        }

        .chain-container {
            position: relative;
            margin-right: 60px;
        }

        .competitive-advantage {
            background: #e8f5e8;
            border: 1px solid #c8e6c9;
            border-radius: 8px;
            padding: 20px;
            margin: 24px 0;
            text-align: center;
        }

        .competitive-advantage h4 {
            color: #2e7d32;
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .autodiagnostic-note {
            background: #f0f4f8;
            border: 1px solid #cbd5e0;
            border-radius: 8px;
            padding: 16px;
            margin: 24px 0;
            font-style: italic;
            color: var(--text-secondary);
            text-align: center;
        }

        /* Estilos para el análisis práctico */
        .analysis-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 24px;
            margin-top: 32px;
        }

        .analysis-card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .analysis-card-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            background: rgba(26, 54, 93, 0.02);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .analysis-card-header h3 {
            margin: 0;
            color: var(--text-primary);
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .analysis-card.strengths .analysis-card-header h3 i {
            color: var(--success-color);
        }

        .analysis-card.weaknesses .analysis-card-header h3 i {
            color: var(--warning-color);
        }

        .status-indicator {
            font-size: 12px;
            color: var(--success-color);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .analysis-card-content {
            padding: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-weight: 600;
            font-size: 14px;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            min-height: 150px;
            resize: vertical;
            transition: border-color 0.3s ease;
            font-family: inherit;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .form-group textarea[readonly] {
            background: #f8f9fa;
            color: var(--text-secondary);
        }

        .preview-card {
            background: #f8f9fa;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            margin-top: 16px;
        }

        .preview-card h4 {
            color: var(--text-primary);
            margin-bottom: 16px;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .preview-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .preview-list li {
            background: white;
            padding: 12px 16px;
            margin-bottom: 8px;
            border-radius: 6px;
            border-left: 4px solid;
            display: flex;
            align-items: flex-start;
            gap: 8px;
            box-shadow: var(--shadow-sm);
        }

        .preview-list.strengths li {
            border-left-color: var(--success-color);
        }

        .preview-list.weaknesses li {
            border-left-color: var(--warning-color);
        }

        .preview-list li::before {
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            font-size: 14px;
            margin-top: 2px;
        }

        .preview-list.strengths li::before {
            content: "\f2f5";
            color: var(--success-color);
        }

        .preview-list.weaknesses li::before {
            content: "\f071";
            color: var(--warning-color);
        }

        .save-section {
            text-align: center;
            margin-top: 32px;
            padding: 24px;
            background: linear-gradient(135deg, rgba(49, 130, 206, 0.1), rgba(56, 161, 105, 0.1));
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        .save-section h3 {
            margin-bottom: 12px;
            font-size: 20px;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .save-section p {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
                height: auto;
                min-height: 100vh;
            }
            
            .dashboard-sidebar {
                width: 100%;
                order: 2;
                height: auto;
            }
            
            .dashboard-content {
                order: 1;
                height: auto;
            }
            
            .dashboard-main {
                padding: 20px;
            }
            
            .analysis-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .dashboard-header {
                padding: 16px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .chain-flow {
                flex-direction: column;
                align-items: center;
            }

            .chain-arrow {
                transform: rotate(90deg);
            }

            .primary-activities {
                flex-direction: column;
            }

            .chain-container {
                margin-right: 0;
            }

            .margin-indicator {
                position: static;
                writing-mode: horizontal-tb;
                text-orientation: initial;
                width: auto;
                height: 40px;
                margin-top: 16px;
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
                        <span><%= userInitials %></span>
                    </div>
                    <div class="user-info">
                        <h3><%= usuario %></h3>
                        <p><%= userEmail %></p>
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
                        <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
                        <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Análisis Estratégico</div>
                    <ul>
                        <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
                        <li class="active"><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
                 
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Herramientas de Gestión</div>
                    <ul>
                
                        <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
      
                        <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-chart-scatter"></i> Matriz de Participación</a></li>
                         <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>
                        <li><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Sistema</div>
                    <ul>
                        <li><a href="historial_cambios.jsp"><i class="fas fa-history"></i> Historial de Cambios</a></li>
                        <li><a href="../logout.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                    </ul>
                </div>
            </nav>
        </div>
        <div class="dashboard-content">
            <header class="dashboard-header">
                <h1>
                    <i class="fas fa-chart-bar"></i> Análisis Interno
                    <% if (modoColaborativo) { %>
                        - <%= grupoActual %>
                    <% } else { %>
                        - Modo Individual
                    <% } %>
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <div class="status-badge">
                            <i class="fas fa-users"></i> Modo Colaborativo
                            <% if ("admin".equals(rolUsuario)) { %>
                                <span class="admin-badge">
                                    <i class="fas fa-crown"></i> Administrador
                                </span>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="status-badge">
                            <i class="fas fa-user"></i> Modo Individual
                        </div>
                    <% } %>
                    <a href="../menuprincipal.jsp" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Menú Principal
                    </a>
                </div>
            </header>
            <main class="dashboard-main">
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

                <!-- Sección Informativa de la Cadena de Valor -->
                <div class="info-section">
                    <div class="info-header">
                        <h2><i class="fas fa-link"></i> 6. ANÁLISIS INTERNO: LA CADENA DE VALOR</h2>
                    </div>
                    
                    <div class="info-content">
                        <p class="info-description">
                            <strong>Todas las actividades de una empresa forman la cadena de valor.</strong>
                        </p>
                        
                        <div class="value-chain-intro">
                            <p>La Cadena de Valor es una herramienta que permite a la empresa identificar aquellas actividades o fases que 
                            pueden aportar un mayor valor añadido al producto final. Intenta buscar fuentes de ventaja competitiva.</p>
                            
                            <p>La empresa está formada por una secuencia de actividades diseñadas para añadir valor al producto o servicio 
                            según las distintas fases, hasta que se llega al cliente final.</p>
                            
                            <p><strong>Una cadena de valor genérica está constituida por tres elementos básicos:</strong></p>
                        </div>
                        
                        <div class="value-chain-diagram">
                            <div class="chain-flow">
                                <div class="chain-element">Actividades primarias</div>
                                <div class="chain-arrow"></div>
                                <div class="chain-result">Transformación de inputs y relación con el cliente</div>
                            </div>
                            
                            <div class="chain-flow">
                                <div class="chain-element">Actividades de apoyo</div>
                                <div class="chain-arrow"></div>
                                <div class="chain-result">Estructura de la empresa para poder desarrollar todo el proceso productivo</div>
                            </div>
                            
                            <div class="chain-flow">
                                <div class="chain-element">Margen</div>
                                <div class="chain-arrow"></div>
                                <div class="chain-result">Valor obtenido por la empresa en relación a los costes</div>
                            </div>
                        </div>
                        
                        <div class="activities-section">
                            <h3>Las Actividades Primarias son aquellas que tienen que ver con el producto/servicio, su producción, logística, comercialización, etc.</h3>
                            
                            <div class="activity-list">
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Logística de entrada</div>
                                        <div class="activity-description">(recepción, almacenamiento, manipulación de materiales, inspección interna, devoluciones, inventarios, ...)</div>
                                    </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Operaciones</div>
                                        <div class="activity-description">(proceso de fabricación, ensamblaje, mantenimiento de equipos, mecanización, embalaje, ...)</div>
                                    </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Logística de salida</div>
                                        <div class="activity-description">(gestión de pedidos, honorarios, almacenamiento de producto terminado, transporte, ...)</div>
                                    </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Marketing y ventas</div>
                                        <div class="activity-description">(comercialización, selección del canal de distribución, publicidad, promoción, política de precio, ...)</div>
                                    </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Servicios</div>
                                        <div class="activity-description">(reparaciones de productos, instalación, mantenimiento, servicios post - venta, reclamaciones, reg. del producto, ...)</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="activities-section">
                            <h3>Las Actividades de Soporte o apoyo a las actividades primarias son:</h3>
                            
                            <div class="activity-list">
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Infraestructura empresarial</div>
                                        <div class="activity-description">(administración, finanzas, contabilidad, calidad, relaciones públicas, asesoría legal, gerencia, ...)</div>
                                    </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Gestión de los recursos humanos</div>
                                        <div class="activity-description">(selección, contratación, formación, incentivos, ...)</div>
                                    </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Desarrollo tecnológico</div>
                                        <div class="activity-description">(telecomunicaciones, automatización, desarrollo de procesos e ingeniería, diseño, saber hacer, procedimientos, I+D, ...)</div>
                                    </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon">
                                        <i class="fas fa-arrow-right"></i>
                                    </div>
                                    <div class="activity-content">
                                        <div class="activity-title">Abastecimiento</div>
                                        <div class="activity-description">(compras de materias primas, consumibles, equipamientos, servicios, ...)</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="margin-definition">
                            <h4>El Margen</h4>
                            <p>es la diferencia entre el valor total obtenido y los costes incurridos por la empresa para 
                            desempeñar las actividades generadoras de valor</p>
                        </div>
                        
                        <div class="value-chain-visual">
                            <div class="chain-container">
                                <div class="chain-structure">
                                    <div class="support-activities">
                                        <div class="support-activity">INFRAESTRUCTURA DE LA EMPRESA</div>
                                        <div class="support-activity">GESTIÓN DE RECURSOS HUMANOS</div>
                                        <div class="support-activity">COMPRAS</div>
                                        <div class="support-activity">DESARROLLO DE TECNOLOGÍAS</div>
                                    </div>
                                    
                                    <div class="primary-activities">
                                        <div class="primary-activity">Logística de entrada</div>
                                        <div class="primary-activity">Operaciones</div>
                                        <div class="primary-activity">Logística de salida</div>
                                        <div class="primary-activity">Marketing y ventas</div>
                                        <div class="primary-activity">Servicios</div>
                                    </div>
                                    
                                    <div style="text-align: center; margin-top: 16px; font-weight: 600; color: var(--text-primary);">
                                        ACTIVIDADES PRIMARIAS
                                    </div>
                                </div>
                                <div class="margin-indicator">
                                    Margen
                                </div>
                            </div>
                        </div>
                        
                        <div class="competitive-advantage">
                            <h4><i class="fas fa-trophy"></i> Ventaja Competitiva</h4>
                            <p>Cada eslabón de la cadena puede ser fuente de ventaja competitiva, ya sea porque se optimice (excelencia en 
                            la ejecución de una actividad) y/o mejore su coordinación con otra actividad.</p>
                        </div>
                        
                        <div class="autodiagnostic-note">
                            <p><em>A continuación le proponemos un autodiagnóstico de la cadena de valor interna para conocer 
                            porcentualmente el potencial de mejora de la cadena de valor.</em></p>
                        </div>
                    </div>
                </div>

                <!-- Análisis Práctico -->
                <form method="post" action="">
                    <div class="analysis-grid">
                        <!-- Fortalezas -->
                        <div class="analysis-card strengths">
                            <div class="analysis-card-header">
                                <h3>
                                    <i class="fas fa-thumbs-up"></i> Fortalezas
                                </h3>
                                <% if (modoColaborativo && !fortalezas.isEmpty()) { %>
                                    <span class="status-indicator">
                                        <i class="fas fa-check-circle"></i> Guardado
                                    </span>
                                <% } %>
                            </div>
                            <div class="analysis-card-content">
                                <div class="form-group">
                                    <label for="fortalezas">
                                        Identifica las fortalezas internas de tu organización:
                                    </label>
                                    <textarea 
                                        id="fortalezas" 
                                        name="fortalezas"
                                        placeholder="Escribe cada fortaleza en una línea diferente:&#10;&#10;• Equipo altamente capacitado&#10;• Tecnología de vanguardia&#10;• Procesos optimizados&#10;• Buena reputación en el mercado&#10;• Sólida situación financiera&#10;• Cultura organizacional fuerte"
                                        <%= modoColaborativo ? "" : "readonly" %>
                                        onkeyup="actualizarPreviewFortalezas()"
                                    ><%= fortalezas %></textarea>
                                </div>

                                <div class="preview-card">
                                    <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                                    <ul class="preview-list strengths" id="previewFortalezas">
                                        <% if (!fortalezas.isEmpty()) { %>
                                            <%
                                                String[] lineasFort = fortalezas.split("\\n");
                                                for (String linea : lineasFort) {
                                                    linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                                    if (linea.length() > 0) {
                                            %>
                                            <li><%= linea %></li>
                                            <%
                                                    }
                                                }
                                            %>
                                        <% } else { %>
                                            <li>Las fortalezas aparecerán aquí mientras las escribes</li>
                                        <% } %>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Debilidades -->
                        <div class="analysis-card weaknesses">
                            <div class="analysis-card-header">
                                <h3>
                                    <i class="fas fa-exclamation-circle"></i> Debilidades
                                </h3>
                                <% if (modoColaborativo && !debilidades.isEmpty()) { %>
                                    <span class="status-indicator">
                                        <i class="fas fa-check-circle"></i> Guardado
                                    </span>
                                <% } %>
                            </div>
                            <div class="analysis-card-content">
                                <div class="form-group">
                                    <label for="debilidades">
                                        Identifica las debilidades internas de tu organización:
                                    </label>
                                    <textarea 
                                        id="debilidades" 
                                        name="debilidades"
                                        placeholder="Escribe cada debilidad en una línea diferente:&#10;&#10;• Recursos financieros limitados&#10;• Falta de personal especializado&#10;• Procesos manuales lentos&#10;• Infraestructura tecnológica obsoleta&#10;• Baja presencia en redes sociales&#10;• Dependencia de pocos clientes"
                                        <%= modoColaborativo ? "" : "readonly" %>
                                        onkeyup="actualizarPreviewDebilidades()"
                                    ><%= debilidades %></textarea>
                                </div>

                                <div class="preview-card">
                                    <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                                    <ul class="preview-list weaknesses" id="previewDebilidades">
                                        <% if (!debilidades.isEmpty()) { %>
                                            <%
                                                String[] lineasDeb = debilidades.split("\\n");
                                                for (String linea : lineasDeb) {
                                                    linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                                    if (linea.length() > 0) {
                                            %>
                                            <li><%= linea %></li>
                                            <%
                                                    }
                                                }
                                            %>
                                        <% } else { %>
                                            <li>Las debilidades aparecerán aquí mientras las escribes</li>
                                        <% } %>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (modoColaborativo) { %>
                        <div class="save-section">
                            <h3><i class="fas fa-save"></i> Guardar Análisis Interno</h3>
                            <p>Los cambios se guardarán para todo el equipo y estarán disponibles para la matriz FODA</p>
                            <button type="submit" class="btn-success">
                                <i class="fas fa-save"></i> Guardar Fortalezas y Debilidades
                            </button>
                        </div>
                    <% } %>
                </form>

                <% if (modoColaborativo) { %>
                    <div style="background: rgba(56, 161, 105, 0.05); border: 1px solid rgba(56, 161, 105, 0.2); padding: 16px; border-radius: 8px; margin-top: 24px;">
                        <p style="color: var(--success-color); margin: 0; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-info-circle"></i> 
                            <strong>Modo Colaborativo Activo:</strong> Los cambios se guardan automáticamente y son visibles 
                            para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                        </p>
                    </div>
                <% } %>
            </main>
        </div>
    </div>

    <script>
        function actualizarPreviewFortalezas() {
            const texto = document.getElementById('fortalezas').value;
            const preview = document.getElementById('previewFortalezas');
            
            if (texto.trim() === '') {
                preview.innerHTML = '<li>Las fortalezas aparecerán aquí mientras las escribes</li>';
                return;
            }
            
            const lineas = texto.split('\n');
            let html = '';
            
            lineas.forEach(linea => {
                linea = linea.trim().replace(/^[•\-\*]\s*/, '');
                if (linea.length > 0) {
                    html += '<li>' + linea + '</li>';
                }
            });
            
            if (html === '') {
                html = '<li>Las fortalezas aparecerán aquí mientras las escribes</li>';
            }
            
            preview.innerHTML = html;
        }

        function actualizarPreviewDebilidades() {
            const texto = document.getElementById('debilidades').value;
            const preview = document.getElementById('previewDebilidades');
            
            if (texto.trim() === '') {
                preview.innerHTML = '<li>Las debilidades aparecerán aquí mientras las escribes</li>';
                return;
            }
            
            const lineas = texto.split('\n');
            let html = '';
            
            lineas.forEach(linea => {
                linea = linea.trim().replace(/^[•\-\*]\s*/, '');
                if (linea.length > 0) {
                    html += '<li>' + linea + '</li>';
                }
            });
            
            if (html === '') {
                html = '<li>Las debilidades aparecerán aquí mientras las escribes</li>';
            }
            
            preview.innerHTML = html;
        }

        <% if (modoColaborativo) { %>
        // Auto-actualización para modo colaborativo
        let ultimaActualizacion = new Date().getTime();
        let cambiosLocales = false;

        // Detectar cambios locales
        document.getElementById('fortalezas').addEventListener('input', function() {
            cambiosLocales = true;
        });

        document.getElementById('debilidades').addEventListener('input', function() {
            cambiosLocales = true;
        });

        // Auto-actualizar cada 20 segundos si no hay cambios locales
        setInterval(function() {
            if (!cambiosLocales) {
                location.reload();
            }
        }, 20000);

        // Resetear flag de cambios locales después de guardar
        document.querySelector('form').addEventListener('submit', function() {
            cambiosLocales = false;
        });
        <% } %>
    </script>
</body>
</html>