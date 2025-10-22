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
    
    // Variables para las cinco fuerzas de Porter
    String poderProveedores = "";
    String poderCompradores = "";
    String amenazaSustitutos = "";
    String amenazaEntrantes = "";
    String rivalidadExistentes = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevosProveedores = request.getParameter("proveedores");
        String nuevosCompradores = request.getParameter("compradores");
        String nuevosSustitutos = request.getParameter("sustitutos");
        String nuevosEntrantes = request.getParameter("entrantes");
        String nuevaRivalidad = request.getParameter("rivalidad");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevosProveedores != null && !nuevosProveedores.trim().isEmpty()) {
                ClsEPeti datoProveedores = new ClsEPeti(grupoId, "porter", "proveedores", nuevosProveedores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoProveedores);
            }
            if (nuevosCompradores != null && !nuevosCompradores.trim().isEmpty()) {
                ClsEPeti datoCompradores = new ClsEPeti(grupoId, "porter", "compradores", nuevosCompradores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoCompradores);
            }
            if (nuevosSustitutos != null && !nuevosSustitutos.trim().isEmpty()) {
                ClsEPeti datoSustitutos = new ClsEPeti(grupoId, "porter", "sustitutos", nuevosSustitutos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoSustitutos);
            }
            if (nuevosEntrantes != null && !nuevosEntrantes.trim().isEmpty()) {
                ClsEPeti datoEntrantes = new ClsEPeti(grupoId, "porter", "entrantes", nuevosEntrantes.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoEntrantes);
            }
            if (nuevaRivalidad != null && !nuevaRivalidad.trim().isEmpty()) {
                ClsEPeti datoRivalidad = new ClsEPeti(grupoId, "porter", "rivalidad", nuevaRivalidad.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoRivalidad);
            }
            
            if (exito) {
                mensaje = "Análisis de las 5 Fuerzas de Porter guardado exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar el análisis de Porter";
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
            Map<String, String> datosPorter = negocioPeti.obtenerDatosSeccion(grupoId, "porter");
            
            if (datosPorter.containsKey("proveedores")) {
                poderProveedores = datosPorter.get("proveedores");
            }
            if (datosPorter.containsKey("compradores")) {
                poderCompradores = datosPorter.get("compradores");
            }
            if (datosPorter.containsKey("sustitutos")) {
                amenazaSustitutos = datosPorter.get("sustitutos");
            }
            if (datosPorter.containsKey("entrantes")) {
                amenazaEntrantes = datosPorter.get("entrantes");
            }
            if (datosPorter.containsKey("rivalidad")) {
                rivalidadExistentes = datosPorter.get("rivalidad");
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
    <title>5 Fuerzas de Porter - PETI Colaborativo</title>
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
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            color: #2c3e50;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 700;
        }

        .porter-logo {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            padding: 12px 16px;
            border-radius: 12px;
            font-weight: bold;
            font-size: 18px;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
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

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
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

        .content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .alert {
            padding: 18px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }

        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .alert-warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
        }

        .porter-intro {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(231, 76, 60, 0.3);
        }

        .porter-intro h2 {
            font-size: 32px;
            margin-bottom: 15px;
        }

        .porter-intro p {
            font-size: 18px;
            opacity: 0.95;
        }

        /* Nuevo diseño de formulario por secciones */
        .forces-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .force-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            border-left: 6px solid;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .force-section:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .force-section.entrantes {
            border-left-color: #e74c3c;
        }

        .force-section.proveedores {
            border-left-color: #17a2b8;
        }

        .force-section.rivalidad {
            border-left-color: #ffc107;
        }

        .force-section.compradores {
            border-left-color: #6f42c1;
        }

        .force-section.sustitutos {
            border-left-color: #e83e8c;
        }

        .force-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .force-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            font-weight: bold;
        }

        .force-section.entrantes .force-icon {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        }

        .force-section.proveedores .force-icon {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        }

        .force-section.rivalidad .force-icon {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
        }

        .force-section.compradores .force-icon {
            background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%);
        }

        .force-section.sustitutos .force-icon {
            background: linear-gradient(135deg, #e83e8c 0%, #d91a72 100%);
        }

        .force-title {
            font-size: 22px;
            font-weight: 700;
            color: #2c3e50;
        }

        .force-description {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 1px solid #e9ecef;
        }

        .force-description h4 {
            color: #495057;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .force-description ul {
            color: #6c757d;
            font-size: 14px;
            padding-left: 20px;
        }

        .force-description li {
            margin-bottom: 5px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 16px;
        }

        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 15px;
            min-height: 120px;
            resize: vertical;
            transition: all 0.3s ease;
            background: white;
            color: #2c3e50;
            font-family: inherit;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea::placeholder {
            color: #adb5bd;
            font-style: italic;
        }

        .counter-badge {
            background: #667eea;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: auto;
        }

        .preview-box {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }

        .preview-box h5 {
            color: #495057;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .preview-list {
            list-style: none;
            padding: 0;
        }

        .preview-list li {
            background: white;
            padding: 8px 12px;
            margin-bottom: 5px;
            border-radius: 5px;
            border-left: 3px solid #667eea;
            font-size: 14px;
            color: #495057;
        }

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

        .summary-stats {
            background: #e3f2fd;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border: 1px solid #bbdefb;
        }

        .summary-stats h3 {
            color: #1976d2;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .stat-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            border-top: 4px solid;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .stat-item.entrantes { border-top-color: #e74c3c; }
        .stat-item.proveedores { border-top-color: #17a2b8; }
        .stat-item.rivalidad { border-top-color: #ffc107; }
        .stat-item.compradores { border-top-color: #6f42c1; }
        .stat-item.sustitutos { border-top-color: #e83e8c; }

        .stat-number {
            font-size: 32px;
            font-weight: 800;
            color: #2c3e50;
            display: block;
        }

        .stat-label {
            font-size: 14px;
            color: #6c757d;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .forces-container {
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
                    <span class="porter-logo">5F</span>
                    5 Fuerzas de Porter
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

            <div class="porter-intro">
                <h2>⚔️ Análisis de las 5 Fuerzas de Porter</h2>
                <p>Evalúa la intensidad competitiva y el atractivo de tu industria completando cada una de las cinco fuerzas</p>
            </div>

            <div class="summary-stats">
                <h3><i class="fas fa-chart-bar"></i> Resumen del Análisis</h3>
                <div class="stats-grid">
                    <div class="stat-item entrantes">
                        <span class="stat-number" id="countEntrantes">0</span>
                        <div class="stat-label">Nuevos Entrantes</div>
                    </div>
                    <div class="stat-item proveedores">
                        <span class="stat-number" id="countProveedores">0</span>
                        <div class="stat-label">Poder Proveedores</div>
                    </div>
                    <div class="stat-item rivalidad">
                        <span class="stat-number" id="countRivalidad">0</span>
                        <div class="stat-label">Rivalidad</div>
                    </div>
                    <div class="stat-item compradores">
                        <span class="stat-number" id="countCompradores">0</span>
                        <div class="stat-label">Poder Compradores</div>
                    </div>
                    <div class="stat-item sustitutos">
                        <span class="stat-number" id="countSustitutos">0</span>
                        <div class="stat-label">Productos Sustitutos</div>
                    </div>
                </div>
            </div>

            <form method="post" action="">
                <div class="forces-container">
                    <!-- Amenaza de Nuevos Entrantes -->
                    <div class="force-section entrantes">
                        <div class="force-header">
                            <div class="force-icon">
                                <i class="fas fa-door-open"></i>
                            </div>
                            <div>
                                <div class="force-title">Amenaza de Nuevos Entrantes</div>
                                <span class="counter-badge" id="badgeEntrantes">0 factores</span>
                            </div>
                        </div>
                        
                        <div class="force-description">
                            <h4>🚪 Factores a considerar:</h4>
                            <ul>
                                <li>Barreras de entrada (capital, tecnología, licencias)</li>
                                <li>Economías de escala existentes</li>
                                <li>Diferenciación de productos</li>
                                <li>Acceso a canales de distribución</li>
                                <li>Respuesta esperada de competidores actuales</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="entrantes">Describe los factores de nuevos entrantes:</label>
                            <textarea 
                                id="entrantes" 
                                name="entrantes"
                                placeholder="Ejemplo:&#10;• Altas barreras de entrada por inversión inicial de $5M&#10;• Necesidad de licencias especializadas del gobierno&#10;• Marca establecida con 20 años de experiencia&#10;• Red de distribución exclusiva con principales retailers"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores('entrantes', 'countEntrantes', 'badgeEntrantes', 'previewEntrantes')"
                            ><%= amenazaEntrantes %></textarea>
                        </div>

                        <div class="preview-box">
                            <h5><i class="fas fa-eye"></i> Vista Previa:</h5>
                            <ul class="preview-list" id="previewEntrantes">
                                <% if (!amenazaEntrantes.isEmpty()) { %>
                                    <%
                                        String[] lineasEnt = amenazaEntrantes.split("\\n");
                                        for (String linea : lineasEnt) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li style="color: #adb5bd; font-style: italic;">Los factores aparecerán aquí mientras escribes...</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Poder de Negociación de Proveedores -->
                    <div class="force-section proveedores">
                        <div class="force-header">
                            <div class="force-icon">
                                <i class="fas fa-truck"></i>
                            </div>
                            <div>
                                <div class="force-title">Poder de Proveedores</div>
                                <span class="counter-badge" id="badgeProveedores">0 factores</span>
                            </div>
                        </div>
                        
                        <div class="force-description">
                            <h4>🚚 Factores a considerar:</h4>
                            <ul>
                                <li>Concentración de proveedores vs compradores</li>
                                <li>Diferenciación de insumos</li>
                                <li>Costos de cambio de proveedor</li>
                                <li>Presencia de insumos sustitutos</li>
                                <li>Amenaza de integración hacia adelante</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="proveedores">Describe el poder de negociación de proveedores:</label>
                            <textarea 
                                id="proveedores" 
                                name="proveedores"
                                placeholder="Ejemplo:&#10;• Solo 3 proveedores principales en el mercado&#10;• Tecnología propietaria difícil de reemplazar&#10;• Contratos a largo plazo con penalizaciones&#10;• Proveedores han amenazado con venta directa"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores('proveedores', 'countProveedores', 'badgeProveedores', 'previewProveedores')"
                            ><%= poderProveedores %></textarea>
                        </div>

                        <div class="preview-box">
                            <h5><i class="fas fa-eye"></i> Vista Previa:</h5>
                            <ul class="preview-list" id="previewProveedores">
                                <% if (!poderProveedores.isEmpty()) { %>
                                    <%
                                        String[] lineasProv = poderProveedores.split("\\n");
                                        for (String linea : lineasProv) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li style="color: #adb5bd; font-style: italic;">Los factores aparecerán aquí mientras escribes...</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Rivalidad entre Competidores -->
                    <div class="force-section rivalidad">
                        <div class="force-header">
                            <div class="force-icon">
                                <i class="fas fa-users-cog"></i>
                            </div>
                            <div>
                                <div class="force-title">Rivalidad Competitiva</div>
                                <span class="counter-badge" id="badgeRivalidad">0 factores</span>
                            </div>
                        </div>
                        
                        <div class="force-description">
                            <h4>⚔️ Factores a considerar:</h4>
                            <ul>
                                <li>Número y tamaño de competidores</li>
                                <li>Tasa de crecimiento de la industria</li>
                                <li>Diferenciación de productos</li>
                                <li>Costos fijos y de almacenamiento</li>
                                <li>Barreras de salida</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="rivalidad">Describe la rivalidad competitiva:</label>
                            <textarea 
                                id="rivalidad" 
                                name="rivalidad"
                                placeholder="Ejemplo:&#10;• 8 competidores principales de tamaño similar&#10;• Crecimiento del mercado del 2% anual&#10;• Productos poco diferenciados, compiten por precio&#10;• Guerra de precios recurrente cada trimestre"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores('rivalidad', 'countRivalidad', 'badgeRivalidad', 'previewRivalidad')"
                            ><%= rivalidadExistentes %></textarea>
                        </div>

                        <div class="preview-box">
                            <h5><i class="fas fa-eye"></i> Vista Previa:</h5>
                            <ul class="preview-list" id="previewRivalidad">
                                <% if (!rivalidadExistentes.isEmpty()) { %>
                                    <%
                                        String[] lineasRiv = rivalidadExistentes.split("\\n");
                                        for (String linea : lineasRiv) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li style="color: #adb5bd; font-style: italic;">Los factores aparecerán aquí mientras escribes...</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Poder de Negociación de Compradores -->
                    <div class="force-section compradores">
                        <div class="force-header">
                            <div class="force-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div>
                                <div class="force-title">Poder de Compradores</div>
                                <span class="counter-badge" id="badgeCompradores">0 factores</span>
                            </div>
                        </div>
                        
                        <div class="force-description">
                            <h4>🛒 Factores a considerar:</h4>
                            <ul>
                                <li>Concentración de compradores</li>
                                <li>Volumen de compras</li>
                                <li>Información disponible sobre precios</li>
                                <li>Diferenciación de productos</li>
                                <li>Amenaza de integración hacia atrás</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="compradores">Describe el poder de negociación de compradores:</label>
                            <textarea 
                                id="compradores" 
                                name="compradores"
                                placeholder="Ejemplo:&#10;• 5 clientes principales representan 70% de ventas&#10;• Compradores bien informados sobre precios del mercado&#10;• Fácil comparación de productos en línea&#10;• Algunos clientes han desarrollado capacidades internas"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores('compradores', 'countCompradores', 'badgeCompradores', 'previewCompradores')"
                            ><%= poderCompradores %></textarea>
                        </div>

                        <div class="preview-box">
                            <h5><i class="fas fa-eye"></i> Vista Previa:</h5>
                            <ul class="preview-list" id="previewCompradores">
                                <% if (!poderCompradores.isEmpty()) { %>
                                    <%
                                        String[] lineasComp = poderCompradores.split("\\n");
                                        for (String linea : lineasComp) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li style="color: #adb5bd; font-style: italic;">Los factores aparecerán aquí mientras escribes...</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Amenaza de Productos Sustitutos -->
                    <div class="force-section sustitutos">
                        <div class="force-header">
                            <div class="force-icon">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                            <div>
                                <div class="force-title">Amenaza de Sustitutos</div>
                                <span class="counter-badge" id="badgeSustitutos">0 factores</span>
                            </div>
                        </div>
                        
                        <div class="force-description">
                            <h4>🔄 Factores a considerar:</h4>
                            <ul>
                                <li>Disponibilidad de productos sustitutos</li>
                                <li>Relación precio-desempeño de sustitutos</li>
                                <li>Costos de cambio para el comprador</li>
                                <li>Propensión del comprador a sustituir</li>
                                <li>Tecnologías emergentes</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="sustitutos">Describe la amenaza de productos sustitutos:</label>
                            <textarea 
                                id="sustitutos" 
                                name="sustitutos"
                                placeholder="Ejemplo:&#10;• Tecnologías digitales reemplazan soluciones físicas&#10;• Sustitutos 30% más baratos pero menor calidad&#10;• Bajo costo de cambio para clientes&#10;• Tendencia creciente hacia alternativas sostenibles"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarContadores('sustitutos', 'countSustitutos', 'badgeSustitutos', 'previewSustitutos')"
                            ><%= amenazaSustitutos %></textarea>
                        </div>

                        <div class="preview-box">
                            <h5><i class="fas fa-eye"></i> Vista Previa:</h5>
                            <ul class="preview-list" id="previewSustitutos">
                                <% if (!amenazaSustitutos.isEmpty()) { %>
                                    <%
                                        String[] lineasSust = amenazaSustitutos.split("\\n");
                                        for (String linea : lineasSust) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li style="color: #adb5bd; font-style: italic;">Los factores aparecerán aquí mientras escribes...</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>

                <% if (modoColaborativo) { %>
                    <div class="save-section">
                        <h3><i class="fas fa-save"></i> Guardar Análisis Completo</h3>
                        <p>El análisis de las 5 Fuerzas de Porter se guardará para todo el equipo y estará disponible para evaluaciones estratégicas futuras</p>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Guardar Análisis de Porter
                        </button>
                    </div>
                <% } %>
            </form>

            <% if (modoColaborativo) { %>
                <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                    <p style="color: #2d5a3d; margin: 0;">
                        <i class="fas fa-info-circle"></i> 
                        <strong>Modo Colaborativo Activo:</strong> Los cambios se guardan automáticamente y son visibles 
                        para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                    </p>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        function actualizarContadores(inputId, countId, badgeId, previewId) {
            const texto = document.getElementById(inputId).value;
            const contador = document.getElementById(countId);
            const badge = document.getElementById(badgeId);
            const preview = document.getElementById(previewId);
            
            if (texto.trim()) {
                const lineas = texto.split('\n').filter(linea => linea.trim().length > 0);
                let html = '';
                let count = 0;
                
                lineas.forEach(linea => {
                    const lineaLimpia = linea.trim().replace(/^[•\-\*]\s*/, '');
                    if (lineaLimpia.length > 0) {
                        html += `<li>${lineaLimpia}</li>`;
                        count++;
                    }
                });
                
                if (html === '') {
                    html = '<li style="color: #adb5bd; font-style: italic;">Los factores aparecerán aquí mientras escribes...</li>';
                    count = 0;
                }
                
                preview.innerHTML = html;
                contador.textContent = count;
                badge.textContent = count + (count === 1 ? ' factor' : ' factores');
            } else {
                preview.innerHTML = '<li style="color: #adb5bd; font-style: italic;">Los factores aparecerán aquí mientras escribes...</li>';
                contador.textContent = '0';
                badge.textContent = '0 factores';
            }
        }

        // Inicializar contadores al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            actualizarContadores('entrantes', 'countEntrantes', 'badgeEntrantes', 'previewEntrantes');
            actualizarContadores('proveedores', 'countProveedores', 'badgeProveedores', 'previewProveedores');
            actualizarContadores('rivalidad', 'countRivalidad', 'badgeRivalidad', 'previewRivalidad');
            actualizarContadores('compradores', 'countCompradores', 'badgeCompradores', 'previewCompradores');
            actualizarContadores('sustitutos', 'countSustitutos', 'badgeSustitutos', 'previewSustitutos');
        });
    </script>
    <% if (modoColaborativo) { %>
    <script>
        // Auto-refresh cada 30 segundos para ver cambios de otros usuarios
        setInterval(function() {
            const inputs = ['entrantes', 'proveedores', 'rivalidad', 'compradores', 'sustitutos'];
            let hayChanged = false;
            
            inputs.forEach(inputId => {
                const input = document.getElementById(inputId);
                if (input.dataset.changed === 'true') {
                    hayChanged = true;
                }
            });
            
            if (!hayChanged) {
                location.reload();
            }
        }, 30000);

        // Marcar como cambiado cuando el usuario escribe
        ['entrantes', 'proveedores', 'rivalidad', 'compradores', 'sustitutos'].forEach(inputId => {
            document.getElementById(inputId).addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });
    </script>
    <% } %>
</body>
</html>