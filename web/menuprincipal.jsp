<%-- 
    Document   : menuprincipal
    Created on : 15 set. 2025
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="negocio.ClsNGrupo"%>
<%@page import="negocio.ClsNLogin"%>

<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Obtener ID del usuario desde la sesión o base de datos
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    if (usuarioId == null) {
        // Si no está en sesión, obtenerlo de la base de datos
        ClsNLogin loginNegocio = new ClsNLogin();
        usuarioId = loginNegocio.obtenerIdPorUsername(usuario);
        if (usuarioId == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        session.setAttribute("usuarioId", usuarioId);
    }
    
    // Obtener todos los grupos del usuario desde la base de datos
    ClsNGrupo grupoNegocio = new ClsNGrupo();
    List<Map<String, Object>> gruposUsuario = grupoNegocio.obtenerTodosLosGruposUsuario(usuarioId);
    
    // Grupo actualmente seleccionado
    String grupoSeleccionado = request.getParameter("grupoSeleccionado");
    if (grupoSeleccionado == null && !gruposUsuario.isEmpty()) {
        grupoSeleccionado = (String) gruposUsuario.get(0).get("nombre");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Menú Principal - Proyecto PETI</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f8f9fa;
                min-height: 100vh;
                color: #333;
            }
            
            .header {
                background: #2c5aa0;
                color: white;
                padding: 1.5rem 2rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .header h2 {
                font-size: 1.5rem;
                font-weight: 600;
            }
            
            .header p {
                opacity: 0.9;
                font-size: 0.9rem;
                margin-top: 0.25rem;
            }
            
            .logout-btn {
                background: #dc3545;
                color: white;
                border: none;
                padding: 0.6rem 1.2rem;
                border-radius: 6px;
                text-decoration: none;
                font-size: 0.9rem;
                transition: background 0.3s;
            }
            
            .logout-btn:hover {
                background: #c82333;
            }
            
            .container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 0 1rem;
            }
            
            .groups-selector {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 1.5rem;
                margin-bottom: 2rem;
                border-left: 4px solid #2c5aa0;
            }
            
            .groups-selector h3 {
                color: #2c5aa0;
                margin-bottom: 1rem;
                font-size: 1.25rem;
            }
            
            .groups-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
                margin-bottom: 1rem;
            }
            
            .group-card {
                background: #f8f9fa;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                padding: 1rem;
                cursor: pointer;
                transition: all 0.3s;
                position: relative;
            }
            
            .group-card:hover {
                border-color: #2c5aa0;
                background: #e3f2fd;
            }
            
            .group-card.active {
                border-color: #2c5aa0;
                background: #e3f2fd;
                box-shadow: 0 0 0 2px rgba(44, 90, 160, 0.2);
            }
            
            .group-card h4 {
                color: #2c5aa0;
                margin-bottom: 0.5rem;
                font-size: 1rem;
            }
            
            .group-info {
                font-size: 0.85rem;
                color: #666;
                margin-bottom: 0.5rem;
            }
            
            .role-badge {
                display: inline-block;
                padding: 0.2rem 0.5rem;
                border-radius: 4px;
                font-size: 0.75rem;
                font-weight: bold;
                margin-top: 0.5rem;
            }
            
            .role-admin {
                background: #ffc107;
                color: #212529;
            }
            
            .role-member {
                background: #17a2b8;
                color: white;
            }
            
            .main-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 1.5rem;
            }
            
            .card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 1.5rem;
                border-left: 4px solid #2c5aa0;
            }
            
            .card h3 {
                color: #2c5aa0;
                margin-bottom: 0.75rem;
                font-size: 1.25rem;
                font-weight: 600;
            }
            
            .card p {
                color: #666;
                line-height: 1.5;
                margin-bottom: 1rem;
            }
            
            .form-group {
                margin-bottom: 1rem;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: #333;
                font-weight: 500;
                font-size: 0.9rem;
            }
            
            .form-group input, 
            .form-group select {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 0.95rem;
                transition: border-color 0.3s;
            }
            
            .form-group input:focus, 
            .form-group select:focus {
                outline: none;
                border-color: #2c5aa0;
                box-shadow: 0 0 0 2px rgba(44, 90, 160, 0.1);
            }
            
            .btn {
                display: inline-block;
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 6px;
                font-size: 0.95rem;
                font-weight: 500;
                cursor: pointer;
                text-decoration: none;
                text-align: center;
                transition: all 0.3s;
                width: 100%;
            }
            
            .btn-primary {
                background: #2c5aa0;
                color: white;
            }
            
            .btn-primary:hover {
                background: #1e3f73;
            }
            
            .btn-success {
                background: #28a745;
                color: white;
            }
            
            .btn-success:hover {
                background: #1e7e34;
            }
            
            .btn-info {
                background: #17a2b8;
                color: white;
            }
            
            .btn-info:hover {
                background: #117a8b;
            }
            
            .btn-secondary {
                background: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background: #545b62;
            }
            
            .btn-danger {
                background: #dc3545;
                color: white;
            }
            
            .btn-danger:hover {
                background: #c82333;
            }
            
            .action-buttons {
                display: flex;
                gap: 0.75rem;
                margin-top: 1rem;
            }
            
            .action-buttons .btn {
                flex: 1;
            }
            
            .info-box {
                background: #e3f2fd;
                border: 1px solid #bbdefb;
                border-radius: 6px;
                padding: 1rem;
                margin: 1rem 0;
            }
            
            .info-box h4 {
                color: #1976d2;
                margin-bottom: 0.5rem;
                font-size: 1rem;
            }
            
            .info-box p {
                color: #424242;
                margin: 0;
                font-size: 0.9rem;
            }
            
            .code-display {
                background: #f8f9fa;
                border: 2px dashed #2c5aa0;
                padding: 1.5rem;
                border-radius: 6px;
                text-align: center;
                margin: 1rem 0;
            }
            
            .code-display .code {
                font-size: 1.5rem;
                font-weight: bold;
                color: #2c5aa0;
                letter-spacing: 0.2rem;
                font-family: 'Courier New', monospace;
            }
            
            .members-list {
                background: #f8f9fa;
                border-radius: 6px;
                padding: 1rem;
                margin-top: 1rem;
            }
            
            .member-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0.5rem 0;
                border-bottom: 1px solid #e9ecef;
            }
            
            .member-item:last-child {
                border-bottom: none;
            }
            
            .admin-badge {
                background: #ffc107;
                color: #212529;
                padding: 0.2rem 0.5rem;
                border-radius: 4px;
                font-size: 0.75rem;
                font-weight: bold;
            }
            
            .alert {
                padding: 1rem;
                border-radius: 6px;
                margin-bottom: 1.5rem;
                font-size: 0.9rem;
                border-left: 4px solid;
            }
            
            .alert-error {
                background: #f8d7da;
                border-color: #dc3545;
                color: #721c24;
            }
            
            .alert-success {
                background: #d4edda;
                border-color: #28a745;
                color: #155724;
            }
            
            .status-note {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 6px;
                padding: 0.75rem;
                margin-top: 1rem;
                font-size: 0.85rem;
                color: #856404;
            }
            
            .status-note.member {
                background: #d1ecf1;
                border-color: #bee5eb;
                color: #0c5460;
            }
            
            .no-groups {
                text-align: center;
                padding: 2rem;
                color: #666;
            }
            
            .group-stats {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 1rem;
                padding-top: 1rem;
                border-top: 1px solid #e9ecef;
            }
            
            .peti-access {
                background: linear-gradient(135deg, #2c5aa0 0%, #1e3f73 100%);
                color: white;
                border: none;
                padding: 1rem 1.5rem;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                display: block;
                text-align: center;
                margin: 1rem 0;
                transition: transform 0.2s;
            }
            
            .peti-access:hover {
                transform: translateY(-2px);
                color: white;
            }
            
            @media (max-width: 768px) {
                .header {
                    flex-direction: column;
                    text-align: center;
                    gap: 1rem;
                }
                
                .container {
                    margin: 1rem auto;
                    padding: 0 0.5rem;
                }
                
                .main-grid, .groups-grid {
                    grid-template-columns: 1fr;
                    gap: 1rem;
                }
                
                .action-buttons {
                    flex-direction: column;
                }
            }
        </style>
        <script>
            function selectGroup(groupName) {
                // Redirigir a la misma página con el grupo seleccionado
                window.location.href = 'menuprincipal.jsp?grupoSeleccionado=' + encodeURIComponent(groupName);
            }
            
            function updateGroupContent(groupName) {
                // Aquí puedes actualizar el contenido según el grupo seleccionado
                // Por ahora solo actualizamos la URL del botón PETI
                const petiButton = document.querySelector('.peti-access');
                if (petiButton) {
                    const currentHref = petiButton.href;
                    const baseUrl = currentHref.split('&grupo=')[0];
                    petiButton.href = baseUrl + '&grupo=' + encodeURIComponent(groupName);
                }
                
                // Actualizar información del grupo seleccionado
                const groupInfo = document.querySelector('.selected-group-info');
                if (groupInfo) {
                    groupInfo.innerHTML = '<strong>Grupo activo:</strong> ' + groupName;
                }
            }
            
            function accessPETI(groupName, role) {
                window.location.href = 'peti/dashboard.jsp?modo=colaborativo&grupo=' + encodeURIComponent(groupName) + '&rol=' + role;
            }
        </script>
    </head>
    <body>
        <div class="header">
            <div class="user-info">
                <h2>Bienvenido, <%= usuario %></h2>
                <p>
                    <% if (!gruposUsuario.isEmpty()) { %>
                        Miembro de <%= gruposUsuario.size() %> grupo<%= gruposUsuario.size() > 1 ? "s" : "" %>
                        <span class="selected-group-info">
                            <% if (grupoSeleccionado != null) { %>
                                | <strong>Grupo activo:</strong> <%= grupoSeleccionado %>
                            <% } %>
                        </span>
                    <% } else { %>
                        Sin grupos asignados
                    <% } %>
                </p>
            </div>
            <a href="logout.jsp" class="logout-btn">Cerrar Sesión</a>
        </div>
        
        <div class="container">
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                String grupo = request.getParameter("grupo");
                String codigo = request.getParameter("codigo");
                
                if (error != null) {
                    String mensajeError = "";
                    switch (error) {
                        case "campos_vacios":
                            mensajeError = "Por favor, completa todos los campos requeridos.";
                            break;
                        case "limite_invalido":
                            mensajeError = "El límite de usuarios debe estar entre 2 y 100.";
                            break;
                        case "nombre_grupo_existe":
                            mensajeError = "Ya existe un grupo con ese nombre. Elige otro nombre.";
                            break;
                        case "codigo_vacio":
                            mensajeError = "Debes ingresar un código de grupo.";
                            break;
                        case "codigo_no_encontrado":
                            mensajeError = "El código ingresado no corresponde a ningún grupo existente.";
                            break;
                        case "grupo_lleno":
                            mensajeError = "El grupo ha alcanzado su límite máximo de usuarios.";
                            break;
                        case "ya_es_miembro":
                            mensajeError = "Ya eres miembro de este grupo.";
                            break;
                        default:
                            mensajeError = "Ha ocurrido un error. Inténtalo de nuevo.";
                    }
            %>
                    <div class="alert alert-error">
                        <%= mensajeError %>
                    </div>
            <%
                }
                
                if (success != null) {
                    String mensajeExito = "";
                    switch (success) {
                        case "grupo_creado":
                            mensajeExito = "¡Grupo creado exitosamente! Ahora eres el administrador.";
                            break;
                        case "unido_grupo":
                            mensajeExito = "¡Te has unido al grupo \"" + (grupo != null ? grupo : "desconocido") + "\" exitosamente!";
                            break;
                        case "codigo_generado":
                            mensajeExito = "¡Nuevo código generado exitosamente!" + (codigo != null ? " Código: " + codigo : "");
                            break;
                        case "salir_grupo":
                            mensajeExito = "Has salido del grupo exitosamente.";
                            break;
                        default:
                            mensajeExito = "Operación realizada con éxito.";
                    }
            %>
                    <div class="alert alert-success">
                        <%= mensajeExito %>
                    </div>
            <%
                }
            %>
            
            <% if (!gruposUsuario.isEmpty()) { %>
                <!-- Selector de Grupos -->
                <div class="groups-selector">
                    <h3>Mis Grupos</h3>
                    <p>Selecciona un grupo para trabajar colaborativamente. Puedes cambiar entre grupos en cualquier momento.</p>
                    
                    <div class="groups-grid">
                        <% for (Map<String, Object> grupo_item : gruposUsuario) { 
                            String nombreGrupo = (String) grupo_item.get("nombre");
                            String rolGrupo = (String) grupo_item.get("rol");
                            Integer miembrosCount = (Integer) grupo_item.get("miembros");
                            String codigoGrupo = (String) grupo_item.get("codigo");
                            boolean isActive = nombreGrupo.equals(grupoSeleccionado);
                        %>
                            <div class="group-card <%= isActive ? "active" : "" %>" onclick="selectGroup('<%= nombreGrupo %>')">
                                <h4><%= nombreGrupo %></h4>
                                <div class="group-info">
                                    <div><%= miembrosCount %> miembro<%= miembrosCount > 1 ? "s" : "" %></div>
                                    <div>Código: <strong><%= codigoGrupo %></strong></div>
                                </div>
                                <span class="role-badge role-<%= rolGrupo %>">
                                    <%= rolGrupo.equals("admin") ? "Administrador" : "Miembro" %>
                                </span>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="group-stats">
                        <span>Total de grupos: <strong><%= gruposUsuario.size() %></strong></span>
                        <a href="peti/dashboard.jsp?modo=colaborativo&grupo=<%= java.net.URLEncoder.encode(grupoSeleccionado != null ? grupoSeleccionado : "", "UTF-8") %>" 
                           class="peti-access">
                            🚀 Acceder al Sistema PETI
                        </a>
                    </div>
                </div>
                
                <!-- Información del Grupo Seleccionado -->
                <% 
                    Map<String, Object> grupoActivo = null;
                    for (Map<String, Object> g : gruposUsuario) {
                        if (((String) g.get("nombre")).equals(grupoSeleccionado)) {
                            grupoActivo = g;
                            break;
                        }
                    }
                    
                    if (grupoActivo != null) {
                        String rolActivo = (String) grupoActivo.get("rol");
                        Integer grupoId = (Integer) grupoActivo.get("id");
                        
                        // Obtener miembros del grupo
                        List<entidad.ClsELogin> miembros = grupoNegocio.obtenerMiembrosGrupo(grupoId);
                %>
                    <div class="main-grid">
                        <div class="card">
                            <h3>Información del Grupo</h3>
                            <div class="info-box">
                                <h4><%= grupoActivo.get("nombre") %></h4>
                                <p><strong>Tu rol:</strong> <%= rolActivo.equals("admin") ? "Administrador" : "Miembro" %></p>
                                <p><strong>Miembros:</strong> <%= grupoActivo.get("miembros") %> / <%= grupoActivo.get("limite_usuarios") %></p>
                                <p><strong>Código:</strong> <span class="code"><%= grupoActivo.get("codigo") %></span></p>
                            </div>
                            
                            <% if (rolActivo.equals("admin")) { %>
                                <div class="status-note">
                                    <strong>Eres administrador</strong> - Puedes gestionar miembros y generar nuevos códigos
                                </div>
                                <div class="action-buttons">
                                    <a href="generarCodigo.jsp?grupoId=<%= grupoId %>" class="btn btn-info">Generar Código</a>
                                    <a href="gestionarGrupo.jsp?grupoId=<%= grupoId %>" class="btn btn-secondary">Gestionar Miembros</a>
                                </div>
                            <% } else { %>
                                <div class="status-note member">
                                    <strong>Eres miembro</strong> - Puedes colaborar en el sistema PETI
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="card">
                            <h3>Miembros del Grupo</h3>
                            <div class="members-list">
                                <% for (entidad.ClsELogin miembro : miembros) { %>
                                    <div class="member-item">
                                        <span><%= miembro.getUsername() %></span>
                                        <% 
                                            // Verificar si es admin (esto requiere modificar la consulta o agregar el rol)
                                            boolean esAdmin = ((Integer) grupoActivo.get("admin_id")).equals(miembro.getId());
                                        %>
                                        <% if (esAdmin) { %>
                                            <span class="admin-badge">Admin</span>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                            
                            <% if (rolActivo.equals("admin")) { %>
                                <div class="action-buttons" style="margin-top: 1rem;">
                                    <a href="gestionarGrupo.jsp?grupoId=<%= grupoId %>" class="btn btn-primary">Gestionar Miembros</a>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="card">
                            <h3>Sistema PETI</h3>
                            <p>Accede al sistema de Planificación Estratégica de Tecnologías de Información en modo colaborativo con tu grupo.</p>
                            
                            <div class="info-box">
                                <h4>Grupo: <%= grupoActivo.get("nombre") %></h4>
                                <p>Rol: <%= rolActivo.equals("admin") ? "Administrador" : "Miembro" %></p>
                            </div>
                            
                            <a href="peti/dashboard.jsp?modo=colaborativo&grupo=<%= java.net.URLEncoder.encode((String) grupoActivo.get("nombre"), "UTF-8") %>&rol=<%= rolActivo %>" 
                               class="btn btn-success">Acceder al Sistema PETI (Modo Colaborativo)</a>
                        </div>
                        
                        <div class="card">
                            <h3>Configuración</h3>
                            <p>Opciones adicionales para tu participación en el grupo.</p>
                            
                            <div class="action-buttons">
                                <% if (!rolActivo.equals("admin")) { %>
                                    <a href="salirGrupo.jsp?grupoId=<%= grupoId %>" 
                                       class="btn btn-danger" 
                                       onclick="return confirm('¿Estás seguro de que quieres salir de este grupo?')">
                                        Salir del Grupo
                                    </a>
                                <% } else { %>
                                    <span class="btn btn-secondary" style="opacity: 0.6; cursor: not-allowed;">
                                        No puedes salir (Eres admin)
                                    </span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <!-- Opción para unirse a más grupos -->
                <div class="card" style="margin-top: 2rem;">
                    <h3>Unirse a Otro Grupo</h3>
                    <p>¿Tienes el código de otro grupo? Puedes unirte a múltiples grupos para colaborar en diferentes proyectos.</p>
                    
                    <form action="unirseGrupo.jsp" method="post">
                        <div class="form-group">
                            <label for="codigoGrupo">Código del Grupo:</label>
                            <input type="text" id="codigoGrupo" name="codigoGrupo" 
                                   placeholder="Ingresa el código del grupo" 
                                   style="text-transform: uppercase;" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Unirse al Grupo</button>
                    </form>
                </div>
                
            <% } else { %>
                <!-- Usuario sin grupos -->
                <div class="no-groups">
                    <h3>No perteneces a ningún grupo</h3>
                    <p>Puedes crear un nuevo grupo o unirte a uno existente usando un código.</p>
                </div>
                
                <div class="main-grid">
                    <div class="card">
                        <h3>Crear Nuevo Grupo</h3>
                        <p>Crea tu propio grupo y conviértete en administrador. Podrás invitar a otros usuarios y gestionar el grupo.</p>
                        
                        <form action="crearGrupo.jsp" method="post">
                            <div class="form-group">
                                <label for="nombreGrupo">Nombre del Grupo:</label>
                                <input type="text" id="nombreGrupo" name="nombreGrupo" 
                                       placeholder="Ej: Equipo de Desarrollo" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="limiteUsuarios">Límite de Usuarios:</label>
                                <select id="limiteUsuarios" name="limiteUsuarios" required>
                                    <option value="">Selecciona el límite</option>
                                    <option value="2">2 usuarios</option>
                                    <option value="3">3 usuarios</option>
                                    <option value="4">4 usuarios</option>
                                    <option value="5" selected>5 usuarios</option>
                                    <option value="6">6 usuarios</option>
                                    <option value="7">7 usuarios</option>
                                    <option value="8">8 usuarios</option>
                                    <option value="9">9 usuarios</option>
                                    <option value="10">10 usuarios</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn btn-success">Crear Grupo</button>
                        </form>
                    </div>
                    
                    <div class="card">
                        <h3>Unirse a Grupo Existente</h3>
                        <p>¿Ya tienes un código de grupo? Úsalo para unirte a un grupo existente.</p>
                        
                        <form action="unirseGrupo.jsp" method="post">
                            <div class="form-group">
                                <label for="codigoGrupo">Código del Grupo:</label>
                                <input type="text" id="codigoGrupo" name="codigoGrupo" 
                                       placeholder="Ej: ABC123" 
                                       style="text-transform: uppercase;" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Unirse al Grupo</button>
                        </form>
                    </div>
                    
                    <div class="card">
                        <h3>Explorar Sistema PETI</h3>
                        <p>También puedes explorar el sistema PETI en modo individual para familiarizarte con las herramientas.</p>
                        
                        <a href="peti/dashboard.jsp?modo=individual" class="btn btn-info">
                            Acceder al Sistema PETI (Modo Individual)
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    </body>
</html>