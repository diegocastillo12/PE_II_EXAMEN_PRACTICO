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
    
    // Variables para los datos de la empresa
    String nombreEmpresa = "";
    String sectorEmpresa = "";
    String ubicacionEmpresa = "";
    String descripcionEmpresa = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String accion = request.getParameter("accion");
        String nuevoNombre = request.getParameter("nombre_empresa");
        String nuevoSector = request.getParameter("sector_empresa");
        String nuevaUbicacion = request.getParameter("ubicacion_empresa");
        String nuevaDescripcion = request.getParameter("descripcion_empresa");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = false;
        int exitosos = 0;
        int total = 0;
        
        try {
            // Guardar nombre de la empresa
            if (nuevoNombre != null && !nuevoNombre.trim().isEmpty()) {
                ClsEPeti datoNombre = new ClsEPeti(grupoId, "empresa", "nombre", nuevoNombre.trim(), usuarioId);
                if (negocioPeti.guardarDato(datoNombre)) {
                    exitosos++;
                }
                total++;
            }
            
            // Guardar sector de la empresa
            if (nuevoSector != null && !nuevoSector.trim().isEmpty()) {
                ClsEPeti datoSector = new ClsEPeti(grupoId, "empresa", "sector", nuevoSector.trim(), usuarioId);
                if (negocioPeti.guardarDato(datoSector)) {
                    exitosos++;
                }
                total++;
            }
            
            // Guardar ubicación de la empresa
            if (nuevaUbicacion != null && !nuevaUbicacion.trim().isEmpty()) {
                ClsEPeti datoUbicacion = new ClsEPeti(grupoId, "empresa", "ubicacion", nuevaUbicacion.trim(), usuarioId);
                if (negocioPeti.guardarDato(datoUbicacion)) {
                    exitosos++;
                }
                total++;
            }
            
            // Guardar descripción de la empresa
            if (nuevaDescripcion != null && !nuevaDescripcion.trim().isEmpty()) {
                ClsEPeti datoDescripcion = new ClsEPeti(grupoId, "empresa", "descripcion", nuevaDescripcion.trim(), usuarioId);
                if (negocioPeti.guardarDato(datoDescripcion)) {
                    exitosos++;
                }
                total++;
            }
            
            // Determinar mensaje de resultado
            if (exitosos == total && total > 0) {
                mensaje = "Información de la empresa guardada exitosamente";
                tipoMensaje = "success";
            } else if (exitosos > 0) {
                mensaje = "Se guardaron " + exitosos + " de " + total + " campos";
                tipoMensaje = "warning";
            } else {
                mensaje = "Error al guardar la información de la empresa";
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
            Map<String, String> datosEmpresa = negocioPeti.obtenerDatosSeccion(grupoId, "empresa");
            
            if (datosEmpresa.containsKey("nombre")) {
                nombreEmpresa = datosEmpresa.get("nombre");
            }
            if (datosEmpresa.containsKey("sector")) {
                sectorEmpresa = datosEmpresa.get("sector");
            }
            if (datosEmpresa.containsKey("ubicacion")) {
                ubicacionEmpresa = datosEmpresa.get("ubicacion");
            }
            if (datosEmpresa.containsKey("descripcion")) {
                descripcionEmpresa = datosEmpresa.get("descripcion");
            }
        } catch (Exception e) {
            // Error al cargar datos de empresa - se omite para evitar problemas de compilación
        }
    }
    
    // Obtener información del usuario para la interfaz
    String userEmail = usuario + "@sistema.local";
    String userInitials = usuario != null && usuario.length() > 0 ? 
        (usuario.length() > 1 ? usuario.substring(0, 2).toUpperCase() : usuario.substring(0, 1).toUpperCase()) : "U";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Información de la Empresa - PETI Colaborativo</title>
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .form-section h3 {
            color: var(--text-primary);
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
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

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.2s ease;
            background: var(--card-bg);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .form-group input[readonly],
        .form-group select[disabled],
        .form-group textarea[readonly] {
            background: #f8f9fa;
            color: var(--text-secondary);
            cursor: not-allowed;
        }

        .preview-card {
            background: rgba(26, 54, 93, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            margin-top: 24px;
        }

        .preview-card h3 {
            color: var(--text-primary);
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .preview-item {
            display: flex;
            margin-bottom: 12px;
            padding: 8px 0;
            border-bottom: 1px solid rgba(226, 232, 240, 0.5);
        }

        .preview-item:last-child {
            border-bottom: none;
        }

        .preview-item strong {
            min-width: 140px;
            color: var(--text-secondary);
            font-weight: 500;
        }

        .preview-item span {
            color: var(--text-primary);
            flex: 1;
        }

        .saved-indicator {
            color: var(--success-color);
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            margin-left: 8px;
        }

        .mode-info {
            background: rgba(49, 130, 206, 0.05);
            border: 1px solid rgba(49, 130, 206, 0.2);
            border-radius: 8px;
            padding: 16px;
            margin-top: 24px;
            color: var(--accent-color);
        }

        .save-button-container {
            margin-top: 32px;
            text-align: center;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
        }

        .save-button-container .btn-primary {
            padding: 15px 40px;
            font-size: 16px;
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
            
            .form-grid {
                grid-template-columns: 1fr;
                gap: 20px;
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
                        <li><a href="dashboard.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Planificación Estratégica</div>
                    <ul>
                        <li class="active"><a href="empresa_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-building"></i> Información Empresarial</a></li>
                        <li><a href="mision_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
                        <li><a href="vision_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
                        <li><a href="valores_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
                        <li><a href="objetivos_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Análisis Estratégico</div>
                    <ul>
                        <li><a href="analisis_externo_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
                        <li><a href="analisis_interno_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
                         <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Herramientas de Gestión</div>
                    <ul>
                        
                        <li><a href="cadena_valor_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                        <li><a href="matriz_participacion_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-users"></i> Matriz de Participación</a></li>
                        <li><a href="resumen-ejecutivo-colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
            </nav>
        </div>

        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1>
                    <i class="fas fa-building"></i> Información de la Empresa
                </h1>
                <div class="header-actions">
                    <% if (modoColaborativo) { %>
                        <span class="status-badge">
                            <i class="fas fa-users"></i>
                            Grupo: <%= grupoActual %>
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
                        <h2><i class="fas fa-building"></i> Datos de la Empresa</h2>
                    </div>
                    <div class="section-content">
                        <form method="post" action="">
                            <div class="form-grid">
                                <div>
                                    <div class="form-section">
                                        <h3><i class="fas fa-info-circle"></i> Datos Básicos</h3>
                                        
                                        <div class="form-group">
                                            <label for="nombre_empresa">
                                                Nombre de la Empresa:
                                                <% if (modoColaborativo && !nombreEmpresa.isEmpty()) { %>
                                                    <span class="saved-indicator">
                                                        <i class="fas fa-check-circle"></i> Guardado
                                                    </span>
                                                <% } %>
                                            </label>
                                            <input 
                                                type="text" 
                                                id="nombre_empresa" 
                                                name="nombre_empresa"
                                                placeholder="Ej: TechSolutions S.A.C."
                                                value="<%= nombreEmpresa %>"
                                                <%= modoColaborativo ? "" : "readonly" %>
                                            >
                                        </div>

                                        <div class="form-group">
                                            <label for="sector_empresa">
                                                Sector/Industria:
                                                <% if (modoColaborativo && !sectorEmpresa.isEmpty()) { %>
                                                    <span class="saved-indicator">
                                                        <i class="fas fa-check-circle"></i> Guardado
                                                    </span>
                                                <% } %>
                                            </label>
                                            <select 
                                                id="sector_empresa" 
                                                name="sector_empresa"
                                                <%= modoColaborativo ? "" : "disabled" %>
                                            >
                                                <option value="">Seleccione un sector</option>
                                                <option value="Tecnología" <%= "Tecnología".equals(sectorEmpresa) ? "selected" : "" %>>Tecnología</option>
                                                <option value="Servicios" <%= "Servicios".equals(sectorEmpresa) ? "selected" : "" %>>Servicios</option>
                                                <option value="Manufactura" <%= "Manufactura".equals(sectorEmpresa) ? "selected" : "" %>>Manufactura</option>
                                                <option value="Comercio" <%= "Comercio".equals(sectorEmpresa) ? "selected" : "" %>>Comercio</option>
                                                <option value="Educación" <%= "Educación".equals(sectorEmpresa) ? "selected" : "" %>>Educación</option>
                                                <option value="Salud" <%= "Salud".equals(sectorEmpresa) ? "selected" : "" %>>Salud</option>
                                                <option value="Financiero" <%= "Financiero".equals(sectorEmpresa) ? "selected" : "" %>>Financiero</option>
                                                <option value="Otros" <%= "Otros".equals(sectorEmpresa) ? "selected" : "" %>>Otros</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="ubicacion_empresa">
                                                Ubicación Principal:
                                                <% if (modoColaborativo && !ubicacionEmpresa.isEmpty()) { %>
                                                    <span class="saved-indicator">
                                                        <i class="fas fa-check-circle"></i> Guardado
                                                    </span>
                                                <% } %>
                                            </label>
                                            <input 
                                                type="text" 
                                                id="ubicacion_empresa" 
                                                name="ubicacion_empresa"
                                                placeholder="Ej: Lima, Perú"
                                                value="<%= ubicacionEmpresa %>"
                                                <%= modoColaborativo ? "" : "readonly" %>
                                            >
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <div class="form-section">
                                        <h3><i class="fas fa-file-alt"></i> Descripción</h3>
                                        
                                        <div class="form-group">
                                            <label for="descripcion_empresa">
                                                Descripción de la Empresa:
                                                <% if (modoColaborativo && !descripcionEmpresa.isEmpty()) { %>
                                                    <span class="saved-indicator">
                                                        <i class="fas fa-check-circle"></i> Guardado
                                                    </span>
                                                <% } %>
                                            </label>
                                            <textarea 
                                                id="descripcion_empresa" 
                                                name="descripcion_empresa"
                                                placeholder="Describa brevemente a qué se dedica la empresa, sus principales productos o servicios, y cualquier información relevante..."
                                                <%= modoColaborativo ? "" : "readonly" %>
                                            ><%= descripcionEmpresa %></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Vista Previa -->
                            <div class="preview-card">
                                <h3><i class="fas fa-eye"></i> Vista Previa de la Empresa</h3>
                                <div class="preview-item">
                                    <strong>Nombre:</strong>
                                    <span id="preview_nombre"><%= !nombreEmpresa.isEmpty() ? nombreEmpresa : "No especificado" %></span>
                                </div>
                                <div class="preview-item">
                                    <strong>Sector:</strong>
                                    <span id="preview_sector"><%= !sectorEmpresa.isEmpty() ? sectorEmpresa : "No especificado" %></span>
                                </div>
                                <div class="preview-item">
                                    <strong>Ubicación:</strong>
                                    <span id="preview_ubicacion"><%= !ubicacionEmpresa.isEmpty() ? ubicacionEmpresa : "No especificado" %></span>
                                </div>
                                <div class="preview-item">
                                    <strong>Descripción:</strong>
                                    <span id="preview_descripcion"><%= !descripcionEmpresa.isEmpty() ? descripcionEmpresa : "No especificado" %></span>
                                </div>
                            </div>

                            <% if (modoColaborativo) { %>
                                <div class="save-button-container">
                                    <button type="submit" class="btn-primary">
                                        <i class="fas fa-save"></i> Guardar Información de la Empresa
                                    </button>
                                </div>
                            <% } %>
                        </form>

                        <% if (modoColaborativo) { %>
                            <div class="mode-info">
                                <p>
                                    <i class="fas fa-info-circle"></i> 
                                    <strong>Modo Colaborativo Activo:</strong> Los cambios se guardan automáticamente y son visibles 
                                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                                </p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function actualizarPreviews() {
            const nombre = document.getElementById('nombre_empresa').value;
            const sector = document.getElementById('sector_empresa').value;
            const ubicacion = document.getElementById('ubicacion_empresa').value;
            const descripcion = document.getElementById('descripcion_empresa').value;
            
            document.getElementById('preview_nombre').textContent = nombre || 'No especificado';
            document.getElementById('preview_sector').textContent = sector || 'No especificado';
            document.getElementById('preview_ubicacion').textContent = ubicacion || 'No especificado';
            document.getElementById('preview_descripcion').textContent = descripcion || 'No especificado';
        }

        // Función para guardar automáticamente
        function guardarAutomatico() {
            <% if (modoColaborativo) { %>
            const formData = new FormData();
            formData.append('nombre_empresa', document.getElementById('nombre_empresa').value);
            formData.append('sector_empresa', document.getElementById('sector_empresa').value);
            formData.append('ubicacion_empresa', document.getElementById('ubicacion_empresa').value);
            formData.append('descripcion_empresa', document.getElementById('descripcion_empresa').value);
            
            fetch(window.location.href, {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                // Mostrar indicador de guardado
                mostrarIndicadorGuardado();
                // Marcar como no cambiado después de guardar
                document.querySelectorAll('input, select, textarea').forEach(element => {
                    element.dataset.changed = 'false';
                });
            })
            .catch(error => {
                console.error('Error al guardar:', error);
            });
            <% } %>
        }

        // Función para mostrar indicador de guardado
        function mostrarIndicadorGuardado() {
            // Crear o actualizar indicador de guardado
            let indicator = document.getElementById('auto-save-indicator');
            if (!indicator) {
                indicator = document.createElement('div');
                indicator.id = 'auto-save-indicator';
                indicator.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: #38a169;
                    color: white;
                    padding: 10px 15px;
                    border-radius: 5px;
                    z-index: 1000;
                    font-size: 14px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                `;
                document.body.appendChild(indicator);
            }
            
            indicator.innerHTML = '<i class="fas fa-check"></i> Guardado automáticamente';
            indicator.style.display = 'block';
            
            // Ocultar después de 3 segundos
            setTimeout(() => {
                indicator.style.display = 'none';
            }, 3000);
        }

        // Agregar listeners para actualizar preview y guardado automático
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = ['nombre_empresa', 'sector_empresa', 'ubicacion_empresa', 'descripcion_empresa'];
            inputs.forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.addEventListener('input', actualizarPreviews);
                    element.addEventListener('change', actualizarPreviews);
                    
                    <% if (modoColaborativo) { %>
                    // Guardado automático después de 2 segundos de inactividad
                    let timeoutId;
                    element.addEventListener('input', function() {
                        this.dataset.changed = 'true';
                        clearTimeout(timeoutId);
                        timeoutId = setTimeout(() => {
                            guardarAutomatico();
                        }, 2000);
                    });
                    
                    element.addEventListener('change', function() {
                        this.dataset.changed = 'true';
                        clearTimeout(timeoutId);
                        guardarAutomatico();
                    });
                    <% } %>
                }
            });
        });

        // Auto-refresh cada 30 segundos para ver cambios de otros usuarios (aumentado el tiempo)
        <% if (modoColaborativo) { %>
        setInterval(function() {
            // Solo recargar si no hay cambios sin guardar
            const inputs = document.querySelectorAll('input, select, textarea');
            let hayChanged = false;
            inputs.forEach(input => {
                if (input.dataset.changed === 'true') {
                    hayChanged = true;
                }
            });
            
            if (!hayChanged) {
                // Guardar la posición del scroll antes de recargar
                const scrollPosition = window.scrollY;
                sessionStorage.setItem('scrollPosition', scrollPosition);
                location.reload();
            }
        }, 30000); // Cambiado de 15 a 30 segundos

        // Restaurar posición del scroll después de recargar
        window.addEventListener('load', function() {
            const scrollPosition = sessionStorage.getItem('scrollPosition');
            if (scrollPosition) {
                window.scrollTo(0, parseInt(scrollPosition));
                sessionStorage.removeItem('scrollPosition');
            }
        });

        // Marcar como cambiado cuando el usuario escribe (solo para el auto-refresh)
        document.querySelectorAll('input, select, textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
            element.addEventListener('change', function() {
                this.dataset.changed = 'true';
            });
        });
        <% } %>
    </script>
</body>
</html>