<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="negocio.ClsNPeti"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    // Verificar sesión
    String usuario = (String) session.getAttribute("usuario");
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    String grupoActual = (String) session.getAttribute("grupoActual");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    
    if (usuario == null || usuarioId == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    boolean modoColaborativo = grupoActual != null && grupoId != null;
    if (!modoColaborativo) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Obtener parámetros de filtro
    final String filtroSeccion = request.getParameter("seccion");
    final String filtroUsuario = request.getParameter("usuario");
    final String filtroAccion = request.getParameter("accion");
    int limite = 100;
    
    try {
        String limitePar = request.getParameter("limite");
        if (limitePar != null) {
            limite = Integer.parseInt(limitePar);
        }
    } catch (NumberFormatException e) {
        limite = 100;
    }
    
    // Obtener historial completo
    ClsNPeti negocioPeti = new ClsNPeti();
    List<Map<String, Object>> historialCompleto = negocioPeti.obtenerHistorial(grupoId, limite);
    
    // Aplicar filtros sin usar lambdas (compatible con Java 7)
    if (filtroSeccion != null && !filtroSeccion.isEmpty()) {
        List<Map<String, Object>> listaFiltrada = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> cambio : historialCompleto) {
            if (filtroSeccion.equals(cambio.get("seccion"))) {
                listaFiltrada.add(cambio);
            }
        }
        historialCompleto = listaFiltrada;
    }
    
    if (filtroUsuario != null && !filtroUsuario.isEmpty()) {
        List<Map<String, Object>> listaFiltrada = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> cambio : historialCompleto) {
            String usuarioCambio = (String) cambio.get("usuario");
            if (usuarioCambio != null && usuarioCambio.toLowerCase().contains(filtroUsuario.toLowerCase())) {
                listaFiltrada.add(cambio);
            }
        }
        historialCompleto = listaFiltrada;
    }
    
    if (filtroAccion != null && !filtroAccion.isEmpty()) {
        List<Map<String, Object>> listaFiltrada = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> cambio : historialCompleto) {
            if (filtroAccion.equals(cambio.get("accion"))) {
                listaFiltrada.add(cambio);
            }
        }
        historialCompleto = listaFiltrada;
    }
    
    // Obtener lista de usuarios únicos para el filtro
    Set<String> usuariosUnicos = new HashSet<String>();
    Set<String> seccionesUnicas = new HashSet<String>();
    List<Map<String, Object>> historialParaFiltros = negocioPeti.obtenerHistorial(grupoId, 1000);
    for (Map<String, Object> cambio : historialParaFiltros) {
        usuariosUnicos.add((String) cambio.get("usuario"));
        seccionesUnicas.add((String) cambio.get("seccion"));
    }
    
    // Generar iniciales del usuario
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
    
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        userEmail = "usuario@ejemplo.com";
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Cambios - PETI System</title>
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

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-size: 14px;
        }

        .filter-group select,
        .filter-group input {
            padding: 10px 12px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s ease;
            background: white;
        }

        .filter-group select:focus,
        .filter-group input:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .filter-actions {
            display: flex;
            gap: 12px;
        }

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

        .historial-list {
            max-height: 600px;
            overflow-y: auto;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 20px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 15px;
            background: var(--card-bg);
            transition: all 0.3s ease;
            position: relative;
        }

        .activity-item:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .activity-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-color), #2c5282);
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
            box-shadow: var(--shadow-sm);
        }

        .activity-content {
            flex: 1;
            min-width: 0;
        }

        .activity-header {
            margin-bottom: 8px;
            line-height: 1.5;
            color: var(--text-primary);
            font-weight: 600;
        }

        .activity-action {
            color: var(--text-secondary);
            margin: 0 5px;
            font-weight: 500;
        }

        .activity-preview {
            background: rgba(26, 54, 93, 0.02);
            border-left: 4px solid var(--accent-color);
            padding: 12px 15px;
            margin: 10px 0;
            border-radius: 0 6px 6px 0;
            font-size: 14px;
            color: var(--text-primary);
            line-height: 1.4;
        }

        .activity-time {
            display: flex;
            align-items: center;
            gap: 5px;
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 8px;
        }

        .cambio-accion {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .accion-crear {
            background: rgba(56, 161, 105, 0.1);
            color: var(--success-color);
        }

        .accion-modificar {
            background: rgba(214, 158, 46, 0.1);
            color: var(--warning-color);
        }

        .accion-eliminar {
            background: rgba(229, 62, 62, 0.1);
            color: var(--danger-color);
        }

        .valor-cambio {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 12px;
        }

        .valor-anterior,
        .valor-nuevo {
            padding: 12px;
            border-radius: 6px;
            font-size: 13px;
            line-height: 1.4;
        }

        .valor-anterior {
            background: rgba(229, 62, 62, 0.05);
            border-left: 4px solid var(--danger-color);
        }

        .valor-nuevo {
            background: rgba(56, 161, 105, 0.05);
            border-left: 4px solid var(--success-color);
        }

        .valor-label {
            font-weight: 600;
            margin-bottom: 6px;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-secondary);
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
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .valor-cambio {
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
                        <li><a href="dashboard.jsp?modo=colaborativo&grupo=<%= grupoActual %>&rol=<%= rolUsuario %>"><i class="fas fa-chart-line"></i> Dashboard</a></li>
                        <li class="active"><a href="historial_cambios.jsp"><i class="fas fa-history"></i> Historial de Cambios</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Planificación Estratégica</div>
                    <ul>
                        <li><a href="empresa_colaborativo.jsp"><i class="fas fa-building"></i> Información Empresarial</a></li>
                        <li><a href="mision_colaborativo.jsp"><i class="fas fa-bullseye"></i> Misión Corporativa</a></li>
                        <li><a href="vision_colaborativo.jsp"><i class="fas fa-eye"></i> Visión Estratégica</a></li>
                        <li><a href="valores_colaborativo.jsp"><i class="fas fa-heart"></i> Valores Organizacionales</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Análisis Estratégico</div>
                    <ul>
                        <li><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
                        <li><a href="analisis_interno_colaborativo.jsp"><i class="fas fa-chart-bar"></i> Análisis Organizacional</a></li>
                        <li><a href="pest_colaborativo.jsp"><i class="fas fa-chart-pie"></i> Matriz PEST</a></li>
                        <li><a href="porter_colaborativo.jsp"><i class="fas fa-chess"></i> Fuerzas Competitivas</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Estrategias</div>
                    <ul>
                        <li><a href="identificacion_estrategia_colaborativo.jsp"><i class="fas fa-lightbulb"></i> Identificación de Estrategias</a></li>
                        <li><a href="matriz_came_colaborativo.jsp"><i class="fas fa-table"></i> Matriz CAME</a></li>
                        <li><a href="objetivos_colaborativo.jsp"><i class="fas fa-target"></i> Objetivos Estratégicos</a></li>
                        <li><a href="matriz_participacion_colaborativo.jsp"><i class="fas fa-users"></i> Matriz de Participación</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Cadena de Valor</div>
                    <ul>
                        <li><a href="cadena_valor_colaborativo.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                        <li><a href="resumen-ejecutivo-colaborativo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
            </nav>
        </div>
        
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h1><i class="fas fa-history"></i> Historial de Cambios</h1>
                <div class="header-actions">
                    <span class="status-badge">
                        <i class="fas fa-users"></i>
                        Grupo: <%= grupoActual %>
                    </span>
                </div>
            </div>
            
            <div class="dashboard-main">
                <!-- Filtros de búsqueda -->
                <div class="dashboard-section">
                    <div class="section-header">
                        <h2><i class="fas fa-filter"></i> Filtros de Búsqueda</h2>
                    </div>
                    <div class="section-content">
                        <form method="GET" action="historial_cambios.jsp">
                            <div class="filter-row">
                                <div class="filter-group">
                                    <label for="usuario">Usuario:</label>
                                    <select name="usuario" id="usuario">
                                        <option value="">Todos los usuarios</option>
                                        <% for (String usuarioUnico : usuariosUnicos) { %>
                                            <option value="<%= usuarioUnico %>" <%= usuarioUnico.equals(filtroUsuario) ? "selected" : "" %>>
                                                <%= usuarioUnico %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <div class="filter-group">
                                    <label for="seccion">Sección:</label>
                                    <select name="seccion" id="seccion">
                                        <option value="">Todas las secciones</option>
                                        <% for (String seccionUnica : seccionesUnicas) { %>
                                            <option value="<%= seccionUnica %>" <%= seccionUnica.equals(filtroSeccion) ? "selected" : "" %>>
                                                <%= seccionUnica.substring(0,1).toUpperCase() + seccionUnica.substring(1).replace("_", " ") %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <div class="filter-group">
                                    <label for="accion">Acción:</label>
                                    <select name="accion" id="accion">
                                        <option value="">Todas las acciones</option>
                                        <option value="crear" <%= "crear".equals(filtroAccion) ? "selected" : "" %>>Crear</option>
                                        <option value="modificar" <%= "modificar".equals(filtroAccion) ? "selected" : "" %>>Modificar</option>
                                        <option value="eliminar" <%= "eliminar".equals(filtroAccion) ? "selected" : "" %>>Eliminar</option>
                                    </select>
                                </div>
                                
                                <div class="filter-group">
                                    <label for="limite">Límite:</label>
                                    <select name="limite" id="limite">
                                        <option value="50" <%= limite == 50 ? "selected" : "" %>>50 registros</option>
                                        <option value="100" <%= limite == 100 ? "selected" : "" %>>100 registros</option>
                                        <option value="200" <%= limite == 200 ? "selected" : "" %>>200 registros</option>
                                        <option value="500" <%= limite == 500 ? "selected" : "" %>>500 registros</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="filter-actions">
                                <button type="submit" class="btn-primary">
                                    <i class="fas fa-search"></i> Aplicar Filtros
                                </button>
                                <button type="button" class="btn-secondary" onclick="window.location.href='historial_cambios.jsp'">
                                    <i class="fas fa-times"></i> Limpiar Filtros
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Estadísticas -->
                <div class="dashboard-cards">
                    <div class="card">
                        <div class="card-content">
                            <h3>Cambios Mostrados</h3>
                            <div class="card-value"><%= historialCompleto.size() %></div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content">
                            <h3>Usuarios Activos</h3>
                            <div class="card-value"><%= usuariosUnicos.size() %></div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-content">
                            <h3>Secciones Editadas</h3>
                            <div class="card-value"><%= seccionesUnicas.size() %></div>
                        </div>
                    </div>
                </div>
                
                <!-- Lista de cambios -->
                <div class="dashboard-section">
                    <div class="section-header">
                        <h2><i class="fas fa-list"></i> Registro de Cambios</h2>
                    </div>
                    <div class="section-content">
                        <div class="historial-list">
                            <% if (historialCompleto != null && !historialCompleto.isEmpty()) { %>
                                <% 
                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                    for (Map<String, Object> cambio : historialCompleto) { 
                                        String accion = (String) cambio.get("accion");
                                        String usuarioCambio = (String) cambio.get("usuario");
                                        String iniciales = usuarioCambio.length() >= 2 ? 
                                            usuarioCambio.substring(0,2).toUpperCase() : 
                                            usuarioCambio.substring(0,1).toUpperCase();
                                %>
                                    <div class="activity-item">
                                        <div class="activity-avatar"><%= iniciales %></div>
                                        <div class="activity-content">
                                            <div class="activity-header">
                                                <strong><%= usuarioCambio %></strong>
                                                <span class="activity-action">
                                                    <% if ("crear".equals(accion)) { %>
                                                        creó
                                                    <% } else if ("modificar".equals(accion)) { %>
                                                        modificó
                                                    <% } else { %>
                                                        eliminó
                                                    <% } %>
                                                </span>
                                                el campo
                                                <strong><%= ((String)cambio.get("campo")).substring(0,1).toUpperCase() + 
                                                    ((String)cambio.get("campo")).substring(1).replace("_", " ") %></strong>
                                                en
                                                <strong><%= ((String)cambio.get("seccion")).substring(0,1).toUpperCase() + 
                                                    ((String)cambio.get("seccion")).substring(1).replace("_", " ") %></strong>
                                            </div>
                                            
                                            <% if (cambio.get("valor_anterior") != null || cambio.get("valor_nuevo") != null) { %>
                                                <div class="valor-cambio">
                                                    <% if (cambio.get("valor_anterior") != null) { %>
                                                        <div class="valor-anterior">
                                                            <div class="valor-label">Valor Anterior</div>
                                                            <%= ((String)cambio.get("valor_anterior")).length() > 150 ? 
                                                                ((String)cambio.get("valor_anterior")).substring(0, 150) + "..." : 
                                                                cambio.get("valor_anterior") %>
                                                        </div>
                                                    <% } %>
                                                    <% if (cambio.get("valor_nuevo") != null) { %>
                                                        <div class="valor-nuevo">
                                                            <div class="valor-label">Valor Nuevo</div>
                                                            <%= ((String)cambio.get("valor_nuevo")).length() > 150 ? 
                                                                ((String)cambio.get("valor_nuevo")).substring(0, 150) + "..." : 
                                                                cambio.get("valor_nuevo") %>
                                                        </div>
                                                    <% } %>
                                                </div>
                                            <% } %>
                                            
                                            <div class="activity-time">
                                                <i class="fas fa-clock"></i>
                                                <%= sdf.format(cambio.get("fecha_cambio")) %>
                                            </div>
                                        </div>
                                        <div class="activity-icon">
                                            <div class="cambio-accion accion-<%= accion %>">
                                                <% if ("crear".equals(accion)) { %>
                                                    <i class="fas fa-plus"></i>
                                                <% } else if ("modificar".equals(accion)) { %>
                                                    <i class="fas fa-edit"></i>
                                                <% } else { %>
                                                    <i class="fas fa-trash"></i>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <div class="empty-state">
                                    <i class="fas fa-history"></i>
                                    <h3>No hay cambios registrados</h3>
                                    <p>No se encontraron cambios que coincidan con los filtros seleccionados.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>