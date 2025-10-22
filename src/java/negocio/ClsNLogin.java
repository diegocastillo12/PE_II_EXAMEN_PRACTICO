package negocio;

import conexion.conexion;
import entidad.ClsELogin;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
// Removido JOptionPane para compatibilidad web

/**
 * Clase de negocio para el manejo de operaciones de login y usuarios
 * Contiene toda la lógica de negocio y acceso a datos
 * 
 * @author Mi Equipo
 */
public class ClsNLogin {
    
    private Connection conn;
    
    /**
     * Constructor que inicializa la conexión
     */
    public ClsNLogin() {
        this.conn = conexion.getConexion();
    }
    
    /**
     * Método para validar login de usuario
     * @param usuario objeto ClsELogin con username y password
     * @return ClsELogin completo si login es exitoso, null si falla
     */
    public ClsELogin validarLogin(ClsELogin usuario) {
        if (!usuario.validarDatosLogin()) {
            System.err.println("✗ Datos de login incompletos");
            return null;
        }
        
        String sql = "SELECT id, username, password, email, fecha_registro, activo " +
                    "FROM usuarios WHERE username = ? AND password = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, usuario.getUsername());
            pst.setString(2, usuario.getPassword());
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // Login exitoso - crear objeto con datos completos
                ClsELogin usuarioCompleto = new ClsELogin(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getTimestamp("fecha_registro"),
                    rs.getBoolean("activo")
                );
                
                System.out.println("✓ Login exitoso para usuario: " + usuario.getUsername());
                return usuarioCompleto;
            } else {
                System.err.println("✗ Usuario o contraseña incorrectos: " + usuario.getUsername());
                return null;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error SQL en validarLogin: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Método para registrar un nuevo usuario
     * @param usuario objeto ClsELogin con los datos del nuevo usuario
     * @return true si se registró exitosamente, false si no
     */
    public boolean registrarUsuario(ClsELogin usuario) {
        if (!usuario.validarDatosRegistro()) {
            System.err.println("✗ Datos de registro incompletos");
            return false;
        }
        
        if (!usuario.validarEmail()) {
            System.err.println("✗ Email inválido: " + usuario.getEmail());
            return false;
        }
        
        // Verificar si el usuario ya existe
        if (existeUsuario(usuario.getUsername())) {
            System.err.println("✗ Usuario ya existe: " + usuario.getUsername());
            return false;
        }
        
        String sql = "INSERT INTO usuarios (username, password, email, fecha_registro, activo) " +
                    "VALUES (?, ?, ?, NOW(), TRUE)";
        
        try (PreparedStatement pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pst.setString(1, usuario.getUsername());
            pst.setString(2, usuario.getPassword());
            pst.setString(3, usuario.getEmail());
            
            int filasAfectadas = pst.executeUpdate();
            
            if (filasAfectadas > 0) {
                // Obtener el ID generado
                ResultSet rs = pst.getGeneratedKeys();
                if (rs.next()) {
                    usuario.setId(rs.getInt(1));
                }
                
                System.out.println("✓ Usuario registrado exitosamente: " + usuario.getUsername());
                return true;
            } else {
                System.err.println("✗ No se pudo registrar el usuario: " + usuario.getUsername());
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error SQL en registrarUsuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Verifica si un nombre de usuario ya existe
     * @param username nombre de usuario a verificar
     * @return true si existe, false si no existe
     */
    public boolean existeUsuario(String username) {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE username = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, username);
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error en existeUsuario: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Obtiene un usuario por su ID
     * @param id identificador del usuario
     * @return ClsELogin si se encuentra, null si no existe
     */
    public ClsELogin obtenerUsuarioPorId(int id) {
        String sql = "SELECT id, username, password, email, fecha_registro, activo " +
                    "FROM usuarios WHERE id = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return new ClsELogin(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getTimestamp("fecha_registro"),
                    rs.getBoolean("activo")
                );
            }
            
        } catch (SQLException e) {
            System.err.println("Error en obtenerUsuarioPorId: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Actualiza la información de un usuario
     * @param usuario objeto con los datos actualizados
     * @return true si se actualizó exitosamente, false si no
     */
    public boolean actualizarUsuario(ClsELogin usuario) {
        if (!usuario.validarDatosRegistro()) {
            System.err.println("✗ Datos de actualización incompletos");
            return false;
        }
        
        String sql = "UPDATE usuarios SET username = ?, password = ?, email = ? WHERE id = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, usuario.getUsername());
            pst.setString(2, usuario.getPassword());
            pst.setString(3, usuario.getEmail());
            pst.setInt(4, usuario.getId());
            
            int filasAfectadas = pst.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✓ Usuario actualizado exitosamente: " + usuario.getUsername());
                return true;
            } else {
                System.err.println("✗ No se pudo actualizar el usuario: " + usuario.getUsername());
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error SQL en actualizarUsuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Desactiva un usuario (soft delete)
     * @param id identificador del usuario a desactivar
     * @return true si se desactivó exitosamente, false si no
     */
    public boolean desactivarUsuario(int id) {
        String sql = "UPDATE usuarios SET activo = FALSE WHERE id = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, id);
            
            int filasAfectadas = pst.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error en desactivarUsuario: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Obtiene todos los usuarios activos
     * @return Lista de usuarios activos
     */
    public List<ClsELogin> obtenerTodosLosUsuarios() {
        List<ClsELogin> usuarios = new ArrayList<>();
        String sql = "SELECT id, username, password, email, fecha_registro, activo " +
                    "FROM usuarios WHERE activo = TRUE ORDER BY username";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                ClsELogin usuario = new ClsELogin(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getTimestamp("fecha_registro"),
                    rs.getBoolean("activo")
                );
                usuarios.add(usuario);
            }
            
        } catch (SQLException e) {
            System.err.println("Error en obtenerTodosLosUsuarios: " + e.getMessage());
        }
        
        return usuarios;
    }
    
    /**
     * Cambia la contraseña de un usuario
     * @param id identificador del usuario
     * @param nuevaPassword nueva contraseña
     * @return true si se cambió exitosamente, false si no
     */
    public boolean cambiarPassword(int id, String nuevaPassword) {
        if (nuevaPassword == null || nuevaPassword.trim().isEmpty()) {
            System.err.println("✗ La contraseña no puede estar vacía");
            return false;
        }
        
        String sql = "UPDATE usuarios SET password = ? WHERE id = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, nuevaPassword);
            pst.setInt(2, id);
            
            int filasAfectadas = pst.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✓ Contraseña actualizada exitosamente para usuario ID: " + id);
                return true;
            } else {
                System.err.println("✗ No se pudo cambiar la contraseña para usuario ID: " + id);
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error SQL en cambiarPassword: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cierra la conexión a la base de datos
     */
    public void cerrarConexion() {
        conexion.cerrarConexion();
    }
    
    // Método mostrarMensaje removido para compatibilidad web
    // Los mensajes ahora se manejan a través de logs del sistema
    
    /**
     * Método para probar la funcionalidad básica
     */
    public void probarFuncionalidad() {
        System.out.println("=== PROBANDO FUNCIONALIDAD DE LOGIN ===");
        
        // Crear usuario de prueba
        ClsELogin usuarioPrueba = new ClsELogin("test_user", "test_pass", "test@example.com");
        
        // Intentar login con datos de prueba existentes
        ClsELogin loginTest = new ClsELogin("admin", "123");
        ClsELogin resultado = validarLogin(loginTest);
        
        if (resultado != null) {
            System.out.println("✓ Login de prueba exitoso: " + resultado.getUsername());
        } else {
            System.out.println("✗ Login de prueba falló");
        }
        
        System.out.println("=======================================");
    }

    /**
     * Obtener ID de usuario por username
     * @param username nombre de usuario
     * @return ID del usuario, null si no existe
     */
    public Integer obtenerIdPorUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT id FROM usuarios WHERE username = ? AND activo = TRUE";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, username);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener ID por username: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Método para obtener el ID de un usuario por su username
     * @param username nombre de usuario
     * @return ID del usuario como int primitivo, -1 si no se encuentra
     */
    public int obtenerIdUsuario(String username) {
        Integer id = obtenerIdPorUsername(username);
        return (id != null) ? id : -1;
    }
}