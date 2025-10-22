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
    
    // Variables para los datos
    String reflexion = "";
    String fortaleza1 = "";
    String fortaleza2 = "";
    String debilidad1 = "";
    String debilidad2 = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Array para almacenar las valoraciones de las 25 afirmaciones
    String[] valoraciones = new String[25];
    for (int i = 0; i < 25; i++) {
        valoraciones[i] = "";
    }
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            // Guardar valoraciones de las afirmaciones
            for (int i = 1; i <= 25; i++) {
                String valoracion = request.getParameter("afirmacion_" + i);
                if (valoracion != null && !valoracion.trim().isEmpty()) {
                    ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "afirmacion_" + i, valoracion.trim(), usuarioId);
                    exito = exito && negocioPeti.guardarDato(dato);
                }
            }
            
            // Guardar reflexión
            String nuevaReflexion = request.getParameter("reflexion");
            if (nuevaReflexion != null && !nuevaReflexion.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "reflexion", nuevaReflexion.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            // Guardar fortalezas
            String nuevaFortaleza1 = request.getParameter("fortaleza1");
            if (nuevaFortaleza1 != null && !nuevaFortaleza1.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "fortaleza1", nuevaFortaleza1.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            String nuevaFortaleza2 = request.getParameter("fortaleza2");
            if (nuevaFortaleza2 != null && !nuevaFortaleza2.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "fortaleza2", nuevaFortaleza2.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            // Guardar debilidades
            String nuevaDebilidad1 = request.getParameter("debilidad1");
            if (nuevaDebilidad1 != null && !nuevaDebilidad1.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "debilidad1", nuevaDebilidad1.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            String nuevaDebilidad2 = request.getParameter("debilidad2");
            if (nuevaDebilidad2 != null && !nuevaDebilidad2.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "cadena_valor", "debilidad2", nuevaDebilidad2.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Autodiagnóstico de Cadena de Valor guardado exitosamente";
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
            Map<String, String> datosCadena = negocioPeti.obtenerDatosSeccion(grupoId, "cadena_valor");
            
            // Cargar valoraciones
            for (int i = 1; i <= 25; i++) {
                valoraciones[i-1] = datosCadena.getOrDefault("afirmacion_" + i, "");
            }
            
            reflexion = datosCadena.getOrDefault("reflexion", "");
            fortaleza1 = datosCadena.getOrDefault("fortaleza1", "");
            fortaleza2 = datosCadena.getOrDefault("fortaleza2", "");
            debilidad1 = datosCadena.getOrDefault("debilidad1", "");
            debilidad2 = datosCadena.getOrDefault("debilidad2", "");
        } catch (Exception e) {
            // Error al cargar datos
        }
    }
    
    // Generar iniciales del usuario
    String userInitials = "U";
    if (usuario != null && usuario.length() > 0) {
        userInitials = usuario.substring(0, 1).toUpperCase();
        if (usuario.contains(" ") && usuario.length() > usuario.indexOf(" ") + 1) {
            userInitials += usuario.substring(usuario.indexOf(" ") + 1, usuario.indexOf(" ") + 2).toUpperCase();
        }
    }
    
    // Obtener información del usuario para mostrar en el dashboard
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        userEmail = "usuario@ejemplo.com";
    }
    
    // Definir las afirmaciones
    String[] afirmaciones = {
        "La empresa tiene una política sistematizada de cero defectos en la producción de productos/servicios.",
        "La empresa emplea los medios productivos tecnológicamente más avanzados de su sector.",
        "La empresa dispone de un sistema de información y control de gestión eficiente y eficaz.",
        "Los medios técnicos y tecnológicos de la empresa están preparados para competir en un futuro a corto, medio y largo plazo.",
        "La empresa es un referente en su sector en I+D+i.",
        "La excelencia de los procedimientos de la empresa (en ISO, etc.) son una principal fuente de ventaja competitiva.",
        "La empresa dispone de página web, y esta se emplea no sólo como escaparate virtual de productos/servicios, sino también para establecer relaciones con clientes y proveedores.",
        "Los productos/servicios que desarrolla nuestra empresa llevan incorporada una tecnología difícil de imitar.",
        "La empresa es referente en su sector en la optimización, en términos de coste, de su cadena de producción, siendo esta una de sus principales ventajas competitivas.",
        "La informatización de la empresa es una fuente de ventaja competitiva clara respecto a sus competidores.",
        "Los canales de distribución de la empresa son una importante fuente de ventajas competitivas.",
        "Los productos/servicios de la empresa son altamente, y diferenciadamente, valorados por el cliente respecto a nuestros competidores.",
        "La empresa dispone y ejecuta un sistemático plan de marketing y ventas.",
        "La empresa tiene optimizada su gestión financiera.",
        "La empresa busca continuamente el mejorar la relación con sus clientes cortando los plazos de ejecución, personalizando la oferta o mejorando las condiciones de entrega. Pero siempre partiendo de un plan previo.",
        "La empresa es referente en su sector en el lanzamiento de innovadores productos y servicio de éxito demostrado en el mercado.",
        "Los Recursos Humanos son especialmente responsables del éxito de la empresa, considerándolos incluso como el principal activo estratégico.",
        "Se tiene una plantilla altamente motivada, que conoce con claridad las metas, objetivos y estrategias de la organización.",
        "La empresa siempre trabaja conforme a una estrategia y objetivos claros.",
        "La gestión del circulante está optimizada.",
        "Se tiene definido claramente el posicionamiento estratégico de todos los productos de la empresa.",
        "Se dispone de una política de marca basada en la reputación que la empresa genera, en la gestión de relación con el cliente y en el posicionamiento estratégico previamente definido.",
        "La cartera de clientes de nuestra empresa está altamente fidelizada, ya que tenemos como principal propósito el deleitarlos día a día.",
        "Nuestra política y equipo de ventas y marketing es una importante ventaja competitiva de nuestra empresa respecto al sector.",
        "El servicio al cliente que prestamos es uno de nuestras principales ventajas competitivas respecto a nuestros competidores."
    };
    
    // Calcular el potencial de mejora
    int totalPuntos = 0;
    int respuestasCompletas = 0;
    double porcentajeMejora = 0.0;
    
    if (modoColaborativo) {
        for (int i = 0; i < 25; i++) {
            if (!valoraciones[i].isEmpty()) {
                try {
                    totalPuntos += Integer.parseInt(valoraciones[i]);
                    respuestasCompletas++;
                } catch (NumberFormatException e) {
                    // Ignorar valores no numéricos
                }
            }
        }
        
        if (respuestasCompletas > 0) {
            // Calcular porcentaje: (puntos obtenidos / puntos máximos posibles) * 100
            int puntosMaximos = respuestasCompletas * 4; // 4 es la puntuación máxima por pregunta
            porcentajeMejora = ((double) totalPuntos / puntosMaximos) * 100;
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Autodiagnóstico Cadena de Valor - PETI Colaborativo</title>
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

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
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

        .instructions {
            background: rgba(49, 130, 206, 0.05);
            border: 1px solid rgba(49, 130, 206, 0.1);
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
            color: var(--text-primary);
            font-size: 14px;
            line-height: 1.5;
        }

        .diagnostic-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 24px;
            font-size: 13px;
        }

        .diagnostic-table th {
            background: #4a90a4;
            color: white;
            padding: 12px 8px;
            text-align: center;
            font-weight: 600;
            border: 1px solid #357a8b;
        }

        .diagnostic-table th:first-child {
            text-align: left;
            width: 50%;
        }

        .diagnostic-table td {
            padding: 10px 8px;
            border: 1px solid var(--border-color);
            text-align: center;
            vertical-align: middle;
        }

        .diagnostic-table td:first-child {
            text-align: left;
            background: #f8f9fa;
            font-weight: 500;
            line-height: 1.4;
        }

        .diagnostic-table tr:nth-child(even) td:first-child {
            background: #e9ecef;
        }

        .diagnostic-table input[type="radio"] {
            transform: scale(1.2);
            cursor: pointer;
        }

        .reflection-section {
            margin: 32px 0;
        }

        .reflection-box {
            background: #f8f9fa;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
        }

        .reflection-text {
            font-style: italic;
            color: var(--text-secondary);
            margin-bottom: 12px;
            line-height: 1.5;
        }

        .reflection-textarea {
            width: 100%;
            min-height: 120px;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            resize: vertical;
        }

        .reflection-textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .strengths-weaknesses {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-top: 24px;
        }

        .sw-section {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
        }

        .sw-header {
            padding: 12px 16px;
            font-weight: 600;
            text-align: center;
            color: white;
        }

        .strengths .sw-header {
            background: #d4a574;
        }

        .weaknesses .sw-header {
            background: #a8c4a2;
        }

        .sw-content {
            padding: 16px;
        }

        .sw-item {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
        }

        .sw-label {
            font-weight: 600;
            margin-right: 8px;
            min-width: 30px;
        }

        .sw-input {
            flex: 1;
            padding: 8px 12px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            font-size: 14px;
        }

        .sw-input:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 2px rgba(49, 130, 206, 0.1);
        }

        .btn-primary {
            background: var(--accent-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            background: #2c5282;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .save-button-container {
            text-align: center;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid var(--border-color);
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
            }
            
            .dashboard-content {
                order: 1;
                height: auto;
            }
            
            .dashboard-main {
                padding: 20px;
            }
            
            .strengths-weaknesses {
                grid-template-columns: 1fr;
            }
            
            .diagnostic-table {
                font-size: 12px;
            }
            
            .diagnostic-table th,
            .diagnostic-table td {
                padding: 8px 4px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="sidebar-header">
                <div class="company-logo">
                    <i class="fas fa-link"></i>
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
                        <li><a href="empresa_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-building"></i> Información Empresarial</a></li>
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
                    
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Herramientas de Gestión</div>
                    <ul>
                        
                        <li class="active"><a href="cadena_valor_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                        
                        <li><a href="matriz_participacion_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-users"></i> Matriz de Participación</a></li>
                         <li><a href="autodiagnostico_BCG.jsp"><i class="fas fa-users"></i> autodiagnostico_BCG</a></li>
                        <li><a href="resumen-ejecutivo-colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    </ul>
                </div>
                <div class="nav-section">
                    <div class="nav-section-title">Sistema</div>
                    <ul>
                        <li><a href="historial_cambios.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>"><i class="fas fa-history"></i> Historial de Cambios</a></li>
                        <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                    </ul>
                </div>
            </nav>
        </div>

        <div class="dashboard-content">
            <header class="dashboard-header">
                <h1>
                    <i class="fas fa-link"></i> Autodiagnóstico Cadena de Valor
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
                        </div>
                        <% if ("admin".equals(rolUsuario)) { %>
                            <div class="status-badge admin-badge">
                                <i class="fas fa-crown"></i> Administrador
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="status-badge">
                            <i class="fas fa-user"></i> Modo Individual
                        </div>
                    <% } %>
                </div>
            </header>

            <div class="dashboard-main">
                <% if (!mensaje.isEmpty()) { %>
                    <div class="alert alert-<%= tipoMensaje %>">
                        <i class="fas fa-<%= tipoMensaje.equals("success") ? "check-circle" : "exclamation-triangle" %>"></i>
                        <%= mensaje %>
                    </div>
                <% } %>

                <% if (!modoColaborativo) { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle"></i>
                        Para utilizar esta funcionalidad, debe estar en modo colaborativo. 
                        <a href="dashboard.jsp">Ir al Dashboard</a> para unirse a un grupo.
                    </div>
                <% } %>

                <form method="post" action="cadena_valor_colaborativo.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "" %>">
                    <div class="dashboard-section">
                        <div class="section-header">
                            <h2><i class="fas fa-clipboard-check"></i> Autodiagnóstico de la Cadena de Valor Interna</h2>
                        </div>
                        <div class="section-content">
                            <div class="instructions">
                                A continuación marque con una X para valorar su empresa en función de cada una de las afirmaciones, de tal forma que 0= En total en desacuerdo, 1= No está de acuerdo, 2=Está de acuerdo, 3= Está bastante de acuerdo, 4=En total acuerdo. En caso de no cumplimentar una casilla o duplicar su respuesta le aparecerá el mensaje de error ("¡REF!")
                            </div>

                            <table class="diagnostic-table">
                                <thead>
                                    <tr>
                                        <th>AUTODIAGNÓSTICO DE LA CADENA DE VALOR INTERNA</th>
                                        <th colspan="5">VALORACIÓN</th>
                                    </tr>
                                    <tr>
                                        <th></th>
                                        <th>0</th>
                                        <th>1</th>
                                        <th>2</th>
                                        <th>3</th>
                                        <th>4</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (int i = 0; i < 25; i++) { %>
                                        <tr>
                                            <td><%= (i + 1) %>. <%= afirmaciones[i] %></td>
                                            <% for (int j = 0; j <= 4; j++) { %>
                                                <td>
                                                    <input type="radio" 
                                                           name="afirmacion_<%= (i + 1) %>" 
                                                           value="<%= j %>"
                                                           <%= valoraciones[i].equals(String.valueOf(j)) ? "checked" : "" %>
                                                           <%= !modoColaborativo ? "disabled" : "" %>>
                                                </td>
                                            <% } %>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                            
                            <!-- Sección de Potencial de Mejora -->
                            <div style="margin-top: 24px; padding: 16px; background: #f8f9fa; border: 2px solid #dee2e6; border-radius: 8px;">
                                <table style="width: 100%; border-collapse: collapse;">
                                    <tr>
                                        <td style="background: #6c757d; color: white; padding: 12px; text-align: center; font-weight: bold; border: 1px solid #495057;">
                                            POTENCIAL DE MEJORA DE LA CADENA DE VALOR INTERNA
                                        </td>
                                        <td style="background: #e9ecef; padding: 12px; text-align: center; font-weight: bold; border: 1px solid #495057; color: #0066cc;">
                                            <% if (modoColaborativo && respuestasCompletas == 25) { %>
                                                <%= String.format("%.0f", porcentajeMejora) %>%
                                            <% } else { %>
                                                #¡REF!
                                            <% } %>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="dashboard-section reflection-section">
                        <div class="section-header">
                            <h2><i class="fas fa-lightbulb"></i> Reflexión</h2>
                        </div>
                        <div class="section-content">
                            <div class="reflection-box">
                                <div class="reflection-text">
                                    Reflexione sobre el resultado obtenido. Anote aquellas observaciones que puedan ser de su interés. Identifique sus fortalezas y debilidades respecto a su cadena de valor
                                </div>
                                <textarea class="reflection-textarea" 
                                          name="reflexion" 
                                          placeholder="Escriba aquí sus reflexiones sobre el autodiagnóstico..."
                                          <%= !modoColaborativo ? "disabled" : "" %>><%= reflexion %></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="strengths-weaknesses">
                        <div class="sw-section strengths">
                            <div class="sw-header">FORTALEZAS</div>
                            <div class="sw-content">
                                <div class="sw-item">
                                    <span class="sw-label">F1:</span>
                                    <input type="text" 
                                           class="sw-input" 
                                           name="fortaleza1" 
                                           value="<%= fortaleza1 %>"
                                           <%= !modoColaborativo ? "disabled" : "" %>>
                                </div>
                                <div class="sw-item">
                                    <span class="sw-label">F2:</span>
                                    <input type="text" 
                                           class="sw-input" 
                                           name="fortaleza2" 
                                           value="<%= fortaleza2 %>"
                                           <%= !modoColaborativo ? "disabled" : "" %>>
                                </div>
                            </div>
                        </div>

                        <div class="sw-section weaknesses">
                            <div class="sw-header">DEBILIDADES</div>
                            <div class="sw-content">
                                <div class="sw-item">
                                    <span class="sw-label">D1:</span>
                                    <input type="text" 
                                           class="sw-input" 
                                           name="debilidad1" 
                                           value="<%= debilidad1 %>"
                                           <%= !modoColaborativo ? "disabled" : "" %>>
                                </div>
                                <div class="sw-item">
                                    <span class="sw-label">D2:</span>
                                    <input type="text" 
                                           class="sw-input" 
                                           name="debilidad2" 
                                           value="<%= debilidad2 %>"
                                           <%= !modoColaborativo ? "disabled" : "" %>>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (modoColaborativo) { %>
                        <div class="save-button-container">
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-save"></i>
                                Guardar Autodiagnóstico
                            </button>
                        </div>
                    <% } %>
                </form>
            </div>
        </div>
    </div>

    <script>
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }

        // Validar que solo se seleccione una opción por fila
        document.addEventListener('DOMContentLoaded', function() {
            const radioButtons = document.querySelectorAll('input[type="radio"]');
            
            radioButtons.forEach(radio => {
                radio.addEventListener('change', function() {
                    // Lógica adicional si es necesaria
                });
            });
        });
    </script>
</body>
</html>