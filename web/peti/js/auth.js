// Datos estáticos de usuarios
const users = [
    {
        id: 1,
        nombre: 'Diego Castillo',
        email: 'diego@upt.pe',
        password: '123456'
    },
    {
        id: 2,
        nombre: 'Andy Calizaya',
        email: 'andy@upt.pe',
        password: 'andy123'
    },
    {
        id: 3,
        nombre: 'Admin',
        email: 'admin@ejemplo.com',
        password: 'admin123'
    }
];

// Función para manejar el inicio de sesión
document.addEventListener('DOMContentLoaded', function() {
    // Formulario de login
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const messageDiv = document.getElementById('loginMessage');
            
            // Buscar usuario
            const user = users.find(u => u.email === email && u.password === password);
            
            if (user) {
                // Login exitoso
                messageDiv.textContent = 'Inicio de sesión exitoso. Redirigiendo...';
                messageDiv.className = 'message success';
                messageDiv.style.display = 'block';
                
                // Guardar información del usuario en sessionStorage
                sessionStorage.setItem('currentUser', JSON.stringify({
                    id: user.id,
                    nombre: user.nombre,
                    email: user.email
                }));
                
                // Redirigir al dashboard después de 1 segundo
                setTimeout(() => {
                    window.location.href = 'dashboard.jsp';
                }, 1000);
            } else {
                // Login fallido
                messageDiv.textContent = 'Correo electrónico o contraseña incorrectos';
                messageDiv.className = 'message error';
                messageDiv.style.display = 'block';
            }
        });
    }
    
    // Formulario de registro
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const nombre = document.getElementById('nombre').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm-password').value;
            const messageDiv = document.getElementById('registerMessage');
            
            // Validar que las contraseñas coincidan
            if (password !== confirmPassword) {
                messageDiv.textContent = 'Las contraseñas no coinciden';
                messageDiv.className = 'message error';
                messageDiv.style.display = 'block';
                return;
            }
            
            // Verificar si el correo ya está registrado
            if (users.some(u => u.email === email)) {
                messageDiv.textContent = 'Este correo electrónico ya está registrado';
                messageDiv.className = 'message error';
                messageDiv.style.display = 'block';
                return;
            }
            
            // En un caso real, aquí se enviaría la información al servidor
            // Como estamos usando datos estáticos, simulamos un registro exitoso
            messageDiv.textContent = 'Registro exitoso. Redirigiendo al login...';
            messageDiv.className = 'message success';
            messageDiv.style.display = 'block';
            
            // Redirigir al login después de 2 segundos
            setTimeout(() => {
                window.location.href = '/proyecto_peti/index.jsp';
            }, 2000);
        });
    }
    
    // Para páginas JSP, NO verificar autenticación en JavaScript
    // La autenticación se maneja completamente del lado del servidor
    const dashboardContainer = document.querySelector('.dashboard-container');
    if (dashboardContainer) {
        // Solo mostrar información del usuario si existe en sessionStorage
        const currentUser = JSON.parse(sessionStorage.getItem('currentUser'));
        
        if (currentUser) {
            // Mostrar información del usuario
            const userNameElement = document.getElementById('userName');
            const userEmailElement = document.getElementById('userEmail');
            const userInitialsElement = document.getElementById('userInitials');
            
            if (userNameElement) userNameElement.textContent = currentUser.nombre;
            if (userEmailElement) userEmailElement.textContent = currentUser.email;
            if (userInitialsElement) userInitialsElement.textContent = currentUser.nombre.charAt(0);
        }
        
        // Manejar cierre de sesión
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', function() {
                sessionStorage.removeItem('currentUser');
                window.location.href = '/proyecto_peti/index.jsp';
            });
        }
    }
});