/**
 * Almacenamiento para el Plan Estratégico
 * Maneja el almacenamiento y recuperación de datos del plan estratégico
 */

const PlanStorage = {
    /**
     * Guarda datos en el almacenamiento local
     * @param {string} key - Clave para almacenar los datos
     * @param {any} data - Datos a almacenar
     */
    saveData: function(key, data) {
        try {
            localStorage.setItem(`plan_${key}`, JSON.stringify(data));
            return true;
        } catch (error) {
            console.error('Error al guardar datos:', error);
            return false;
        }
    },
    
    /**
     * Recupera datos del almacenamiento local
     * @param {string} key - Clave para recuperar los datos
     * @returns {any} - Datos almacenados o null si no existen
     */
    getData: function(key) {
        try {
            const data = localStorage.getItem(`plan_${key}`);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            console.error('Error al recuperar datos:', error);
            return null;
        }
    },
    
    /**
     * Elimina datos del almacenamiento local
     * @param {string} key - Clave para eliminar los datos
     */
    removeData: function(key) {
        try {
            localStorage.removeItem(`plan_${key}`);
            return true;
        } catch (error) {
            console.error('Error al eliminar datos:', error);
            return false;
        }
    },
    
    /**
     * Verifica si existen datos para una clave específica
     * @param {string} key - Clave a verificar
     * @returns {boolean} - True si existen datos, false en caso contrario
     */
    hasData: function(key) {
        return localStorage.getItem(`plan_${key}`) !== null;
    },
    
    /**
     * Guarda el progreso general del plan estratégico
     * @param {Object} progress - Objeto con el progreso
     */
    saveProgress: function(progress) {
        this.saveData('progress', progress);
    },
    
    /**
     * Recupera el progreso general del plan estratégico
     * @returns {Object} - Objeto con el progreso o un objeto vacío
     */
    getProgress: function() {
        return this.getData('progress') || {};
    },
    
    /**
     * Actualiza el progreso de una sección específica
     * @param {string} section - Nombre de la sección
     * @param {boolean} completed - Estado de completitud
     */
    updateSectionProgress: function(section, completed) {
        const progress = this.getProgress();
        progress[section] = completed;
        this.saveProgress(progress);
    },
    
    /**
     * Verifica si una sección está completa
     * @param {string} section - Nombre de la sección
     * @returns {boolean} - True si está completa, false en caso contrario
     */
    isSectionComplete: function(section) {
        const progress = this.getProgress();
        return progress[section] === true;
    },
    
    /**
     * Calcula el porcentaje total de progreso
     * @param {Array} sections - Array con los nombres de todas las secciones
     * @returns {number} - Porcentaje de progreso (0-100)
     */
    calculateTotalProgress: function(sections) {
        const progress = this.getProgress();
        let completed = 0;
        
        sections.forEach(section => {
            if (progress[section] === true) {
                completed++;
            }
        });
        
        return sections.length > 0 ? Math.round((completed / sections.length) * 100) : 0;
    },
    
    /**
     * Exporta todos los datos del plan estratégico
     * @returns {Object} - Objeto con todos los datos del plan
     */
    exportAllData: function() {
        const exportData = {};
        
        // Lista de todas las secciones del plan
        const sections = [
            'empresa',
            'mision',
            'vision',
            'valores',
            'objetivos',
            'analisis-interno',
            'analisis-externo',
            'pest',
            'porter',
            'cadena-valor',
            'matriz-participacion',
            'identificacion-estrategia',
            'matriz-came',
            'resumen-ejecutivo'
        ];
        
        // Exportar datos de cada sección
        sections.forEach(section => {
            exportData[section] = this.getData(section);
        });
        
        // Añadir información de progreso
        exportData.progress = this.getProgress();
        
        return exportData;
    },
    
    /**
     * Importa datos al plan estratégico
     * @param {Object} data - Datos a importar
     * @returns {boolean} - True si la importación fue exitosa
     */
    importData: function(data) {
        try {
            // Validar que sea un objeto
            if (typeof data !== 'object' || data === null) {
                throw new Error('Los datos a importar no son válidos');
            }
            
            // Importar cada sección
            Object.keys(data).forEach(key => {
                if (key !== 'progress') {
                    this.saveData(key, data[key]);
                }
            });
            
            // Importar progreso si existe
            if (data.progress) {
                this.saveProgress(data.progress);
            }
            
            return true;
        } catch (error) {
            console.error('Error al importar datos:', error);
            return false;
        }
    }
};