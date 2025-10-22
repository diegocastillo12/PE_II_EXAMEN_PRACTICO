/**
 * Sistema de Notificaciones en Tiempo Real
 * MEJORA 1 - Examen Práctico Unidad II
 * Sin dependencias externas, solo JavaScript puro
 */

class NotificationSystem {
    constructor() {
        this.notificationContainer = null;
        this.updateInterval = 30000; // 30 segundos
        this.intervalId = null;
        this.lastUpdate = 0;
        this.unreadCount = 0;
    }

    /**
     * Inicializa el sistema de notificaciones
     */
    init() {
        this.createNotificationPanel();
        this.startAutoUpdate();
        this.attachEventListeners();
        this.loadNotifications();
    }

    /**
     * Crea el panel de notificaciones en el DOM
     */
    createNotificationPanel() {
        // Crear el botón de notificaciones
        const notifButton = document.createElement('div');
        notifButton.id = 'notification-button';
        notifButton.innerHTML = `
            <i class="fas fa-bell"></i>
            <span class="notification-badge" style="display: none;">0</span>
        `;
        notifButton.style.cssText = `
            position: fixed;
            top: 20px;
            right: 80px;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            z-index: 1000;
            transition: all 0.3s ease;
        `;

        // Crear el panel de notificaciones
        const panel = document.createElement('div');
        panel.id = 'notification-panel';
        panel.innerHTML = `
            <div class="notification-header">
                <h3><i class="fas fa-bell"></i> Notificaciones en Tiempo Real</h3>
                <button id="close-notifications" class="close-btn">&times;</button>
            </div>
            
            <div class="notification-tabs">
                <button class="tab-btn active" data-tab="cambios">
                    <i class="fas fa-history"></i> Cambios Recientes
                </button>
                <button class="tab-btn" data-tab="miembros">
                    <i class="fas fa-users"></i> Miembros Activos
                </button>
            </div>
            
            <div class="notification-content">
                <div id="tab-cambios" class="tab-content active">
                    <div class="loading">Cargando notificaciones...</div>
                </div>
                <div id="tab-miembros" class="tab-content">
                    <div class="loading">Cargando miembros...</div>
                </div>
            </div>
            
            <div class="notification-footer">
                <small>Última actualización: <span id="last-update-time">Nunca</span></small>
                <button id="refresh-notifications" class="refresh-btn">
                    <i class="fas fa-sync-alt"></i> Actualizar
                </button>
            </div>
        `;
        panel.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            width: 400px;
            max-height: 600px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            z-index: 1001;
            display: none;
            overflow: hidden;
            animation: slideIn 0.3s ease;
        `;

        // Agregar estilos
        this.addStyles();

        // Agregar al DOM
        document.body.appendChild(notifButton);
        document.body.appendChild(panel);

        this.notificationContainer = panel;
    }

    /**
     * Agregar estilos CSS
     */
    addStyles() {
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.1); }
            }

            #notification-button:hover {
                transform: scale(1.1);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            }

            #notification-button i {
                color: white;
                font-size: 24px;
            }

            .notification-badge {
                position: absolute;
                top: -5px;
                right: -5px;
                background: #ff4757;
                color: white;
                border-radius: 50%;
                width: 22px;
                height: 22px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 11px;
                font-weight: bold;
                animation: pulse 1s infinite;
            }

            .notification-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .notification-header h3 {
                margin: 0;
                font-size: 18px;
                font-weight: 600;
            }

            .close-btn {
                background: none;
                border: none;
                color: white;
                font-size: 28px;
                cursor: pointer;
                padding: 0;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: transform 0.2s;
            }

            .close-btn:hover {
                transform: rotate(90deg);
            }

            .notification-tabs {
                display: flex;
                background: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
            }

            .tab-btn {
                flex: 1;
                padding: 12px;
                background: none;
                border: none;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                color: #6c757d;
                transition: all 0.3s;
                border-bottom: 3px solid transparent;
            }

            .tab-btn:hover {
                background: #e9ecef;
                color: #495057;
            }

            .tab-btn.active {
                color: #667eea;
                border-bottom-color: #667eea;
                background: white;
            }

            .notification-content {
                max-height: 400px;
                overflow-y: auto;
                padding: 15px;
            }

            .tab-content {
                display: none;
            }

            .tab-content.active {
                display: block;
            }

            .notification-item {
                padding: 12px;
                border-left: 3px solid #667eea;
                background: #f8f9fa;
                border-radius: 8px;
                margin-bottom: 10px;
                transition: all 0.3s;
            }

            .notification-item:hover {
                background: #e9ecef;
                transform: translateX(5px);
            }

            .notification-item.new {
                border-left-color: #ff4757;
                background: #fff5f5;
            }

            .notification-item strong {
                color: #667eea;
                font-weight: 600;
            }

            .notification-item small {
                color: #6c757d;
                font-size: 12px;
            }

            .member-item {
                display: flex;
                align-items: center;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 8px;
                background: #f8f9fa;
                transition: all 0.3s;
            }

            .member-item:hover {
                background: #e9ecef;
            }

            .member-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
                margin-right: 12px;
            }

            .member-info {
                flex: 1;
            }

            .member-name {
                font-weight: 600;
                color: #495057;
                margin-bottom: 2px;
            }

            .member-role {
                font-size: 12px;
                color: #6c757d;
            }

            .status-indicator {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background: #28a745;
                animation: pulse 2s infinite;
            }

            .notification-footer {
                padding: 12px 20px;
                background: #f8f9fa;
                border-top: 1px solid #dee2e6;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .refresh-btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 12px;
                font-weight: 600;
                transition: all 0.3s;
            }

            .refresh-btn:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            }

            .loading {
                text-align: center;
                padding: 40px;
                color: #6c757d;
            }

            .empty-state {
                text-align: center;
                padding: 40px 20px;
                color: #6c757d;
            }

            .empty-state i {
                font-size: 48px;
                color: #dee2e6;
                margin-bottom: 15px;
            }
        `;
        document.head.appendChild(style);
    }

    /**
     * Adjuntar event listeners
     */
    attachEventListeners() {
        const button = document.getElementById('notification-button');
        const panel = document.getElementById('notification-panel');
        const closeBtn = document.getElementById('close-notifications');
        const refreshBtn = document.getElementById('refresh-notifications');
        const tabs = document.querySelectorAll('.tab-btn');

        button.addEventListener('click', () => this.togglePanel());
        closeBtn.addEventListener('click', () => this.hidePanel());
        refreshBtn.addEventListener('click', () => this.loadNotifications());

        tabs.forEach(tab => {
            tab.addEventListener('click', (e) => this.switchTab(e.target.dataset.tab));
        });

        // Cerrar al hacer clic fuera
        document.addEventListener('click', (e) => {
            if (!panel.contains(e.target) && !button.contains(e.target)) {
                this.hidePanel();
            }
        });
    }

    /**
     * Alternar visibilidad del panel
     */
    togglePanel() {
        const panel = this.notificationContainer;
        if (panel.style.display === 'none') {
            panel.style.display = 'block';
            this.loadNotifications();
        } else {
            panel.style.display = 'none';
        }
    }

    /**
     * Ocultar panel
     */
    hidePanel() {
        this.notificationContainer.style.display = 'none';
    }

    /**
     * Cambiar de pestaña
     */
    switchTab(tabName) {
        // Actualizar botones
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

        // Actualizar contenido
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.remove('active');
        });
        document.getElementById(`tab-${tabName}`).classList.add('active');
    }

    /**
     * Cargar notificaciones desde el servidor
     */
    async loadNotifications() {
        try {
            const response = await fetch('api/obtenerNotificaciones.jsp');
            const data = await response.json();

            if (data.success) {
                this.renderCambios(data.cambiosRecientes);
                this.renderMiembros(data.miembrosActivos);
                this.updateTimestamp();
                this.updateBadge(data.cambiosRecientes.length);
            }
        } catch (error) {
            console.error('Error al cargar notificaciones:', error);
            this.showError();
        }
    }

    /**
     * Renderizar cambios recientes
     */
    renderCambios(cambios) {
        const container = document.getElementById('tab-cambios');
        
        if (cambios.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>No hay cambios recientes</p>
                </div>
            `;
            return;
        }

        let html = '';
        cambios.forEach(cambio => {
            html += `
                <div class="notification-item">
                    <strong>${cambio.usuario}</strong> modificó 
                    <strong>${cambio.seccion}</strong>
                    <br>
                    <small><i class="fas fa-clock"></i> ${cambio.fecha}</small>
                </div>
            `;
        });

        container.innerHTML = html;
    }

    /**
     * Renderizar miembros activos
     */
    renderMiembros(miembros) {
        const container = document.getElementById('tab-miembros');
        
        if (miembros.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <p>No hay miembros en el grupo</p>
                </div>
            `;
            return;
        }

        let html = '';
        miembros.forEach(miembro => {
            const inicial = miembro.username.charAt(0).toUpperCase();
            const rolBadge = miembro.rol === 'admin' ? '👑' : '👤';
            html += `
                <div class="member-item">
                    <div class="member-avatar">${inicial}</div>
                    <div class="member-info">
                        <div class="member-name">${rolBadge} ${miembro.username}</div>
                        <div class="member-role">${miembro.rol}</div>
                    </div>
                    <div class="status-indicator"></div>
                </div>
            `;
        });

        container.innerHTML = html;
    }

    /**
     * Actualizar timestamp
     */
    updateTimestamp() {
        const now = new Date();
        const timeStr = now.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
        document.getElementById('last-update-time').textContent = timeStr;
    }

    /**
     * Actualizar badge de notificaciones
     */
    updateBadge(count) {
        const badge = document.querySelector('.notification-badge');
        if (count > 0) {
            badge.textContent = count > 99 ? '99+' : count;
            badge.style.display = 'flex';
        } else {
            badge.style.display = 'none';
        }
    }

    /**
     * Mostrar error
     */
    showError() {
        document.getElementById('tab-cambios').innerHTML = `
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle"></i>
                <p>Error al cargar notificaciones</p>
            </div>
        `;
    }

    /**
     * Iniciar actualización automática
     */
    startAutoUpdate() {
        this.intervalId = setInterval(() => {
            this.loadNotifications();
        }, this.updateInterval);
    }

    /**
     * Detener actualización automática
     */
    stopAutoUpdate() {
        if (this.intervalId) {
            clearInterval(this.intervalId);
        }
    }
}

// Inicializar al cargar la página
document.addEventListener('DOMContentLoaded', function() {
    // Solo inicializar si estamos en modo colaborativo
    const grupoActual = document.querySelector('[data-grupo-id]');
    if (grupoActual) {
        const notificationSystem = new NotificationSystem();
        notificationSystem.init();
        
        // Hacer disponible globalmente
        window.notificationSystem = notificationSystem;
    }
});
