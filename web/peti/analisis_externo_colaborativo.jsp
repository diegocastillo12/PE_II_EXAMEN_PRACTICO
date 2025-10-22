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
    
    // Variables para los datos
    String oportunidades = "";
    String amenazas = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevasOportunidades = request.getParameter("oportunidades");
        String nuevasAmenazas = request.getParameter("amenazas");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevasOportunidades != null && !nuevasOportunidades.trim().isEmpty()) {
                ClsEPeti datoOportunidades = new ClsEPeti(grupoId, "analisis_externo", "oportunidades", nuevasOportunidades.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoOportunidades);
            }
            if (nuevasAmenazas != null && !nuevasAmenazas.trim().isEmpty()) {
                ClsEPeti datoAmenazas = new ClsEPeti(grupoId, "analisis_externo", "amenazas", nuevasAmenazas.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(datoAmenazas);
            }
            
            if (exito) {
                mensaje = "Análisis externo guardado exitosamente";
                tipoMensaje = "success";
            } else {
                mensaje = "Error al guardar el análisis externo";
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
            Map<String, String> datosAnalisis = negocioPeti.obtenerDatosSeccion(grupoId, "analisis_externo");
            
            if (datosAnalisis.containsKey("oportunidades")) {
                oportunidades = datosAnalisis.get("oportunidades");
            }
            if (datosAnalisis.containsKey("amenazas")) {
                amenazas = datosAnalisis.get("amenazas");
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
    <title>Análisis Externo - PETI Colaborativo</title>
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

        .btn-success {
            background: var(--success-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            text-decoration: none;
        }

        .btn-success:hover {
            background: #2f855a;
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-success i {
            margin-right: 8px;
        }

        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: rgba(56, 161, 105, 0.1);
            border: 1px solid rgba(56, 161, 105, 0.2);
            color: var(--success-color);
        }

        .alert-error {
            background: rgba(229, 62, 62, 0.1);
            border: 1px solid rgba(229, 62, 62, 0.2);
            color: var(--danger-color);
        }

        .alert-warning {
            background: rgba(214, 158, 46, 0.1);
            border: 1px solid rgba(214, 158, 46, 0.2);
            color: var(--warning-color);
        }

        .analysis-section {
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
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-content {
            padding: 24px;
        }

        .analysis-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }

        @media (max-width: 768px) {
            .analysis-grid {
                grid-template-columns: 1fr;
            }
        }

        .analysis-card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .analysis-card-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .opportunities .analysis-card-header {
            background: rgba(56, 161, 105, 0.05);
            border-bottom-color: rgba(56, 161, 105, 0.2);
        }

        .threats .analysis-card-header {
            background: rgba(229, 62, 62, 0.05);
            border-bottom-color: rgba(229, 62, 62, 0.2);
        }

        .analysis-card-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
        }

        .opportunities .analysis-card-header h3 {
            color: var(--success-color);
        }

        .threats .analysis-card-header h3 {
            color: var(--danger-color);
        }

        .analysis-card-content {
            padding: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-weight: 600;
            font-size: 14px;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            font-size: 14px;
            min-height: 150px;
            resize: vertical;
            transition: border-color 0.3s ease;
            font-family: inherit;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
        }

        .guidelines {
            background: rgba(49, 130, 206, 0.05);
            border: 1px solid rgba(49, 130, 206, 0.1);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 24px;
        }

        .guidelines h4 {
            color: var(--accent-color);
            margin-bottom: 12px;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .guidelines-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 16px;
        }

        .guidelines-column h5 {
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .guidelines-column.opportunities h5 {
            color: var(--success-color);
        }

        .guidelines-column.threats h5 {
            color: var(--danger-color);
        }

        .guidelines ul {
            color: var(--text-secondary);
            padding-left: 20px;
        }

        .guidelines li {
            margin-bottom: 6px;
            line-height: 1.5;
        }

        .preview-card {
            background: rgba(26, 54, 93, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 16px;
            margin-top: 16px;
        }

        .preview-card h4 {
            color: var(--text-primary);
            margin-bottom: 12px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .preview-list {
            list-style: none;
            padding: 0;
        }

        .preview-list li {
            background: var(--card-bg);
            padding: 12px 16px;
            margin-bottom: 8px;
            border-radius: 6px;
            border-left: 4px solid;
            position: relative;
            font-size: 14px;
            line-height: 1.4;
        }

        .preview-list.opportunities li {
            border-left-color: var(--success-color);
        }

        .preview-list.threats li {
            border-left-color: var(--danger-color);
        }

        .preview-list li::before {
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            margin-right: 8px;
        }

        .preview-list.opportunities li::before {
            content: "\f058";
            color: var(--success-color);
        }

        .preview-list.threats li::before {
            content: "\f071";
            color: var(--danger-color);
        }

        .save-section {
            text-align: center;
            margin-top: 32px;
            padding: 24px;
            background: linear-gradient(135deg, var(--accent-color), #2c5282);
            border-radius: 12px;
            color: white;
        }

        .save-section h3 {
            margin-bottom: 12px;
            font-size: 20px;
            font-weight: 600;
        }

        .save-section p {
            margin-bottom: 20px;
            opacity: 0.9;
        }

        .status-indicator {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 500;
            padding: 4px 8px;
            border-radius: 4px;
            background: rgba(56, 161, 105, 0.1);
            color: var(--success-color);
        }

        .info-section {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            margin-bottom: 32px;
            overflow: hidden;
        }

        .info-header {
            padding: 24px 32px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .info-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .info-content {
            padding: 32px;
        }

        .info-description {
            font-size: 16px;
            line-height: 1.6;
            color: var(--text-secondary);
            margin-bottom: 20px;
            text-align: justify;
        }

        .analysis-flow {
            display: flex;
            flex-direction: column;
            gap: 24px;
            margin: 32px 0;
            padding: 24px;
            background: rgba(49, 130, 206, 0.02);
            border-radius: 12px;
            border: 1px solid rgba(49, 130, 206, 0.1);
        }

        .flow-item {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .flow-box {
            background: var(--primary-color);
            color: white;
            padding: 16px 24px;
            border-radius: 8px;
            font-weight: 600;
            min-width: 200px;
            text-align: center;
        }

        .flow-arrows {
            display: flex;
            align-items: center;
        }

        .arrow-right {
            width: 0;
            height: 0;
            border-left: 15px solid var(--accent-color);
            border-top: 10px solid transparent;
            border-bottom: 10px solid transparent;
        }

        .flow-elements {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .element {
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            font-size: 14px;
        }

        .element.opportunities {
            background: rgba(229, 62, 62, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(229, 62, 62, 0.2);
        }

        .element.threats {
            background: rgba(56, 161, 105, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(56, 161, 105, 0.2);
        }

        .element.strengths {
            background: rgba(229, 62, 62, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(229, 62, 62, 0.2);
        }

        .element.weaknesses {
            background: rgba(56, 161, 105, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(56, 161, 105, 0.2);
        }

        .flow-result {
            margin-top: 20px;
            text-align: center;
        }

        .result-box {
            background: var(--accent-color);
            color: white;
            padding: 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
        }

        .definitions-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin: 32px 0;
        }

        .definition-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            box-shadow: var(--shadow-sm);
        }

        .definition-card h4 {
            margin: 0 0 12px 0;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .definition-card h4 i {
            font-size: 18px;
        }

        .definition-card h4:has(.fa-plus-circle) {
            color: var(--success-color);
        }

        .definition-card h4:has(.fa-exclamation-triangle) {
            color: var(--danger-color);
        }

        .definition-card h4:has(.fa-star) {
            color: var(--warning-color);
        }

        .definition-card h4:has(.fa-minus-circle) {
            color: var(--text-secondary);
        }

        .definition-card p {
            margin: 0 0 12px 0;
            line-height: 1.5;
            color: var(--text-secondary);
            text-align: justify;
        }

        .definition-card p:last-child {
            margin-bottom: 0;
        }

        .foda-section {
            margin-top: 32px;
            padding: 24px;
            background: rgba(26, 54, 93, 0.02);
            border-radius: 12px;
            border: 1px solid rgba(26, 54, 93, 0.1);
        }

        .foda-section h3 {
            color: var(--primary-color);
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 24px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .foda-diagram {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 24px;
        }

        .foda-center {
            text-align: center;
        }

        .foda-box {
            background: var(--accent-color);
            color: white;
            padding: 20px 40px;
            border-radius: 50%;
            font-size: 24px;
            font-weight: 700;
            display: inline-block;
            min-width: 100px;
            min-height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .foda-branches {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            width: 100%;
            max-width: 800px;
        }

        .foda-branch {
            text-align: center;
        }

        .branch-box {
            background: var(--primary-color);
            color: white;
            padding: 16px 20px;
            border-radius: 8px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        .sub-branches {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sub-box {
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
        }

        .sub-box.micro {
            background: rgba(56, 161, 105, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(56, 161, 105, 0.2);
        }

        .sub-box.macro {
            background: rgba(214, 158, 46, 0.1);
            color: var(--warning-color);
            border: 1px solid rgba(214, 158, 46, 0.2);
        }

        .sub-box.chain {
            background: rgba(49, 130, 206, 0.1);
            color: var(--accent-color);
            border: 1px solid rgba(49, 130, 206, 0.2);
        }

        .sub-box.matrix {
            background: rgba(229, 62, 62, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(229, 62, 62, 0.2);
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
            
            .analysis-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .dashboard-header {
                padding: 16px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .guidelines-grid {
                grid-template-columns: 1fr;
            }

            .definitions-grid {
                grid-template-columns: 1fr;
            }

            .foda-branches {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .analysis-flow {
                padding: 16px;
            }

            .flow-item {
                flex-direction: column;
                text-align: center;
                gap: 12px;
            }

            .flow-box {
                min-width: auto;
                width: 100%;
            }

            .info-content {
                padding: 20px;
            }

            .info-header {
                padding: 20px;
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
                        <li><a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
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
                        <li class="active"><a href="analisis_externo_colaborativo.jsp"><i class="fas fa-search"></i> Análisis del Entorno</a></li>
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
                    <i class="fas fa-search"></i> Análisis Externo
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
                            <% if ("admin".equals(rolUsuario)) { %>
                                <span class="admin-badge">
                                    <i class="fas fa-crown"></i> Administrador
                                </span>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="status-badge">
                            <i class="fas fa-user"></i> Modo Individual
                        </div>
                    <% } %>
                    <a href="../menuprincipal.jsp" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Menú Principal
                    </a>
                </div>
            </header>
            <main class="dashboard-main">
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
                        <a href="../menuprincipal.jsp" style="color: var(--warning-color); text-decoration: underline;">Únete a un grupo</a> 
                        para trabajar colaborativamente.
                    </div>
                <% } %>

                <!-- Sección Informativa del Análisis Externo -->
                <div class="info-section">
                    <div class="info-header">
                        <h2><i class="fas fa-search"></i> 5. ANÁLISIS INTERNO Y EXTERNO</h2>
                    </div>
                    
                    <div class="info-content">
                        <p class="info-description">
                            Fijados los objetivos estratégicos se debe analizar las distintas estrategias para lograrlos. De 
                            esta forma las estrategias son los caminos que diferentes profesionales proponen para alcanzar los objetivos. 
                            Responden a la pregunta ¿cómo?
                        </p>
                        
                        <p class="info-description">
                            Para determinar la estrategia, podemos basarnos en el conjunto de estrategias genéricas y 
                            específicas que diferentes profesionales proponen al respecto. Esta guía, lejos de rozar la 
                            teoría, propone llevar a cabo un análisis interno y externo que nos permita obtener una 
                            estrategia que se ajuste a la realidad de la empresa.
                        </p>
                        
                        <p class="info-description">
                            Este análisis te permitirá detectar por un lado los factores de éxito (fortalezas y 
                            oportunidades) y por otro lado, las debilidades y amenazas que esta empresa debe gestionar.
                        </p>
                        
                        <div class="analysis-flow">
                            <div class="flow-item analysis-external">
                                <div class="flow-box">
                                    <h4>ANÁLISIS EXTERNO</h4>
                                </div>
                                <div class="flow-arrows">
                                    <div class="arrow-right"></div>
                                </div>
                                <div class="flow-elements">
                                    <div class="element opportunities">AMENAZAS</div>
                                    <div class="element threats">OPORTUNIDADES</div>
                                </div>
                            </div>
                            
                            <div class="flow-item analysis-internal">
                                <div class="flow-box">
                                    <h4>ANÁLISIS INTERNO</h4>
                                </div>
                                <div class="flow-arrows">
                                    <div class="arrow-right"></div>
                                </div>
                                <div class="flow-elements">
                                    <div class="element strengths">DEBILIDADES</div>
                                    <div class="element weaknesses">FORTALEZAS</div>
                                </div>
                            </div>
                            
                            <div class="flow-result">
                                <div class="result-box">
                                    <h4>ANÁLISIS DE RECURSOS Y CAPACIDADES DE LA EMPRESA</h4>
                                </div>
                            </div>
                        </div>
                        
                        <div class="definitions-grid">
                            <div class="definition-card">
                                <h4><i class="fas fa-plus-circle"></i> Oportunidades:</h4>
                                <p>aquellos aspectos que pueden presentar una posibilidad para mejorar la 
                                rentabilidad de la empresa, aumentar la cifra de negocio y fortalecer la ventaja competitiva</p>
                                <p><strong>Ejemplos:</strong> Fuerte crecimiento, desarrollo de la automatización, nuevas tecnologías, seguridad 
                                de la información, nuevos grupos objetivo, competencia con precios altos, cambio de hábitos de 
                                consumo, recursos financieros adecuados, ventajas en costes, lider en el mercado, buena 
                                imagen ante los clientes.</p>
                            </div>
                            
                            <div class="definition-card">
                                <h4><i class="fas fa-exclamation-triangle"></i> Amenazas:</h4>
                                <p>son fuerzas y presiones del mercado externo que pueden impedir y dificultar el 
                                crecimiento de la empresa, la ejecución de la estrategia, reducir su eficacia o incrementar los 
                                riesgos del negocio, reducir los ingresos y sector de actividad.</p>
                                <p><strong>Ejemplos:</strong> Competencia en el mercado, aparición de nuevos competidores, reglamentación 
                                desfavorable, crisis económica, cambio de gustos de los consumidores, creciente 
                                poder de negociación de clientes y/o proveedores.</p>
                            </div>
                            
                            <div class="definition-card">
                                <h4><i class="fas fa-star"></i> Fortalezas:</h4>
                                <p>son capacidades, recursos, posiciones alcanzadas, ventajas competitivas que 
                                posee la empresa y que la ayudan a aprovechar las oportunidades del mercado</p>
                                <p><strong>Ejemplos:</strong> Recursos disponibles, capacidad de la dirección, habilidad para competir, capacidad de 
                                innovación, recursos financieros adecuados, ventajas en costes, lider en el mercado, buena 
                                imagen ante los clientes.</p>
                            </div>
                            
                            <div class="definition-card">
                                <h4><i class="fas fa-minus-circle"></i> Debilidades:</h4>
                                <p>son todos aquellos aspectos que limitan o reducen la capacidad de desarrollo 
                                de la empresa. Constituyen dificultades para la organización y deben, por tanto, ser 
                                controladas y superadas.</p>
                                <p><strong>Ejemplos:</strong> Pocos recursos disponibles, productos en el final de su ciclo de vida, deficiente control de 
                                los riesgos, recursos humanos poco cualificados, débil imagen en el mercado, red de 
                                distribución limitada, falta de dirección estratégica clara etc.</p>
                            </div>
                        </div>
                        
                        <div class="foda-section">
                            <h3><i class="fas fa-chart-line"></i> Para elaborar el análisis FODA de su empresa le proponemos que utilice distintos 
                            instrumentos para el análisis tanto externo como interno.</h3>
                            
                            <div class="foda-diagram">
                                <div class="foda-center">
                                    <div class="foda-box">FODA</div>
                                </div>
                                <div class="foda-branches">
                                    <div class="foda-branch left">
                                        <div class="branch-box">ANÁLISIS EXTERNO</div>
                                        <div class="sub-branches">
                                            <div class="sub-branch">
                                                <div class="sub-box micro">MICROENTORNO (A.E. CINCO FUERZAS DE PORTER)</div>
                                            </div>
                                            <div class="sub-branch">
                                                <div class="sub-box macro">MACROENTORNO (A.E. PEST)</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="foda-branch right">
                                        <div class="branch-box">ANÁLISIS INTERNO</div>
                                        <div class="sub-branches">
                                            <div class="sub-branch">
                                                <div class="sub-box chain">CADENA DE VALOR</div>
                                            </div>
                                            <div class="sub-branch">
                                                <div class="sub-box matrix">MATRIZ DE PARTICIPACIÓN-CRECIMIENTO (BCG)</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="guidelines">
                    <h4><i class="fas fa-lightbulb"></i> Guía para el Análisis Externo</h4>
                    <p><strong>Analiza el entorno externo de tu organización identificando factores que pueden influir positiva o negativamente:</strong></p>
                    <div class="guidelines-grid">
                        <div class="guidelines-column opportunities">
                            <h5><i class="fas fa-plus-circle"></i> Oportunidades</h5>
                            <ul>
                                <li>Nuevos mercados o segmentos</li>
                                <li>Avances tecnológicos</li>
                                <li>Cambios en regulaciones favorables</li>
                                <li>Tendencias del mercado</li>
                                <li>Alianzas estratégicas posibles</li>
                            </ul>
                        </div>
                        <div class="guidelines-column threats">
                            <h5><i class="fas fa-exclamation-triangle"></i> Amenazas</h5>
                            <ul>
                                <li>Competencia agresiva</li>
                                <li>Crisis económicas</li>
                                <li>Cambios regulatorios negativos</li>
                                <li>Obsolescencia tecnológica</li>
                                <li>Cambios en gustos del consumidor</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <form method="post" action="">
                    <div class="analysis-grid">
                        <!-- Oportunidades -->
                        <div class="analysis-card opportunities">
                            <div class="analysis-card-header">
                                <i class="fas fa-plus-circle"></i>
                                <h3>Oportunidades</h3>
                                <% if (modoColaborativo && !oportunidades.isEmpty()) { %>
                                    <span class="status-indicator">
                                        <i class="fas fa-check-circle"></i> Guardado
                                    </span>
                                <% } %>
                            </div>
                            <div class="analysis-card-content">
                                <div class="form-group">
                                    <label for="oportunidades">
                                        Identifica las oportunidades del entorno externo:
                                    </label>
                                    <textarea 
                                        id="oportunidades" 
                                        name="oportunidades"
                                        placeholder="Escribe cada oportunidad en una línea diferente:&#10;&#10;• Crecimiento del mercado digital&#10;• Nueva legislación que favorece nuestro sector&#10;• Tendencia hacia la sostenibilidad&#10;• Posibles alianzas con empresas complementarias&#10;• Avances tecnológicos que podemos adoptar"
                                        <%= modoColaborativo ? "" : "readonly" %>
                                        onkeyup="actualizarPreviewOportunidades()"
                                    ><%= oportunidades %></textarea>
                                </div>

                                <div class="preview-card">
                                    <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                                    <ul class="preview-list opportunities" id="previewOportunidades">
                                        <% if (!oportunidades.isEmpty()) { %>
                                            <%
                                                String[] lineasOp = oportunidades.split("\\n");
                                                for (String linea : lineasOp) {
                                                    linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                                    if (linea.length() > 0) {
                                            %>
                                            <li><%= linea %></li>
                                            <%
                                                    }
                                                }
                                            %>
                                        <% } else { %>
                                            <li>Las oportunidades aparecerán aquí mientras las escribes</li>
                                        <% } %>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Amenazas -->
                        <div class="analysis-card threats">
                            <div class="analysis-card-header">
                                <i class="fas fa-exclamation-triangle"></i>
                                <h3>Amenazas</h3>
                                <% if (modoColaborativo && !amenazas.isEmpty()) { %>
                                    <span class="status-indicator">
                                        <i class="fas fa-check-circle"></i> Guardado
                                    </span>
                                <% } %>
                            </div>
                            <div class="analysis-card-content">
                                <div class="form-group">
                                    <label for="amenazas">
                                        Identifica las amenazas del entorno externo:
                                    </label>
                                    <textarea 
                                        id="amenazas" 
                                        name="amenazas"
                                        placeholder="Escribe cada amenaza en una línea diferente:&#10;&#10;• Entrada de nuevos competidores&#10;• Crisis económica global&#10;• Cambios en regulaciones del sector&#10;• Obsolescencia de nuestras tecnologías&#10;• Cambios en preferencias de los clientes"
                                        <%= modoColaborativo ? "" : "readonly" %>
                                        onkeyup="actualizarPreviewAmenazas()"
                                    ><%= amenazas %></textarea>
                                </div>

                                <div class="preview-card">
                                    <h4><i class="fas fa-eye"></i> Vista Previa</h4>
                                    <ul class="preview-list threats" id="previewAmenazas">
                                        <% if (!amenazas.isEmpty()) { %>
                                            <%
                                                String[] lineasAm = amenazas.split("\\n");
                                                for (String linea : lineasAm) {
                                                    linea = linea.trim().replaceAll("^[•\\-\\*]\\s*", "");
                                                    if (linea.length() > 0) {
                                            %>
                                            <li><%= linea %></li>
                                            <%
                                                    }
                                                }
                                            %>
                                        <% } else { %>
                                            <li>Las amenazas aparecerán aquí mientras las escribes</li>
                                        <% } %>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (modoColaborativo) { %>
                        <div class="save-section">
                            <h3><i class="fas fa-save"></i> Guardar Análisis Externo</h3>
                            <p>Los cambios se guardarán para todo el equipo y estarán disponibles para los siguientes análisis</p>
                            <button type="submit" class="btn-success">
                                <i class="fas fa-save"></i> Guardar Oportunidades y Amenazas
                            </button>
                        </div>
                    <% } %>
                </form>

                <% if (modoColaborativo) { %>
                    <div style="background: rgba(56, 161, 105, 0.05); border: 1px solid rgba(56, 161, 105, 0.2); padding: 16px; border-radius: 8px; margin-top: 24px;">
                        <p style="color: var(--success-color); margin: 0; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-info-circle"></i> 
                            <strong>Modo Colaborativo Activo:</strong> Los cambios se guardan automáticamente y son visibles 
                            para todos los miembros del grupo <strong><%= grupoActual %></strong>.
                        </p>
                    </div>
                <% } %>
            </main>
        </div>
    </div>

    <script>
        function actualizarPreviewOportunidades() {
            const texto = document.getElementById('oportunidades').value;
            const preview = document.getElementById('previewOportunidades');
            
            if (texto.trim()) {
                const lineas = texto.split('\n').filter(linea => linea.trim().length > 0);
                let html = '';
                
                lineas.forEach(linea => {
                    const lineaLimpia = linea.trim().replace(/^[•\-\*]\s*/, '');
                    if (lineaLimpia.length > 0) {
                        html += `<li>${lineaLimpia}</li>`;
                    }
                });
                
                if (html === '') {
                    html = '<li>Las oportunidades aparecerán aquí mientras las escribes</li>';
                }
                
                preview.innerHTML = html;
            } else {
                preview.innerHTML = '<li>Las oportunidades aparecerán aquí mientras las escribes</li>';
            }
        }
        
        function actualizarPreviewAmenazas() {
            const texto = document.getElementById('amenazas').value;
            const preview = document.getElementById('previewAmenazas');
            
            if (texto.trim()) {
                const lineas = texto.split('\n').filter(linea => linea.trim().length > 0);
                let html = '';
                
                lineas.forEach(linea => {
                    const lineaLimpia = linea.trim().replace(/^[•\-\*]\s*/, '');
                    if (lineaLimpia.length > 0) {
                        html += `<li>${lineaLimpia}</li>`;
                    }
                });
                
                if (html === '') {
                    html = '<li>Las amenazas aparecerán aquí mientras las escribes</li>';
                }
                
                preview.innerHTML = html;
            } else {
                preview.innerHTML = '<li>Las amenazas aparecerán aquí mientras las escribes</li>';
            }
        }

        function logout() {
            if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
                window.location.href = 'logout.jsp';
            }
        }

        <% if (modoColaborativo) { %>
        // Auto-refresh cada 30 segundos para ver cambios de otros usuarios
        setInterval(function() {
            const oportunidadesInput = document.getElementById('oportunidades');
            const amenazasInput = document.getElementById('amenazas');
            
            if (!oportunidadesInput.dataset.changed && !amenazasInput.dataset.changed) {
                location.reload();
            }
        }, 30000);

        // Marcar como cambiado cuando el usuario escribe
        document.getElementById('oportunidades').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
        
        document.getElementById('amenazas').addEventListener('input', function() {
            this.dataset.changed = 'true';
        });
        <% } %>
    </script>
</body>
</html>