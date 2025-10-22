



/**
 * Gestión de formularios para el Plan Estratégico
 * Maneja la validación y envío de formularios
 */

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar todos los formularios del plan estratégico
    initPlanForms();
    
    // Cargar datos guardados si existen
    loadSavedData();
});

/**
 * Inicializa los formularios del plan estratégico
 */
function initPlanForms() {
    const planForm = document.querySelector('.plan-form');
    if (!planForm) return;
    
    // Obtener el ID de la sección actual
    const currentPath = window.location.pathname;
    const filename = currentPath.substring(currentPath.lastIndexOf('/') + 1);
    const sectionId = filename.replace('.jsp', '');
    
    // Configurar el formulario para guardar automáticamente
    setupAutoSave(planForm, sectionId);
    
    // Configurar el botón de guardar
    const saveButton = planForm.querySelector('.save-button');
    if (saveButton) {
        saveButton.addEventListener('click', function(e) {
            e.preventDefault();
            saveFormData(planForm, sectionId);
        });
    }
    
    // Configurar el botón de restablecer
    const resetButton = planForm.querySelector('.reset-button');
    if (resetButton) {
        resetButton.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm('¿Estás seguro de que deseas restablecer este formulario? Se perderán todos los datos ingresados.')) {
                resetForm(planForm, sectionId);
            }
        });
    }
}

/**
 * Configura el guardado automático para un formulario
 * @param {HTMLFormElement} form - El formulario a configurar
 * @param {string} sectionId - ID de la sección
 */
function setupAutoSave(form, sectionId) {
    // Guardar datos cuando cambie cualquier campo
    const formInputs = form.querySelectorAll('input, textarea, select');
    formInputs.forEach(input => {
        input.addEventListener('change', function() {
            saveFormData(form, sectionId, true);
        });
        
        // Para campos de texto, guardar después de un tiempo sin escribir
        if (input.tagName === 'TEXTAREA' || input.type === 'text') {
            let typingTimer;
            input.addEventListener('keyup', function() {
                clearTimeout(typingTimer);
                typingTimer = setTimeout(function() {
                    saveFormData(form, sectionId, true);
                }, 1000);
            });
        }
    });
}

/**
 * Guarda los datos de un formulario
 * @param {HTMLFormElement} form - El formulario a guardar
 * @param {string} sectionId - ID de la sección
 * @param {boolean} silent - Si es true, no muestra mensajes de éxito
 */
function saveFormData(form, sectionId, silent = false) {
    // Recopilar datos del formulario
    const formData = {};
    const formInputs = form.querySelectorAll('[name]');
    
    formInputs.forEach(input => {
        const name = input.name;
        let value;
        
        if (input.type === 'checkbox') {
            value = input.checked;
        } else if (input.type === 'radio') {
            if (input.checked) {
                value = input.value;
            } else {
                return; // Saltar radios no seleccionados
            }
        } else {
            value = input.value;
        }
        
        formData[name] = value;
    });
    
    // Guardar datos
    const saved = PlanStorage.saveData(sectionId, formData);
    
    // Actualizar estado de completitud
    const isComplete = validateFormCompletion(form);
    PlanStorage.updateSectionProgress(sectionId, isComplete);
    
    // Actualizar indicador visual de progreso
    updateProgressIndicator();
    
    // Mostrar mensaje de éxito si no es silencioso
    if (saved && !silent) {
        showMessage('Datos guardados correctamente', 'success');
    }
    
    return saved;
}

/**
 * Carga datos guardados en el formulario
 */
function loadSavedData() {
    const planForm = document.querySelector('.plan-form');
    if (!planForm) return;
    
    // Obtener el ID de la sección actual
    const currentPath = window.location.pathname;
    const filename = currentPath.substring(currentPath.lastIndexOf('/') + 1);
    const sectionId = filename.replace('.jsp', '');
    
    // Recuperar datos guardados
    const savedData = PlanStorage.getData(sectionId);
    if (!savedData) return;
    
    // Rellenar el formulario con los datos guardados
    Object.keys(savedData).forEach(key => {
        const input = planForm.querySelector(`[name="${key}"]`);
        if (!input) return;
        
        if (input.type === 'checkbox') {
            input.checked = savedData[key];
        } else if (input.type === 'radio') {
            const radio = planForm.querySelector(`[name="${key}"][value="${savedData[key]}"]`);
            if (radio) radio.checked = true;
        } else {
            input.value = savedData[key];
        }
    });
    
    // Actualizar indicador visual de progreso
    updateProgressIndicator();
}

/**
 * Restablece un formulario y elimina los datos guardados
 * @param {HTMLFormElement} form - El formulario a restablecer
 * @param {string} sectionId - ID de la sección
 */
function resetForm(form, sectionId) {
    // Restablecer el formulario
    form.reset();
    
    // Eliminar datos guardados
    PlanStorage.removeData(sectionId);
    
    // Actualizar estado de completitud
    PlanStorage.updateSectionProgress(sectionId, false);
    
    // Actualizar indicador visual de progreso
    updateProgressIndicator();
    
    showMessage('Formulario restablecido', 'info');
}

/**
 * Valida si un formulario está completo
 * @param {HTMLFormElement} form - El formulario a validar
 * @returns {boolean} - True si el formulario está completo
 */
function validateFormCompletion(form) {
    const requiredInputs = form.querySelectorAll('[required]');
    let isComplete = true;
    
    requiredInputs.forEach(input => {
        if (input.type === 'radio') {
            // Para radios, verificar si alguno del mismo nombre está seleccionado
            const name = input.name;
            const checkedRadio = form.querySelector(`[name="${name}"]:checked`);
            if (!checkedRadio) {
                isComplete = false;
            }
        } else if (input.type === 'checkbox' && input.required && !input.checked) {
            isComplete = false;
        } else if (!input.value.trim()) {
            isComplete = false;
        }
    });
    
    return isComplete;
}

/**
 * Muestra un mensaje al usuario
 * @param {string} text - Texto del mensaje
 * @param {string} type - Tipo de mensaje (success, error, info)
 */
function showMessage(text, type = 'info') {
    // Buscar o crear el contenedor de mensajes
    let messageContainer = document.querySelector('.message-container');
    if (!messageContainer) {
        messageContainer = document.createElement('div');
        messageContainer.className = 'message-container';
        document.body.appendChild(messageContainer);
    }
    
    // Crear el mensaje
    const message = document.createElement('div');
    message.className = `message ${type}`;
    message.textContent = text;
    
    // Añadir el mensaje al contenedor
    messageContainer.appendChild(message);
    
    // Eliminar el mensaje después de un tiempo
    setTimeout(() => {
        message.classList.add('fade-out');
        setTimeout(() => {
            message.remove();
        }, 500);
    }, 3000);
}