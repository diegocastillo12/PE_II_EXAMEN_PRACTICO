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
    
    // Variables para la matriz CAME
    String corregir = "";
    String afrontar = "";
    String mantener = "";
    String explotar = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevoCorregir = request.getParameter("corregir");
        String nuevoAfrontar = request.getParameter("afrontar");
        String nuevoMantener = request.getParameter("mantener");
        String nuevoExplotar = request.getParameter("explotar");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevoCorregir != null && !nuevoCorregir.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "came", "corregir", nuevoCorregir.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoAfrontar != null && !nuevoAfrontar.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "came", "afrontar", nuevoAfrontar.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoMantener != null && !nuevoMantener.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "came", "mantener", nuevoMantener.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoExplotar != null && !nuevoExplotar.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "came", "explotar", nuevoExplotar.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Matriz CAME guardada exitosamente";
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
            Map<String, String> datosCame = negocioPeti.obtenerDatosSeccion(grupoId, "came");
            
            corregir = datosCame.getOrDefault("corregir", "");
            afrontar = datosCame.getOrDefault("afrontar", "");
            mantener = datosCame.getOrDefault("mantener", "");
            explotar = datosCame.getOrDefault("explotar", "");
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
    <title>Matriz CAME - PETI Colaborativo</title>
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
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            z-index: -1;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header h1 {
            color: #2c3e50;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 700;
        }

        .came-logo {
            background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
            color: white;
            padding: 12px 16px;
            border-radius: 12px;
            font-weight: bold;
            font-size: 18px;
            box-shadow: 0 4px 15px rgba(230, 126, 34, 0.3);
        }

        .grupo-info {
            font-size: 16px;
            color: #7f8c8d;
            font-weight: 500;
        }

        .nav-buttons {
            display: flex;
            gap: 12px;
        }

        .content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .alert {
            padding: 18px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .alert-error {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .alert-warning {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 1px solid #ffeaa7;
            color: #856404;
        }

        .came-intro {
            background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(230, 126, 34, 0.3);
        }

        .came-intro h2 {
            font-size: 32px;
            margin-bottom: 15px;
        }

        .came-intro p {
            font-size: 18px;
            opacity: 0.95;
        }

        .came-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        .came-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            padding: 30px;
            border-left: 6px solid;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .came-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.1) 50%, transparent 70%);
            transform: rotate(45deg);
            transition: all 0.6s ease;
            opacity: 0;
        }

        .came-card:hover::before {
            opacity: 1;
            animation: shimmer 1.5s ease-in-out;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .came-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        .corregir-card {
            border-left-color: #e74c3c;
        }

        .afrontar-card {
            border-left-color: #f39c12;
        }

        .mantener-card {
            border-left-color: #27ae60;
        }

        .explotar-card {
            border-left-color: #3498db;
        }

        .came-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .came-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .corregir-card .came-icon {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        }

        .afrontar-card .came-icon {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
        }

        .mantener-card .came-icon {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
        }

        .explotar-card .came-icon {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
        }

        .came-title {
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .came-subtitle {
            font-size: 14px;
            color: #7f8c8d;
            margin-top: 5px;
            font-style: italic;
        }

        .came-description {
            background: rgba(255, 255, 255, 0.8);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid rgba(0, 0, 0, 0.1);
        }

        .came-description h4 {
            color: #2c3e50;
            margin-bottom: 12px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .came-description ul {
            color: #34495e;
            font-size: 14px;
            padding-left: 20px;
            line-height: 1.6;
        }

        .came-description li {
            margin-bottom: 8px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 12px;
            color: #2c3e50;
            font-weight: 600;
            font-size: 16px;
        }

        .form-group textarea {
            width: 100%;
            padding: 18px;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            font-size: 15px;
            min-height: 140px;
            resize: vertical;
            background: rgba(255, 255, 255, 0.9);
            color: #2c3e50;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: white;
        }

        .form-group textarea::placeholder {
            color: #adb5bd;
            font-style: italic;
        }

        .counter-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
            font-size: 12px;
            color: #6c757d;
        }

        .character-count {
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 500;
        }

        .strategy-examples {
            background: rgba(255, 255, 255, 0.7);
            padding: 12px;
            border-radius: 8px;
            margin-top: 12px;
            font-size: 12px;
            color: #6c757d;
            font-style: italic;
            border-left: 3px solid #dee2e6;
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            font-size: 18px;
            padding: 20px 40px;
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .summary-stats {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border: 1px solid #90caf9;
        }

        .summary-stats h3 {
            color: #1976d2;
            margin-bottom: 20px;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .stat-item {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            border-top: 4px solid;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .stat-item.corregir { border-top-color: #e74c3c; }
        .stat-item.afrontar { border-top-color: #f39c12; }
        .stat-item.mantener { border-top-color: #27ae60; }
        .stat-item.explotar { border-top-color: #3498db; }

        .stat-number {
            font-size: 32px;
            font-weight: 800;
            color: #2c3e50;
            display: block;
        }

        .stat-label {
            font-size: 14px;
            color: #6c757d;
            margin-top: 8px;
            font-weight: 500;
        }

        .preview-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .preview-section h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .preview-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .preview-item {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .preview-item h4 {
            margin-bottom: 12px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .preview-item p {
            font-size: 14px;
            line-height: 1.6;
            color: #555;
            margin: 0;
        }

        .corregir-preview { border-left-color: #e74c3c; }
        .afrontar-preview { border-left-color: #f39c12; }
        .mantener-preview { border-left-color: #27ae60; }
        .explotar-preview { border-left-color: #3498db; }

        .save-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-top: 30px;
            box-shadow: 0 8px 32px rgba(40, 167, 69, 0.3);
        }

        .save-section h3 {
            font-size: 26px;
            margin-bottom: 15px;
        }

        .save-section p {
            font-size: 16px;
            margin-bottom: 25px;
            opacity: 0.9;
        }

        .progress-indicator {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid #e9ecef;
        }

        .progress-indicator h4 {
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .progress-bar {
            background: #e9ecef;
            height: 10px;
            border-radius: 5px;
            overflow: hidden;
            margin-bottom: 10px;
        }

        .progress-fill {
            background: linear-gradient(90deg, #28a745, #20c997);
            height: 100%;
            transition: width 0.3s ease;
        }

        .progress-text {
            font-size: 14px;
            color: #6c757d;
            display: flex;
            justify-content: space-between;
        }

        @media (max-width: 768px) {
            .came-grid,
            .preview-grid {
                grid-template-columns: 1fr;
            }
            
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .nav-buttons {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <span class="came-logo">CAME</span>
                    Matriz CAME
                    <% if (modoColaborativo) { %>
                        <small class="grupo-info">- Grupo: <%= grupoActual %> 
                        <% if ("admin".equals(rolUsuario)) { %>
                            <span style="color: #ffc107;">👑</span>
                        <% } %>
                        </small>
                    <% } else { %>
                        <small class="grupo-info">- Modo Individual</small>
                    <% } %>
                </h1>
            </div>
            <div class="nav-buttons">
                <a href="dashboard.jsp<%= modoColaborativo ? "?modo=colaborativo&grupo=" + grupoActual + "&rol=" + rolUsuario : "?modo=individual" %>" class="btn btn-secondary">
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
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Modo Individual:</strong> No puedes guardar cambios. 
                    <a href="../menuprincipal.jsp" style="color: #856404; text-decoration: underline;">Únete a un grupo</a> 
                    para trabajar colaborativamente.
                </div>
            <% } %>

            <div class="came-intro">
                <h2>📊 Matriz CAME - Estrategias de Acción</h2>
                <p>Convierte debilidades en fortalezas y amenazas en oportunidades definiendo estrategias específicas de acción</p>
            </div>

            <div class="summary-stats">
                <h3><i class="fas fa-chart-pie"></i> Progreso del Análisis CAME</h3>
                <div class="stats-grid">
                    <div class="stat-item corregir">
                        <span class="stat-number" id="countCorregir">0</span>
                        <div class="stat-label">Acciones Correctivas</div>
                    </div>
                    <div class="stat-item afrontar">
                        <span class="stat-number" id="countAfrontar">0</span>
                        <div class="stat-label">Estrategias Defensivas</div>
                    </div>
                    <div class="stat-item mantener">
                        <span class="stat-number" id="countMantener">0</span>
                        <div class="stat-label">Estrategias de Mantenimiento</div>
                    </div>
                    <div class="stat-item explotar">
                        <span class="stat-number" id="countExplotar">0</span>
                        <div class="stat-label">Estrategias Ofensivas</div>
                    </div>
                </div>
            </div>

            <div class="progress-indicator">
                <h4><i class="fas fa-tasks"></i> Completitud del Análisis</h4>
                <div class="progress-bar">
                    <div class="progress-fill" id="progressFill"></div>
                </div>
                <div class="progress-text">
                    <span id="progressText">0 de 4 secciones completadas</span>
                    <span id="progressPercent">0%</span>
                </div>
            </div>

            <form method="post" action="">
                <div class="came-grid">
                    <!-- CORREGIR - Debilidades -->
                    <div class="came-card corregir-card">
                        <div class="came-header">
                            <div class="came-icon">
                                <i class="fas fa-tools"></i>
                            </div>
                            <div>
                                <div class="came-title">Corregir</div>
                                <div class="came-subtitle">Eliminar debilidades internas</div>
                            </div>
                        </div>
                        
                        <div class="came-description">
                            <h4><i class="fas fa-wrench"></i> ¿Cómo corregir debilidades?</h4>
                            <ul>
                                <li>Capacitación y desarrollo del personal</li>
                                <li>Inversión en nuevas tecnologías</li>
                                <li>Mejora de procesos operativos</li>
                                <li>Reestructuración organizacional</li>
                                <li>Fortalecimiento de áreas deficientes</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="corregir">Estrategias para Corregir Debilidades:</label>
                            <textarea 
                                id="corregir" 
                                name="corregir"
                                placeholder="Ejemplo:&#10;• Implementar programa de capacitación técnica para el 100% del personal&#10;• Actualizar sistemas tecnológicos obsoletos con inversión de $2M&#10;• Rediseñar procesos operativos para reducir tiempos en 30%&#10;• Contratar especialistas en áreas críticas identificadas"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores()"
                            ><%= corregir %></textarea>
                            <div class="counter-info">
                                <span>Estrategias para fortalecer la organización</span>
                                <span class="character-count" id="charCorregir">0 caracteres</span>
                            </div>
                            <div class="strategy-examples">
                                💡 <strong>Sugerencias:</strong> Enfócate en acciones específicas, medibles y con plazos definidos para eliminar las debilidades identificadas
                            </div>
                        </div>
                    </div>

                    <!-- AFRONTAR - Amenazas -->
                    <div class="came-card afrontar-card">
                        <div class="came-header">
                            <div class="came-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <div>
                                <div class="came-title">Afrontar</div>
                                <div class="came-subtitle">Neutralizar amenazas externas</div>
                            </div>
                        </div>
                        
                        <div class="came-description">
                            <h4><i class="fas fa-shield-virus"></i> ¿Cómo afrontar amenazas?</h4>
                            <ul>
                                <li>Planes de contingencia y gestión de riesgos</li>
                                <li>Diversificación de productos y mercados</li>
                                <li>Alianzas estratégicas defensivas</li>
                                <li>Sistemas de monitoreo del entorno</li>
                                <li>Estrategias de diferenciación</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="afrontar">Estrategias para Afrontar Amenazas:</label>
                            <textarea 
                                id="afrontar" 
                                name="afrontar"
                                placeholder="Ejemplo:&#10;• Desarrollar plan de contingencia para crisis económicas&#10;• Diversificar portafolio hacia 3 nuevos segmentos de mercado&#10;• Establecer alianzas estratégicas con proveedores clave&#10;• Implementar sistema de alerta temprana de cambios regulatorios"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores()"
                            ><%= afrontar %></textarea>
                            <div class="counter-info">
                                <span>Estrategias para neutralizar riesgos</span>
                                <span class="character-count" id="charAfrontar">0 caracteres</span>
                            </div>
                            <div class="strategy-examples">
                                ⚠️ <strong>Sugerencias:</strong> Desarrolla estrategias proactivas para mitigar o eliminar las amenazas más críticas del entorno
                            </div>
                        </div>
                    </div>

                    <!-- MANTENER - Fortalezas -->
                    <div class="came-card mantener-card">
                        <div class="came-header">
                            <div class="came-icon">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <div>
                                <div class="came-title">Mantener</div>
                                <div class="came-subtitle">Conservar fortalezas actuales</div>
                            </div>
                        </div>
                        
                        <div class="came-description">
                            <h4><i class="fas fa-award"></i> ¿Cómo mantener fortalezas?</h4>
                            <ul>
                                <li>Programas de retención de talento clave</li>
                                <li>Inversión continua en I+D</li>
                                <li>Mantenimiento de certificaciones</li>
                                <li>Fortalecimiento de la cultura organizacional</li>
                                <li>Innovación incremental constante</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="mantener">Estrategias para Mantener Fortalezas:</label>
                            <textarea 
                                id="mantener" 
                                name="mantener"
                                placeholder="Ejemplo:&#10;• Programa de retención del 95% del talento clave con incentivos&#10;• Inversión anual del 5% de ingresos en investigación y desarrollo&#10;• Renovación automática de certificaciones ISO y de calidad&#10;• Fortalecimiento de la cultura organizacional con actividades trimestrales"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores()"
                            ><%= mantener %></textarea>
                            <div class="counter-info">
                                <span>Estrategias para preservar ventajas</span>
                                <span class="character-count" id="charMantener">0 caracteres</span>
                            </div>
                            <div class="strategy-examples">
                                ✅ <strong>Sugerencias:</strong> Crea estrategias sostenibles para preservar y potenciar las fortalezas que te dan ventaja competitiva
                            </div>
                        </div>
                    </div>

                    <!-- EXPLOTAR - Oportunidades -->
                    <div class="came-card explotar-card">
                        <div class="came-header">
                            <div class="came-icon">
                                <i class="fas fa-rocket"></i>
                            </div>
                            <div>
                                <div class="came-title">Explotar</div>
                                <div class="came-subtitle">Aprovechar oportunidades</div>
                            </div>
                        </div>
                        
                        <div class="came-description">
                            <h4><i class="fas fa-bullseye"></i> ¿Cómo explotar oportunidades?</h4>
                            <ul>
                                <li>Expansión a nuevos mercados geográficos</li>
                                <li>Desarrollo de productos innovadores</li>
                                <li>Aprovechamiento de tendencias tecnológicas</li>
                                <li>Alianzas comerciales estratégicas</li>
                                <li>Inversión en tecnologías emergentes</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="explotar">Estrategias para Explotar Oportunidades:</label>
                            <textarea 
                                id="explotar" 
                                name="explotar"
                                placeholder="Ejemplo:&#10;• Expansión a 5 nuevos mercados latinoamericanos en 18 meses&#10;• Lanzamiento de 3 productos digitales innovadores este año&#10;• Aprovechamiento de tendencias de sostenibilidad con línea eco-friendly&#10;• Alianza comercial con líderes tecnológicos para co-innovación"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores()"
                            ><%= explotar %></textarea>
                            <div class="counter-info">
                                <span>Estrategias para capturar valor</span>
                                <span class="character-count" id="charExplotar">0 caracteres</span>
                            </div>
                            <div class="strategy-examples">
                                🚀 <strong>Sugerencias:</strong> Define estrategias ambiciosas pero realistas para capitalizar las mejores oportunidades del mercado
                            </div>
                        </div>
                    </div>
                </div>

                <% if (modoColaborativo) { %>
                    <div class="save-section">
                        <h3><i class="fas fa-save"></i> Guardar Matriz CAME Completa</h3>
                        <p>Las estrategias definidas estarán disponibles para todo el equipo y servirán como base para la implementación del plan estratégico</p>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Guardar Estrategias CAME
                        </button>
                    </div>
                <% } %>
            </form>

            <!-- Vista Previa Mejorada -->
            <div class="preview-section">
                <h3><i class="fas fa-eye"></i> Resumen Ejecutivo de Estrategias CAME</h3>
                <div class="preview-grid" id="previewGrid">
                    <!-- Se llenará dinámicamente -->
                </div>
            </div>

            <% if (modoColaborativo) { %>
                <div style="background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%); padding: 20px; border-radius: 12px; margin-top: 25px; border: 1px solid #4caf50;">
                    <p style="color: #2d5a3d; margin: 0; font-size: 16px;">
                        <i class="fas fa-users"></i> 
                        <strong>Colaboración Activa:</strong> Las estrategias CAME se sincronizan en tiempo real con todos los miembros del grupo <strong><%= grupoActual %></strong>. Los cambios son visibles inmediatamente para facilitar el trabajo en equipo.
                    </p>
                </div>
            <% } %>
        </div>
        </div>
    </div>

    <script>
        function actualizarContadores() {
            const campos = ['corregir', 'afrontar', 'mantener', 'explotar'];
            let completados = 0;
            
            campos.forEach(campo => {
                const elemento = document.getElementById(campo);
                const contador = document.getElementById('count' + campo.charAt(0).toUpperCase() + campo.slice(1));
                const charCounter = document.getElementById('char' + campo.charAt(0).toUpperCase() + campo.slice(1));
                
                if (elemento && contador && charCounter) {
                    const texto = elemento.value.trim();
                    const caracteres = texto.length;
                    const estrategias = texto ? texto.split('\n').filter(linea => linea.trim().length > 0).length : 0;
                    
                    contador.textContent = estrategias;
                    charCounter.textContent = caracteres + ' caracteres';
                    
                    if (texto.length > 50) { // Mínimo contenido para considerar completo
                        completados++;
                    }
                }
            });
            
            // Actualizar barra de progreso
            const progress = (completados / 4) * 100;
            const progressFill = document.getElementById('progressFill');
            const progressText = document.getElementById('progressText');
            const progressPercent = document.getElementById('progressPercent');
            
            if (progressFill && progressText && progressPercent) {
                progressFill.style.width = progress + '%';
                progressText.textContent = completados + ' de 4 secciones completadas';
                progressPercent.textContent = Math.round(progress) + '%';
            }
            
            // Actualizar vista previa
            actualizarPreview();
        }

        function actualizarPreview() {
            const estrategias = [
                { 
                    id: 'corregir', 
                    clase: 'corregir-preview', 
                    titulo: 'CORREGIR (Debilidades)', 
                    icono: 'fas fa-tools', 
                    color: '#e74c3c',
                    descripcion: 'Estrategias para eliminar debilidades'
                },
                { 
                    id: 'afrontar', 
                    clase: 'afrontar-preview', 
                    titulo: 'AFRONTAR (Amenazas)', 
                    icono: 'fas fa-shield-alt', 
                    color: '#f39c12',
                    descripcion: 'Estrategias para neutralizar amenazas'
                },
                { 
                    id: 'mantener', 
                    clase: 'mantener-preview', 
                    titulo: 'MANTENER (Fortalezas)', 
                    icono: 'fas fa-trophy', 
                    color: '#27ae60',
                    descripcion: 'Estrategias para conservar ventajas'
                },
                { 
                    id: 'explotar', 
                    clase: 'explotar-preview', 
                    titulo: 'EXPLOTAR (Oportunidades)', 
                    icono: 'fas fa-rocket', 
                    color: '#3498db',
                    descripcion: 'Estrategias para capturar valor'
                }
            ];
            
            const previewGrid = document.getElementById('previewGrid');
            if (!previewGrid) return;
            
            previewGrid.innerHTML = '';
            
            estrategias.forEach(estrategia => {
                const elemento = document.getElementById(estrategia.id);
                const texto = elemento ? elemento.value.trim() : '';
                
                const previewDiv = document.createElement('div');
                previewDiv.className = `preview-item ${estrategia.clase}`;
                
                let contenido = '';
                if (texto) {
                    const lineas = texto.split('\n').filter(linea => linea.trim().length > 0);
                    if (lineas.length > 0) {
                        contenido = '<ul style="margin: 10px 0; padding-left: 20px;">';
                        lineas.slice(0, 3).forEach(linea => { // Mostrar máximo 3 estrategias
                            const lineaLimpia = linea.trim().replace(/^[•\-\*]\s*/, '');
                            contenido += `<li style="margin-bottom: 5px; color: #555;">${lineaLimpia}</li>`;
                        });
                        if (lineas.length > 3) {
                            contenido += `<li style="color: #999; font-style: italic;">+ ${lineas.length - 3} estrategias más...</li>`;
                        }
                        contenido += '</ul>';
                    }
                } else {
                    contenido = `<p style="color: #adb5bd; font-style: italic; margin: 10px 0;">No se han definido estrategias para ${estrategia.descripcion.toLowerCase()}</p>`;
                }
                
                previewDiv.innerHTML = `
                    <h4 style="color: #2c3e50; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                        <i class="${estrategia.icono}" style="color: ${estrategia.color};"></i> 
                        ${estrategia.titulo}
                    </h4>
                    ${contenido}
                `;
                
                previewGrid.appendChild(previewDiv);
            });
        }

        // Inicializar cuando se carga la página
        document.addEventListener('DOMContentLoaded', function() {
            const campos = ['corregir', 'afrontar', 'mantener', 'explotar'];
            
            // Agregar listeners a todos los campos
            campos.forEach(id => {
                const elemento = document.getElementById(id);
                if (elemento) {
                    elemento.addEventListener('input', actualizarContadores);
                    elemento.addEventListener('keyup', actualizarContadores);
                }
            });
            
            // Actualizar contadores iniciales
            actualizarContadores();
        });
    </script>
    
    <% if (modoColaborativo) { %>
    <script>
        // Auto-refresh para colaboración (cada 30 segundos)
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
        }, 30000);

        // Marcar como cambiado cuando el usuario escribe
        document.querySelectorAll('textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });
    </script>
    <% } %>
</body>
</html>