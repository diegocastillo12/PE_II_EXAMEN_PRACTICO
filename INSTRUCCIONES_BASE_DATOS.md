# Instrucciones para crear la base de datos

## Problema actual
El error "Error de conexión con la base de datos" indica que la base de datos `sistema_peti` no existe o no se puede conectar.

## Solución

### Opción 1: Usar HeidiSQL (Recomendado)
1. Abre HeidiSQL
2. Conecta a tu servidor MySQL local (localhost:3306)
3. Usuario: `root`, Contraseña: (la que tengas configurada, puede estar vacía)
4. Una vez conectado, ve a "Archivo" → "Ejecutar archivo SQL"
5. Selecciona el archivo `database_script.sql` de este proyecto
6. Ejecuta el script completo

### Opción 2: Usar phpMyAdmin
1. Abre phpMyAdmin en tu navegador (http://localhost/phpmyadmin)
2. Ve a la pestaña "SQL"
3. Copia y pega todo el contenido del archivo `database_script.sql`
4. Haz clic en "Continuar" para ejecutar

### Opción 3: Línea de comandos (si tienes MySQL instalado)
```bash
mysql -u root -p < database_script.sql
```

## Verificación
Después de ejecutar el script, deberías ver:
- Base de datos `sistema_peti` creada
- 3 tablas: `usuarios`, `grupos`, `miembros_grupo`
- Datos de prueba insertados
- 2 vistas creadas
- 2 procedimientos almacenados

## Configuración actual del proyecto
La clase `conexion.java` está configurada para:
- Servidor: localhost:3306
- Base de datos: sistema_peti
- Usuario: root
- Contraseña: (vacía)

Si tu configuración de MySQL es diferente, modifica estos valores en:
`src/java/conexion/conexion.java`

## Usuarios de prueba incluidos
- admin / 123
- usuario1 / pass1
- usuario2 / pass2
- test / test
- demo / demo

## Próximos pasos
1. Ejecuta el script SQL
2. Reinicia tu servidor de aplicaciones (Tomcat)
3. Prueba el registro de usuarios
4. Verifica que la conexión funcione correctamente