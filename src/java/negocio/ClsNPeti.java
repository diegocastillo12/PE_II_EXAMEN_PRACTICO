package negocio;

import conexion.conexion;
import entidad.ClsEPeti;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Clase de negocio para el manejo de datos del PETI
 * Contiene la lógica de negocio para operaciones CRUD de datos PETI
 * 
 * @author Mi Equipo
 */
public class ClsNPeti {
    
    private Connection conn;
    
    /**
     * Constructor que inicializa la conexión
     */
    public ClsNPeti() {
        this.conn = conexion.getConexion();
    }
    
    /**
     * Guarda o actualiza un dato del PETI
     * @param peti objeto ClsEPeti con los datos
     * @return true si la operación fue exitosa
     */
    public boolean guardarDato(ClsEPeti peti) {
        if (!peti.validarDatos()) {
            System.err.println("Datos de PETI inválidos");
            return false;
        }
        
        String sql = "INSERT INTO peti_datos (grupo_id, seccion, campo, valor, usuario_modificacion) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "valor = VALUES(valor), " +
                     "usuario_modificacion = VALUES(usuario_modificacion), " +
                     "version = version + 1";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, peti.getGrupoId());
            pstmt.setString(2, peti.getSeccion());
            pstmt.setString(3, peti.getCampo());
            pstmt.setString(4, peti.getValor());
            pstmt.setInt(5, peti.getUsuarioModificacion());
            
            int resultado = pstmt.executeUpdate();
            
            // Registrar en historial
            if (resultado > 0) {
                registrarHistorial(peti, "modificar");
            }
            
            return resultado > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al guardar dato PETI: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Obtiene un dato específico del PETI
     * @param grupoId ID del grupo
     * @param seccion sección del PETI
     * @param campo campo específico
     * @return objeto ClsEPeti o null si no existe
     */
    public ClsEPeti obtenerDato(int grupoId, String seccion, String campo) {
        String sql = "SELECT * FROM peti_datos WHERE grupo_id = ? AND seccion = ? AND campo = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, grupoId);
            pstmt.setString(2, seccion);
            pstmt.setString(3, campo);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return new ClsEPeti(
                    rs.getInt("id"),
                    rs.getInt("grupo_id"),
                    rs.getString("seccion"),
                    rs.getString("campo"),
                    rs.getString("valor"),
                    rs.getInt("usuario_modificacion"),
                    rs.getTimestamp("fecha_modificacion"),
                    rs.getInt("version")
                );
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener dato PETI: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Obtiene todos los datos de una sección específica para un grupo
     * @param grupoId ID del grupo
     * @param seccion sección del PETI
     * @return Map con campo->valor
     */
    public Map<String, String> obtenerDatosSeccion(int grupoId, String seccion) {
        Map<String, String> datos = new HashMap<>();
        String sql = "SELECT campo, valor FROM peti_datos WHERE grupo_id = ? AND seccion = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, grupoId);
            pstmt.setString(2, seccion);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                datos.put(rs.getString("campo"), rs.getString("valor"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener datos de sección: " + e.getMessage());
        }
        
        return datos;
    }
    
    /**
     * Obtiene todos los datos del PETI para un grupo
     * @param grupoId ID del grupo
     * @return Map con seccion->Map(campo->valor)
     */
    public Map<String, Map<String, String>> obtenerTodosDatos(int grupoId) {
        Map<String, Map<String, String>> todosDatos = new HashMap<>();
        String sql = "SELECT seccion, campo, valor FROM peti_datos WHERE grupo_id = ? ORDER BY seccion, campo";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, grupoId);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String seccion = rs.getString("seccion");
                String campo = rs.getString("campo");
                String valor = rs.getString("valor");
                
                todosDatos.computeIfAbsent(seccion, k -> new HashMap<>()).put(campo, valor);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener todos los datos: " + e.getMessage());
        }
        
        return todosDatos;
    }
    
    /**
     * Elimina un dato específico del PETI
     * @param grupoId ID del grupo
     * @param seccion sección del PETI
     * @param campo campo específico
     * @param usuarioId ID del usuario que elimina
     * @return true si la operación fue exitosa
     */
    public boolean eliminarDato(int grupoId, String seccion, String campo, int usuarioId) {
        // Primero obtener el dato para el historial
        ClsEPeti datoAnterior = obtenerDato(grupoId, seccion, campo);
        
        String sql = "DELETE FROM peti_datos WHERE grupo_id = ? AND seccion = ? AND campo = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, grupoId);
            pstmt.setString(2, seccion);
            pstmt.setString(3, campo);
            
            int resultado = pstmt.executeUpdate();
            
            // Registrar en historial
            if (resultado > 0 && datoAnterior != null) {
                datoAnterior.setUsuarioModificacion(usuarioId);
                registrarHistorial(datoAnterior, "eliminar");
            }
            
            return resultado > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar dato PETI: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Obtiene el historial de cambios para un grupo
     * @param grupoId ID del grupo
     * @param limite número máximo de registros
     * @return lista de cambios
     */
    public List<Map<String, Object>> obtenerHistorial(int grupoId, int limite) {
        List<Map<String, Object>> historial = new ArrayList<>();
        String sql = "SELECT h.*, u.username " +
                     "FROM peti_historial h " +
                     "JOIN usuarios u ON h.usuario_id = u.id " +
                     "WHERE h.grupo_id = ? " +
                     "ORDER BY h.fecha_cambio DESC " +
                     "LIMIT ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, grupoId);
            pstmt.setInt(2, limite);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> cambio = new HashMap<>();
                cambio.put("seccion", rs.getString("seccion"));
                cambio.put("campo", rs.getString("campo"));
                cambio.put("valor_anterior", rs.getString("valor_anterior"));
                cambio.put("valor_nuevo", rs.getString("valor_nuevo"));
                cambio.put("usuario", rs.getString("username"));
                cambio.put("fecha_cambio", rs.getTimestamp("fecha_cambio"));
                cambio.put("accion", rs.getString("accion"));
                
                historial.add(cambio);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener historial: " + e.getMessage());
        }
        
        return historial;
    }
    
    /**
     * Verifica si un usuario tiene permisos para editar el PETI de un grupo
     * @param usuarioId ID del usuario
     * @param grupoId ID del grupo
     * @return true si tiene permisos
     */
    public boolean tienePermisos(int usuarioId, int grupoId) {
        String sql = "SELECT COUNT(*) FROM miembros_grupo WHERE usuario_id = ? AND grupo_id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, usuarioId);
            pstmt.setInt(2, grupoId);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error al verificar permisos: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Registra un cambio en el historial
     * @param peti datos del PETI
     * @param accion tipo de acción realizada
     */
    private void registrarHistorial(ClsEPeti peti, String accion) {
        String valorAnterior = null;
        
        // Si es modificación, obtener valor anterior
        if ("modificar".equals(accion)) {
            ClsEPeti datoAnterior = obtenerDato(peti.getGrupoId(), peti.getSeccion(), peti.getCampo());
            if (datoAnterior != null) {
                valorAnterior = datoAnterior.getValor();
            }
        }
        
        String sql = "INSERT INTO peti_historial (grupo_id, seccion, campo, valor_anterior, valor_nuevo, usuario_id, accion) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, peti.getGrupoId());
            pstmt.setString(2, peti.getSeccion());
            pstmt.setString(3, peti.getCampo());
            pstmt.setString(4, valorAnterior);
            pstmt.setString(5, "eliminar".equals(accion) ? null : peti.getValor());
            pstmt.setInt(6, peti.getUsuarioModificacion());
            pstmt.setString(7, accion);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("Error al registrar historial: " + e.getMessage());
        }
    }
    
    /**
     * Obtiene el progreso completado de un grupo (porcentaje de campos llenos)
     * @param grupoId ID del grupo
     * @return porcentaje de completado (0-100)
     */
    public int obtenerProgreso(int grupoId) {
        // Definir las 9 secciones principales del PETI (sin estrategias que aún no existe)
        String[] seccionesPrincipales = {
            "empresa", "mision", "vision", "valores", "objetivos",
            "analisis_interno", "analisis_externo",
            "cadena_valor", "bcg"
        };
        
        int totalSecciones = seccionesPrincipales.length; // 9 secciones
        int seccionesCompletadas = 0;
        
        // Contar cuántas de las 10 secciones principales tienen datos
        String sql = "SELECT COUNT(DISTINCT seccion) FROM peti_datos WHERE grupo_id = ? AND seccion = ? AND valor IS NOT NULL AND valor != ''";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (String seccion : seccionesPrincipales) {
                pstmt.setInt(1, grupoId);
                pstmt.setString(2, seccion);
                
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    seccionesCompletadas++;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al calcular progreso: " + e.getMessage());
        }
        
        // Calcular porcentaje y asegurar que no exceda 100%
        int progreso = (int) ((double) seccionesCompletadas / totalSecciones * 100);
        return Math.min(progreso, 100); // Nunca mayor a 100%
    }
    
    /**
     * MEJORA 1: Obtiene los cambios recientes del grupo
     * @param grupoId ID del grupo
     * @param limite número máximo de cambios a obtener
     * @return lista de cambios recientes
     */
    public List<Map<String, Object>> obtenerCambiosRecientes(int grupoId, int limite) {
        List<Map<String, Object>> cambios = new ArrayList<>();
        
        String sql = "SELECT h.seccion, h.campo, h.accion, h.fecha_cambio, u.username as usuario " +
                     "FROM peti_historial h " +
                     "INNER JOIN usuarios u ON h.usuario_id = u.id " +
                     "WHERE h.grupo_id = ? " +
                     "ORDER BY h.fecha_cambio DESC " +
                     "LIMIT ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, grupoId);
            pstmt.setInt(2, limite);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> cambio = new HashMap<>();
                cambio.put("seccion", rs.getString("seccion"));
                cambio.put("campo", rs.getString("campo"));
                cambio.put("accion", rs.getString("accion"));
                cambio.put("fecha", rs.getTimestamp("fecha_cambio"));
                cambio.put("usuario", rs.getString("usuario"));
                cambios.add(cambio);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cambios recientes: " + e.getMessage());
        }
        
        return cambios;
    }
}