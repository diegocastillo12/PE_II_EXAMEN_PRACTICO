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
    
    // Variables para los datos
    String valor1 = "";
    String valor2 = "";
    String valor3 = "";
    String valor4 = "";
    String valor5 = "";
    String descripcionValores = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevoValor1 = request.getParameter("valor1");
        String nuevoValor2 = request.getParameter("valor2");
        String nuevoValor3 = request.getParameter("valor3");
        String nuevoValor4 = request.getParameter("valor4");
        String nuevoValor5 = request.getParameter("valor5");
        String nuevaDescripcion = request.getParameter("descripcion_valores");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevoValor1 != null && !nuevoValor1.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "valores", "valor1", nuevoValor1.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoValor2 != null && !nuevoValor2.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "valores", "valor2", nuevoValor2.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoValor3 != null && !nuevoValor3.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "valores", "valor3", nuevoValor3.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoValor4 != null && !nuevoValor4.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "valores", "valor4", nuevoValor4.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoValor5 != null && !nuevoValor5.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "valores", "valor5", nuevoValor5.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevaDescripcion != null && !nuevaDescripcion.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "valores", "descripcion", nuevaDescripcion.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Valores corporativos guardados exitosamente";
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
            Map<String, String> datosValores = negocioPeti.obtenerDatosSeccion(grupoId, "valores");
            
            valor1 = datosValores.getOrDefault("valor1", "");
            valor2 = datosValores.getOrDefault("valor2", "");
            valor3 = datosValores.getOrDefault("valor3", "");
            valor4 = datosValores.getOrDefault("valor4", "");
            valor5 = datosValores.getOrDefault("valor5", "");
            descripcionValores = datosValores.getOrDefault("descripcion", "");
        } catch (Exception e) {
            System.err.println("Error al cargar datos: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Valores Corporativos - PETI Colaborativo</title>
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
            max-width: 1200px;
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

        .valores-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .valor-card {
            background: #f8f9fa;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .valor-card:hover {
            border-color: #667eea;
        }

        .valor-card h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 16px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .preview-section {
            background: #e3f2fd;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        .preview-section h3 {
            color: #1976d2;
            margin-bottom: 15px;
        }

        .valores-preview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .valor-preview {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .valor-preview h4 {
            color: #333;
            margin-bottom: 5px;
        }

        .valor-preview p {
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>
                    <i class="fas fa-heart"></i> Valores Corporativos
                    <small style="font-size: 14px; color: #666;">- Grupo: <%= grupoActual %> 
                    <% if ("admin".equals(rolUsuario)) { %>
                        <span style="color: #ffc107;">👑</span>
                    <% } %>
                    </small>
                </h1>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="dashboard.jsp" class="btn" style="background: #6c757d; color: white;">
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
                <div class="alert" style="background: #fff3cd; border: 1px solid #ffeaa7; color: #856404;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Error:</strong> Debes estar en un grupo para acceder a esta página.
                    <a href="../menuprincipal.jsp" style="color: #856404; text-decoration: underline;">Ir al menú principal</a>
                </div>
            <% } else { %>

            <form method="post" action="">
                <div class="valores-grid">
                    <div class="valor-card">
                        <h3><i class="fas fa-star"></i> Valor 1</h3>
                        <div class="form-group">
                            <label for="valor1">Nombre del Valor:</label>
                            <input type="text" id="valor1" name="valor1" 
                                   placeholder="Ej: Integridad"
                                   value="<%= valor1 %>">
                        </div>
                    </div>

                    <div class="valor-card">
                        <h3><i class="fas fa-star"></i> Valor 2</h3>
                        <div class="form-group">
                            <label for="valor2">Nombre del Valor:</label>
                            <input type="text" id="valor2" name="valor2" 
                                   placeholder="Ej: Innovación"
                                   value="<%= valor2 %>">
                        </div>
                    </div>

                    <div class="valor-card">
                        <h3><i class="fas fa-star"></i> Valor 3</h3>
                        <div class="form-group">
                            <label for="valor3">Nombre del Valor:</label>
                            <input type="text" id="valor3" name="valor3" 
                                   placeholder="Ej: Excelencia"
                                   value="<%= valor3 %>">
                        </div>
                    </div>

                    <div class="valor-card">
                        <h3><i class="fas fa-star"></i> Valor 4</h3>
                        <div class="form-group">
                            <label for="valor4">Nombre del Valor:</label>
                            <input type="text" id="valor4" name="valor4" 
                                   placeholder="Ej: Responsabilidad"
                                   value="<%= valor4 %>">
                        </div>
                    </div>

                    <div class="valor-card">
                        <h3><i class="fas fa-star"></i> Valor 5</h3>
                        <div class="form-group">
                            <label for="valor5">Nombre del Valor:</label>
                            <input type="text" id="valor5" name="valor5" 
                                   placeholder="Ej: Trabajo en Equipo"
                                   value="<%= valor5 %>">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="descripcion_valores">Descripción de los Valores:</label>
                    <textarea id="descripcion_valores" name="descripcion_valores" 
                              rows="5" 
                              placeholder="Describe cómo estos valores se manifiestan en la empresa y por qué son importantes..."><%= descripcionValores %></textarea>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                        <i class="fas fa-save"></i> Guardar Valores Corporativos
                    </button>
                </div>
            </form>

            <!-- Vista Previa -->
            <div class="preview-section">
                <h3><i class="fas fa-eye"></i> Vista Previa de los Valores</h3>
                <div class="valores-preview" id="valoresPreview">
                    <!-- Se llenará dinámicamente -->
                </div>
                <div style="margin-top: 15px;">
                    <h4>Descripción:</h4>
                    <p id="descripcionPreview" style="font-style: italic; color: #666;">
                        <%= !descripcionValores.isEmpty() ? descripcionValores : "La descripción aparecerá aquí..." %>
                    </p>
                </div>
            </div>

            <div style="background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 20px;">
                <p style="color: #2d5a3d; margin: 0;">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Modo Colaborativo:</strong> Los valores se guardan automáticamente y son visibles 
                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                </p>
            </div>

            <% } %>
        </div>
    </div>

    <script>
        function actualizarPreview() {
            const valores = ['valor1', 'valor2', 'valor3', 'valor4', 'valor5'];
            const previewContainer = document.getElementById('valoresPreview');
            const descripcionPreview = document.getElementById('descripcionPreview');
            const descripcion = document.getElementById('descripcion_valores').value;
            
            previewContainer.innerHTML = '';
            
            valores.forEach((valorId, index) => {
                const valor = document.getElementById(valorId).value;
                if (valor.trim()) {
                    const valorDiv = document.createElement('div');
                    valorDiv.className = 'valor-preview';
                    valorDiv.innerHTML = `
                        <h4><i class="fas fa-star" style="color: #ffc107;"></i> ${valor}</h4>
                        <p>Valor ${index + 1} de la empresa</p>
                    `;
                    previewContainer.appendChild(valorDiv);
                }
            });
            
            if (previewContainer.children.length === 0) {
                previewContainer.innerHTML = '<p style="text-align: center; color: #666; font-style: italic;">No hay valores definidos</p>';
            }
            
            descripcionPreview.textContent = descripcion || 'La descripción aparecerá aquí...';
        }

        // Agregar listeners
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = ['valor1', 'valor2', 'valor3', 'valor4', 'valor5', 'descripcion_valores'];
            inputs.forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.addEventListener('input', actualizarPreview);
                }
            });
            
            // Actualizar preview inicial
            actualizarPreview();
        });

        // Auto-refresh cada 15 segundos
        setInterval(function() {
            const inputs = document.querySelectorAll('input, textarea');
            let hayChanged = false;
            inputs.forEach(input => {
                if (input.dataset.changed === 'true') {
                    hayChanged = true;
                }
            });
            
            if (!hayChanged) {
                location.reload();
            }
        }, 15000);

        // Marcar como cambiado
        document.querySelectorAll('input, textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });
    </script>
</body>
</html>
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

        .values-section {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        .values-section h2 {
            margin-bottom: 20px;
            color: #2c3e50;
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

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .value-item {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            position: relative;
        }

        .value-item h4 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .value-item p {
            color: #555;
            line-height: 1.5;
            margin: 0;
        }

        .btn-remove {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            font-size: 12px;
        }

        .btn-remove:hover {
            background: #c82333;
        }

        .btn-add {
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-right: 10px;
        }

        .btn-add:hover {
            background: #218838;
            transform: translateY(-1px);
        }

        .btn-save {
            background: #007bff;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            background: #0056b3;
            transform: translateY(-1px);
        }

        .guidelines {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 0 8px 8px 0;
        }

        .guidelines h4 {
            color: #856404;
            margin-bottom: 10px;
        }

        .guidelines ul {
            color: #555;
            padding-left: 20px;
        }

        .guidelines li {
            margin-bottom: 5px;
        }

        .values-list {
            margin-top: 20px;
        }

        .empty-state {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            padding: 40px;
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
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-sidebar">
            <div class="user-profile">
                <div class="user-avatar">
                    <span><%= userInitials %></span>
                </div>
                <div class="user-info">
                    <h3><%= usuario %></h3>
                    <p><%= userEmail %></p>
                </div>
            </div>
            <nav class="dashboard-nav">
                <ul>
                    <li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>
                    <li><a href="empresa.jsp"><i class="fas fa-building"></i> Empresa</a></li>
                    <li><a href="mision.jsp"><i class="fas fa-bullseye"></i> Misión</a></li>
                    <li><a href="vision.jsp"><i class="fas fa-eye"></i> Visión</a></li>
                    <li class="active"><a href="valores.jsp"><i class="fas fa-heart"></i> Valores</a></li>
                    <li><a href="analisis-externo.jsp"><i class="fas fa-search"></i> Análisis Externo</a></li>
                    <li><a href="analisis-interno.jsp"><i class="fas fa-chart-bar"></i> Análisis Interno</a></li>
                    <li><a href="pest.jsp"><i class="fas fa-list"></i> Análisis PEST</a></li>
                    <li><a href="porter.jsp"><i class="fas fa-shield-alt"></i> Porter</a></li>
                    <li><a href="matriz-came.jsp"><i class="fas fa-th"></i> Matriz CAME</a></li>
                    <li><a href="cadena-valor.jsp"><i class="fas fa-link"></i> Cadena de Valor</a></li>
                    <li><a href="objetivos.jsp"><i class="fas fa-target"></i> Objetivos</a></li>
                    <li><a href="identificacion-estrategia.jsp"><i class="fas fa-lightbulb"></i> Estrategias</a></li>
                    <li><a href="matriz-participacion.jsp"><i class="fas fa-users"></i> Matriz Participación</a></li>
                    <li><a href="resumen-ejecutivo.jsp"><i class="fas fa-file-alt"></i> Resumen Ejecutivo</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a></li>
                </ul>
            </nav>
        </div>
        <div class="dashboard-content">
            <header class="dashboard-header">
                <h1>Valores de la Empresa</h1>
                <div class="header-actions">
                    <button class="btn-primary" onclick="guardarValores()"><i class="fas fa-save"></i> Guardar</button>
                </div>
            </header>
            <main class="dashboard-main">
                <div class="values-section">
                    <h2>Definición de Valores Corporativos</h2>
                    
                    <div class="guidelines">
                        <h4>Guía para definir valores:</h4>
                        <ul>
                            <li>Los valores deben ser principios fundamentales que guíen el comportamiento</li>
                            <li>Deben ser auténticos y reflejar la cultura real de la empresa</li>
                            <li>Cada valor debe tener una descripción clara de su significado</li>
                            <li>Recomendamos entre 3 y 7 valores principales</li>
                        </ul>
                    </div>
                    
                    <div class="form-group">
                        <label for="valorNombre">Nombre del Valor:</label>
                        <input type="text" id="valorNombre" placeholder="Ej: Integridad, Innovación, Excelencia...">
                    </div>
                    
                    <div class="form-group">
                        <label for="valorDescripcion">Descripción del Valor:</label>
                        <textarea id="valorDescripcion" placeholder="Describe qué significa este valor para la empresa y cómo se manifiesta en el día a día..."></textarea>
                    </div>
                    
                    <button class="btn-add" onclick="agregarValor()">
                        <i class="fas fa-plus"></i> Agregar Valor
                    </button>
                    
                    <div class="values-list" id="valuesList">
                        <div class="empty-state" id="emptyState">
                            No hay valores definidos. Agregue el primer valor usando el formulario anterior.
                        </div>
                    </div>
                    
                    <button class="btn-save" onclick="guardarValores()">
                        <i class="fas fa-save"></i> Guardar Todos los Valores
                    </button>
                </div>
            </main>
        </div>
    </div>
    
    <script>
        let valores = [];
        
        function logout() {
            if (confirm('¿Está seguro que desea cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }
        
        function agregarValor() {
            const nombre = document.getElementById('valorNombre').value.trim();
            const descripcion = document.getElementById('valorDescripcion').value.trim();
            
            if (!nombre) {
                alert('Por favor, ingrese el nombre del valor.');
                return;
            }
            
            if (!descripcion) {
                alert('Por favor, ingrese la descripción del valor.');
                return;
            }
            
            // Verificar si el valor ya existe
            if (valores.some(v => v.nombre.toLowerCase() === nombre.toLowerCase())) {
                alert('Este valor ya existe. Por favor, ingrese un valor diferente.');
                return;
            }
            
            const valor = {
                id: Date.now(),
                nombre: nombre,
                descripcion: descripcion
            };
            
            valores.push(valor);
            
            // Limpiar formulario
            document.getElementById('valorNombre').value = '';
            document.getElementById('valorDescripcion').value = '';
            
            renderizarValores();
        }
        
        function eliminarValor(id) {
            if (confirm('¿Está seguro que desea eliminar este valor?')) {
                valores = valores.filter(v => v.id !== id);
                renderizarValores();
            }
        }
        
        function renderizarValores() {
            const valuesList = document.getElementById('valuesList');
            const emptyState = document.getElementById('emptyState');
            
            if (valores.length === 0) {
                emptyState.style.display = 'block';
                return;
            }
            
            emptyState.style.display = 'none';
            
            const valoresHTML = valores.map(valor => `
                <div class="value-item">
                    <button class="btn-remove" onclick="eliminarValor(${valor.id})">
                        <i class="fas fa-times"></i>
                    </button>
                    <h4>${valor.nombre}</h4>
                    <p>${valor.descripcion}</p>
                </div>
            `).join('');
            
            valuesList.innerHTML = valoresHTML;
        }
        
        function guardarValores() {
            if (valores.length === 0) {
                alert('Por favor, agregue al menos un valor antes de guardar.');
                return;
            }
            
            // Aquí se puede agregar la lógica para guardar en la base de datos
            alert(`Se han guardado ${valores.length} valores exitosamente.`);
        }
        
        // Cargar datos guardados al cargar la página
        window.onload = function() {
            // Aquí se puede agregar la lógica para cargar datos existentes
            renderizarValores();
        };
    </script>
</body>
</html>