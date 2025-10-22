package negocio;

import conexion.conexion;
import entidad.ClsEGrupo;
import entidad.ClsELogin;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Clase de negocio para el manejo de operaciones de grupos
 * Contiene toda la lógica de negocio y acceso a datos para grupos
 * 
 * @author Mi Equipo
 */
public class ClsNGrupo {
    
    private Connection conn;
    
    /**
     * Constructor que inicializa la conexión
     */
    public ClsNGrupo() {
        this.conn = conexion.getConexion();
    }
    
    // ... existing code ...
    
    /**
     * Crear un nuevo grupo
     * @param grupo objeto ClsEGrupo con los datos del grupo
     * @return ID del grupo creado, -1 si hay error
     */
    public int crearGrupo(ClsEGrupo grupo) {
        if (!grupo.validarDatosCreacion()) {
            System.err.println("✗ Datos del grupo inválidos");
            return -1;
        }
        
        // Verificar que el usuario no tenga ya un grupo
        if (usuarioTieneGrupo(grupo.getAdminId())) {
            System.err.println("✗ El usuario ya pertenece a un grupo");
            return -2; // Código específico para "ya tiene grupo"
        }
        
        // Generar código único
        String codigoUnico = generarCodigoUnico();
        grupo.setCodigo(codigoUnico);
        
        // Verificar que el nombre no exista
        if (existeNombreGrupo(grupo.getNombre())) {
            System.err.println("✗ Ya existe un grupo con ese nombre");
            return -3; // Código específico para "nombre existe"
        }
        
        try {
            // Usar el procedimiento almacenado CrearGrupo
            String sql = "CALL CrearGrupo(?, ?, ?, ?)";
            
            try (CallableStatement cst = conn.prepareCall(sql)) {
                cst.setString(1, grupo.getNombre());
                cst.setString(2, grupo.getCodigo());
                cst.setInt(3, grupo.getLimiteUsuarios());
                cst.setInt(4, grupo.getAdminId());
                
                ResultSet rs = cst.executeQuery();
                
                if (rs.next()) {
                    int grupoId = rs.getInt("id");
                    System.out.println("✓ Grupo creado exitosamente con ID: " + grupoId);
                    return grupoId;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al crear grupo: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Unirse a un grupo existente usando código
     * @param usuarioId ID del usuario que se quiere unir
     * @param codigoGrupo código del grupo
     * @return true si se unió exitosamente, false en caso contrario
     */
    public boolean unirseGrupo(int usuarioId, String codigoGrupo) {
        if (codigoGrupo == null || codigoGrupo.trim().isEmpty()) {
            System.err.println("✗ Código de grupo vacío");
            return false;
        }
        
        // Obtener información del grupo por código
        ClsEGrupo grupo = obtenerGrupoPorCodigo(codigoGrupo);
        if (grupo == null) {
            System.err.println("✗ Grupo no encontrado con el código: " + codigoGrupo);
            return false;
        }
        
        // Verificar que el usuario no sea ya miembro de este grupo específico
        if (usuarioYaPerteneceAGrupo(usuarioId, grupo.getId())) {
            System.err.println("✗ El usuario ya pertenece a este grupo");
            return false;
        }
        
        // Verificar que el grupo no esté lleno
        int miembrosActuales = contarMiembrosGrupo(grupo.getId());
        if (miembrosActuales >= grupo.getLimiteUsuarios()) {
            System.err.println("✗ El grupo ha alcanzado su límite máximo de usuarios");
            return false;
        }
        
        try {
            String sql = "INSERT INTO miembros_grupo (usuario_id, grupo_id, rol) VALUES (?, ?, 'miembro')";
            
            try (PreparedStatement pst = conn.prepareStatement(sql)) {
                pst.setInt(1, usuarioId);
                pst.setInt(2, grupo.getId());
                
                int filasAfectadas = pst.executeUpdate();
                
                if (filasAfectadas > 0) {
                    System.out.println("✓ Usuario unido al grupo exitosamente");
                    return true;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al unirse al grupo: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Obtener información del grupo de un usuario
     * @param usuarioId ID del usuario
     * @return objeto ClsEGrupo con la información del grupo, null si no tiene grupo
     */
    public ClsEGrupo obtenerGrupoUsuario(int usuarioId) {
        String sql = "SELECT g.id, g.nombre, g.codigo, g.limite_usuarios, g.admin_id, " +
                    "g.fecha_creacion, g.activo, mg.rol " +
                    "FROM grupos g " +
                    "INNER JOIN miembros_grupo mg ON g.id = mg.grupo_id " +
                    "WHERE mg.usuario_id = ? AND g.activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                ClsEGrupo grupo = new ClsEGrupo(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("codigo"),
                    rs.getInt("limite_usuarios"),
                    rs.getInt("admin_id"),
                    rs.getTimestamp("fecha_creacion"),
                    rs.getBoolean("activo")
                );
                
                return grupo;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al obtener grupo del usuario: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Verificar si un usuario es administrador de su grupo
     * @param usuarioId ID del usuario
     * @return true si es admin, false en caso contrario
     */
    public boolean esAdministrador(int usuarioId) {
        String sql = "SELECT COUNT(*) as count FROM miembros_grupo mg " +
                    "INNER JOIN grupos g ON mg.grupo_id = g.id " +
                    "WHERE mg.usuario_id = ? AND mg.rol = 'admin' AND g.activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al verificar si es administrador: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Obtener lista de miembros de un grupo
     * @param grupoId ID del grupo
     * @return lista de usuarios miembros del grupo
     */
    public List<ClsELogin> obtenerMiembrosGrupo(int grupoId) {
        List<ClsELogin> miembros = new ArrayList<>();
        
        String sql = "SELECT u.id, u.username, u.email, mg.rol, mg.fecha_union " +
                    "FROM usuarios u " +
                    "INNER JOIN miembros_grupo mg ON u.id = mg.usuario_id " +
                    "WHERE mg.grupo_id = ? AND u.activo = TRUE " +
                    "ORDER BY mg.rol DESC, mg.fecha_union ASC";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, grupoId);
            
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                ClsELogin usuario = new ClsELogin();
                usuario.setId(rs.getInt("id"));
                usuario.setUsername(rs.getString("username"));
                usuario.setEmail(rs.getString("email"));
                // Aquí podrías agregar el rol si extiendes la clase ClsELogin
                
                miembros.add(usuario);
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al obtener miembros del grupo: " + e.getMessage());
        }
        
        return miembros;
    }
    
    /**
     * Generar nuevo código para un grupo (solo admin)
     * @param grupoId ID del grupo
     * @param adminId ID del administrador
     * @return nuevo código generado, null si hay error
     */
    public String generarNuevoCodigo(int grupoId, int adminId) {
        // Verificar que el usuario sea admin del grupo
        if (!esAdministradorDelGrupo(adminId, grupoId)) {
            System.err.println("✗ Usuario no es administrador del grupo");
            return null;
        }
        
        String nuevoCodigo = generarCodigoUnico();
        
        String sql = "UPDATE grupos SET codigo = ? WHERE id = ? AND admin_id = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, nuevoCodigo);
            pst.setInt(2, grupoId);
            pst.setInt(3, adminId);
            
            int filasAfectadas = pst.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✓ Código actualizado exitosamente: " + nuevoCodigo);
                return nuevoCodigo;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al generar nuevo código: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Salir de un grupo
     * @param usuarioId ID del usuario
     * @return true si salió exitosamente, false en caso contrario
     */
    public boolean salirGrupo(int usuarioId) {
        // Verificar si es admin y hay otros miembros
        if (esAdministrador(usuarioId)) {
            int totalMiembros = contarMiembrosGrupoUsuario(usuarioId);
            if (totalMiembros > 1) {
                System.err.println("✗ El administrador no puede salir mientras haya otros miembros");
                return false;
            }
        }
        
        String sql = "DELETE FROM miembros_grupo WHERE usuario_id = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            int filasAfectadas = pst.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✓ Usuario salió del grupo exitosamente");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al salir del grupo: " + e.getMessage());
        }
        
        return false;
    }
    
    // Métodos auxiliares privados
    
    /**
     * Verificar si un usuario ya pertenece a un grupo
     */
    private boolean usuarioTieneGrupo(int usuarioId) {
        String sql = "SELECT COUNT(*) as count FROM miembros_grupo mg " +
                    "INNER JOIN grupos g ON mg.grupo_id = g.id " +
                    "WHERE mg.usuario_id = ? AND g.activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al verificar si usuario tiene grupo: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Verificar si existe un grupo con el nombre dado
     */
    private boolean existeNombreGrupo(String nombre) {
        String sql = "SELECT COUNT(*) as count FROM grupos WHERE nombre = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, nombre);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al verificar nombre de grupo: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Generar un código único que no exista en la base de datos
     */
    private String generarCodigoUnico() {
        String codigo;
        int intentos = 0;
        
        do {
            codigo = ClsEGrupo.generarCodigo();
            intentos++;
            
            if (intentos > 10) {
                // Fallback si hay muchas colisiones
                codigo = ClsEGrupo.generarCodigo() + System.currentTimeMillis() % 100;
                break;
            }
            
        } while (existeCodigo(codigo));
        
        return codigo;
    }
    
    /**
     * Verificar si existe un código de grupo
     */
    private boolean existeCodigo(String codigo) {
        String sql = "SELECT COUNT(*) as count FROM grupos WHERE codigo = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, codigo);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al verificar código: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Verificar si un usuario es administrador de un grupo específico
     */
    private boolean esAdministradorDelGrupo(int usuarioId, int grupoId) {
        String sql = "SELECT COUNT(*) as count FROM grupos WHERE id = ? AND admin_id = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, grupoId);
            pst.setInt(2, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al verificar administrador del grupo: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Contar miembros del grupo al que pertenece un usuario
     */
    private int contarMiembrosGrupoUsuario(int usuarioId) {
        String sql = "SELECT COUNT(*) as count FROM miembros_grupo mg1 " +
                    "INNER JOIN miembros_grupo mg2 ON mg1.grupo_id = mg2.grupo_id " +
                    "WHERE mg1.usuario_id = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al contar miembros: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Contar miembros de un grupo específico
     */
    private int contarMiembrosGrupo(int grupoId) {
        String sql = "SELECT COUNT(*) as count FROM miembros_grupo WHERE grupo_id = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, grupoId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al contar miembros del grupo: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Obtener información de un grupo por su código
     * @param codigo código del grupo
     * @return objeto ClsEGrupo con la información del grupo, null si no existe
     */
    public ClsEGrupo obtenerGrupoPorCodigo(String codigo) {
        if (codigo == null || codigo.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT id, nombre, codigo, limite_usuarios, admin_id, fecha_creacion, activo " +
                    "FROM grupos WHERE codigo = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, codigo.toUpperCase());
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                ClsEGrupo grupo = new ClsEGrupo();
                grupo.setId(rs.getInt("id"));
                grupo.setNombre(rs.getString("nombre"));
                grupo.setCodigo(rs.getString("codigo"));
                grupo.setLimiteUsuarios(rs.getInt("limite_usuarios"));
                grupo.setAdminId(rs.getInt("admin_id"));
                grupo.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                grupo.setActivo(rs.getBoolean("activo"));
                
                return grupo;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al obtener grupo por código: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Obtener información del grupo actual de un usuario
     * @param usuarioId ID del usuario
     * @return objeto ClsEGrupo con la información del grupo, null si no pertenece a ninguno
     */
    public ClsEGrupo obtenerGrupoActualUsuario(int usuarioId) {
        String sql = "SELECT g.id, g.nombre, g.codigo, g.limite_usuarios, g.admin_id, g.fecha_creacion, g.activo, " +
                    "mg.rol FROM grupos g " +
                    "INNER JOIN miembros_grupo mg ON g.id = mg.grupo_id " +
                    "WHERE mg.usuario_id = ? AND g.activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                ClsEGrupo grupo = new ClsEGrupo();
                grupo.setId(rs.getInt("id"));
                grupo.setNombre(rs.getString("nombre"));
                grupo.setCodigo(rs.getString("codigo"));
                grupo.setLimiteUsuarios(rs.getInt("limite_usuarios"));
                grupo.setAdminId(rs.getInt("admin_id"));
                grupo.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                grupo.setActivo(rs.getBoolean("activo"));
                
                // También guardamos el rol del usuario en el grupo
                String rol = rs.getString("rol");
                // Podríamos agregar un campo rol en ClsEGrupo o devolverlo de otra manera
                // Por ahora lo manejaremos en el JSP
                
                return grupo;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al obtener grupo actual del usuario: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Obtener el rol de un usuario en su grupo actual
     * @param usuarioId ID del usuario
     * @return rol del usuario ("admin" o "miembro"), null si no pertenece a ningún grupo
     */
    public String obtenerRolUsuarioEnGrupo(int usuarioId) {
        String sql = "SELECT mg.rol FROM miembros_grupo mg " +
                    "INNER JOIN grupos g ON mg.grupo_id = g.id " +
                    "WHERE mg.usuario_id = ? AND g.activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getString("rol");
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al obtener rol del usuario: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Obtener todos los grupos a los que pertenece un usuario
     * @param usuarioId ID del usuario
     * @return lista de grupos con información completa incluyendo rol y número de miembros
     */
    public List<Map<String, Object>> obtenerTodosLosGruposUsuario(int usuarioId) {
        List<Map<String, Object>> grupos = new ArrayList<>();
        
        String sql = "SELECT g.id, g.nombre, g.codigo, g.limite_usuarios, g.admin_id, " +
                    "g.fecha_creacion, g.activo, mg.rol, " +
                    "(SELECT COUNT(*) FROM miembros_grupo mg2 WHERE mg2.grupo_id = g.id) as total_miembros " +
                    "FROM grupos g " +
                    "INNER JOIN miembros_grupo mg ON g.id = mg.grupo_id " +
                    "WHERE mg.usuario_id = ? AND g.activo = TRUE " +
                    "ORDER BY g.fecha_creacion DESC";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> grupo = new HashMap<>();
                grupo.put("id", rs.getInt("id"));
                grupo.put("nombre", rs.getString("nombre"));
                grupo.put("codigo", rs.getString("codigo"));
                grupo.put("limite_usuarios", rs.getInt("limite_usuarios"));
                grupo.put("admin_id", rs.getInt("admin_id"));
                grupo.put("fecha_creacion", rs.getTimestamp("fecha_creacion"));
                grupo.put("activo", rs.getBoolean("activo"));
                grupo.put("rol", rs.getString("rol"));
                grupo.put("miembros", rs.getInt("total_miembros"));
                
                grupos.add(grupo);
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al obtener todos los grupos del usuario: " + e.getMessage());
        }
        
        return grupos;
    }
    
    /**
     * Obtener información detallada de un grupo específico con el rol del usuario
     * @param usuarioId ID del usuario
     * @param grupoId ID del grupo
     * @return Map con información del grupo y rol del usuario, null si no pertenece al grupo
     */
    public Map<String, Object> obtenerInfoGrupoConRol(int usuarioId, int grupoId) {
        String sql = "SELECT g.id, g.nombre, g.codigo, g.limite_usuarios, g.admin_id, " +
                    "g.fecha_creacion, g.activo, mg.rol, " +
                    "(SELECT COUNT(*) FROM miembros_grupo mg2 WHERE mg2.grupo_id = g.id) as total_miembros " +
                    "FROM grupos g " +
                    "INNER JOIN miembros_grupo mg ON g.id = mg.grupo_id " +
                    "WHERE mg.usuario_id = ? AND g.id = ? AND g.activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            pst.setInt(2, grupoId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> grupo = new HashMap<>();
                grupo.put("id", rs.getInt("id"));
                grupo.put("nombre", rs.getString("nombre"));
                grupo.put("codigo", rs.getString("codigo"));
                grupo.put("limite_usuarios", rs.getInt("limite_usuarios"));
                grupo.put("admin_id", rs.getInt("admin_id"));
                grupo.put("fecha_creacion", rs.getTimestamp("fecha_creacion"));
                grupo.put("activo", rs.getBoolean("activo"));
                grupo.put("rol", rs.getString("rol"));
                grupo.put("miembros", rs.getInt("total_miembros"));
                
                return grupo;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al obtener información del grupo con rol: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Verificar si un usuario ya pertenece a un grupo específico
     * @param usuarioId ID del usuario
     * @param grupoId ID del grupo
     * @return true si ya pertenece al grupo, false en caso contrario
     */
    public boolean usuarioYaPerteneceAGrupo(int usuarioId, int grupoId) {
        String sql = "SELECT COUNT(*) as count FROM miembros_grupo mg " +
                    "WHERE mg.usuario_id = ? AND mg.grupo_id = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            pst.setInt(2, grupoId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al verificar si usuario pertenece al grupo: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Contar cuántos grupos tiene un usuario
     */
    public int contarGruposUsuario(int usuarioId) {
        String sql = "SELECT COUNT(*) as count FROM miembros_grupo mg " +
                    "INNER JOIN grupos g ON mg.grupo_id = g.id " +
                    "WHERE mg.usuario_id = ? AND g.activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, usuarioId);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al contar grupos del usuario: " + e.getMessage());
        }
        
        return 0;
    }
}