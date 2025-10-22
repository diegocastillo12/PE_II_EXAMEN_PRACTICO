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
    
    // Variables para la identificación de estrategia
    String estrategiaCompetitiva = "";
    String estrategiaCrecimiento = "";
    String estrategiaFuncional = "";
    String estrategiaCorporativa = "";
    String ventajaCompetitiva = "";
    String posicionamientoEstrategico = "";
    String factoresClavesExito = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevaCompetitiva = request.getParameter("competitiva");
        String nuevoCrecimiento = request.getParameter("crecimiento");
        String nuevaFuncional = request.getParameter("funcional");
        String nuevaCorporativa = request.getParameter("corporativa");
        String nuevaVentaja = request.getParameter("ventaja");
        String nuevoPosicionamiento = request.getParameter("posicionamiento");
        String nuevosFactores = request.getParameter("factores");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevaCompetitiva != null && !nuevaCompetitiva.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "identificacion_estrategia", "competitiva", nuevaCompetitiva.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoCrecimiento != null && !nuevoCrecimiento.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "identificacion_estrategia", "crecimiento", nuevoCrecimiento.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevaFuncional != null && !nuevaFuncional.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "identificacion_estrategia", "funcional", nuevaFuncional.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevaCorporativa != null && !nuevaCorporativa.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "identificacion_estrategia", "corporativa", nuevaCorporativa.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevaVentaja != null && !nuevaVentaja.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "identificacion_estrategia", "ventaja", nuevaVentaja.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevoPosicionamiento != null && !nuevoPosicionamiento.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "identificacion_estrategia", "posicionamiento", nuevoPosicionamiento.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosFactores != null && !nuevosFactores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "identificacion_estrategia", "factores", nuevosFactores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Identificación de Estrategia guardada exitosamente";
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
            Map<String, String> datosEstrategia = negocioPeti.obtenerDatosSeccion(grupoId, "identificacion_estrategia");
            
            estrategiaCompetitiva = datosEstrategia.getOrDefault("competitiva", "");
            estrategiaCrecimiento = datosEstrategia.getOrDefault("crecimiento", "");
            estrategiaFuncional = datosEstrategia.getOrDefault("funcional", "");
            estrategiaCorporativa = datosEstrategia.getOrDefault("corporativa", "");
            ventajaCompetitiva = datosEstrategia.getOrDefault("ventaja", "");
            posicionamientoEstrategico = datosEstrategia.getOrDefault("posicionamiento", "");
            factoresClavesExito = datosEstrategia.getOrDefault("factores", "");
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
    <title>Identificación de Estrategia - PETI Colaborativo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        /* Elementos decorativos flotantes */
        body::before {
            content: '';
            position: fixed;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 50px 50px;
            animation: float 20s linear infinite;
            pointer-events: none;
        }

        @keyframes float {
            0% { transform: translate(0, 0) rotate(0deg); }
            100% { transform: translate(-50px, -50px) rotate(360deg); }
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            z-index: 1;
        }

        /* Header con glassmorphism */
        .header {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 25px 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            animation: slideDown 0.8s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header h1 {
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header h1 i {
            color: #ffd700;
            filter: drop-shadow(0 0 10px rgba(255, 215, 0, 0.5));
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .btn-primary {
            background: rgba(52, 152, 219, 0.8);
            color: white;
        }

        .btn-secondary {
            background: rgba(149, 165, 166, 0.8);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            background: rgba(52, 152, 219, 0.9);
        }

        /* Contenido principal */
        .content {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
            animation: fadeInUp 1s ease-out 0.3s both;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Alertas */
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert-success {
            background: rgba(46, 204, 113, 0.2);
            border-left: 4px solid #2ecc71;
            color: #27ae60;
        }

        .alert-error {
            background: rgba(231, 76, 60, 0.2);
            border-left: 4px solid #e74c3c;
            color: #c0392b;
        }

        /* Información del modo colaborativo */
        .modo-colaborativo {
            background: rgba(52, 152, 219, 0.15);
            border: 1px solid rgba(52, 152, 219, 0.3);
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
        }

        .modo-colaborativo p {
            color: white;
            margin: 0;
            font-weight: 500;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
        }

        /* Tarjetas de estrategia */
        .estrategia-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .estrategia-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 25px;
            border-radius: 20px;
            transition: all 0.3s ease;
            animation: fadeInScale 0.6s ease-out;
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .estrategia-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
            background: rgba(255, 255, 255, 0.15);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .card-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffd700;
            font-size: 1.5rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .card-title {
            color: white;
            font-size: 1.3rem;
            font-weight: 600;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
        }

        /* Formularios */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: white;
            font-weight: 600;
            margin-bottom: 8px;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
        }

        .form-group textarea,
        .form-group input[type="text"] {
            width: 100%;
            padding: 15px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            color: white;
            font-size: 16px;
            transition: all 0.3s ease;
            resize: vertical;
            min-height: 100px;
        }

        .form-group textarea::placeholder,
        .form-group input[type="text"]::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .form-group textarea:focus,
        .form-group input[type="text"]:focus {
            outline: none;
            border-color: rgba(52, 152, 219, 0.6);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 20px rgba(52, 152, 219, 0.3);
        }

        /* Botón de guardar */
        .btn-save {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 30px auto 0;
            box-shadow: 0 8px 25px rgba(46, 204, 113, 0.3);
        }

        .btn-save {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 30px auto 0;
            box-shadow: 0 8px 25px rgba(46, 204, 113, 0.3);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(46, 204, 113, 0.4);
            background: linear-gradient(135deg, #27ae60, #229954);
        }

        .btn-save:active {
            transform: translateY(-1px);
        }

        /* Efectos de carga */
        .estrategia-card {
            opacity: 0;
            animation: slideInCard 0.6s ease-out forwards;
        }

        .estrategia-card:nth-child(1) { animation-delay: 0.1s; }
        .estrategia-card:nth-child(2) { animation-delay: 0.2s; }
        .estrategia-card:nth-child(3) { animation-delay: 0.3s; }
        .estrategia-card:nth-child(4) { animation-delay: 0.4s; }
        .estrategia-card:nth-child(5) { animation-delay: 0.5s; }
        .estrategia-card:nth-child(6) { animation-delay: 0.6s; }
        .estrategia-card:nth-child(7) { animation-delay: 0.7s; }

        @keyframes slideInCard {
            from {
                opacity: 0;
                transform: translateY(30px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Mejoras adicionales en los iconos */
        .card-icon {
            position: relative;
            overflow: hidden;
        }

        .card-icon::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: transform 0.6s;
            transform: translateX(-100%);
        }

        .estrategia-card:hover .card-icon::before {
            transform: translateX(100%);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .estrategia-grid {
                grid-template-columns: 1fr;
            }
            
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            
            .content {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-content">
                <div>
                    <h1>
                        <i class="fas fa-chess-king"></i> Identificación de Estrategia
                    </h1>
                    <p style="color: rgba(255,255,255,0.9); margin: 5px 0 0 65px; font-size: 1.1rem;">
                        Grupo: <strong><%= grupoActual %></strong>
                        <% if ("admin".equals(rolUsuario)) { %>
                            <span style="color: #ffd700; margin-left: 10px;">👑 Admin</span>
                        <% } %>
                    </p>
                </div>
                <div class="nav-buttons">
                    <a href="dashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Dashboard
                    </a>
                    <a href="../menuprincipal.jsp" class="btn btn-primary">
                        <i class="fas fa-home"></i> Menú Principal
                    </a>
                </div>
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
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Error:</strong> Debes estar en un grupo para acceder a esta página.
                    <a href="../menuprincipal.jsp" style="color: #c0392b; text-decoration: underline; font-weight: 600;">Ir al menú principal</a>
                </div>
            <% } else { %>

            <div style="background: rgba(255, 255, 255, 0.1); padding: 25px; border-radius: 20px; margin-bottom: 30px; backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);">
                <h2 style="color: white; text-align: center; margin-bottom: 20px; font-size: 2rem; font-weight: 700;">
                    <i class="fas fa-lightbulb" style="color: #ffd700; margin-right: 15px; filter: drop-shadow(0 0 10px rgba(255, 215, 0, 0.5));"></i>
                    Identificación de Estrategias PETI
                </h2>
                <p style="color: rgba(255, 255, 255, 0.9); text-align: center; font-size: 1.1rem; line-height: 1.7; margin-bottom: 20px;">
                    <i class="fas fa-users" style="color: #3498db;"></i> Colabora con tu equipo del grupo 
                    <strong style="color: #ffd700;"><%= grupoActual %></strong> para definir las estrategias clave del PETI. 
                    Los cambios se sincronizan automáticamente entre todos los miembros.
                </p>
                <div style="display: flex; justify-content: center; gap: 20px; margin-top: 20px; flex-wrap: wrap;">
                    <div style="background: linear-gradient(135deg, rgba(52, 152, 219, 0.3), rgba(52, 152, 219, 0.1)); padding: 12px 24px; border-radius: 25px; border: 1px solid rgba(52, 152, 219, 0.4); backdrop-filter: blur(10px); transition: all 0.3s ease;" 
                         onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 8px 25px rgba(52, 152, 219, 0.3)'"
                         onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                        <i class="fas fa-chess" style="color: #3498db; margin-right: 8px;"></i> 
                        <span style="color: white; font-weight: 600;">Estrategias Competitivas</span>
                    </div>
                    <div style="background: linear-gradient(135deg, rgba(46, 204, 113, 0.3), rgba(46, 204, 113, 0.1)); padding: 12px 24px; border-radius: 25px; border: 1px solid rgba(46, 204, 113, 0.4); backdrop-filter: blur(10px); transition: all 0.3s ease;"
                         onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 8px 25px rgba(46, 204, 113, 0.3)'"
                         onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                        <i class="fas fa-rocket" style="color: #2ecc71; margin-right: 8px;"></i> 
                        <span style="color: white; font-weight: 600;">Crecimiento & Expansión</span>
                    </div>
                    <div style="background: linear-gradient(135deg, rgba(155, 89, 182, 0.3), rgba(155, 89, 182, 0.1)); padding: 12px 24px; border-radius: 25px; border: 1px solid rgba(155, 89, 182, 0.4); backdrop-filter: blur(10px); transition: all 0.3s ease;"
                         onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 8px 25px rgba(155, 89, 182, 0.3)'"
                         onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                        <i class="fas fa-cogs" style="color: #9b59b6; margin-right: 8px;"></i> 
                        <span style="color: white; font-weight: 600;">Funcionales & Corporativas</span>
                    </div>
                </div>
            </div>

            <form method="post" action="">
                <!-- Grid de Estrategias -->
                <div class="estrategia-grid">
                    <!-- Estrategia Competitiva -->
                    <div class="estrategia-card" style="background: linear-gradient(135deg, rgba(76, 175, 80, 0.2), rgba(139, 195, 74, 0.1)); border: 1px solid rgba(76, 175, 80, 0.3);">
                        <div class="card-header">
                            <div class="card-icon" style="background: linear-gradient(135deg, #4caf50, #8bc34a); color: white;">
                                <i class="fas fa-chess-king"></i>
                            </div>
                            <div>
                                <h3 class="card-title" style="color: #4caf50; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Estrategia Competitiva</h3>
                                <p style="color: rgba(255,255,255,0.9); font-size: 0.95rem; margin: 5px 0;">
                                    <i class="fas fa-target" style="color: #4caf50; margin-right: 5px;"></i>
                                    Posicionamiento en el mercado y ventaja competitiva
                                </p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="competitiva" style="color: white; font-size: 1rem; margin-bottom: 10px;">
                                <i class="fas fa-crosshairs" style="color: #4caf50;"></i> Estrategia de Competencia
                            </label>
                            <textarea id="competitiva" name="competitiva" 
                                      style="background: rgba(255,255,255,0.15); border: 1px solid rgba(76, 175, 80, 0.4); color: white; min-height: 140px;"
                                      placeholder="• Liderazgo en costos vs diferenciación&#10;• Enfoque en nichos específicos&#10;• Ventajas competitivas sostenibles&#10;• Posicionamiento frente a competidores&#10;• Estrategias de defensa/ataque"
                                      onchange="guardarCampo(this)" oninput="marcarCambiado(this)"
                                      ><%= estrategiaCompetitiva %></textarea>
                        </div>
                    </div>

                    <!-- Estrategia de Crecimiento -->
                    <div class="estrategia-card" style="background: linear-gradient(135deg, rgba(33, 150, 243, 0.2), rgba(3, 169, 244, 0.1)); border: 1px solid rgba(33, 150, 243, 0.3);">
                        <div class="card-header">
                            <div class="card-icon" style="background: linear-gradient(135deg, #2196f3, #03a9f4); color: white;">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div>
                                <h3 class="card-title" style="color: #2196f3; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Estrategia de Crecimiento</h3>
                                <p style="color: rgba(255,255,255,0.9); font-size: 0.95rem; margin: 5px 0;">
                                    <i class="fas fa-rocket" style="color: #2196f3; margin-right: 5px;"></i>
                                    Expansión, desarrollo y escalabilidad organizacional
                                </p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="crecimiento" style="color: white; font-size: 1rem; margin-bottom: 10px;">
                                <i class="fas fa-expand-arrows-alt" style="color: #2196f3;"></i> Planes de Expansión
                            </label>
                            <textarea id="crecimiento" name="crecimiento" 
                                      style="background: rgba(255,255,255,0.15); border: 1px solid rgba(33, 150, 243, 0.4); color: white; min-height: 140px;"
                                      placeholder="• Nuevos mercados y segmentos&#10;• Desarrollo de productos/servicios&#10;• Alianzas estratégicas y partnerships&#10;• Penetración y expansión geográfica&#10;• Crecimiento orgánico vs adquisiciones"
                                      onchange="guardarCampo(this)" oninput="marcarCambiado(this)"
                                      ><%= estrategiaCrecimiento %></textarea>
                        </div>
                    </div>

                    <!-- Estrategia Funcional -->
                    <div class="estrategia-card" style="background: linear-gradient(135deg, rgba(156, 39, 176, 0.2), rgba(233, 30, 99, 0.1)); border: 1px solid rgba(156, 39, 176, 0.3);">
                        <div class="card-header">
                            <div class="card-icon" style="background: linear-gradient(135deg, #9c27b0, #e91e63); color: white;">
                                <i class="fas fa-cogs"></i>
                            </div>
                            <div>
                                <h3 class="card-title" style="color: #9c27b0; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Estrategia Funcional</h3>
                                <p style="color: rgba(255,255,255,0.9); font-size: 0.95rem; margin: 5px 0;">
                                    <i class="fas fa-sitemap" style="color: #9c27b0; margin-right: 5px;"></i>
                                    Estrategias específicas por área y departamento
                                </p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="funcional" style="color: white; font-size: 1rem; margin-bottom: 10px;">
                                <i class="fas fa-puzzle-piece" style="color: #9c27b0;"></i> Estrategias por Función
                            </label>
                            <textarea id="funcional" name="funcional" 
                                      style="background: rgba(255,255,255,0.15); border: 1px solid rgba(156, 39, 176, 0.4); color: white; min-height: 140px;"
                                      placeholder="• Marketing: segmentación, branding, canales&#10;• Operaciones: eficiencia, calidad, procesos&#10;• Finanzas: estructura capital, inversiones&#10;• RRHH: talento, cultura, competencias&#10;• Tecnología: digital, sistemas, innovación"
                                      onchange="guardarCampo(this)" oninput="marcarCambiado(this)"
                                      ><%= estrategiaFuncional %></textarea>
                        </div>
                    </div>

                    <!-- Estrategia Corporativa -->
                    <div class="estrategia-card" style="background: linear-gradient(135deg, rgba(255, 152, 0, 0.2), rgba(255, 193, 7, 0.1)); border: 1px solid rgba(255, 152, 0, 0.3);">
                        <div class="card-header">
                            <div class="card-icon" style="background: linear-gradient(135deg, #ff9800, #ffc107); color: white;">
                                <i class="fas fa-building"></i>
                            </div>
                            <div>
                                <h3 class="card-title" style="color: #ff9800; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Estrategia Corporativa</h3>
                                <p style="color: rgba(255,255,255,0.9); font-size: 0.95rem; margin: 5px 0;">
                                    <i class="fas fa-chess-king" style="color: #ff9800; margin-right: 5px;"></i>
                                    Gestión del portafolio y estructura organizacional
                                </p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="corporativa" style="color: white; font-size: 1rem; margin-bottom: 10px;">
                                <i class="fas fa-chess-board" style="color: #ff9800;"></i> Estrategia Global
                            </label>
                            <textarea id="corporativa" name="corporativa" 
                                      style="background: rgba(255,255,255,0.15); border: 1px solid rgba(255, 152, 0, 0.4); color: white; min-height: 140px;"
                                      placeholder="• Diversificación de portafolio&#10;• Integración vertical/horizontal&#10;• Reestructuración organizacional&#10;• Fusiones y adquisiciones&#10;• Desinversión y spin-offs&#10;• Governance y control corporativo"
                                      onchange="guardarCampo(this)" oninput="marcarCambiado(this)"
                                      ><%= estrategiaCorporativa %></textarea>
                        </div>
                    </div>

                    <!-- Ventaja Competitiva -->
                    <div class="estrategia-card" style="background: linear-gradient(135deg, rgba(244, 67, 54, 0.2), rgba(255, 87, 34, 0.1)); border: 1px solid rgba(244, 67, 54, 0.3);">
                        <div class="card-header">
                            <div class="card-icon" style="background: linear-gradient(135deg, #f44336, #ff5722); color: white;">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <div>
                                <h3 class="card-title" style="color: #f44336; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Ventaja Competitiva</h3>
                                <p style="color: rgba(255,255,255,0.9); font-size: 0.95rem; margin: 5px 0;">
                                    <i class="fas fa-medal" style="color: #f44336; margin-right: 5px;"></i>
                                    Factor diferenciador único e inimitable
                                </p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="ventaja" style="color: white; font-size: 1rem; margin-bottom: 10px;">
                                <i class="fas fa-star" style="color: #f44336;"></i> Ventaja Distintiva
                            </label>
                            <textarea id="ventaja" name="ventaja" 
                                      style="background: rgba(255,255,255,0.15); border: 1px solid rgba(244, 67, 54, 0.4); color: white; min-height: 140px;"
                                      placeholder="• Recursos únicos y capacidades distintivas&#10;• Tecnología propietaria o know-how&#10;• Relaciones exclusivas con clientes/proveedores&#10;• Marca y reputación consolidada&#10;• Eficiencias operacionales superiores"
                                      onchange="guardarCampo(this)" oninput="marcarCambiado(this)"
                                      ><%= ventajaCompetitiva %></textarea>
                        </div>
                    </div>

                    <!-- Posicionamiento Estratégico -->
                    <div class="estrategia-card" style="background: linear-gradient(135deg, rgba(0, 188, 212, 0.2), rgba(0, 172, 193, 0.1)); border: 1px solid rgba(0, 188, 212, 0.3);">
                        <div class="card-header">
                            <div class="card-icon" style="background: linear-gradient(135deg, #00bcd4, #00acc1); color: white;">
                                <i class="fas fa-crosshairs"></i>
                            </div>
                            <div>
                                <h3 class="card-title" style="color: #00bcd4; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Posicionamiento Estratégico</h3>
                                <p style="color: rgba(255,255,255,0.9); font-size: 0.95rem; margin: 5px 0;">
                                    <i class="fas fa-map-marker-alt" style="color: #00bcd4; margin-right: 5px;"></i>
                                    Percepción deseada en el mercado objetivo
                                </p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="posicionamiento" style="color: white; font-size: 1rem; margin-bottom: 10px;">
                                <i class="fas fa-bullseye" style="color: #00bcd4;"></i> Posición en el Mercado
                            </label>
                            <textarea id="posicionamiento" name="posicionamiento" 
                                      style="background: rgba(255,255,255,0.15); border: 1px solid rgba(0, 188, 212, 0.4); color: white; min-height: 140px;"
                                      placeholder="• Imagen de marca deseada&#10;• Segmento objetivo específico&#10;• Propuesta de valor única&#10;• Diferenciación vs competencia&#10;• Percepción de calidad/precio&#10;• Posicionamiento premium/masivo/nicho"
                                      onchange="guardarCampo(this)" oninput="marcarCambiado(this)"
                                      ><%= posicionamientoEstrategico %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Factores Clave de Éxito -->
                <div class="estrategia-card" style="grid-column: 1 / -1; margin-top: 30px; background: linear-gradient(135deg, rgba(255, 193, 7, 0.2), rgba(255, 235, 59, 0.1)); border: 1px solid rgba(255, 193, 7, 0.3);">
                    <div class="card-header">
                        <div class="card-icon" style="background: linear-gradient(135deg, #ffc107, #ffeb3b); color: #333;">
                            <i class="fas fa-key"></i>
                        </div>
                        <div>
                            <h3 class="card-title" style="color: #ffc107; text-shadow: 0 2px 4px rgba(0,0,0,0.3); font-size: 1.3rem;">Factores Clave de Éxito</h3>
                            <p style="color: rgba(255,255,255,0.9); font-size: 1rem; margin: 8px 0;">
                                <i class="fas fa-lightbulb" style="color: #ffc107; margin-right: 8px;"></i>
                                Elementos críticos y habilitadores del éxito estratégico
                            </p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="factores" style="color: white; font-size: 1.1rem; margin-bottom: 15px;">
                            <i class="fas fa-list-check" style="color: #ffc107;"></i> Factores Críticos de Éxito
                        </label>
                        <textarea id="factores" name="factores" 
                                  style="background: rgba(255,255,255,0.15); border: 1px solid rgba(255, 193, 7, 0.4); color: white; min-height: 160px; font-size: 1rem;"
                                  placeholder="• Capacidades organizacionales requeridas&#10;• Recursos financieros y humanos críticos&#10;• Sistemas y procesos habilitadores&#10;• Cultura organizacional y liderazgo&#10;• Partnerships y alianzas estratégicas&#10;• Innovación y adaptabilidad&#10;• Gestión del riesgo y compliance&#10;• Métricas y KPIs de seguimiento"
                                  onchange="guardarCampo(this)" oninput="marcarCambiado(this)"
                                  ><%= factoresClavesExito %></textarea>
                    </div>
                </div>

                <button type="submit" class="btn-save">
                    <i class="fas fa-save"></i>
                    Guardar Estrategias
                </button>
            </form>

            <div class="modo-colaborativo" style="margin-top: 30px;">
                <p>
                    <i class="fas fa-info-circle"></i> 
                    <strong>Modo Colaborativo:</strong> La Identificación de Estrategia se guarda automáticamente y es visible 
                    para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                </p>
            </div>

            <% } %>
        </div>
    </div>

    <script>
        // Auto-refresh cada 15 segundos para colaboración en tiempo real
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
        }, 15000);

        // Marcar como cambiado para evitar refresh automático
        document.querySelectorAll('textarea').forEach(element => {
            element.addEventListener('input', function() {
                this.dataset.changed = 'true';
            });
        });

        // Guardar automáticamente al escribir
        function marcarCambiado(elemento) {
            elemento.dataset.changed = 'true';
            elemento.style.borderColor = 'rgba(255, 193, 7, 0.6)';
            clearTimeout(elemento.saveTimeout);
            elemento.saveTimeout = setTimeout(() => guardarCampo(elemento), 1000);
        }

        function guardarCampo(campo) {
            try {
                const grupoId = '<%= grupoId %>';
                if (!grupoId || grupoId === 'null') return;

                const formData = new FormData();
                formData.append('action', 'guardarCampo');
                formData.append('grupoId', grupoId);
                formData.append('campo', campo.id);
                formData.append('valor', campo.value);

                fetch('guardarIdentificacionEstrategia.jsp', {
                    method: 'POST',
                    body: formData
                }).then(() => {
                    campo.style.borderColor = 'rgba(46, 204, 113, 0.6)';
                    setTimeout(() => {
                        campo.style.borderColor = '';
                    }, 2000);
                });
            } catch (error) {
                console.error('Error al guardar campo:', error);
            }
        }

        // Animaciones de aparición secuencial mejoradas
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.estrategia-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 150);
            });

            // Efectos hover mejorados
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px) scale(1.02)';
                    this.style.boxShadow = '0 15px 40px rgba(0, 0, 0, 0.2)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                    this.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.1)';
                });
            });
        });
    </script>
</body>
</html>