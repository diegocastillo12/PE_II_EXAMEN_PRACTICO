package entidad;

import java.sql.Timestamp;

/**
 * Clase entidad para el manejo de usuarios/login
 * Corresponde a la tabla 'usuarios' de la base de datos
 * 
 * @author Mi Equipo
 */
public class ClsELogin {
    
    // Atributos correspondientes a la tabla usuarios
    private int id;
    private String username;
    private String password;
    private String email;
    private Timestamp fechaRegistro;
    private boolean activo;
    
    // Constructores
    
    /**
     * Constructor vacío
     */
    public ClsELogin() {
        this.activo = true; // Por defecto activo
    }
    
    /**
     * Constructor para login básico
     * @param username nombre de usuario
     * @param password contraseña
     */
    public ClsELogin(String username, String password) {
        this.username = username;
        this.password = password;
        this.activo = true;
    }
    
    /**
     * Constructor completo para registro
     * @param username nombre de usuario
     * @param password contraseña
     * @param email correo electrónico
     */
    public ClsELogin(String username, String password, String email) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.activo = true;
    }
    
    /**
     * Constructor completo con ID (para datos existentes)
     * @param id identificador único
     * @param username nombre de usuario
     * @param password contraseña
     * @param email correo electrónico
     * @param fechaRegistro fecha de registro
     * @param activo estado del usuario
     */
    public ClsELogin(int id, String username, String password, String email, 
                     Timestamp fechaRegistro, boolean activo) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fechaRegistro = fechaRegistro;
        this.activo = activo;
    }
    
    // Getters y Setters
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }
    
    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
    public boolean isActivo() {
        return activo;
    }
    
    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
    // Métodos útiles
    
    /**
     * Valida que los datos básicos estén completos para login
     * @return true si username y password no están vacíos
     */
    public boolean validarDatosLogin() {
        return username != null && !username.trim().isEmpty() &&
               password != null && !password.trim().isEmpty();
    }
    
    /**
     * Valida que los datos estén completos para registro
     * @return true si todos los campos obligatorios están llenos
     */
    public boolean validarDatosRegistro() {
        return validarDatosLogin() && email != null && !email.trim().isEmpty();
    }
    
    /**
     * Valida formato básico de email
     * @return true si el email tiene formato válido
     */
    public boolean validarEmail() {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");
    }
    
    @Override
    public String toString() {
        return "ClsELogin{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fechaRegistro=" + fechaRegistro +
                ", activo=" + activo +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        ClsELogin that = (ClsELogin) obj;
        return id == that.id && username.equals(that.username);
    }
    
    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, username);
    }
}