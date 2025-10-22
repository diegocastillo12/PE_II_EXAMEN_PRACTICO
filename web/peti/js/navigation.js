/**
 * Navegación para el Plan Estratégico
 * Maneja la navegación entre las diferentes secciones del plan
 */

document.addEventListener('DOMContentLoaded', function() {
    // Para páginas JSP, la autenticación se maneja del lado del servidor
    // No necesitamos verificar sessionStorage aquí
    
    // Resaltar el elemento de navegación activo
    highlightActiveNavItem();
    
    // Manejar el menú móvil
    setupMobileMenu();
    
    // Configurar enlaces de navegación del plan estratégico
    setupPlanLinks();
});

/**
 * Resalta el elemento de navegación activo basado en la URL actual
 */
function highlightActiveNavItem() {
    const currentPath = window.location.pathname;
    const filename = currentPath.substring(currentPath.lastIndexOf('/') + 1);
    
    // Seleccionar todos los enlaces de navegación
    const navLinks = document.querySelectorAll('.dashboard-nav a, .plan-nav a');
    
    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href === filename || (filename === '' && href === 'dashboard.jsp')) {
            // Encontrar el elemento li padre y añadir la clase active
            const parentLi = link.closest('li');
            if (parentLi) {
                parentLi.classList.add('active');
            }
        } else {
            // Remover la clase active de otros elementos
            const parentLi = link.closest('li');
            if (parentLi) {
                parentLi.classList.remove('active');
            }
        }
    });
}

/**
 * Configura el menú móvil para dispositivos pequeños
 */
function setupMobileMenu() {
    const menuToggle = document.querySelector('.menu-toggle');
    const sidebar = document.querySelector('.dashboard-sidebar');
    
    if (menuToggle && sidebar) {
        menuToggle.addEventListener('click', function() {
            sidebar.classList.toggle('active');
            menuToggle.classList.toggle('active');
        });
    }
}

/**
 * Configura los enlaces para la navegación del plan estratégico
 */
function setupPlanLinks() {
    // Estructura del plan estratégico
    const planSections = [
        { id: 'empresa', name: 'Información de la Empresa', icon: 'fa-building' },
        { id: 'mision', name: 'Misión', icon: 'fa-bullseye' },
        { id: 'vision', name: 'Visión', icon: 'fa-eye' },
        { id: 'valores', name: 'Valores', icon: 'fa-gem' },
        { id: 'objetivos', name: 'Objetivos', icon: 'fa-flag' },
        { id: 'analisis-interno', name: 'Análisis Interno', icon: 'fa-search' },
        { id: 'analisis-externo', name: 'Análisis Externo', icon: 'fa-binoculars' },
        { id: 'pest', name: 'Análisis PEST', icon: 'fa-chart-pie' },
        { id: 'porter', name: '5 Fuerzas de Porter', icon: 'fa-sitemap' },
        { id: 'cadena-valor', name: 'Cadena de Valor', icon: 'fa-link' },
        { id: 'matriz-participacion', name: 'Matriz de Participación', icon: 'fa-users' },
        { id: 'identificacion-estrategia', name: 'Identificación de Estrategia', icon: 'fa-lightbulb' },
        { id: 'matriz-came', name: 'Matriz CAME', icon: 'fa-project-diagram' },
        { id: 'resumen-ejecutivo', name: 'Resumen Ejecutivo', icon: 'fa-file-alt' }
    ];
    
    // Generar menú de navegación del plan si existe el contenedor
    const planNavContainer = document.querySelector('.plan-nav-container');
    if (planNavContainer) {
        const planNav = document.createElement('ul');
        planNav.className = 'plan-nav';
        
        planSections.forEach(section => {
            const li = document.createElement('li');
            li.innerHTML = `<a href="${section.id}.jsp"><i class="fas ${section.icon}"></i> ${section.name}</a>`;
            planNav.appendChild(li);
        });
        
        planNavContainer.appendChild(planNav);
    }
    
    // Actualizar el breadcrumb si existe
    updateBreadcrumb(planSections);
}

/**
 * Actualiza el breadcrumb basado en la página actual
 */
function updateBreadcrumb(planSections) {
    const breadcrumb = document.querySelector('.breadcrumb');
    if (!breadcrumb) return;
    
    const currentPath = window.location.pathname;
    const filename = currentPath.substring(currentPath.lastIndexOf('/') + 1);
    const pageName = filename.replace('.jsp', '');
    
    // Siempre incluir el enlace al dashboard
    let breadcrumbHTML = '<li><a href="dashboard.jsp"><i class="fas fa-home"></i> Inicio</a></li>';
    
    // Añadir la página actual si no es el dashboard
    if (pageName !== 'dashboard' && pageName !== '') {
        const currentSection = planSections.find(section => section.id === pageName);
        if (currentSection) {
            breadcrumbHTML += `<li>${currentSection.name}</li>`;
        }
    }
    
    breadcrumb.innerHTML = breadcrumbHTML;
}