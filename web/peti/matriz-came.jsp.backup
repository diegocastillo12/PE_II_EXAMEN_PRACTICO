<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%
    // Verificar si hay una sesión activa
    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener información del usuario
    String usuario = (String) session.getAttribute("usuario");
    String email = (String) session.getAttribute("email");
    String nombreCompleto = (String) session.getAttribute("nombreCompleto");
    
    // Generar iniciales del usuario
    String iniciales = "U";
    if (nombreCompleto != null && !nombreCompleto.trim().isEmpty()) {
        String[] nombres = nombreCompleto.trim().split("\\s+");
        if (nombres.length >= 2) {
            iniciales = nombres[0].substring(0, 1).toUpperCase() + nombres[1].substring(0, 1).toUpperCase();
        } else if (nombres.length == 1) {
            iniciales = nombres[0].substring(0, 1).toUpperCase();
        }
    } else if (usuario != null && !usuario.trim().isEmpty()) {
        iniciales = usuario.substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matriz CAME - Plan Estratégico</title>
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

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            display: flex;
            align-items: center;
            transition: all 0.2s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .card-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            margin-right: 20px;
            flex-shrink: 0;
        }

        .card-content {
            flex: 1;
        }

        .card-content h3 {
            font-size: 16px;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .card-value {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
        }

        .dashboard-section {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        .dashboard-section h2 {
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 20px;
            font-weight: 600;
        }

        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .activity-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .activity-content {
            flex: 1;
        }

        .activity-content p {
            margin: 0 0 5px 0;
            color: #555;
            line-height: 1.4;
        }

        .activity-content strong {
            color: #333;
        }

        .activity-content small {
            color: #999;
            font-size: 12px;
        }

        /* Estilos adicionales para el formulario */
        .breadcrumb-container {
            display: flex;
            align-items: center;
        }

        .breadcrumb {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            align-items: center;
        }

        .breadcrumb li {
            display: flex;
            align-items: center;
        }

        .breadcrumb li:not(:last-child)::after {
            content: '/';
            margin: 0 10px;
            color: #999;
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
            display: flex;
            align-items: center;
            transition: color 0.3s ease;
        }

        .breadcrumb a:hover {
            color: #764ba2;
        }

        .breadcrumb a i {
            margin-right: 5px;
        }

        .section-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .section-status.pending {
            background: #fff3cd;
            color: #856404;
        }

        .section-status i {
            margin-right: 5px;
        }

        .plan-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .plan-section h1 {
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .plan-section h1 i {
            margin-right: 12px;
            color: #667eea;
        }

        .section-description {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .progress-bar-container {
            margin-bottom: 30px;
        }

        .progress {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s ease;
        }

        .progress-text {
            text-align: center;
            margin-top: 8px;
            font-size: 14px;
            color: #666;
        }

        .plan-form {
            display: flex;
            flex-direction: column;
        }

        .form-section {
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 1px solid #eee;
        }

        .form-section:last-of-type {
            border-bottom: none;
        }

        .form-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
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

        .required {
            color: #dc3545;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            background: white;
            resize: vertical;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        .tips-container {
            background: linear-gradient(135deg, #e8f2ff 0%, #f0f8ff 100%);
            border: 1px solid #cce7ff;
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
        }

        .tips-container h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .tips-container h3 i {
            margin-right: 10px;
            color: #667eea;
        }

        .tips-container ul {
            margin: 0;
            padding-left: 20px;
        }

        .tips-container li {
            color: #555;
            margin-bottom: 8px;
            line-height: 1.5;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            padding-top: 30px;
            border-top: 1px solid #eee;
            justify-content: flex-start;
            flex-wrap: wrap;
        }

        .navigation-buttons {
            display: flex;
            gap: 15px;
            margin-left: auto;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .btn i {
            margin-right: 8px;
        }

        .save-button {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .save-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .reset-button {
            background: #6c757d;
            color: white;
        }

        .reset-button:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .prev-button {
            background: #6c757d;
            color: white;
        }

        .prev-button:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .next-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .next-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .plan-nav-container {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        .plan-nav-container h3 {
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 15px;
            font-size: 16px;
            font-weight: 600;
        }

        .subsection {
            margin-bottom: 40px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .subsection h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
            font-weight: 600;
        }

        .subsection-intro {
            color: #666;
            margin-bottom: 20px;
            font-style: italic;
        }

        .estrategia-item {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .col-md-6 {
            flex: 1;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
            margin-top: 10px;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-1px);
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
            }

            .form-actions {
                flex-direction: column;
            }

            .navigation-buttons {
                margin-left: 0;
                flex-direction: column;
            }

            .plan-section {
                padding: 20px;
            }

            .dashboard-header {
                padding: 15px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .breadcrumb-container {
                width: 100%;
            }

            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar de navegación -->
        <div class="dashboard-sidebar">
            <div class="user-profile">
                <div class="user-avatar">
                    <span id="userInitials"><%= iniciales %></span>
                </div>
                <div class="user-info">
                    <h3 id="userName"><%= nombreCompleto != null ? nombreCompleto : usuario %></h3>
                    <p id="userEmail"><%= email != null ? email : "usuario@ejemplo.com" %></p>
                </div>
            </div>
            
            <!-- Navegación principal -->
            <nav class="dashboard-nav">
                <ul>
                    <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                    <li><a href="empresa.jsp"><i class="fas fa-building"></i> Empresa</a></li>
                    <li><a href="mision.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                    <li><a href="vision.jsp"><i class="fas fa-eye"></i> Visión</a></li>
                    <li><a href="valores.jsp"><i class="fas fa-heart"></i> Valores</a></li>
                    <li><a href="analisis-externo.jsp"><i class="fas fa-search"></i> Análisis Externo</a></li>
                    <li><a href="analisis-interno.jsp"><i class="fas fa-chart-bar"></i> Análisis Interno</a></li>
                    <li><a href="pest.jsp"><i class="fas fa-list"></i> Análisis PEST</a></li>
                    <li><a href="porter.jsp"><i class="fas fa-shield-alt"></i> Porter</a></li>
                    <li class="active"><a href="matriz-came.jsp"><i class="fas fa-th"></i> Matriz CAME</a></li>
                    <li><a href="cadena-valor.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                    <li><a href="objetivos.jsp"><i class="fas fa-target"></i> Objetivos</a></li>
                    <li><a href="identificacion-estrategia.jsp"><i class="fas fa-lightbulb"></i> Estrategias</a></li>
                    <li><a href="matriz-participacion.jsp"><i class="fas fa-users"></i> Matriz Participación</a></li>
                    <li><a href="resumen-ejecutivo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    <li><a href="#" onclick="cerrarSesion()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                </ul>
            </nav>
            
            <!-- Navegación del plan estratégico -->
            <div class="plan-nav-container">
                <h3>Plan Estratégico</h3>
                <!-- El menú se generará con JavaScript -->
            </div>
        </div>
        
        <!-- Contenido principal -->
        <div class="dashboard-content">
            <!-- Encabezado -->
            <header class="dashboard-header">
                <div class="breadcrumb-container">
                    <ul class="breadcrumb">
                        <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                        <li><a href="empresa.jsp">Información de la Empresa</a></li>
                        <li><a href="identificacion-estrategia.jsp">Identificación de Estrategias</a></li>
                        <li>Matriz CAME</li>
                    </ul>
                </div>
                <div class="header-actions">
                    <span class="section-status pending"><i class="fas fa-clock"></i> Pendiente</span>
                </div>
            </header>
            
            <!-- Contenido de la sección -->
            <main class="dashboard-main">
                <div class="plan-section">
                    <h1><i class="fas fa-project-diagram"></i> Matriz CAME</h1>
                    <p class="section-description">
                        La matriz CAME (Corregir, Afrontar, Mantener y Explotar) es una herramienta de planificación estratégica que complementa el análisis FODA. Permite definir acciones específicas para cada elemento del FODA: corregir las debilidades, afrontar las amenazas, mantener las fortalezas y explotar las oportunidades.
                    </p>
                    
                    <!-- Barra de progreso -->
                    <div class="progress-bar-container">
                        <div class="progress">
                            <div class="progress-bar" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <div class="progress-text">0% Completado</div>
                    </div>
                    
                    <!-- Formulario -->
                    <form class="plan-form">
                        <div class="form-section">
                            <h2>Resumen del Análisis FODA</h2>
                            <p class="section-intro">Antes de desarrollar la matriz CAME, revisemos los principales elementos del análisis FODA.</p>
                            
                            <div class="form-group">
                                <label for="resumenFortalezas">Principales fortalezas <span class="required">*</span></label>
                                <textarea id="resumenFortalezas" name="resumenFortalezas" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las fortalezas más relevantes identificadas en el análisis interno.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="resumenDebilidades">Principales debilidades <span class="required">*</span></label>
                                <textarea id="resumenDebilidades" name="resumenDebilidades" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las debilidades más relevantes identificadas en el análisis interno.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="resumenOportunidades">Principales oportunidades <span class="required">*</span></label>
                                <textarea id="resumenOportunidades" name="resumenOportunidades" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las oportunidades más relevantes identificadas en el análisis externo.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="resumenAmenazas">Principales amenazas <span class="required">*</span></label>
                                <textarea id="resumenAmenazas" name="resumenAmenazas" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Resuma las amenazas más relevantes identificadas en el análisis externo.</small>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Estrategias CAME</h2>
                            
                            <div class="tips-container">
                                <h3><i class="fas fa-lightbulb"></i> Tipos de Estrategias CAME</h3>
                                <ul>
                                    <li><strong>Estrategias de Reorientación (Corregir):</strong> Acciones para corregir las debilidades aprovechando las oportunidades.</li>
                                    <li><strong>Estrategias de Supervivencia (Afrontar):</strong> Acciones para afrontar las amenazas no dejando crecer las debilidades.</li>
                                    <li><strong>Estrategias Defensivas (Mantener):</strong> Acciones para mantener las fortalezas afrontando las amenazas.</li>
                                    <li><strong>Estrategias Ofensivas (Explotar):</strong> Acciones para explotar las oportunidades aprovechando las fortalezas.</li>
                                </ul>
                            </div>
                            
                            <!-- Estrategias de Reorientación (DO) -->
                            <div class="subsection">
                                <h3>1. Estrategias de Reorientación (Corregir Debilidades + Aprovechar Oportunidades)</h3>
                                <p class="subsection-intro">Estas estrategias buscan corregir las debilidades internas aprovechando las oportunidades externas.</p>
                                
                                <div id="estrategiasReorientacionContainer">
                                    <!-- Plantilla para estrategia de reorientación -->
                                    <div class="estrategia-item">
                                        <div class="form-group">
                                            <label for="nombreEstrategiaReorientacion1">Nombre de la estrategia <span class="required">*</span></label>
                                            <input type="text" id="nombreEstrategiaReorientacion1" name="nombreEstrategiaReorientacion1" class="form-control" required>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="descripcionEstrategiaReorientacion1">Descripción de la estrategia <span class="required">*</span></label>
                                            <textarea id="descripcionEstrategiaReorientacion1" name="descripcionEstrategiaReorientacion1" class="form-control" rows="3" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="debilidadRelacionadaReorientacion1">Debilidad relacionada <span class="required">*</span></label>
                                                <textarea id="debilidadRelacionadaReorientacion1" name="debilidadRelacionadaReorientacion1" class="form-control" rows="2" required></textarea>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="oportunidadRelacionadaReorientacion1">Oportunidad relacionada <span class="required">*</span></label>
                                                <textarea id="oportunidadRelacionadaReorientacion1" name="oportunidadRelacionadaReorientacion1" class="form-control" rows="2" required></textarea>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="accionesEstrategiaReorientacion1">Acciones específicas <span class="required">*</span></label>
                                            <textarea id="accionesEstrategiaReorientacion1" name="accionesEstrategiaReorientacion1" class="form-control" rows="3" required></textarea>
                                            <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="recursosEstrategiaReorientacion1">Recursos necesarios <span class="required">*</span></label>
                                            <textarea id="recursosEstrategiaReorientacion1" name="recursosEstrategiaReorientacion1" class="form-control" rows="2" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="responsableEstrategiaReorientacion1">Responsable <span class="required">*</span></label>
                                                <input type="text" id="responsableEstrategiaReorientacion1" name="responsableEstrategiaReorientacion1" class="form-control" required>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="plazoEstrategiaReorientacion1">Plazo de implementación <span class="required">*</span></label>
                                                <select id="plazoEstrategiaReorientacion1" name="plazoEstrategiaReorientacion1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="corto">Corto plazo (< 1 año)</option>
                                                    <option value="medio">Mediano plazo (1-3 años)</option>
                                                    <option value="largo">Largo plazo (> 3 años)</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                                    </div>
                                </div>
                                
                                <button type="button" class="btn btn-primary" id="addEstrategiaReorientacion"><i class="fas fa-plus"></i> Agregar estrategia de reorientación</button>
                            </div>
                            
                            <!-- Estrategias de Supervivencia (DA) -->
                            <div class="subsection">
                                <h3>2. Estrategias de Supervivencia (Afrontar Amenazas + Corregir Debilidades)</h3>
                                <p class="subsection-intro">Estas estrategias buscan afrontar las amenazas externas no dejando crecer las debilidades internas.</p>
                                
                                <div id="estrategiasSupervivenciaContainer">
                                    <!-- Plantilla para estrategia de supervivencia -->
                                    <div class="estrategia-item">
                                        <div class="form-group">
                                            <label for="nombreEstrategiaSupervivencia1">Nombre de la estrategia <span class="required">*</span></label>
                                            <input type="text" id="nombreEstrategiaSupervivencia1" name="nombreEstrategiaSupervivencia1" class="form-control" required>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="descripcionEstrategiaSupervivencia1">Descripción de la estrategia <span class="required">*</span></label>
                                            <textarea id="descripcionEstrategiaSupervivencia1" name="descripcionEstrategiaSupervivencia1" class="form-control" rows="3" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="debilidadRelacionadaSupervivencia1">Debilidad relacionada <span class="required">*</span></label>
                                                <textarea id="debilidadRelacionadaSupervivencia1" name="debilidadRelacionadaSupervivencia1" class="form-control" rows="2" required></textarea>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="amenazaRelacionadaSupervivencia1">Amenaza relacionada <span class="required">*</span></label>
                                                <textarea id="amenazaRelacionadaSupervivencia1" name="amenazaRelacionadaSupervivencia1" class="form-control" rows="2" required></textarea>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="accionesEstrategiaSupervivencia1">Acciones específicas <span class="required">*</span></label>
                                            <textarea id="accionesEstrategiaSupervivencia1" name="accionesEstrategiaSupervivencia1" class="form-control" rows="3" required></textarea>
                                            <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="recursosEstrategiaSupervivencia1">Recursos necesarios <span class="required">*</span></label>
                                            <textarea id="recursosEstrategiaSupervivencia1" name="recursosEstrategiaSupervivencia1" class="form-control" rows="2" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="responsableEstrategiaSupervivencia1">Responsable <span class="required">*</span></label>
                                                <input type="text" id="responsableEstrategiaSupervivencia1" name="responsableEstrategiaSupervivencia1" class="form-control" required>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="plazoEstrategiaSupervivencia1">Plazo de implementación <span class="required">*</span></label>
                                                <select id="plazoEstrategiaSupervivencia1" name="plazoEstrategiaSupervivencia1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="corto">Corto plazo (< 1 año)</option>
                                                    <option value="medio">Mediano plazo (1-3 años)</option>
                                                    <option value="largo">Largo plazo (> 3 años)</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                                    </div>
                                </div>
                                
                                <button type="button" class="btn btn-primary" id="addEstrategiaSupervivencia"><i class="fas fa-plus"></i> Agregar estrategia de supervivencia</button>
                            </div>
                            
                            <!-- Estrategias Defensivas (FA) -->
                            <div class="subsection">
                                <h3>3. Estrategias Defensivas (Mantener Fortalezas + Afrontar Amenazas)</h3>
                                <p class="subsection-intro">Estas estrategias buscan mantener las fortalezas internas para afrontar las amenazas externas.</p>
                                
                                <div id="estrategiasDefensivasContainer">
                                    <!-- Plantilla para estrategia defensiva -->
                                    <div class="estrategia-item">
                                        <div class="form-group">
                                            <label for="nombreEstrategiaDefensiva1">Nombre de la estrategia <span class="required">*</span></label>
                                            <input type="text" id="nombreEstrategiaDefensiva1" name="nombreEstrategiaDefensiva1" class="form-control" required>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="descripcionEstrategiaDefensiva1">Descripción de la estrategia <span class="required">*</span></label>
                                            <textarea id="descripcionEstrategiaDefensiva1" name="descripcionEstrategiaDefensiva1" class="form-control" rows="3" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="fortalezaRelacionadaDefensiva1">Fortaleza relacionada <span class="required">*</span></label>
                                                <textarea id="fortalezaRelacionadaDefensiva1" name="fortalezaRelacionadaDefensiva1" class="form-control" rows="2" required></textarea>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="amenazaRelacionadaDefensiva1">Amenaza relacionada <span class="required">*</span></label>
                                                <textarea id="amenazaRelacionadaDefensiva1" name="amenazaRelacionadaDefensiva1" class="form-control" rows="2" required></textarea>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="accionesEstrategiaDefensiva1">Acciones específicas <span class="required">*</span></label>
                                            <textarea id="accionesEstrategiaDefensiva1" name="accionesEstrategiaDefensiva1" class="form-control" rows="3" required></textarea>
                                            <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="recursosEstrategiaDefensiva1">Recursos necesarios <span class="required">*</span></label>
                                            <textarea id="recursosEstrategiaDefensiva1" name="recursosEstrategiaDefensiva1" class="form-control" rows="2" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="responsableEstrategiaDefensiva1">Responsable <span class="required">*</span></label>
                                                <input type="text" id="responsableEstrategiaDefensiva1" name="responsableEstrategiaDefensiva1" class="form-control" required>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="plazoEstrategiaDefensiva1">Plazo de implementación <span class="required">*</span></label>
                                                <select id="plazoEstrategiaDefensiva1" name="plazoEstrategiaDefensiva1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="corto">Corto plazo (< 1 año)</option>
                                                    <option value="medio">Mediano plazo (1-3 años)</option>
                                                    <option value="largo">Largo plazo (> 3 años)</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                                    </div>
                                </div>
                                
                                <button type="button" class="btn btn-primary" id="addEstrategiaDefensiva"><i class="fas fa-plus"></i> Agregar estrategia defensiva</button>
                            </div>
                            
                            <!-- Estrategias Ofensivas (FO) -->
                            <div class="subsection">
                                <h3>4. Estrategias Ofensivas (Explotar Oportunidades + Mantener Fortalezas)</h3>
                                <p class="subsection-intro">Estas estrategias buscan explotar las oportunidades externas aprovechando las fortalezas internas.</p>
                                
                                <div id="estrategiasOfensivasContainer">
                                    <!-- Plantilla para estrategia ofensiva -->
                                    <div class="estrategia-item">
                                        <div class="form-group">
                                            <label for="nombreEstrategiaOfensiva1">Nombre de la estrategia <span class="required">*</span></label>
                                            <input type="text" id="nombreEstrategiaOfensiva1" name="nombreEstrategiaOfensiva1" class="form-control" required>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="descripcionEstrategiaOfensiva1">Descripción de la estrategia <span class="required">*</span></label>
                                            <textarea id="descripcionEstrategiaOfensiva1" name="descripcionEstrategiaOfensiva1" class="form-control" rows="3" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="fortalezaRelacionadaOfensiva1">Fortaleza relacionada <span class="required">*</span></label>
                                                <textarea id="fortalezaRelacionadaOfensiva1" name="fortalezaRelacionadaOfensiva1" class="form-control" rows="2" required></textarea>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="oportunidadRelacionadaOfensiva1">Oportunidad relacionada <span class="required">*</span></label>
                                                <textarea id="oportunidadRelacionadaOfensiva1" name="oportunidadRelacionadaOfensiva1" class="form-control" rows="2" required></textarea>
                                            </div>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="accionesEstrategiaOfensiva1">Acciones específicas <span class="required">*</span></label>
                                            <textarea id="accionesEstrategiaOfensiva1" name="accionesEstrategiaOfensiva1" class="form-control" rows="3" required></textarea>
                                            <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label for="recursosEstrategiaOfensiva1">Recursos necesarios <span class="required">*</span></label>
                                            <textarea id="recursosEstrategiaOfensiva1" name="recursosEstrategiaOfensiva1" class="form-control" rows="2" required></textarea>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="responsableEstrategiaOfensiva1">Responsable <span class="required">*</span></label>
                                                <input type="text" id="responsableEstrategiaOfensiva1" name="responsableEstrategiaOfensiva1" class="form-control" required>
                                            </div>
                                            
                                            <div class="form-group col-md-6">
                                                <label for="plazoEstrategiaOfensiva1">Plazo de implementación <span class="required">*</span></label>
                                                <select id="plazoEstrategiaOfensiva1" name="plazoEstrategiaOfensiva1" class="form-control" required>
                                                    <option value="">Seleccionar...</option>
                                                    <option value="corto">Corto plazo (< 1 año)</option>
                                                    <option value="medio">Mediano plazo (1-3 años)</option>
                                                    <option value="largo">Largo plazo (> 3 años)</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                                    </div>
                                </div>
                                
                                <button type="button" class="btn btn-primary" id="addEstrategiaOfensiva"><i class="fas fa-plus"></i> Agregar estrategia ofensiva</button>
                            </div>
                        </div>
                        
                        <div class="form-section">
                            <h2>Priorización de Estrategias CAME</h2>
                            
                            <div class="form-group">
                                <label for="estrategiasPrioritarias">Estrategias prioritarias <span class="required">*</span></label>
                                <textarea id="estrategiasPrioritarias" name="estrategiasPrioritarias" class="form-control" rows="4" required></textarea>
                                <small class="form-text">Identifique las estrategias CAME que considera prioritarias y explique por qué.</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="criteriosPriorizacion">Criterios de priorización utilizados <span class="required">*</span></label>
                                <textarea id="criteriosPriorizacion" name="criteriosPriorizacion" class="form-control" rows="3" required></textarea>
                                <small class="form-text">Explique los criterios utilizados para priorizar las estrategias (ej. impacto esperado, urgencia, factibilidad, etc.).</small>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="button" class="btn save-button"><i class="fas fa-save"></i> Guardar</button>
                            <button type="button" class="btn reset-button"><i class="fas fa-undo"></i> Restablecer</button>
                            <div class="navigation-buttons">
                                <a href="identificacion-estrategia.jsp" class="btn prev-button"><i class="fas fa-arrow-left"></i> Anterior: Identificación de Estrategias</a>
                                <a href="resumen-ejecutivo.jsp" class="btn next-button"><i class="fas fa-arrow-right"></i> Siguiente: Resumen Ejecutivo</a>
                            </div>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
    
    <script src="js/auth.js"></script>
    <script src="js/storage.js"></script>
    <script src="js/navigation.js"></script>
    <script src="js/forms.js"></script>
    <script src="js/progress.js"></script>
    
    <!-- Script específico para la matriz CAME -->
    <script>
        // Función para cerrar sesión
        function cerrarSesion() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = '../logout.jsp';
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            // Contadores para los IDs de las estrategias
            let estrategiaReorientacionCount = 1;
            let estrategiaSupervivenciaCount = 1;
            let estrategiaDefensivaCount = 1;
            let estrategiaOfensivaCount = 1;
            
            // Función para agregar una nueva estrategia de reorientación
            document.getElementById('addEstrategiaReorientacion').addEventListener('click', function() {
                estrategiaReorientacionCount++;
                const container = document.getElementById('estrategiasReorientacionContainer');
                const newEstrategia = document.createElement('div');
                newEstrategia.className = 'estrategia-item';
                newEstrategia.innerHTML = `
                    <hr>
                    <div class="form-group">
                        <label for="nombreEstrategiaReorientacion${estrategiaReorientacionCount}">Nombre de la estrategia <span class="required">*</span></label>
                        <input type="text" id="nombreEstrategiaReorientacion${estrategiaReorientacionCount}" name="nombreEstrategiaReorientacion${estrategiaReorientacionCount}" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="descripcionEstrategiaReorientacion${estrategiaReorientacionCount}">Descripción de la estrategia <span class="required">*</span></label>
                        <textarea id="descripcionEstrategiaReorientacion${estrategiaReorientacionCount}" name="descripcionEstrategiaReorientacion${estrategiaReorientacionCount}" class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="debilidadRelacionadaReorientacion${estrategiaReorientacionCount}">Debilidad relacionada <span class="required">*</span></label>
                            <textarea id="debilidadRelacionadaReorientacion${estrategiaReorientacionCount}" name="debilidadRelacionadaReorientacion${estrategiaReorientacionCount}" class="form-control" rows="2" required></textarea>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="oportunidadRelacionadaReorientacion${estrategiaReorientacionCount}">Oportunidad relacionada <span class="required">*</span></label>
                            <textarea id="oportunidadRelacionadaReorientacion${estrategiaReorientacionCount}" name="oportunidadRelacionadaReorientacion${estrategiaReorientacionCount}" class="form-control" rows="2" required></textarea>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="accionesEstrategiaReorientacion${estrategiaReorientacionCount}">Acciones específicas <span class="required">*</span></label>
                        <textarea id="accionesEstrategiaReorientacion${estrategiaReorientacionCount}" name="accionesEstrategiaReorientacion${estrategiaReorientacionCount}" class="form-control" rows="3" required></textarea>
                        <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="recursosEstrategiaReorientacion${estrategiaReorientacionCount}">Recursos necesarios <span class="required">*</span></label>
                        <textarea id="recursosEstrategiaReorientacion${estrategiaReorientacionCount}" name="recursosEstrategiaReorientacion${estrategiaReorientacionCount}" class="form-control" rows="2" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="responsableEstrategiaReorientacion${estrategiaReorientacionCount}">Responsable <span class="required">*</span></label>
                            <input type="text" id="responsableEstrategiaReorientacion${estrategiaReorientacionCount}" name="responsableEstrategiaReorientacion${estrategiaReorientacionCount}" class="form-control" required>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="plazoEstrategiaReorientacion${estrategiaReorientacionCount}">Plazo de implementación <span class="required">*</span></label>
                            <select id="plazoEstrategiaReorientacion${estrategiaReorientacionCount}" name="plazoEstrategiaReorientacion${estrategiaReorientacionCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="corto">Corto plazo (< 1 año)</option>
                                <option value="medio">Mediano plazo (1-3 años)</option>
                                <option value="largo">Largo plazo (> 3 años)</option>
                            </select>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                `;
                container.appendChild(newEstrategia);
                
                // Agregar evento para eliminar la estrategia
                newEstrategia.querySelector('.remove-estrategia').addEventListener('click', function() {
                    container.removeChild(newEstrategia);
                });
            });
            
            // Función para agregar una nueva estrategia de supervivencia
            document.getElementById('addEstrategiaSupervivencia').addEventListener('click', function() {
                estrategiaSupervivenciaCount++;
                const container = document.getElementById('estrategiasSupervivenciaContainer');
                const newEstrategia = document.createElement('div');
                newEstrategia.className = 'estrategia-item';
                newEstrategia.innerHTML = `
                    <hr>
                    <div class="form-group">
                        <label for="nombreEstrategiaSupervivencia${estrategiaSupervivenciaCount}">Nombre de la estrategia <span class="required">*</span></label>
                        <input type="text" id="nombreEstrategiaSupervivencia${estrategiaSupervivenciaCount}" name="nombreEstrategiaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="descripcionEstrategiaSupervivencia${estrategiaSupervivenciaCount}">Descripción de la estrategia <span class="required">*</span></label>
                        <textarea id="descripcionEstrategiaSupervivencia${estrategiaSupervivenciaCount}" name="descripcionEstrategiaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="debilidadRelacionadaSupervivencia${estrategiaSupervivenciaCount}">Debilidad relacionada <span class="required">*</span></label>
                            <textarea id="debilidadRelacionadaSupervivencia${estrategiaSupervivenciaCount}" name="debilidadRelacionadaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" rows="2" required></textarea>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="amenazaRelacionadaSupervivencia${estrategiaSupervivenciaCount}">Amenaza relacionada <span class="required">*</span></label>
                            <textarea id="amenazaRelacionadaSupervivencia${estrategiaSupervivenciaCount}" name="amenazaRelacionadaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" rows="2" required></textarea>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="accionesEstrategiaSupervivencia${estrategiaSupervivenciaCount}">Acciones específicas <span class="required">*</span></label>
                        <textarea id="accionesEstrategiaSupervivencia${estrategiaSupervivenciaCount}" name="accionesEstrategiaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" rows="3" required></textarea>
                        <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="recursosEstrategiaSupervivencia${estrategiaSupervivenciaCount}">Recursos necesarios <span class="required">*</span></label>
                        <textarea id="recursosEstrategiaSupervivencia${estrategiaSupervivenciaCount}" name="recursosEstrategiaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" rows="2" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="responsableEstrategiaSupervivencia${estrategiaSupervivenciaCount}">Responsable <span class="required">*</span></label>
                            <input type="text" id="responsableEstrategiaSupervivencia${estrategiaSupervivenciaCount}" name="responsableEstrategiaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" required>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="plazoEstrategiaSupervivencia${estrategiaSupervivenciaCount}">Plazo de implementación <span class="required">*</span></label>
                            <select id="plazoEstrategiaSupervivencia${estrategiaSupervivenciaCount}" name="plazoEstrategiaSupervivencia${estrategiaSupervivenciaCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="corto">Corto plazo (< 1 año)</option>
                                <option value="medio">Mediano plazo (1-3 años)</option>
                                <option value="largo">Largo plazo (> 3 años)</option>
                            </select>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                `;
                container.appendChild(newEstrategia);
                
                // Agregar evento para eliminar la estrategia
                newEstrategia.querySelector('.remove-estrategia').addEventListener('click', function() {
                    container.removeChild(newEstrategia);
                });
            });
            
            // Función para agregar una nueva estrategia defensiva
            document.getElementById('addEstrategiaDefensiva').addEventListener('click', function() {
                estrategiaDefensivaCount++;
                const container = document.getElementById('estrategiasDefensivasContainer');
                const newEstrategia = document.createElement('div');
                newEstrategia.className = 'estrategia-item';
                newEstrategia.innerHTML = `
                    <hr>
                    <div class="form-group">
                        <label for="nombreEstrategiaDefensiva${estrategiaDefensivaCount}">Nombre de la estrategia <span class="required">*</span></label>
                        <input type="text" id="nombreEstrategiaDefensiva${estrategiaDefensivaCount}" name="nombreEstrategiaDefensiva${estrategiaDefensivaCount}" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="descripcionEstrategiaDefensiva${estrategiaDefensivaCount}">Descripción de la estrategia <span class="required">*</span></label>
                        <textarea id="descripcionEstrategiaDefensiva${estrategiaDefensivaCount}" name="descripcionEstrategiaDefensiva${estrategiaDefensivaCount}" class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="fortalezaRelacionadaDefensiva${estrategiaDefensivaCount}">Fortaleza relacionada <span class="required">*</span></label>
                            <textarea id="fortalezaRelacionadaDefensiva${estrategiaDefensivaCount}" name="fortalezaRelacionadaDefensiva${estrategiaDefensivaCount}" class="form-control" rows="2" required></textarea>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="amenazaRelacionadaDefensiva${estrategiaDefensivaCount}">Amenaza relacionada <span class="required">*</span></label>
                            <textarea id="amenazaRelacionadaDefensiva${estrategiaDefensivaCount}" name="amenazaRelacionadaDefensiva${estrategiaDefensivaCount}" class="form-control" rows="2" required></textarea>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="accionesEstrategiaDefensiva${estrategiaDefensivaCount}">Acciones específicas <span class="required">*</span></label>
                        <textarea id="accionesEstrategiaDefensiva${estrategiaDefensivaCount}" name="accionesEstrategiaDefensiva${estrategiaDefensivaCount}" class="form-control" rows="3" required></textarea>
                        <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="recursosEstrategiaDefensiva${estrategiaDefensivaCount}">Recursos necesarios <span class="required">*</span></label>
                        <textarea id="recursosEstrategiaDefensiva${estrategiaDefensivaCount}" name="recursosEstrategiaDefensiva${estrategiaDefensivaCount}" class="form-control" rows="2" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="responsableEstrategiaDefensiva${estrategiaDefensivaCount}">Responsable <span class="required">*</span></label>
                            <input type="text" id="responsableEstrategiaDefensiva${estrategiaDefensivaCount}" name="responsableEstrategiaDefensiva${estrategiaDefensivaCount}" class="form-control" required>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="plazoEstrategiaDefensiva${estrategiaDefensivaCount}">Plazo de implementación <span class="required">*</span></label>
                            <select id="plazoEstrategiaDefensiva${estrategiaDefensivaCount}" name="plazoEstrategiaDefensiva${estrategiaDefensivaCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="corto">Corto plazo (< 1 año)</option>
                                <option value="medio">Mediano plazo (1-3 años)</option>
                                <option value="largo">Largo plazo (> 3 años)</option>
                            </select>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                `;
                container.appendChild(newEstrategia);
                
                // Agregar evento para eliminar la estrategia
                newEstrategia.querySelector('.remove-estrategia').addEventListener('click', function() {
                    container.removeChild(newEstrategia);
                });
            });
            
            // Función para agregar una nueva estrategia ofensiva
            document.getElementById('addEstrategiaOfensiva').addEventListener('click', function() {
                estrategiaOfensivaCount++;
                const container = document.getElementById('estrategiasOfensivasContainer');
                const newEstrategia = document.createElement('div');
                newEstrategia.className = 'estrategia-item';
                newEstrategia.innerHTML = `
                    <hr>
                    <div class="form-group">
                        <label for="nombreEstrategiaOfensiva${estrategiaOfensivaCount}">Nombre de la estrategia <span class="required">*</span></label>
                        <input type="text" id="nombreEstrategiaOfensiva${estrategiaOfensivaCount}" name="nombreEstrategiaOfensiva${estrategiaOfensivaCount}" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="descripcionEstrategiaOfensiva${estrategiaOfensivaCount}">Descripción de la estrategia <span class="required">*</span></label>
                        <textarea id="descripcionEstrategiaOfensiva${estrategiaOfensivaCount}" name="descripcionEstrategiaOfensiva${estrategiaOfensivaCount}" class="form-control" rows="3" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="fortalezaRelacionadaOfensiva${estrategiaOfensivaCount}">Fortaleza relacionada <span class="required">*</span></label>
                            <textarea id="fortalezaRelacionadaOfensiva${estrategiaOfensivaCount}" name="fortalezaRelacionadaOfensiva${estrategiaOfensivaCount}" class="form-control" rows="2" required></textarea>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="oportunidadRelacionadaOfensiva${estrategiaOfensivaCount}">Oportunidad relacionada <span class="required">*</span></label>
                            <textarea id="oportunidadRelacionadaOfensiva${estrategiaOfensivaCount}" name="oportunidadRelacionadaOfensiva${estrategiaOfensivaCount}" class="form-control" rows="2" required></textarea>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="accionesEstrategiaOfensiva${estrategiaOfensivaCount}">Acciones específicas <span class="required">*</span></label>
                        <textarea id="accionesEstrategiaOfensiva${estrategiaOfensivaCount}" name="accionesEstrategiaOfensiva${estrategiaOfensivaCount}" class="form-control" rows="3" required></textarea>
                        <small class="form-text">Detalle las acciones concretas para implementar esta estrategia.</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="recursosEstrategiaOfensiva${estrategiaOfensivaCount}">Recursos necesarios <span class="required">*</span></label>
                        <textarea id="recursosEstrategiaOfensiva${estrategiaOfensivaCount}" name="recursosEstrategiaOfensiva${estrategiaOfensivaCount}" class="form-control" rows="2" required></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="responsableEstrategiaOfensiva${estrategiaOfensivaCount}">Responsable <span class="required">*</span></label>
                            <input type="text" id="responsableEstrategiaOfensiva${estrategiaOfensivaCount}" name="responsableEstrategiaOfensiva${estrategiaOfensivaCount}" class="form-control" required>
                        </div>
                        
                        <div class="form-group col-md-6">
                            <label for="plazoEstrategiaOfensiva${estrategiaOfensivaCount}">Plazo de implementación <span class="required">*</span></label>
                            <select id="plazoEstrategiaOfensiva${estrategiaOfensivaCount}" name="plazoEstrategiaOfensiva${estrategiaOfensivaCount}" class="form-control" required>
                                <option value="">Seleccionar...</option>
                                <option value="corto">Corto plazo (< 1 año)</option>
                                <option value="medio">Mediano plazo (1-3 años)</option>
                                <option value="largo">Largo plazo (> 3 años)</option>
                            </select>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-danger remove-estrategia"><i class="fas fa-trash"></i> Eliminar</button>
                `;
                container.appendChild(newEstrategia);
                
                // Agregar evento para eliminar la estrategia
                newEstrategia.querySelector('.remove-estrategia').addEventListener('click', function() {
                    container.removeChild(newEstrategia);
                });
            });
            
            // Agregar eventos para eliminar estrategias existentes
            document.querySelectorAll('.remove-estrategia').forEach(function(button) {
                button.addEventListener('click', function() {
                    const estrategiaItem = button.closest('.estrategia-item');
                    estrategiaItem.parentNode.removeChild(estrategiaItem);
                });
            });
        });
    </script>
</body>
</html>