package entidad;

import java.sql.Timestamp;

/**
 * Clase entidad para el manejo de grupos
 * Corresponde a la tabla 'grupos' de la base de datos
 * 
 * @author Mi Equipo
 */
public class ClsEGrupo {
    
    // Atributos correspondientes a la tabla grupos
    private int id;
    private String nombre;
    private String codigo;
    private int limiteUsuarios;
    private int adminId;
    private Timestamp fechaCreacion;
    private boolean activo;
    
    // Constructores
    
    /**
     * Constructor vacío
     */
    public ClsEGrupo() {
        this.activo = true; // Por defecto activo
        this.limiteUsuarios = 10; // Límite por defecto
    }
    
    /**
     * Constructor para crear grupo básico
     * @param nombre nombre del grupo
     * @param codigo código del grupo
     * @param limiteUsuarios límite de usuarios
     * @param adminId ID del administrador
     */
    public ClsEGrupo(String nombre, String codigo, int limiteUsuarios, int adminId) {
        this.nombre = nombre;
        this.codigo = codigo;
        this.limiteUsuarios = limiteUsuarios;
        this.adminId = adminId;
        this.activo = true;
    }
    
    /**
     * Constructor completo
     * @param id ID del grupo
     * @param nombre nombre del grupo
     * @param codigo código del grupo
     * @param limiteUsuarios límite de usuarios
     * @param adminId ID del administrador
     * @param fechaCreacion fecha de creación
     * @param activo estado del grupo
     */
    public ClsEGrupo(int id, String nombre, String codigo, int limiteUsuarios, 
                     int adminId, Timestamp fechaCreacion, boolean activo) {
        this.id = id;
        this.nombre = nombre;
        this.codigo = codigo;
        this.limiteUsuarios = limiteUsuarios;
        this.adminId = adminId;
        this.fechaCreacion = fechaCreacion;
        this.activo = activo;
    }
    
    // Getters y Setters
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    public int getLimiteUsuarios() {
        return limiteUsuarios;
    }
    
    public void setLimiteUsuarios(int limiteUsuarios) {
        this.limiteUsuarios = limiteUsuarios;
    }
    
    public int getAdminId() {
        return adminId;
    }
    
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
    
    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }
    
    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
    
    public boolean isActivo() {
        return activo;
    }
    
    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
    // Métodos de validación
    
    /**
     * Valida que los datos básicos para crear un grupo estén completos
     * @return true si los datos son válidos, false en caso contrario
     */
    public boolean validarDatosCreacion() {
        if (nombre == null || nombre.trim().isEmpty()) {
            System.err.println("✗ El nombre del grupo no puede estar vacío");
            return false;
        }
        
        if (nombre.length() > 100) {
            System.err.println("✗ El nombre del grupo no puede exceder 100 caracteres");
            return false;
        }
        
        if (limiteUsuarios < 2 || limiteUsuarios > 100) {
            System.err.println("✗ El límite de usuarios debe estar entre 2 y 100");
            return false;
        }
        
        if (adminId <= 0) {
            System.err.println("✗ ID de administrador inválido");
            return false;
        }
        
        return true;
    }
    
    /**
     * Valida que el código del grupo sea válido
     * @return true si el código es válido, false en caso contrario
     */
    public boolean validarCodigo() {
        if (codigo == null || codigo.trim().isEmpty()) {
            System.err.println("✗ El código del grupo no puede estar vacío");
            return false;
        }
        
        if (codigo.length() != 6) {
            System.err.println("✗ El código del grupo debe tener exactamente 6 caracteres");
            return false;
        }
        
        // Verificar que solo contenga letras y números
        if (!codigo.matches("^[A-Z0-9]+$")) {
            System.err.println("✗ El código solo puede contener letras mayúsculas y números");
            return false;
        }
        
        return true;
    }
    
    // Métodos de utilidad
    
    /**
     * Genera un código aleatorio para el grupo
     * @return código de 6 caracteres alfanumérico
     */
    public static String generarCodigo() {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder codigo = new StringBuilder();
        
        for (int i = 0; i < 6; i++) {
            int indice = (int) (Math.random() * caracteres.length());
            codigo.append(caracteres.charAt(indice));
        }
        
        return codigo.toString();
    }
    
    @Override
    public String toString() {
        return "ClsEGrupo{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", codigo='" + codigo + '\'' +
                ", limiteUsuarios=" + limiteUsuarios +
                ", adminId=" + adminId +
                ", fechaCreacion=" + fechaCreacion +
                ", activo=" + activo +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        ClsEGrupo grupo = (ClsEGrupo) obj;
        return id == grupo.id;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(id);
    }
}