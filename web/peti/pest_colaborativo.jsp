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
    
    // Variables para los datos PEST
    String politicos = "";
    String economicos = "";
    String sociales = "";
    String tecnologicos = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevosPoliticos = request.getParameter("politicos");
        String nuevosEconomicos = request.getParameter("economicos");
        String nuevosSociales = request.getParameter("sociales");
        String nuevosTecnologicos = request.getParameter("tecnologicos");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevosPoliticos != null && !nuevosPoliticos.trim().isEmpty()) {
                ClsEPeti datoPoliticos = new ClsEPeti(grupoId, "pest", "politicos", nuevosPoliticos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoPoliticos);
            }
            if (nuevosEconomicos != null && !nuevosEconomicos.trim().isEmpty()) {
                ClsEPeti datoEconomicos = new ClsEPeti(grupoId, "pest", "economicos", nuevosEconomicos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoEconomicos);
            }
            if (nuevosSociales != null && !nuevosSociales.trim().isEmpty()) {
                ClsEPeti datoSociales = new ClsEPeti(grupoId, "pest", "sociales", nuevosSociales.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoSociales);
            }
            if (nuevosTecnologicos != null && !nuevosTecnologicos.trim().isEmpty()) {
                ClsEPeti datoTecnologicos = new ClsEPeti(grupoId, "pest", "tecnologicos", nuevosTecnologicos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoTecnologicos);
            }
            
            if (exito) {
                mensaje = "Análisis PEST guardado exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar el análisis PEST";
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
            Map<String, String> datosPest = negocioPeti.obtenerDatosSeccion(grupoId, "pest");
            
            if (datosPest.containsKey("politicos")) {
                politicos = datosPest.get("politicos");
            }
            if (datosPest.containsKey("economicos")) {
                economicos = datosPest.get("economicos");
            }
            if (datosPest.containsKey("sociales")) {
                sociales = datosPest.get("sociales");
            }
            if (datosPest.containsKey("tecnologicos")) {
                tecnologicos = datosPest.get("tecnologicos");
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
    <title>Análisis PEST - PETI Colaborativo</title>
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
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            color: #333;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .pest-logo {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 12px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 16px;
        }

        .grupo-info {
            font-size: 14px;
            color: #666;
        }

        .nav-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            font-size: 18px;
            padding: 20px 50px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
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

        .pest-intro {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            text-align: center;
        }

        .pest-intro h2 {
            font-size: 28px;
            margin-bottom: 15px;
        }

        .pest-intro p {
            font-size: 16px;
            opacity: 0.9;
        }

        .pest-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .pest-grid {
                grid-template-columns: 1fr;
            }
        }

        .pest-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 5px solid;
            transition: transform 0.3s ease;
        }

        .pest-section:hover {
            transform: translateY(-2px);
        }

        .political { border-left-color: #dc3545; }
        .economic { border-left-color: #28a745; }
        .social { border-left-color: #007bff; }
        .technological { border-left-color: #ffc107; }

        .pest-section h3 {
            margin-bottom: 15px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .political h3 { color: #dc3545; }
        .economic h3 { color: #28a745; }
        .social h3 { color: #007bff; }
        .technological h3 { color: #ffc107; }

        .pest-icon {
            font-size: 24px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .political .pest-icon { background: #dc3545; }
        .economic .pest-icon { background: #28a745; }
        .social .pest-icon { background: #007bff; }
        .technological .pest-icon { background: #ffc107; }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
            min-height: 120px;
            resize: vertical;
            transition: border-color 0.3s ease;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .guidelines {
            background: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            border: 1px solid #e1e5e9;
        }

        .guidelines h4 {
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        .guidelines ul {
            font-size: 13px;
            color: #666;
            padding-left: 18px;
        }

        .guidelines li {
            margin-bottom: 3px;
        }

        .preview-card {
            background: white;
            border: 1px solid #e1e5e9;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }

        .preview-card h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .preview-list {
            list-style: none;
            padding: 0;
        }

        .preview-list li {
            background: #f8f9fa;
            padding: 8px 12px;
            margin-bottom: 5px;
            border-radius: 4px;
            border-left: 3px solid;
            font-size: 14px;
        }

        .preview-list.political li { border-left-color: #dc3545; }
        .preview-list.economic li { border-left-color: #28a745; }
        .preview-list.social li { border-left-color: #007bff; }
        .preview-list.technological li { border-left-color: #ffc107; }

        .save-section {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-top: 30px;
        }

        .save-section h3 {
            font-size: 24px;
            margin-bottom: 15px;
        }

        .save-section p {
            font-size: 16px;
            margin-bottom: 25px;
            opacity: 0.9;
        }

        .pest-summary {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .pest-summary h3 {
            color: #1976d2;
            margin-bottom: 15px;
        }

        .pest-summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-top: 15px;
        }

        @media (max-width: 768px) {
            .pest-summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .summary-item {
            text-align: center;
            padding: 15px;
            background: white;
            border-radius: 8px;
            border-top: 4px solid;
        }

        .summary-item.political { border-top-color: #dc3545; }
        .summary-item.economic { border-top-color: #28a745; }
        .summary-item.social { border-top-color: #007bff; }
        .summary-item.technological { border-top-color: #ffc107; }

        .summary-item h4 {
            font-size: 14px;
            margin-bottom: 5px;
        }

        .summary-item span {
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <span class="pest-logo">PEST</span>
                    Análisis PEST
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

            <div class="pest-intro">
                <h2>🎯 Análisis PEST</h2>
                <p>Evalúa los factores del macroentorno que pueden influir en tu organización: <strong>P</strong>olíticos, <strong>E</strong>conómicos, <strong>S</strong>ociales y <strong>T</strong>ecnológicos</p>
            </div>

            <div class="pest-summary">
                <h3><i class="fas fa-chart-pie"></i> Resumen del Análisis</h3>
                <p>Completa cada sección para obtener una visión integral del macroentorno</p>
                <div class="pest-summary-grid">
                    <div class="summary-item political">
                        <h4>Políticos</h4>
                        <span id="countPoliticos">0</span>
                    </div>
                    <div class="summary-item economic">
                        <h4>Económicos</h4>
                        <span id="countEconomicos">0</span>
                    </div>
                    <div class="summary-item social">
                        <h4>Sociales</h4>
                        <span id="countSociales">0</span>
                    </div>
                    <div class="summary-item technological">
                        <h4>Tecnológicos</h4>
                        <span id="countTecnologicos">0</span>
                    </div>
                </div>
            </div>

            <form method="post" action="">
                <div class="pest-grid">
                    <!-- Factores Políticos -->
                    <div class="pest-section political">
                        <h3>
                            <div class="pest-icon"><i class="fas fa-university"></i></div>
                            Factores Políticos
                            <% if (modoColaborativo && !politicos.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px; margin-left: auto;">
                                    <i class="fas fa-check-circle"></i> Guardado
                                </span>
                            <% } %>
                        </h3>
                        
                        <div class="guidelines">
                            <h4>🏛️ Considera:</h4>
                            <ul>
                                <li>Políticas gubernamentales</li>
                                <li>Regulaciones y leyes</li>
                                <li>Estabilidad política</li>
                                <li>Políticas fiscales</li>
                                <li>Comercio internacional</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="politicos">Factores Políticos:</label>
                            <textarea 
                                id="politicos" 
                                name="politicos"
                                placeholder="Ejemplo:&#10;• Nueva ley de protección de datos&#10;• Incentivos fiscales para tecnología&#10;• Regulaciones ambientales más estrictas"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarPreview('politicos', 'previewPoliticos', 'countPoliticos')"
                            ><%= politicos %></textarea>
                        </div>

                        <div class="preview-card">
                            <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                            <ul class="preview-list political" id="previewPoliticos">
                                <% if (!politicos.isEmpty()) { %>
                                    <%
                                        String[] lineasPol = politicos.split("\\n");
                                        for (String linea : lineasPol) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li>Los factores políticos aparecerán aquí</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Factores Económicos -->
                    <div class="pest-section economic">
                        <h3>
                            <div class="pest-icon"><i class="fas fa-chart-line"></i></div>
                            Factores Económicos
                            <% if (modoColaborativo && !economicos.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px; margin-left: auto;">
                                    <i class="fas fa-check-circle"></i> Guardado
                                </span>
                            <% } %>
                        </h3>
                        
                        <div class="guidelines">
                            <h4>💰 Considera:</h4>
                            <ul>
                                <li>Crecimiento económico</li>
                                <li>Tasas de interés</li>
                                <li>Inflación</li>
                                <li>Tipo de cambio</li>
                                <li>Niveles de empleo</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="economicos">Factores Económicos:</label>
                            <textarea 
                                id="economicos" 
                                name="economicos"
                                placeholder="Ejemplo:&#10;• Crecimiento del PIB del 3.5%&#10;• Reducción de tasas de interés&#10;• Aumento del poder adquisitivo"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarPreview('economicos', 'previewEconomicos', 'countEconomicos')"
                            ><%= economicos %></textarea>
                        </div>

                        <div class="preview-card">
                            <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                            <ul class="preview-list economic" id="previewEconomicos">
                                <% if (!economicos.isEmpty()) { %>
                                    <%
                                        String[] lineasEco = economicos.split("\\n");
                                        for (String linea : lineasEco) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li>Los factores económicos aparecerán aquí</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Factores Sociales -->
                    <div class="pest-section social">
                        <h3>
                            <div class="pest-icon"><i class="fas fa-users"></i></div>
                            Factores Sociales
                            <% if (modoColaborativo && !sociales.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px; margin-left: auto;">
                                    <i class="fas fa-check-circle"></i> Guardado
                                </span>
                            <% } %>
                        </h3>
                        
                        <div class="guidelines">
                            <h4>👥 Considera:</h4>
                            <ul>
                                <li>Cambios demográficos</li>
                                <li>Estilos de vida</li>
                                <li>Actitudes culturales</li>
                                <li>Nivel educativo</li>
                                <li>Conciencia ambiental</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="sociales">Factores Sociales:</label>
                            <textarea 
                                id="sociales" 
                                name="sociales"
                                placeholder="Ejemplo:&#10;• Mayor conciencia sobre sostenibilidad&#10;• Envejecimiento de la población&#10;• Aumento del trabajo remoto"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarPreview('sociales', 'previewSociales', 'countSociales')"
                            ><%= sociales %></textarea>
                        </div>

                        <div class="preview-card">
                            <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                            <ul class="preview-list social" id="previewSociales">
                                <% if (!sociales.isEmpty()) { %>
                                    <%
                                        String[] lineasSoc = sociales.split("\\n");
                                        for (String linea : lineasSoc) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li>Los factores sociales aparecerán aquí</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <!-- Factores Tecnológicos -->
                    <div class="pest-section technological">
                        <h3>
                            <div class="pest-icon"><i class="fas fa-microchip"></i></div>
                            Factores Tecnológicos
                            <% if (modoColaborativo && !tecnologicos.isEmpty()) { %>
                                <span style="color: #28a745; font-size: 12px; margin-left: auto;">
                                    <i class="fas fa-check-circle"></i> Guardado
                                </span>
                            <% } %>
                        </h3>
                        
                        <div class="guidelines">
                            <h4>🔬 Considera:</h4>
                            <ul>
                                <li>Innovaciones tecnológicas</li>
                                <li>Automatización</li>
                                <li>I+D</li>
                                <li>Adopción digital</li>
                                <li>Ciberseguridad</li>
                            </ul>
                        </div>

                        <div class="form-group">
                            <label for="tecnologicos">Factores Tecnológicos:</label>
                            <textarea 
                                id="tecnologicos" 
                                name="tecnologicos"
                                placeholder="Ejemplo:&#10;• Avances en inteligencia artificial&#10;• Mayor adopción de cloud computing&#10;• Desarrollo de tecnologías 5G"
                                <%= modoColaborativo ? "" : "readonly" %>
                                onkeyup="actualizarPreview('tecnologicos', 'previewTecnologicos', 'countTecnologicos')"
                            ><%= tecnologicos %></textarea>
                        </div>

                        <div class="preview-card">
                            <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                            <ul class="preview-list technological" id="previewTecnologicos">
                                <% if (!tecnologicos.isEmpty()) { %>
                                    <%
                                        String[] lineasTec = tecnologicos.split("\\n");
                                        for (String linea : lineasTec) {
                                            linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                            if (linea.length() > 0) {
                                    %>
                                    <li><%= linea %></li>
                                    <%
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <li>Los factores tecnológicos aparecerán aquí</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>

                <% if (modoColaborativo) { %>
                    <div class="save-section">
                        <h3><i class="fas fa-save"></i> Guardar Análisis PEST Completo</h3>
                        <p>Los 4 factores del macroentorno se guardarán para todo el equipo y estarán disponibles para análisis posteriores</p>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Guardar Análisis PEST
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
        function actualizarPreview(inputId, previewId, countId) {
            const texto = document.getElementById(inputId).value;
            const preview = document.getElementById(previewId);
            const counter = document.getElementById(countId);
            
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
                    html = `<li>Los factores ${inputId} aparecerán aquí</li>`;
                    count = 0;
                }
                
                preview.innerHTML = html;
                counter.textContent = count;
            } else {
                preview.innerHTML = `<li>Los factores ${inputId} aparecerán aquí</li>`;
                counter.textContent = '0';
            }
        }

        // Inicializar contadores al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            actualizarPreview('politicos', 'previewPoliticos', 'countPoliticos');
            actualizarPreview('economicos', 'previewEconomicos', 'countEconomicos');
            actualizarPreview('sociales', 'previewSociales', 'countSociales');
            actualizarPreview('tecnologicos', 'previewTecnologicos', 'countTecnologicos');
        });
    </script>
    <% if (modoColaborativo) { %>
    <script>
        // Auto-refresh cada 25 segundos para ver cambios de otros usuarios
        setInterval(function() {
            const inputs = ['politicos', 'economicos', 'sociales', 'tecnologicos'];
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
        }, 25000);

        // Marcar como cambiado cuando el usuario escribe
        ['politicos', 'economicos', 'sociales', 'tecnologicos'].forEach(inputId => {
            document.getElementById(inputId).addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });
    </script>
    <% } %>
</body>
</html>