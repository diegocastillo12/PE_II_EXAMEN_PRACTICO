/**
 * Seguimiento de progreso para el Plan Estratégico
 * Maneja la visualización y actualización del progreso
 */

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar indicadores de progreso
    updateProgressIndicator();
    
    // Inicializar la barra de progreso general si existe
    initTotalProgressBar();
});

/**
 * Actualiza los indicadores visuales de progreso en la página
 */
function updateProgressIndicator() {
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
    
    // Actualizar indicadores de progreso en el menú de navegación
    updateNavProgressIndicators(sections);
    
    // Actualizar la barra de progreso general si existe
    updateTotalProgressBar(sections);
    
    // Actualizar el estado de la sección actual
    updateCurrentSectionStatus();
}

/**
 * Actualiza los indicadores de progreso en el menú de navegación
 * @param {Array} sections - Lista de secciones del plan
 */
function updateNavProgressIndicators(sections) {
    const navItems = document.querySelectorAll('.plan-nav li');
    
    navItems.forEach(item => {
        const link = item.querySelector('a');
        if (!link) return;
        
        const href = link.getAttribute('href');
        const sectionId = href.replace('.jsp', '');
        
        // Verificar si la sección está completa
        const isComplete = PlanStorage.isSectionComplete(sectionId);
        
        // Actualizar el indicador visual
        if (isComplete) {
            item.classList.add('completed');
            
            // Añadir icono de completado si no existe
            if (!item.querySelector('.completion-indicator')) {
                const indicator = document.createElement('span');
                indicator.className = 'completion-indicator';
                indicator.innerHTML = '<i class="fas fa-check-circle"></i>';
                item.appendChild(indicator);
            }
        } else {
            item.classList.remove('completed');
            
            // Eliminar icono de completado si existe
            const indicator = item.querySelector('.completion-indicator');
            if (indicator) {
                indicator.remove();
            }
        }
    });
}

/**
 * Inicializa la barra de progreso general
 */
function initTotalProgressBar() {
    const progressBarContainer = document.querySelector('.progress-bar-container');
    if (!progressBarContainer) return;
    
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
    
    // Calcular el progreso total
    const totalProgress = PlanStorage.calculateTotalProgress(sections);
    
    // Actualizar la barra de progreso
    const progressBar = progressBarContainer.querySelector('.progress-bar');
    if (progressBar) {
        progressBar.style.width = `${totalProgress}%`;
        progressBar.setAttribute('aria-valuenow', totalProgress);
    }
    
    // Actualizar el texto de progreso
    const progressText = progressBarContainer.querySelector('.progress-text');
    if (progressText) {
        progressText.textContent = `${totalProgress}% Completado`;
    }
}

/**
 * Actualiza la barra de progreso general
 * @param {Array} sections - Lista de secciones del plan
 */
function updateTotalProgressBar(sections) {
    const progressBarContainer = document.querySelector('.progress-bar-container');
    if (!progressBarContainer) return;
    
    // Calcular el progreso total
    const totalProgress = PlanStorage.calculateTotalProgress(sections);
    
    // Actualizar la barra de progreso
    const progressBar = progressBarContainer.querySelector('.progress-bar');
    if (progressBar) {
        progressBar.style.width = `${totalProgress}%`;
        progressBar.setAttribute('aria-valuenow', totalProgress);
    }
    
    // Actualizar el texto de progreso
    const progressText = progressBarContainer.querySelector('.progress-text');
    if (progressText) {
        progressText.textContent = `${totalProgress}% Completado`;
    }
}

/**
 * Actualiza el estado de la sección actual
 */
function updateCurrentSectionStatus() {
    // Obtener el ID de la sección actual
    const currentPath = window.location.pathname;
    const filename = currentPath.substring(currentPath.lastIndexOf('/') + 1);
    const sectionId = filename.replace('.jsp', '');
    
    // Verificar si la sección actual está completa
    const isComplete = PlanStorage.isSectionComplete(sectionId);
    
    // Actualizar el indicador de estado en la página
    const statusIndicator = document.querySelector('.section-status');
    if (statusIndicator) {
        if (isComplete) {
            statusIndicator.innerHTML = '<i class="fas fa-check-circle"></i> Completado';
            statusIndicator.className = 'section-status completed';
        } else {
            statusIndicator.innerHTML = '<i class="fas fa-clock"></i> Pendiente';
            statusIndicator.className = 'section-status pending';
        }
    }
}

/**
 * Genera un informe de progreso del plan estratégico
 * @returns {Object} - Objeto con el informe de progreso
 */
function generateProgressReport() {
    // Lista de todas las secciones del plan
    const sections = [
        { id: 'empresa', name: 'Información de la Empresa' },
        { id: 'mision', name: 'Misión' },
        { id: 'vision', name: 'Visión' },
        { id: 'valores', name: 'Valores' },
        { id: 'objetivos', name: 'Objetivos' },
        { id: 'analisis-interno', name: 'Análisis Interno' },
        { id: 'analisis-externo', name: 'Análisis Externo' },
        { id: 'pest', name: 'Análisis PEST' },
        { id: 'porter', name: '5 Fuerzas de Porter' },
        { id: 'cadena-valor', name: 'Cadena de Valor' },
        { id: 'matriz-participacion', name: 'Matriz de Participación' },
        { id: 'identificacion-estrategia', name: 'Identificación de Estrategia' },
        { id: 'matriz-came', name: 'Matriz CAME' },
        { id: 'resumen-ejecutivo', name: 'Resumen Ejecutivo' }
    ];
    
    // Obtener el progreso de cada sección
    const progress = PlanStorage.getProgress();
    
    // Crear informe
    const report = {
        totalSections: sections.length,
        completedSections: 0,
        percentComplete: 0,
        sectionStatus: []
    };
    
    // Calcular secciones completadas y estado de cada sección
    sections.forEach(section => {
        const isComplete = progress[section.id] === true;
        
        if (isComplete) {
            report.completedSections++;
        }
        
        report.sectionStatus.push({
            id: section.id,
            name: section.name,
            completed: isComplete
        });
    });
    
    // Calcular porcentaje de progreso
    report.percentComplete = Math.round((report.completedSections / report.totalSections) * 100);
    
    return report;
}