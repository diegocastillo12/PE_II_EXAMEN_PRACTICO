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
    
    // Variables para la matriz BCG
    String descripcionMatriz = "";
    String productosEstrella = "";
    String productosIncognita = "";
    String productosVaca = "";
    String productosPerro = "";
    String analisisEstrategico = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevaDescripcion = request.getParameter("descripcion");
        String nuevosEstrella = request.getParameter("estrella");
        String nuevosIncognita = request.getParameter("incognita");
        String nuevosVaca = request.getParameter("vaca");
        String nuevosPerro = request.getParameter("perro");
        String nuevoAnalisis = request.getParameter("analisis");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevaDescripcion != null && !nuevaDescripcion.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_bcg", "descripcion", nuevaDescripcion.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosEstrella != null && !nuevosEstrella.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_bcg", "estrella", nuevosEstrella.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosIncognita != null && !nuevosIncognita.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_bcg", "incognita", nuevosIncognita.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosVaca != null && !nuevosVaca.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_bcg", "vaca", nuevosVaca.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosPerro != null && !nuevosPerro.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_bcg", "perro", nuevosPerro.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoAnalisis != null && !nuevoAnalisis.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_bcg", "analisis", nuevoAnalisis.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Matriz BCG guardada exitosamente";
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
            Map<String, String> datosMatriz = negocioPeti.obtenerDatosSeccion(grupoId, "matriz_bcg");
            
            descripcionMatriz = datosMatriz.getOrDefault("descripcion", "");
            productosEstrella = datosMatriz.getOrDefault("estrella", "");
            productosIncognita = datosMatriz.getOrDefault("incognita", "");
            productosVaca = datosMatriz.getOrDefault("vaca", "");
            productosPerro = datosMatriz.getOrDefault("perro", "");
            analisisEstrategico = datosMatriz.getOrDefault("analisis", "");
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
    <title>Matriz BCG - PETI Colaborativo</title>
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

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            padding: 24px;
            border: 1px solid var(--border-color);
            transition: all 0.2s ease;
            margin-bottom: 24px;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .card-header h2 {
            margin: 0;
            color: var(--text-primary);
            font-size: 18px;
            font-weight: 600;
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
            font-size: 18px;
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

        .form-section {
            margin-bottom: 32px;
        }

        .section-title {
            color: var(--text-primary);
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: var(--accent-color);
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            color: var(--text-primary);
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
        }

        .form-group textarea {
            width: 100%;
            padding: 16px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            background: var(--card-bg);
            color: var(--text-primary);
            font-size: 14px;
            min-height: 120px;
            resize: vertical;
            transition: all 0.2s ease;
            font-family: inherit;
            line-height: 1.5;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .form-group textarea::placeholder {
            color: var(--text-secondary);
        }

        .matriz-visual {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 32px;
            margin: 24px 0;
            box-shadow: var(--shadow-sm);
        }

        .matriz-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            gap: 16px;
            height: 400px;
            margin: 24px 0;
            position: relative;
        }

        .matriz-grid::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--border-color);
            transform: translateY(-50%);
        }

        .matriz-grid::after {
            content: '';
            position: absolute;
            left: 50%;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--border-color);
            transform: translateX(-50%);
        }

        .cuadrante {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            transition: all 0.2s ease;
            position: relative;
        }

        .cuadrante:hover {
            transform: scale(1.02);
            box-shadow: var(--shadow-md);
        }

        .cuadrante-estrella {
            background: rgba(52, 152, 219, 0.05);
            border-color: rgba(52, 152, 219, 0.3);
        }

        .cuadrante-incognita {
            background: rgba(46, 204, 113, 0.05);
            border-color: rgba(46, 204, 113, 0.3);
        }

        .cuadrante-vaca {
            background: rgba(155, 89, 182, 0.05);
            border-color: rgba(155, 89, 182, 0.3);
        }

        .cuadrante-perro {
            background: rgba(231, 76, 60, 0.05);
            border-color: rgba(231, 76, 60, 0.3);
        }

        .cuadrante-icon {
            font-size: 3rem;
            margin-bottom: 12px;
        }

        .cuadrante-title {
            color: var(--text-primary);
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .cuadrante-subtitle {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .axis-labels {
            position: relative;
            margin: 16px 0;
        }

        .axis-horizontal {
            text-align: center;
            color: var(--text-primary);
            font-weight: 600;
            font-size: 14px;
            margin: 12px 0;
        }

        .axis-vertical {
            position: absolute;
            left: -120px;
            top: 50%;
            transform: translateY(-50%) rotate(-90deg);
            color: var(--text-primary);
            font-weight: 600;
            font-size: 14px;
            white-space: nowrap;
        }

        .cuadrantes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 24px;
            margin: 24px 0;
        }

        .cuadrante-form {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 24px;
            border-radius: 12px;
            transition: all 0.2s ease;
            box-shadow: var(--shadow-sm);
        }

        .cuadrante-form:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .cuadrante-form.estrella {
            border-left: 4px solid #3498db;
        }

        .cuadrante-form.incognita {
            border-left: 4px solid #2ecc71;
        }

        .cuadrante-form.vaca {
            border-left: 4px solid #9b59b6;
        }

        .cuadrante-form.perro {
            border-left: 4px solid #e74c3c;
        }

        .cuadrante-form-title {
            color: var(--text-primary);
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .caracteristicas-table {
            width: 100%;
            border-collapse: collapse;
            margin: 24px 0;
            background: var(--card-bg);
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
        }

        .caracteristicas-table th,
        .caracteristicas-table td {
            padding: 12px 16px;
            text-align: center;
            border: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .caracteristicas-table th {
            background: var(--primary-color);
            color: white;
            font-weight: 600;
        }

        .caracteristicas-table .caracteristica {
            background: rgba(26, 54, 93, 0.05);
            font-weight: 600;
            text-align: left;
        }

        .caracteristicas-table .decision {
            background: var(--primary-color);
            color: white;
            font-weight: 700;
        }

        .btn-save {
            background: var(--success-color);
            color: white;
            border: none;
            padding: 16px 24px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-save:hover {
            background: #2f855a;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
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
            
            .cuadrantes-grid {
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
                  
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Herramientas de Gestión</div>
                    <ul>
              
                        <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
      
                        <li class="active"><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz de Participación</a></li>
                         <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>
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
            <header class="dashboard-header">
                <h1>Análisis Interno: Matriz de Crecimiento - Participación BCG</h1>
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
                    <% } %>
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
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        Error: Debes estar en un grupo para acceder a esta página.
                    </div>
                <% } else { %>

                <div class="card">
                    <div class="card-header">
                        <h2>Descripción de la Matriz BCG</h2>
                    </div>
                    <p style="color: var(--text-secondary); margin-bottom: 24px;">
                        Toda empresa debe analizar de forma periódica su cartera de productos y servicios. 
                        La <strong>Matriz de crecimiento - participación</strong>, conocida como Matriz BCG, es un método gráfico de 
                        análisis de cartera de negocios desarrollado por The Boston Consulting Group en la década de 1970.
                    </p>

                    <form method="post" action="">
                        <div class="form-section">
                            <div class="form-group">
                                <label for="descripcion">Descripción del análisis de cartera de productos/servicios:</label>
                                <textarea id="descripcion" name="descripcion" 
                                          placeholder="Describe el propósito del análisis, los productos/servicios a evaluar y la metodología utilizada..."
                                          ><%= descripcionMatriz %></textarea>
                            </div>
                        </div>

                        <div class="matriz-visual">
                            <h3 style="color: var(--text-primary); text-align: center; font-size: 20px; margin-bottom: 24px; font-weight: 700;">
                                Matriz de Crecimiento - Participación BCG
                            </h3>
                            
                            <div class="axis-labels">
                                <div class="axis-vertical">(+) CRECIMIENTO (-)</div>
                                <div class="matriz-grid">
                                    <div class="cuadrante cuadrante-incognita">
                                        <div class="cuadrante-icon">❓</div>
                                        <div class="cuadrante-title">INCÓGNITA</div>
                                        <div class="cuadrante-subtitle">Alto crecimiento<br>Baja participación</div>
                                    </div>
                                    <div class="cuadrante cuadrante-estrella">
                                        <div class="cuadrante-icon">⭐</div>
                                        <div class="cuadrante-title">ESTRELLA</div>
                                        <div class="cuadrante-subtitle">Alto crecimiento<br>Alta participación</div>
                                    </div>
                                    <div class="cuadrante cuadrante-perro">
                                        <div class="cuadrante-icon">🐕</div>
                                        <div class="cuadrante-title">PERRO</div>
                                        <div class="cuadrante-subtitle">Bajo crecimiento<br>Baja participación</div>
                                    </div>
                                    <div class="cuadrante cuadrante-vaca">
                                        <div class="cuadrante-icon">🐄</div>
                                        <div class="cuadrante-title">VACA</div>
                                        <div class="cuadrante-subtitle">Bajo crecimiento<br>Alta participación</div>
                                    </div>
                                </div>
                                <div class="axis-horizontal">(-) PARTICIPACIÓN RELATIVA EN EL MERCADO (+)</div>
                            </div>
                            
                            <p style="color: var(--text-secondary); text-align: center; font-style: italic; margin-top: 16px;">
                                El eje vertical de la matriz define el crecimiento en el mercado, y el horizontal la cuota de mercado.
                            </p>
                        </div>

                        <div class="cuadrantes-grid">
                            <div class="cuadrante-form estrella">
                                <h3 class="cuadrante-form-title">
                                    ⭐ Productos/Servicios ESTRELLA
                                </h3>
                                <div class="form-group">
                                    <textarea id="estrella" name="estrella" 
                                              placeholder="Lista los productos/servicios con alta cuota de mercado y alto crecimiento. Describe sus características y estrategias..."
                                              ><%= productosEstrella %></textarea>
                                </div>
                            </div>

                            <div class="cuadrante-form incognita">
                                <h3 class="cuadrante-form-title">
                                    ❓ Productos/Servicios INCÓGNITA
                                </h3>
                                <div class="form-group">
                                    <textarea id="incognita" name="incognita" 
                                              placeholder="Lista los productos/servicios con baja cuota de mercado pero alto crecimiento. Analiza su potencial..."
                                              ><%= productosIncognita %></textarea>
                                </div>
                            </div>

                            <div class="cuadrante-form vaca">
                                <h3 class="cuadrante-form-title">
                                    🐄 Productos/Servicios VACA
                                </h3>
                                <div class="form-group">
                                    <textarea id="vaca" name="vaca" 
                                              placeholder="Lista los productos/servicios con alta cuota de mercado pero bajo crecimiento. Describe cómo mantener su rentabilidad..."
                                              ><%= productosVaca %></textarea>
                                </div>
                            </div>

                            <div class="cuadrante-form perro">
                                <h3 class="cuadrante-form-title">
                                    🐕 Productos/Servicios PERRO
                                </h3>
                                <div class="form-group">
                                    <textarea id="perro" name="perro" 
                                              placeholder="Lista los productos/servicios con baja cuota de mercado y bajo crecimiento. Evalúa estrategias de desinversión..."
                                              ><%= productosPerro %></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h2 class="section-title">
                                <i class="fas fa-table"></i>
                                Cuadro Resumen de las Principales Características
                            </h2>
                            
                            <table class="caracteristicas-table">
                                <thead>
                                    <tr>
                                        <th>Características</th>
                                        <th>Estrella</th>
                                        <th>Incógnita</th>
                                        <th>Vaca</th>
                                        <th>Perro</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="caracteristica">Cuota de mercado</td>
                                        <td>alta</td>
                                        <td>baja</td>
                                        <td>alta</td>
                                        <td>baja</td>
                                    </tr>
                                    <tr>
                                        <td class="caracteristica">Crecimiento del mercado</td>
                                        <td>alto</td>
                                        <td>alto</td>
                                        <td>bajo</td>
                                        <td>bajo</td>
                                    </tr>
                                    <tr>
                                        <td class="caracteristica">Estrategia en función participación en mercado</td>
                                        <td>crecer o mantenerse</td>
                                        <td>crecer</td>
                                        <td>mantenerse</td>
                                        <td>cosechar o desinvertir</td>
                                    </tr>
                                    <tr>
                                        <td class="caracteristica">Inversión requerida</td>
                                        <td>alta</td>
                                        <td>muy alta</td>
                                        <td>baja</td>
                                        <td>baja, desinvertir</td>
                                    </tr>
                                    <tr>
                                        <td class="caracteristica">Rentabilidad</td>
                                        <td>alta</td>
                                        <td>baja o negativa</td>
                                        <td>alta</td>
                                        <td>muy baja, negativa</td>
                                    </tr>
                                    <tr>
                                        <td class="decision">DECISIÓN ESTRATÉGICA</td>
                                        <td class="decision">POTENCIAR</td>
                                        <td class="decision">EVALUAR</td>
                                        <td class="decision">MANTENER</td>
                                        <td class="decision">REESTRUCTURAR O DESINVERTIR</td>
                                    </tr>
                                </tbody>
                            </table>
                            
                            <p style="color: var(--text-secondary); margin-top: 16px; font-style: italic; text-align: center;">
                                La situación idónea es tener un cartera equilibrada, es decir, productos y/o servicios con diferentes 
                                índices de crecimiento y diferentes cuotas o niveles de participación en el mercado.
                            </p>
                        </div>

                        <div class="form-section">
                            <h2 class="section-title">
                                <i class="fas fa-chart-line"></i>
                                Análisis Estratégico y Conclusiones
                            </h2>
                            <div class="form-group">
                                <label for="analisis">Análisis estratégico de la cartera de productos/servicios:</label>
                                <textarea id="analisis" name="analisis" 
                                          placeholder="Realiza un análisis integral de tu cartera. ¿Está equilibrada? ¿Qué decisiones estratégicas recomiendas? ¿Cómo optimizar la asignación de recursos?"
                                          style="min-height: 150px;"
                                          ><%= analisisEstrategico %></textarea>
                            </div>
                        </div>

                        <button type="submit" class="btn-save">
                            <i class="fas fa-save"></i> Guardar Matriz BCG
                        </button>
                    </form>
                </div>

                <% } %>
            </main>
        </div>
    </div>

    <script>
        function logout() {
            if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
                window.location.href = '../logout.jsp';
            }
        }

        // Función para navegar entre secciones
        function navigateToSection(section) {
            <% if (modoColaborativo) { %>
                window.location.href = section + '.jsp?modo=colaborativo&grupo=<%= grupoActual %>&rol=<%= rolUsuario %>';
            <% } else { %>
                window.location.href = section + '.jsp?modo=individual';
            <% } %>
        }
        
        // Actualizar enlaces de navegación
        document.addEventListener('DOMContentLoaded', function() {
            const navLinks = document.querySelectorAll('.dashboard-nav a[href$=".jsp"]');
            navLinks.forEach(link => {
                const originalHref = link.getAttribute('href');
                <% if (modoColaborativo) { %>
                    if (!originalHref.includes('?')) {
                        link.setAttribute('href', originalHref + '?modo=colaborativo&grupo=<%= grupoActual %>&rol=<%= rolUsuario %>');
                    }
                <% } else { %>
                    if (!originalHref.includes('?')) {
                        link.setAttribute('href', originalHref + '?modo=individual');
                    }
                <% } %>
            });
        });
    </script>
</body>
</html>