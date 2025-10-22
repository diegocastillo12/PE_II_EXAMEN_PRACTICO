-- Usuarios de prueba para el sistema PETI
-- Ejecutar después de crear las tablas

USE sistema_peti;

-- Insertar usuarios de prueba
INSERT INTO usuarios (username, password, email) VALUES
('admin', '123', 'admin@test.com'),
('usuario1', 'pass1', 'usuario1@test.com'),
('usuario2', 'pass2', 'usuario2@test.com'),
('test', 'test', 'test@test.com'),
('demo', 'demo', 'demo@test.com'),
('xddd', 'xddd', 'xddd@test.com');

-- Verificar que se insertaron correctamente
SELECT * FROM usuarios;

-- Crear un grupo de ejemplo (opcional)
INSERT INTO grupos (nombre, codigo, limite_usuarios, admin_id) VALUES
('Grupo Demo', 'ABC123', 5, 1);

-- Agregar el admin al grupo (opcional)
INSERT INTO miembros_grupo (usuario_id, grupo_id, rol) VALUES
(1, 1, 'admin');

-- Mostrar información de verificación
SELECT 'Usuarios creados exitosamente' as mensaje;
SELECT COUNT(*) as total_usuarios FROM usuarios;