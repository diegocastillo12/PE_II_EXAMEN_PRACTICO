<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="negocio.ClsNPeti"%>
<%@page import="entidad.ClsEPeti"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>

<%
    // Verificar si el usuario está logueado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.setStatus(401);
        out.print("{\"success\": false, \"error\": \"No autorizado\"}");
        return;
    }
    
    Integer usuarioId = (Integer) session.getAttribute("usuarioId");
    Integer grupoId = (Integer) session.getAttribute("grupoId");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    
    if (grupoId == null) {
        out.print("{\"success\": false, \"error\": \"No hay grupo activo\"}");
        return;
    }
    
    // Solo el admin puede restaurar
    if (!"admin".equals(rolUsuario)) {
        response.setStatus(403);
        out.print("{\"success\": false, \"error\": \"Solo el administrador puede restaurar datos\"}");
        return;
    }
    
    try {
        // Leer el contenido JSON del request
        BufferedReader reader = request.getReader();
        StringBuilder jsonData = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            jsonData.append(line);
        }
        
        String jsonString = jsonData.toString();
        
        // Parsear JSON manualmente (sin librería externa)
        if (jsonString == null || jsonString.trim().isEmpty()) {
            out.print("{\"success\": false, \"error\": \"No se recibieron datos\"}");
            return;
        }
        
        ClsNPeti negocioPeti = new ClsNPeti();
        int registrosRestaurados = 0;
        int errores = 0;
        
        // Parsear y restaurar datos
        // Buscar el objeto "datos" en el JSON
        int datosIndex = jsonString.indexOf("\"datos\":");
        if (datosIndex == -1) {
            out.print("{\"success\": false, \"error\": \"Formato de respaldo inválido\"}");
            return;
        }
        
        // Extraer secciones del JSON
        String datosStr = jsonString.substring(datosIndex + 8);
        int openBrace = datosStr.indexOf('{');
        int closeBrace = findMatchingBrace(datosStr, openBrace);
        
        if (closeBrace == -1) {
            out.print("{\"success\": false, \"error\": \"JSON malformado\"}");
            return;
        }
        
        String datosContent = datosStr.substring(openBrace + 1, closeBrace);
        
        // Dividir por secciones
        List<String> secciones = splitJsonSections(datosContent);
        
        for (String seccionData : secciones) {
            try {
                // Extraer nombre de sección
                int colonIndex = seccionData.indexOf(':');
                if (colonIndex == -1) continue;
                
                String seccionNombre = seccionData.substring(0, colonIndex).trim();
                seccionNombre = seccionNombre.replaceAll("\"", "");
                
                // Extraer campos de la sección
                String camposStr = seccionData.substring(colonIndex + 1).trim();
                if (camposStr.startsWith("{")) {
                    camposStr = camposStr.substring(1);
                }
                if (camposStr.endsWith("}")) {
                    camposStr = camposStr.substring(0, camposStr.length() - 1);
                }
                
                List<String> campos = splitJsonFields(camposStr);
                
                for (String campoData : campos) {
                    try {
                        int campoColonIndex = campoData.indexOf(':');
                        if (campoColonIndex == -1) continue;
                        
                        String campoNombre = campoData.substring(0, campoColonIndex).trim().replaceAll("\"", "");
                        String campoValor = campoData.substring(campoColonIndex + 1).trim();
                        
                        // Limpiar comillas del valor
                        if (campoValor.startsWith("\"")) campoValor = campoValor.substring(1);
                        if (campoValor.endsWith("\"")) campoValor = campoValor.substring(0, campoValor.length() - 1);
                        
                        // Decodificar escapes
                        campoValor = unescapeJson(campoValor);
                        
                        // Guardar en la base de datos
                        ClsEPeti datosPeti = new ClsEPeti(grupoId, seccionNombre, campoNombre, campoValor, usuarioId);
                        if (negocioPeti.guardarDato(datosPeti)) {
                            registrosRestaurados++;
                        } else {
                            errores++;
                        }
                    } catch (Exception e) {
                        errores++;
                        System.err.println("Error al restaurar campo: " + e.getMessage());
                    }
                }
            } catch (Exception e) {
                errores++;
                System.err.println("Error al restaurar sección: " + e.getMessage());
            }
        }
        
        response.setContentType("application/json");
        out.print("{\"success\": true, \"registrosRestaurados\": " + registrosRestaurados + 
                  ", \"errores\": " + errores + ", \"message\": \"Datos restaurados exitosamente\"}");
        
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"success\": false, \"error\": \"Error al restaurar: " + e.getMessage() + "\"}");
        e.printStackTrace();
    }
%>

<%!
    // Encuentra el corchete de cierre correspondiente
    private int findMatchingBrace(String str, int openIndex) {
        int count = 1;
        for (int i = openIndex + 1; i < str.length(); i++) {
            if (str.charAt(i) == '{') count++;
            else if (str.charAt(i) == '}') {
                count--;
                if (count == 0) return i;
            }
        }
        return -1;
    }
    
    // Divide el JSON en secciones
    private List<String> splitJsonSections(String content) {
        List<String> sections = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        int braceCount = 0;
        boolean inString = false;
        char prevChar = ' ';
        
        for (int i = 0; i < content.length(); i++) {
            char c = content.charAt(i);
            
            if (c == '"' && prevChar != '\\') {
                inString = !inString;
            }
            
            if (!inString) {
                if (c == '{') braceCount++;
                else if (c == '}') braceCount--;
                else if (c == ',' && braceCount == 0) {
                    if (current.length() > 0) {
                        sections.add(current.toString().trim());
                        current = new StringBuilder();
                    }
                    prevChar = c;
                    continue;
                }
            }
            
            current.append(c);
            prevChar = c;
        }
        
        if (current.length() > 0) {
            sections.add(current.toString().trim());
        }
        
        return sections;
    }
    
    // Divide los campos del JSON
    private List<String> splitJsonFields(String content) {
        List<String> fields = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inString = false;
        char prevChar = ' ';
        
        for (int i = 0; i < content.length(); i++) {
            char c = content.charAt(i);
            
            if (c == '"' && prevChar != '\\') {
                inString = !inString;
            }
            
            if (!inString && c == ',') {
                if (current.length() > 0) {
                    fields.add(current.toString().trim());
                    current = new StringBuilder();
                }
                prevChar = c;
                continue;
            }
            
            current.append(c);
            prevChar = c;
        }
        
        if (current.length() > 0) {
            fields.add(current.toString().trim());
        }
        
        return fields;
    }
    
    // Decodifica escapes de JSON
    private String unescapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\\"", "\"")
                  .replace("\\\\", "\\")
                  .replace("\\n", "\n")
                  .replace("\\r", "\r")
                  .replace("\\t", "\t");
    }
%>
