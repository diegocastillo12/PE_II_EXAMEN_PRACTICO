package entidad;

import java.sql.Timestamp;

/**
 * Clase entidad para el manejo de datos del PETI
 * Corresponde a la tabla 'peti_datos' de la base de datos
 * 
 * @author Mi Equipo
 */
public class ClsEPeti {
    
    // Atributos correspondientes a la tabla peti_datos
    private int id;
    private int grupoId;
    private String seccion;
    private String campo;
    private String valor;
    private int usuarioModificacion;
    private Timestamp fechaModificacion;
    private int version;
    
    // Constructores
    
    /**
     * Constructor vacío
     */
    public ClsEPeti() {
        this.version = 1;
    }
    
    /**
     * Constructor para crear nuevo dato PETI
     * @param grupoId ID del grupo
     * @param seccion sección del PETI (empresa, mision, vision, etc.)
     * @param campo campo específico
     * @param valor valor del campo
     * @param usuarioModificacion ID del usuario que modifica
     */
    public ClsEPeti(int grupoId, String seccion, String campo, String valor, int usuarioModificacion) {
        this.grupoId = grupoId;
        this.seccion = seccion;
        this.campo = campo;
        this.valor = valor;
        this.usuarioModificacion = usuarioModificacion;
        this.version = 1;
    }
    
    /**
     * Constructor completo
     * @param id ID del registro
     * @param grupoId ID del grupo
     * @param seccion sección del PETI
     * @param campo campo específico
     * @param valor valor del campo
     * @param usuarioModificacion ID del usuario que modifica
     * @param fechaModificacion fecha de modificación
     * @param version versión del registro
     */
    public ClsEPeti(int id, int grupoId, String seccion, String campo, String valor, 
                    int usuarioModificacion, Timestamp fechaModificacion, int version) {
        this.id = id;
        this.grupoId = grupoId;
        this.seccion = seccion;
        this.campo = campo;
        this.valor = valor;
        this.usuarioModificacion = usuarioModificacion;
        this.fechaModificacion = fechaModificacion;
        this.version = version;
    }
    
    // Getters y Setters
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getGrupoId() {
        return grupoId;
    }
    
    public void setGrupoId(int grupoId) {
        this.grupoId = grupoId;
    }
    
    public String getSeccion() {
        return seccion;
    }
    
    public void setSeccion(String seccion) {
        this.seccion = seccion;
    }
    
    public String getCampo() {
        return campo;
    }
    
    public void setCampo(String campo) {
        this.campo = campo;
    }
    
    public String getValor() {
        return valor;
    }
    
    public void setValor(String valor) {
        this.valor = valor;
    }
    
    public int getUsuarioModificacion() {
        return usuarioModificacion;
    }
    
    public void setUsuarioModificacion(int usuarioModificacion) {
        this.usuarioModificacion = usuarioModificacion;
    }
    
    public Timestamp getFechaModificacion() {
        return fechaModificacion;
    }
    
    public void setFechaModificacion(Timestamp fechaModificacion) {
        this.fechaModificacion = fechaModificacion;
    }
    
    public int getVersion() {
        return version;
    }
    
    public void setVersion(int version) {
        this.version = version;
    }
    
    // Métodos de utilidad
    
    /**
     * Incrementa la versión del registro
     */
    public void incrementarVersion() {
        this.version++;
    }
    
    /**
     * Valida si los datos básicos están completos
     * @return true si los datos son válidos
     */
    public boolean validarDatos() {
        return grupoId > 0 && 
               seccion != null && !seccion.trim().isEmpty() &&
               campo != null && !campo.trim().isEmpty() &&
               usuarioModificacion > 0;
    }
    
    /**
     * Obtiene una representación en cadena del objeto
     * @return String representación del objeto
     */
    @Override
    public String toString() {
        return "ClsEPeti{" +
                "id=" + id +
                ", grupoId=" + grupoId +
                ", seccion='" + seccion + '\'' +
                ", campo='" + campo + '\'' +
                ", valor='" + valor + '\'' +
                ", usuarioModificacion=" + usuarioModificacion +
                ", fechaModificacion=" + fechaModificacion +
                ", version=" + version +
                '}';
    }
}