<%-- 
    Document   : validarLogin
    Created on : 15 set. 2025, 11:30:00 p. m.
    Author     : Mi Equipo
    Description: Procesa el login del usuario y maneja códigos de grupo
--%>

<%@page import="negocio.ClsNLogin"%>
<%@page import="negocio.ClsNGrupo"%>
<%@page import="entidad.ClsELogin"%>
<%@page import="entidad.ClsEGrupo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Debug: Imprimir información de la request
    out.println("<!-- === DEBUG VALIDAR LOGIN === -->");
    out.println("<!-- Method: " + request.getMethod() + " -->");
    out.println("<!-- Content-Type: " + request.getContentType() + " -->");
    
    // Obtener parámetros del formulario
    String usuario = request.getParameter("usuario");
    String password = request.getParameter("password");
    String codigoGrupo = request.getParameter("codigoGrupo");
    
    out.println("<!-- Usuario recibido: '" + usuario + "' -->");
    out.println("<!-- Password recibido: " + (password != null ? "[PRESENTE]" : "[NULL]") + " -->");
    out.println("<!-- Código grupo: '" + codigoGrupo + "' -->");
    
    // Validar que los campos obligatorios no estén vacíos
    if (usuario == null || password == null || 
        usuario.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("index.jsp?error=campos_vacios");
        return;
    }
    
    try {
        // Crear instancia del negocio de login
        ClsNLogin negocioLogin = new ClsNLogin();
        
        // Crear objeto usuario para validación
        ClsELogin usuarioLogin = new ClsELogin(usuario.trim(), password);
        out.println("<!-- Objeto usuarioLogin creado para: " + usuario.trim() + " -->");
        
        // Validar login
        out.println("<!-- Iniciando validación de login... -->");
        ClsELogin usuarioValidado = negocioLogin.validarLogin(usuarioLogin);
        out.println("<!-- Resultado validación: " + (usuarioValidado != null ? "EXITOSO" : "FALLIDO") + " -->");
        
        if (usuarioValidado != null) {
            // Login exitoso - guardar información en la sesión
            session.setAttribute("usuarioLogueado", usuarioValidado);
            session.setAttribute("usuarioId", usuarioValidado.getId()); // Usar usuarioId para consistencia
            session.setAttribute("userId", usuarioValidado.getId());
            session.setAttribute("usuario", usuarioValidado.getUsername()); // Corregido: usar "usuario" en lugar de "username"
            session.setAttribute("username", usuarioValidado.getUsername());
            session.setAttribute("email", usuarioValidado.getEmail());
            session.setMaxInactiveInterval(30 * 60); // 30 minutos
            
            out.println("<!-- LOGIN EXITOSO: Usuario validado = " + usuarioValidado.getUsername() + " -->");
            
            // Verificar si hay código de grupo
            if (codigoGrupo != null && !codigoGrupo.trim().isEmpty()) {
                // Procesar código de grupo - unirse automáticamente
                try {
                    out.println("<!-- Procesando código de grupo: " + codigoGrupo.trim() + " -->");
                    
                    // Crear instancia del negocio de grupos
                    ClsNGrupo negocioGrupo = new ClsNGrupo();
                    
                    // Obtener el ID del usuario (reutilizando la instancia existente de negocioLogin)
                    int idUsuario = negocioLogin.obtenerIdUsuario(usuarioValidado.getUsername());
                    
                    if (idUsuario > 0) {
                        // Buscar el grupo por código
                        ClsEGrupo grupo = negocioGrupo.obtenerGrupoPorCodigo(codigoGrupo.trim());
                        
                        if (grupo != null) {
                            // Intentar unirse al grupo
                            boolean resultado = negocioGrupo.unirseGrupo(idUsuario, codigoGrupo.trim());
                            
                            if (resultado) {
                                // Unión exitosa - establecer atributos de sesión
                                session.setAttribute("grupoActual", grupo.getNombre());
                                session.setAttribute("rolUsuario", "miembro");
                                session.setAttribute("codigoGrupo", grupo.getCodigo());
                                session.setAttribute("grupoId", grupo.getId()); // Usar grupoId para consistencia
                                session.setAttribute("idGrupo", grupo.getId());
                                
                                out.println("<!-- Unión al grupo exitosa: " + grupo.getNombre() + " -->");
                                response.sendRedirect("menuprincipal.jsp?success=unido_grupo");
                                return;
                            } else {
                                // Error al unirse al grupo
                                out.println("<!-- Error al unirse al grupo -->");
                                response.sendRedirect("menuprincipal.jsp?error=no_se_pudo_unir");
                                return;
                            }
                        } else {
                            // Código de grupo inválido
                            out.println("<!-- Código de grupo inválido -->");
                            response.sendRedirect("menuprincipal.jsp?error=codigo_invalido");
                            return;
                        }
                    } else {
                        // Error obteniendo ID de usuario
                        out.println("<!-- Error obteniendo ID de usuario -->");
                        response.sendRedirect("menuprincipal.jsp?error=usuario_no_encontrado");
                        return;
                    }
                    
                } catch (Exception e) {
                    // Error procesando código de grupo
                    out.println("<!-- Error procesando código de grupo: " + e.getMessage() + " -->");
                    response.sendRedirect("menuprincipal.jsp?error=error_codigo_grupo");
                    return;
                }
            } else {
                // Sin código de grupo - verificar si el usuario ya pertenece a un grupo
                out.println("<!-- Sin código de grupo - verificando membresía existente -->");
                
                try {
                    ClsNGrupo negocioGrupo = new ClsNGrupo();
                    
                    // Obtener el ID del usuario (reutilizando la instancia existente de negocioLogin)
                    int idUsuario = negocioLogin.obtenerIdUsuario(usuarioValidado.getUsername());
                    
                    if (idUsuario > 0) {
                        // Verificar si ya pertenece a un grupo
                        ClsEGrupo grupoExistente = negocioGrupo.obtenerGrupoActualUsuario(idUsuario);
                        
                        if (grupoExistente != null) {
                            // El usuario ya pertenece a un grupo - recuperar información
                            String rolUsuario = negocioGrupo.obtenerRolUsuarioEnGrupo(idUsuario);
                            
                            session.setAttribute("grupoActual", grupoExistente.getNombre());
                            session.setAttribute("rolUsuario", rolUsuario != null ? rolUsuario : "miembro");
                            session.setAttribute("codigoGrupo", grupoExistente.getCodigo());
                            session.setAttribute("grupoId", grupoExistente.getId()); // Usar grupoId para consistencia
                            session.setAttribute("idGrupo", grupoExistente.getId());
                            
                            out.println("<!-- Usuario recuperado en grupo: " + grupoExistente.getNombre() + " con rol: " + rolUsuario + " -->");
                        }
                    }
                } catch (Exception e) {
                    out.println("<!-- Error al verificar grupo existente: " + e.getMessage() + " -->");
                    // No es crítico, continuar con el login normal
                }
                
                // Ir al menú principal (con o sin grupo)
                out.println("<!-- Redirigiendo a menuprincipal.jsp -->");
                response.sendRedirect("menuprincipal.jsp");
                return;
            }
            
        } else {
            // Login fallido
            response.sendRedirect("index.jsp?error=credenciales_invalidas");
            return;
        }
        
    } catch (Exception e) {
        // Error interno del servidor
        out.println("<!-- ERROR EN VALIDAR LOGIN: " + e.getMessage() + " -->");
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        out.println("<!-- Stack trace: " + sw.toString() + " -->");
        
        // Redirigir con error de base de datos
        if (e.getMessage() != null && (e.getMessage().contains("Connection") || e.getMessage().contains("SQLException"))) {
            response.sendRedirect("index.jsp?error=error_base_datos");
        } else {
            response.sendRedirect("index.jsp?error=error_interno");
        }
        return;
        
    } finally {
        // Limpiar recursos si es necesario
        // La conexión se maneja dentro de ClsNLogin
    }
%>