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
    
    // Variables para la matriz de participación
    String directivosEjecutivos = "";
    String gerentesDirectores = "";
    String jefesCoordinadores = "";
    String supervisoresLideres = "";
    String operativosEspecialistas = "";
    String consultoresExternos = "";
    String stakeholdersClaves = "";
    String comitesGrupos = "";
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar guardado si viene del formulario
    if ("POST".equals(request.getMethod()) && modoColaborativo) {
        String nuevosDirectivos = request.getParameter("directivos");
        String nuevosGerentes = request.getParameter("gerentes");
        String nuevosJefes = request.getParameter("jefes");
        String nuevosSupervisores = request.getParameter("supervisores");
        String nuevosOperativos = request.getParameter("operativos");
        String nuevosConsultores = request.getParameter("consultores");
        String nuevosStakeholders = request.getParameter("stakeholders");
        String nuevosComites = request.getParameter("comites");
        
        ClsNPeti negocioPeti = new ClsNPeti();
        boolean exito = true;
        
        try {
            if (nuevosDirectivos != null && !nuevosDirectivos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "directivos", nuevosDirectivos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosGerentes != null && !nuevosGerentes.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "gerentes", nuevosGerentes.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosJefes != null && !nuevosJefes.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "jefes", nuevosJefes.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosSupervisores != null && !nuevosSupervisores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "supervisores", nuevosSupervisores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosOperativos != null && !nuevosOperativos.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "operativos", nuevosOperativos.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosConsultores != null && !nuevosConsultores.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "consultores", nuevosConsultores.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosStakeholders != null && !nuevosStakeholders.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "stakeholders", nuevosStakeholders.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            if (nuevosComites != null && !nuevosComites.trim().isEmpty()) {
                ClsEPeti dato = new ClsEPeti(grupoId, "matriz_participacion", "comites", nuevosComites.trim(), usuarioId);
                exito = exito && negocioPeti.guardarDato(dato);
            }
            
            if (exito) {
                mensaje = "Matriz de Participación guardada exitosamente";
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
            Map<String, String> datosMatriz = negocioPeti.obtenerDatosSeccion(grupoId, "matriz_participacion");
            
            directivosEjecutivos = datosMatriz.getOrDefault("directivos", "");
            gerentesDirectores = datosMatriz.getOrDefault("gerentes", "");
            jefesCoordinadores = datosMatriz.getOrDefault("jefes", "");
            supervisoresLideres = datosMatriz.getOrDefault("supervisores", "");
            operativosEspecialistas = datosMatriz.getOrDefault("operativos", "");
            consultoresExternos = datosMatriz.getOrDefault("consultores", "");
            stakeholdersClaves = datosMatriz.getOrDefault("stakeholders", "");
            comitesGrupos = datosMatriz.getOrDefault("comites", "");
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
    <title>Matriz de Participación - PETI Colaborativo</title>
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

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            z-index: 1;
        }

        .header {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 25px 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
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

        .content {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
        }

        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            color: white;
        }

        .alert-success {
            background: rgba(46, 204, 113, 0.2);
            border-left: 4px solid #2ecc71;
        }

        .alert-error {
            background: rgba(231, 76, 60, 0.2);
            border-left: 4px solid #e74c3c;
        }

        .participantes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .participante-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 25px;
            border-radius: 20px;
        }

        .form-group textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            color: white;
            font-size: 16px;
            min-height: 120px;
            resize: vertical;
        }

        .form-group textarea::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .form-group label {
            color: white;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
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
            margin: 30px auto 0;
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-sitemap"></i> Matriz de Participación</h1>
            <p style="color: white;">Grupo: <strong><%= grupoActual %></strong></p>
        </div>

        <div class="content">
            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-<%= tipoMensaje %>">
                    <%= mensaje %>
                </div>
            <% } %>

            <% if (!modoColaborativo) { %>
                <div class="alert alert-error">
                    Error: Debes estar en un grupo para acceder a esta página.
                </div>
            <% } else { %>

            <form method="post" action="">
                <div class="participantes-grid">
                    <div class="participante-card">
                        <div class="form-group">
                            <label for="directivos">Directivos/Ejecutivos</label>
                            <textarea id="directivos" name="directivos" 
                                      placeholder="Describe los roles de directivos y ejecutivos..."
                                      ><%= directivosEjecutivos %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <div class="form-group">
                            <label for="gerentes">Gerentes/Directores</label>
                            <textarea id="gerentes" name="gerentes" 
                                      placeholder="Describe los roles de gerentes y directores..."
                                      ><%= gerentesDirectores %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <div class="form-group">
                            <label for="jefes">Jefes/Coordinadores</label>
                            <textarea id="jefes" name="jefes" 
                                      placeholder="Describe los roles de jefes y coordinadores..."
                                      ><%= jefesCoordinadores %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <div class="form-group">
                            <label for="supervisores">Supervisores/Líderes</label>
                            <textarea id="supervisores" name="supervisores" 
                                      placeholder="Describe los roles de supervisores y líderes..."
                                      ><%= supervisoresLideres %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <div class="form-group">
                            <label for="operativos">Operativos/Especialistas</label>
                            <textarea id="operativos" name="operativos" 
                                      placeholder="Describe los roles operativos y especialistas..."
                                      ><%= operativosEspecialistas %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <div class="form-group">
                            <label for="consultores">Consultores/Externos</label>
                            <textarea id="consultores" name="consultores" 
                                      placeholder="Describe los roles de consultores externos..."
                                      ><%= consultoresExternos %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <div class="form-group">
                            <label for="stakeholders">Stakeholders Clave</label>
                            <textarea id="stakeholders" name="stakeholders" 
                                      placeholder="Describe los stakeholders clave..."
                                      ><%= stakeholdersClaves %></textarea>
                        </div>
                    </div>

                    <div class="participante-card">
                        <div class="form-group">
                            <label for="comites">Comités/Grupos</label>
                            <textarea id="comites" name="comites" 
                                      placeholder="Describe los comités y grupos de trabajo..."
                                      ><%= comitesGrupos %></textarea>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-save">
                    <i class="fas fa-save"></i> Guardar Matriz
                </button>
            </form>

            <% } %>
        </div>
    </div>

    <script>
        // JavaScript simplificado estilo visión
        console.log('=== MATRIZ PARTICIPACION ===');
        console.log('Modo colaborativo:', <%= modoColaborativo %>);
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM cargado correctamente');
            
            // Solo marcar cambios
            document.querySelectorAll('textarea').forEach(element => {
                element.addEventListener('input', function() {
                    this.dataset.changed = 'true';
                });
            });
            
            // Auto-refresh cada 30 segundos
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
        });
    </script>
</body>
</html>