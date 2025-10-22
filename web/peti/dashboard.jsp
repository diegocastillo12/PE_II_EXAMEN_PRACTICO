<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="negocio.ClsNPeti, negocio.ClsNGrupo" %>
<%@ page import="entidad.ClsELogin" %>
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
    // Si hay un grupo activo en la sesión, automáticamente es modo colaborativo
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
    
    // Obtener datos del PETI si está en modo colaborativo
    Map<String, Map<String, String>> datosPeti = null;
    List<Map<String, Object>> historialCambios = null;
    int progreso = 0;
    int totalSecciones = 0;
    int seccionesCompletadas = 0;
    int miembrosActivos = 0;
    int cambiosHoy = 0;
    int cambiosSemana = 0;
    String seccionMasEditada = "Ninguna";
    String usuarioMasActivo = "Ninguno";
    
    if (modoColaborativo && grupoId != null) {
        ClsNPeti negocioPeti = new ClsNPeti();
        ClsNGrupo negocioGrupo = new ClsNGrupo();
        
        datosPeti = negocioPeti.obtenerTodosDatos(grupoId);
        historialCambios = negocioPeti.obtenerHistorial(grupoId, 10);
        progreso = negocioPeti.obtenerProgreso(grupoId);
        
        // Calcular estadísticas adicionales
        totalSecciones = 9; // Empresa, Misión, Visión, Valores, Objetivos, Análisis Externo/Interno, Cadena Valor, BCG
        
        // Contar solo las 9 secciones principales del PETI (sin estrategias)
        seccionesCompletadas = 0;
        if (datosPeti != null) {
            String[] seccionesPrincipales = {"empresa", "mision", "vision", "valores", "objetivos", 
                                            "analisis_externo", "analisis_interno", 
                                            "cadena_valor", "bcg"};
            for (String seccion : seccionesPrincipales) {
                if (datosPeti.containsKey(seccion) && !datosPeti.get(seccion).isEmpty()) {
                    seccionesCompletadas++;
                }
            }
        }
        
        // Obtener miembros activos del grupo
        try {
            List<ClsELogin> miembros = negocioGrupo.obtenerMiembrosGrupo(grupoId);
            miembrosActivos = miembros != null ? miembros.size() : 0;
        } catch (Exception e) {
            miembrosActivos = 0;
        }
        
        // Calcular cambios de hoy
        if (historialCambios != null) {
            java.util.Calendar hoy = java.util.Calendar.getInstance();
            hoy.set(java.util.Calendar.HOUR_OF_DAY, 0);
            hoy.set(java.util.Calendar.MINUTE, 0);
            hoy.set(java.util.Calendar.SECOND, 0);
            
            java.util.Calendar semanaAtras = java.util.Calendar.getInstance();
            semanaAtras.add(java.util.Calendar.DAY_OF_YEAR, -7);
            
            for (Map<String, Object> cambio : historialCambios) {
                java.sql.Timestamp fecha = (java.sql.Timestamp) cambio.get("fecha_cambio");
                if (fecha.after(hoy.getTime())) {
                    cambiosHoy++;
                }
                if (fecha.after(semanaAtras.getTime())) {
                    cambiosSemana++;
                }
            }
        }
        
        // Obtener sección más editada y usuario más activo
        try {
            java.util.Map<String, Integer> seccionesCount = new java.util.HashMap<>();
            java.util.Map<String, Integer> usuariosCount = new java.util.HashMap<>();
            
            if (historialCambios != null) {
                for (Map<String, Object> cambio : historialCambios) {
                    String seccion = (String) cambio.get("seccion");
                    String usuarioCambio = (String) cambio.get("usuario");
                    
                    seccionesCount.put(seccion, seccionesCount.getOrDefault(seccion, 0) + 1);
                    usuariosCount.put(usuarioCambio, usuariosCount.getOrDefault(usuarioCambio, 0) + 1);
                }
                
                // Encontrar la sección más editada
                int maxSeccion = 0;
                for (java.util.Map.Entry<String, Integer> entry : seccionesCount.entrySet()) {
                    if (entry.getValue() > maxSeccion) {
                        maxSeccion = entry.getValue();
                        seccionMasEditada = entry.getKey();
                    }
                }
                
                // Encontrar el usuario más activo
                int maxUsuario = 0;
                for (java.util.Map.Entry<String, Integer> entry : usuariosCount.entrySet()) {
                    if (entry.getValue() > maxUsuario) {
                        maxUsuario = entry.getValue();
                        usuarioMasActivo = entry.getKey();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
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

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            padding: 24px;
            border: 1px solid var(--border-color);
            transition: all 0.2s ease;
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

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--accent-color), #2c5282);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 20px;
        }

        .card-content {
            flex: 1;
        }

        .card-content h3 {
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 8px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .card-value {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            line-height: 1.2;
        }

        .card-trend {
            display: flex;
            align-items: center;
            margin-top: 8px;
            font-size: 12px;
        }

        .trend-up {
            color: var(--success-color);
        }

        .trend-down {
            color: var(--danger-color);
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

        .progress-container {
            margin-bottom: 24px;
        }

        .progress-bar {
            background: #e2e8f0;
            border-radius: 8px;
            height: 12px;
            overflow: hidden;
            margin-bottom: 16px;
        }

        .progress-fill {
            background: linear-gradient(90deg, var(--accent-color), var(--success-color));
            height: 100%;
            transition: width 0.3s ease;
            border-radius: 8px;
        }

        .progress-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .progress-item {
            text-align: center;
            padding: 16px;
            background: rgba(26, 54, 93, 0.02);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }

        .progress-item strong {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-primary);
        }

        .status-completed {
            color: var(--success-color);
            font-weight: 500;
        }

        .status-pending {
            color: var(--danger-color);
            font-weight: 500;
        }

        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 20px;
            border: 1px solid #ecf0f1;
            border-radius: 12px;
            margin-bottom: 15px;
            background: white;
            transition: all 0.3s ease;
            position: relative;
        }

        .activity-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .activity-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 16px;
            flex-shrink: 0;
        }

        .activity-icon {
            position: absolute;
            top: 15px;
            right: 20px;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .activity-content {
            flex: 1;
            min-width: 0;
        }

        .activity-header {
            margin-bottom: 8px;
            line-height: 1.5;
            color: #34495e;
        }

        .activity-action {
            color: #7f8c8d;
            margin: 0 5px;
        }

        .activity-preview {
            background: #f8f9fa;
            border-left: 4px solid #3498db;
            padding: 10px 15px;
            margin: 10px 0;
            border-radius: 0 6px 6px 0;
            font-size: 14px;
            color: #2c3e50;
            line-height: 1.4;
        }

        .activity-time {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #95a5a6;
            font-size: 13px;
            margin-top: 8px;
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

        /* Estilos para Progress Container */
        .progress-container {
            margin: 8px 0;
        }

        .progress-container .progress-fill {
            background: linear-gradient(90deg, var(--accent-color), var(--success-color));
            height: 6px;
            border-radius: 3px;
            transition: width 0.5s ease;
        }

        /* Mejoras visuales para las tarjetas de estadísticas */
        .card small {
            display: block;
            margin-top: 8px;
            font-size: 0.85em;
            color: #64748b;
        }

        /* Estilos para los gráficos */
        canvas {
            display: block;
            box-sizing: border-box;
        }

        /* Animación para las tarjetas */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            animation: fadeInUp 0.5s ease-out;
        }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }
        .card:nth-child(4) { animation-delay: 0.4s; }
        .card:nth-child(5) { animation-delay: 0.5s; }
        .card:nth-child(6) { animation-delay: 0.6s; }
        .card:nth-child(7) { animation-delay: 0.7s; }
        .card:nth-child(8) { animation-delay: 0.8s; }

        /* Responsive para las tarjetas */
        @media (max-width: 1200px) {
            .dashboard-cards {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
        }

        @media (max-width: 900px) {
            .dashboard-cards {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
    .dashboard-cards {
        grid-template-columns: 1fr;
        opacity: 0.5;
    }
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
            
            .dashboard-cards {
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
                        <li class="active"><a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
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
                        <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz de Participación</a></li>
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
                <h1>
                    <% if (modoColaborativo) { %>
                        Panel de Control PETI - <%= grupoActual %>
                    <% } else { %>
                        Panel de Control PETI - Modo Individual
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
                        <button class="btn-primary" onclick="verHistorial()">
                            <i class="fas fa-history"></i> Historial de Cambios
                        </button>
                    <% } else { %>
                        <button class="btn-primary" onclick="window.location.href='../menuprincipal.jsp'">
                            <i class="fas fa-users"></i> Gestión de Equipos
                        </button>
                    <% } %>
                </div>
            </header>
            <main class="dashboard-main">
                <% if (modoColaborativo) { %>
                    <!-- Modo Colaborativo -->
                    <div class="dashboard-cards">
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-percentage"></i></div>
                            <div class="card-content">
                                <h3>Progreso PETI</h3>
                                <p class="card-value"><%= Math.min(progreso, 100) %>%</p>
                                <div class="progress-container">
                                    <div class="progress-fill" style="width: <%= Math.min(progreso, 100) %>%;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-users"></i></div>
                            <div class="card-content">
                                <h3>Miembros Activos</h3>
                                <p class="card-value"><%= miembrosActivos %></p>
                                <small style="color: #64748b; font-size: 0.85em;">Colaboradores del equipo</small>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-edit"></i></div>
                            <div class="card-content">
                                <h3>Cambios Hoy</h3>
                                <p class="card-value"><%= cambiosHoy %></p>
                                <small style="color: #64748b; font-size: 0.85em;">Última hora: <%= historialCambios != null && !historialCambios.isEmpty() ? new java.text.SimpleDateFormat("HH:mm").format(historialCambios.get(0).get("fecha_cambio")) : "--:--" %></small>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-calendar-week"></i></div>
                            <div class="card-content">
                                <h3>Cambios Esta Semana</h3>
                                <p class="card-value"><%= cambiosSemana %></p>
                                <small style="color: #64748b; font-size: 0.85em;">Últimos 7 días</small>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-check-circle"></i></div>
                            <div class="card-content">
                                <h3>Secciones Completadas</h3>
                                <p class="card-value"><%= seccionesCompletadas %> / <%= totalSecciones %></p>
                                <div class="progress-container" style="margin-top: 8px;">
                                    <div class="progress-fill" style="width: <%= Math.min((seccionesCompletadas * 100 / totalSecciones), 100) %>%;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-fire"></i></div>
                            <div class="card-content">
                                <h3>Sección Más Editada</h3>
                                <p class="card-value" style="font-size: 1.2em;"><%= seccionMasEditada %></p>
                                <small style="color: #64748b; font-size: 0.85em;">Mayor actividad del equipo</small>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-star"></i></div>
                            <div class="card-content">
                                <h3>Usuario Más Activo</h3>
                                <p class="card-value" style="font-size: 1.2em;"><%= usuarioMasActivo %></p>
                                <small style="color: #64748b; font-size: 0.85em;">Mayor contribución</small>
                            </div>
                        </div>
                    </div>

                    <!-- Gráficos y Estadísticas Visuales -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 24px; margin-top: 24px;">
                        <!-- Gráfico de Progreso por Sección -->
                        <div class="card" style="padding: 24px;">
                            <h3 style="margin-bottom: 20px; color: #1e293b; font-size: 1.1em;">
                                <i class="fas fa-chart-pie"></i> Progreso por Sección
                            </h3>
                            <canvas id="seccionesChart" style="max-height: 300px;"></canvas>
                        </div>

                        <!-- Gráfico de Actividad Semanal -->
                        <div class="card" style="padding: 24px;">
                            <h3 style="margin-bottom: 20px; color: #1e293b; font-size: 1.1em;">
                                <i class="fas fa-chart-line"></i> Actividad de la Semana
                            </h3>
                            <canvas id="actividadChart" style="max-height: 300px;"></canvas>
                        </div>
                    </div>

                    <!-- Actividad Reciente Mejorada -->
                    <div class="dashboard-section" style="margin-top: 24px;">
                        <div class="section-header">
                            <h2><i class="fas fa-tasks"></i> Progreso por Sección</h2>
                        </div>
                        <div class="section-content">
                        <div class="progress-stats">
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-building"></i> Información Empresarial</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("empresa")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("empresa")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-bullseye"></i> Misión</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("mision")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("mision")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-eye"></i> Visión</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("vision")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("vision")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-heart"></i> Valores</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("valores")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("valores")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-target"></i> Objetivos</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("objetivos")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("objetivos")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-search"></i> Análisis Externo</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("analisis_externo")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("analisis_externo")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-chart-bar"></i> Análisis Interno</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("analisis_interno")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("analisis_interno")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px; border-bottom: 1px solid #e2e8f0;">
                                <strong><i class="fas fa-link"></i> Cadena de Valor</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("cadena_valor")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("cadena_valor")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                            <div class="progress-item" style="padding: 12px;">
                                <strong><i class="fas fa-chart-pie"></i> Autodiagnóstico BCG</strong>
                                <span class="<%= (datosPeti != null && datosPeti.containsKey("bcg")) ? "status-completed" : "status-pending" %>">
                                    <%= (datosPeti != null && datosPeti.containsKey("bcg")) ? "✓ Completado" : "✗ Pendiente" %>
                                </span>
                            </div>
                        </div>
                    </div>
                    </div>
                    
                    <!-- Actividad Reciente del Grupo -->
                    <div class="dashboard-section" style="margin-top: 24px;">
                        <div class="section-header">
                            <h2><i class="fas fa-history"></i> Actividad Reciente del Grupo</h2>
                            <button class="btn-secondary" onclick="verHistorial()" style="font-size: 14px; padding: 8px 16px;">
                                <i class="fas fa-clock"></i> Ver Historial Completo
                            </button>
                        </div>
                        <div class="section-content">
                        <div class="activity-list">
                            <% if (historialCambios != null && !historialCambios.isEmpty()) { %>
                                <% 
                                    SimpleDateFormat sdfReciente = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    int maxItems = Math.min(historialCambios.size(), 15);
                                    for (int i = 0; i < maxItems; i++) { 
                                        Map<String, Object> cambio = historialCambios.get(i);
                                        String usuarioCambio = (String) cambio.get("usuario");
                                        String iniciales = usuarioCambio.length() >= 2 ? 
                                            usuarioCambio.substring(0,2).toUpperCase() : 
                                            usuarioCambio.substring(0,1).toUpperCase();
                                %>
                                    <div class="activity-item">
                                        <div class="activity-avatar">
                                            <span><%= iniciales %></span>
                                        </div>
                                        <div class="activity-icon">
                                            <% 
                                                String accion = (String) cambio.get("accion");
                                                if ("crear".equals(accion)) {
                                            %>
                                                <i class="fas fa-plus" style="color: #27ae60;"></i>
                                            <% } else if ("modificar".equals(accion)) { %>
                                                <i class="fas fa-edit" style="color: #f39c12;"></i>
                                            <% } else { %>
                                                <i class="fas fa-trash" style="color: #e74c3c;"></i>
                                            <% } %>
                                        </div>
                                        <div class="activity-content">
                                            <div class="activity-header">
                                                <strong style="color: #2c3e50;"><%= usuarioCambio %></strong>
                                                <span class="activity-action">
                                                    <%= "crear".equals(accion) ? "creó" : ("modificar".equals(accion) ? "modificó" : "eliminó") %>
                                                </span>
                                                <strong style="color: #3498db;"><%= cambio.get("campo") %></strong>
                                                <span>en</span>
                                                <strong style="color: #8e44ad;"><%= ((String)cambio.get("seccion")).replace("_", " ") %></strong>
                                            </div>
                                            <% if (cambio.get("valor_nuevo") != null && !"eliminar".equals(accion)) { %>
                                                <div class="activity-preview">
                                                    <%= ((String)cambio.get("valor_nuevo")).length() > 80 ? 
                                                        ((String)cambio.get("valor_nuevo")).substring(0, 80) + "..." : 
                                                        cambio.get("valor_nuevo") %>
                                                </div>
                                            <% } %>
                                            <div class="activity-time">
                                                <i class="fas fa-clock"></i>
                                                <%= sdfReciente.format(cambio.get("fecha_cambio")) %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <div class="empty-state">
                                    <i class="fas fa-history"></i>
                                    <p>No hay actividad reciente en el grupo</p>
                                    <p style="font-size: 14px;">¡Comienza editando las secciones del PETI!</p>
                                </div>
                            <% } %>
                        </div>
                        </div>
                    </div>
                <% } else { %>
                    <!-- Modo Individual -->
                    <div class="dashboard-cards">
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-user"></i></div>
                            <div class="card-content">
                                <h3>Modo</h3>
                                <p class="card-value" style="font-size: 16px;">Individual</p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-file-alt"></i></div>
                            <div class="card-content">
                                <h3>Secciones</h3>
                                <p class="card-value">9</p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-clock"></i></div>
                            <div class="card-content">
                                <h3>Tiempo Estimado</h3>
                                <p class="card-value" style="font-size: 16px;">2-3 horas</p>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-icon"><i class="fas fa-info-circle"></i></div>
                            <div class="card-content">
                                <h3>Estado</h3>
                                <p class="card-value" style="font-size: 16px;">Solo lectura</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2>Información del Modo Individual</h2>
                        </div>
                        <div class="section-content">
                        <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 20px; margin-bottom: 20px;">
                            <h4 style="color: #856404; margin: 0 0 10px 0;">
                                <i class="fas fa-exclamation-triangle"></i> Limitaciones del Modo Individual
                            </h4>
                            <ul style="color: #856404; margin: 0; padding-left: 20px;">
                                <li>No puedes guardar cambios permanentes</li>
                                <li>No hay colaboración en tiempo real</li>
                                <li>Los datos no se sincronizan</li>
                                <li>Solo puedes explorar las funcionalidades</li>
                            </ul>
                        </div>
                        
                        <div style="background: #d1ecf1; border: 1px solid #bee5eb; border-radius: 8px; padding: 20px;">
                            <h4 style="color: #0c5460; margin: 0 0 10px 0;">
                                <i class="fas fa-lightbulb"></i> ¿Quieres trabajar colaborativamente?
                            </h4>
                            <p style="color: #0c5460; margin: 0 0 15px 0;">
                                Únete a un grupo o crea uno nuevo para trabajar en equipo y guardar el progreso del PETI.
                            </p>
                            <button class="btn-primary" onclick="window.location.href='../menuprincipal.jsp'">
                                <i class="fas fa-users"></i> Ir al Menú Principal
                            </button>
                        </div>
                    </div>
                    
                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2>Secciones del PETI</h2>
                        </div>
                        <div class="section-content">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #667eea;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">📊 Análisis Estratégico</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">FODA, PEST, Porter, Matriz CAME</p>
                            </div>
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #28a745;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">🎯 Definición Organizacional</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">Misión, Visión, Valores, Objetivos</p>
                            </div>
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #ffc107;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">⚡ Estrategias de TI</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">Identificación y Planificación</p>
                            </div>
                            <div style="padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-left: 4px solid #17a2b8;">
                                <h4 style="margin: 0 0 10px 0; color: #333;">📄 Documentación</h4>
                                <p style="margin: 0; color: #666; font-size: 14px;">Resumen Ejecutivo y Reportes</p>
                            </div>
                        </div>
                    </div>
                <% } %>
            </main>
        </div>
    </div>
    
    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <script>
        <% if (modoColaborativo && datosPeti != null) { %>
        // Datos para el gráfico de secciones completadas (9 secciones, sin estrategias)
        const seccionesData = {
            labels: ['Empresa', 'Misión', 'Visión', 'Valores', 'Objetivos', 'Análisis Externo', 'Análisis Interno', 'Cadena Valor', 'BCG'],
            datasets: [{
                label: 'Progreso',
                data: [
                    <%= datosPeti.containsKey("empresa") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("mision") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("vision") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("valores") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("objetivos") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("analisis_externo") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("analisis_interno") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("cadena_valor") ? 100 : 0 %>,
                    <%= datosPeti.containsKey("bcg") ? 100 : 0 %>
                ],
                backgroundColor: [
                    '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6',
                    '#EC4899', '#14B8A6', '#06B6D4', '#84CC16'
                ],
                borderWidth: 0
            }]
        };

        // Crear gráfico de barras para secciones
        const ctxSecciones = document.getElementById('seccionesChart');
        if (ctxSecciones) {
            new Chart(ctxSecciones, {
                type: 'bar',
                data: seccionesData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.parsed.y === 100 ? 'Completado' : 'Pendiente';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                callback: function(value) {
                                    return value + '%';
                                }
                            }
                        },
                        x: {
                            ticks: {
                                font: {
                                    size: 10
                                },
                                maxRotation: 45,
                                minRotation: 45
                            }
                        }
                    }
                }
            });
        }

        // Datos para el gráfico de actividad semanal
        <% 
        // Calcular cambios por día de la semana
        java.util.Map<String, Integer> cambiosPorDia = new java.util.LinkedHashMap<>();
        java.util.Calendar cal = java.util.Calendar.getInstance();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEE");
        
        // Inicializar últimos 7 días
        for (int i = 6; i >= 0; i--) {
            cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.DAY_OF_YEAR, -i);
            String dia = sdf.format(cal.getTime());
            cambiosPorDia.put(dia, 0);
        }
        
        // Contar cambios por día
        if (historialCambios != null) {
            for (Map<String, Object> cambio : historialCambios) {
                java.sql.Timestamp fecha = (java.sql.Timestamp) cambio.get("fecha_cambio");
                cal.setTime(fecha);
                String dia = sdf.format(fecha);
                if (cambiosPorDia.containsKey(dia)) {
                    cambiosPorDia.put(dia, cambiosPorDia.get(dia) + 1);
                }
            }
        }
        %>
        
        const actividadData = {
            labels: [<% 
                boolean first = true;
                for (String dia : cambiosPorDia.keySet()) {
                    if (!first) out.print(", ");
                    out.print("'" + dia + "'");
                    first = false;
                }
            %>],
            datasets: [{
                label: 'Cambios',
                data: [<% 
                    first = true;
                    for (Integer count : cambiosPorDia.values()) {
                        if (!first) out.print(", ");
                        out.print(count);
                        first = false;
                    }
                %>],
                borderColor: '#3B82F6',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                tension: 0.4,
                fill: true,
                pointRadius: 4,
                pointHoverRadius: 6
            }]
        };

        // Crear gráfico de línea para actividad
        const ctxActividad = document.getElementById('actividadChart');
        if (ctxActividad) {
            new Chart(ctxActividad, {
                type: 'line',
                data: actividadData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
        }
        <% } %>
        
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
        
        function verHistorial() {
            // Redirigir a la página completa de historial de cambios
            window.location.href = 'historial_cambios.jsp';
        }
        
        // Auto-refresh para modo colaborativo (cada 30 segundos)
        <% if (modoColaborativo) { %>
            let lastUpdate = new Date();
            
            function checkForUpdates() {
                // Verificar si hay actualizaciones del grupo
                fetch('api/checkUpdates.jsp?grupo=<%= grupoId %>&last=' + lastUpdate.getTime())
                    .then(response => response.json())
                    .then(data => {
                        if (data.hasUpdates) {
                            // Mostrar notificación de actualización
                            showUpdateNotification(data.changes);
                            lastUpdate = new Date();
                        }
                    })
                    .catch(error => console.log('Error checking updates:', error));
            }
            
            function showUpdateNotification(changes) {
                const notification = document.createElement('div');
                notification.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: #4CAF50;
                    color: white;
                    padding: 15px 20px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    z-index: 1000;
                    max-width: 300px;
                `;
                notification.innerHTML = `
                    <div style="display: flex; align-items: center;">
                        <i class="fas fa-sync-alt" style="margin-right: 10px;"></i>
                        <div>
                            <strong>Actualización disponible</strong><br>
                            <small>${changes} cambio(s) nuevo(s)</small>
                        </div>
                        <button onclick="this.parentElement.parentElement.remove()" style="background: none; border: none; color: white; margin-left: 10px; cursor: pointer;">×</button>
                    </div>
                `;
                document.body.appendChild(notification);
                
                // Auto-remover después de 5 segundos
                setTimeout(() => {
                    if (notification.parentElement) {
                        notification.remove();
                    }
                }, 5000);
            }
            
            // Iniciar verificación automática cada 30 segundos
            setInterval(checkForUpdates, 30000);
        <% } %>
        
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
                    link.setAttribute('href', originalHref + '?modo=colaborativo&grupo=<%= grupoActual %>&rol=<%= rolUsuario %>');
                <% } else { %>
                    link.setAttribute('href', originalHref + '?modo=individual');
                <% } %>
            });
        });
    </script>
</body>
</html>