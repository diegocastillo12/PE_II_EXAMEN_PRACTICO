// ============================================
// MEJORA 1: BUSCADOR INTELIGENTE
// ============================================
function abrirBuscador() {
    document.getElementById('modalBuscador').style.display = 'flex';
    document.getElementById('inputBuscar').focus();
}

function cerrarBuscador() {
    document.getElementById('modalBuscador').style.display = 'none';
    document.getElementById('inputBuscar').value = '';
    document.getElementById('resultadosBusqueda').innerHTML = '';
}

function buscarEnPETI() {
    const termino = document.getElementById('inputBuscar').value.toLowerCase().trim();
    const resultados = document.getElementById('resultadosBusqueda');
    
    if (termino.length < 2) {
        resultados.innerHTML = '<p style="color: #999; text-align: center; padding: 40px;">Escribe al menos 2 caracteres para buscar...</p>';
        return;
    }

    const datosPETI = {
        'empresa': {'nombre': 'Ejemplo Empresa', 'descripcion': 'Descripción de la empresa de prueba'},
        'mision': {'texto': 'Nuestra misión es proporcionar servicios de calidad'},
        'vision': {'texto': 'Ser líderes en el mercado nacional'},
        'valores': {'lista': 'Honestidad, Responsabilidad, Innovación'},
        'objetivos': {'lista': 'Aumentar ventas, Mejorar procesos, Expandir mercado'}
    };

    const nombres = {
        'empresa': 'Información Empresarial',
        'mision': 'Misión',
        'vision': 'Visión',
        'valores': 'Valores',
        'objetivos': 'Objetivos Estratégicos'
    };

    let encontrados = [];
    
    for (let seccion in datosPETI) {
        for (let campo in datosPETI[seccion]) {
            const valor = datosPETI[seccion][campo].toLowerCase();
            if (valor.includes(termino)) {
                const inicio = Math.max(0, valor.indexOf(termino) - 50);
                const fin = Math.min(valor.length, valor.indexOf(termino) + termino.length + 50);
                let contexto = valor.substring(inicio, fin);
                if (inicio > 0) contexto = '...' + contexto;
                if (fin < valor.length) contexto = contexto + '...';
                
                encontrados.push({
                    seccion: nombres[seccion] || seccion,
                    campo: campo,
                    contexto: contexto,
                    highlightTermino: termino
                });
            }
        }
    }

    if (encontrados.length === 0) {
        resultados.innerHTML = '<div style="text-align: center; padding: 40px;"><i class="fas fa-search" style="font-size: 60px; color: #ddd;"></i><p style="color: #999; margin-top: 20px;">No se encontraron resultados para "<strong>' + termino + '</strong>"</p></div>';
        return;
    }

    let html = '<h3 style="color: #667eea; margin-bottom: 15px;"><i class="fas fa-check-circle"></i> ' + encontrados.length + ' resultado(s) encontrado(s)</h3>';
    encontrados.forEach(function(item) {
        const contextoResaltado = item.contexto.replace(new RegExp('(' + item.highlightTermino + ')', 'gi'), '<mark style="background: #ffd700; padding: 2px 4px; font-weight: bold;">$1</mark>');
        
        html += '<div style="background: #f8f9fa; border-left: 4px solid #667eea; padding: 15px; margin-bottom: 12px; border-radius: 8px;">';
        html += '<div style="font-weight: bold; color: #667eea; margin-bottom: 5px;"><i class="fas fa-folder"></i> ' + item.seccion + ' - ' + item.campo + '</div>';
        html += '<div style="color: #555; line-height: 1.6;">' + contextoResaltado + '</div>';
        html += '</div>';
    });

    resultados.innerHTML = html;
}

// ============================================
// MEJORA 2: COMPARADOR DE VERSIONES
// ============================================
function abrirComparador() {
    document.getElementById('modalComparador').style.display = 'flex';
}

function cerrarComparador() {
    document.getElementById('modalComparador').style.display = 'none';
    document.getElementById('seccionComparar').value = '';
    document.getElementById('resultadosComparador').innerHTML = '';
}

function cargarVersiones() {
    const seccion = document.getElementById('seccionComparar').value;
    const resultados = document.getElementById('resultadosComparador');
    
    if (!seccion) {
        resultados.innerHTML = '';
        return;
    }

    // El historial se cargará desde el JSP
    if (typeof historialGlobal === 'undefined' || !historialGlobal || historialGlobal.length === 0) {
        resultados.innerHTML = '<p style="text-align: center; padding: 40px; color: #999;">No hay historial de cambios disponible.</p>';
        return;
    }

    const cambiosSeccion = historialGlobal.filter(function(c) { return c.seccion === seccion; });
    
    if (cambiosSeccion.length === 0) {
        resultados.innerHTML = '<p style="text-align: center; padding: 40px; color: #999;">No hay historial de cambios para esta sección.</p>';
        return;
    }

    let html = '<div style="background: #f8f9fa; padding: 20px; border-radius: 10px;">';
    html += '<h3 style="color: #f5576c; margin-bottom: 20px;"><i class="fas fa-history"></i> Historial de Cambios (' + cambiosSeccion.length + ' modificaciones)</h3>';
    
    cambiosSeccion.forEach(function(cambio) {
        html += '<div style="background: white; padding: 20px; margin-bottom: 15px; border-radius: 10px; border: 2px solid #f5576c;">';
        html += '<div style="display: flex; justify-content: space-between; margin-bottom: 15px;">';
        html += '<div><strong style="color: #f5576c;"><i class="fas fa-user"></i> ' + cambio.usuario + '</strong> modificó <strong>' + cambio.campo + '</strong></div>';
        html += '<div style="color: #999;"><i class="fas fa-clock"></i> ' + cambio.fecha + '</div>';
        html += '</div>';
        
        html += '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">';
        html += '<div style="background: #ffe6e6; padding: 15px; border-radius: 8px; border-left: 4px solid #dc3545;">';
        html += '<div style="font-weight: bold; color: #dc3545; margin-bottom: 8px;"><i class="fas fa-minus-circle"></i> Versión Anterior</div>';
        html += '<div style="color: #333; line-height: 1.6; max-height: 150px; overflow-y: auto;">' + (cambio.anterior || '<em style="color: #999;">Sin contenido previo</em>') + '</div>';
        html += '</div>';
        html += '<div style="background: #e6ffe6; padding: 15px; border-radius: 8px; border-left: 4px solid #28a745;">';
        html += '<div style="font-weight: bold; color: #28a745; margin-bottom: 8px;"><i class="fas fa-plus-circle"></i> Versión Nueva</div>';
        html += '<div style="color: #333; line-height: 1.6; max-height: 150px; overflow-y: auto;">' + (cambio.nuevo || '<em style="color: #999;">Sin contenido</em>') + '</div>';
        html += '</div>';
        html += '</div>';
        html += '</div>';
    });
    
    html += '</div>';
    resultados.innerHTML = html;
}

// Cerrar modales al hacer click fuera o con ESC
document.addEventListener('click', function(event) {
    const modalBuscador = document.getElementById('modalBuscador');
    const modalComparador = document.getElementById('modalComparador');
    
    if (event.target === modalBuscador) cerrarBuscador();
    if (event.target === modalComparador) cerrarComparador();
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        cerrarBuscador();
        cerrarComparador();
    }
});
