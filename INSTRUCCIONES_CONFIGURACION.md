# 🔧 Instrucciones para Configurar la Base de Datos

## Problema Identificado
La funcionalidad de crear grupos no funciona porque la base de datos no está configurada correctamente.

## ✅ Soluciones ya implementadas:
1. ✅ Driver MySQL agregado (`mysql-connector-j-9.0.0.jar`)
2. ✅ Carpeta `WEB-INF/lib` creada
3. ✅ Código JSP verificado y correcto

## 🚀 Pasos para solucionar el problema:

### 1. Configurar MySQL
Asegúrate de que MySQL esté ejecutándose en tu sistema:
- **Puerto**: 3306 (por defecto)
- **Usuario**: root
- **Contraseña**: (vacía por defecto, o la que hayas configurado)

### 2. Crear la base de datos
Ejecuta el script `database_script.sql` en tu cliente MySQL (HeidiSQL, phpMyAdmin, etc.):

```sql
-- El script ya está en: database_script.sql
-- Contiene:
-- - Creación de base de datos 'sistema_peti'
-- - Tablas: usuarios, grupos, miembros_grupo
-- - Datos de prueba
-- - Procedimientos almacenados
```

### 3. Verificar configuración de conexión
En el archivo `src/java/conexion/conexion.java`:
```java
private static final String SERVIDOR = "localhost";
private static final String PUERTO = "3306";
private static final String BASE_DATOS = "sistema_peti";
private static final String USUARIO = "root";
private static final String PASSWORD = ""; // Cambia si tienes contraseña
```

### 4. Probar la conexión
Ejecuta desde NetBeans o línea de comandos:
```bash
java -cp "web/WEB-INF/lib/*:src/java" conexion.conexion
```

### 5. Usuarios de prueba disponibles:
- **Usuario**: admin, **Contraseña**: 123
- **Usuario**: test, **Contraseña**: test
- **Usuario**: demo, **Contraseña**: demo

## 🔍 Diagnóstico de errores comunes:

### Error: "error_base_datos"
- Verificar que MySQL esté ejecutándose
- Verificar credenciales de conexión
- Verificar que la base de datos 'sistema_peti' exista

### Error: "campos_vacios"
- Completar todos los campos del formulario
- Nombre del grupo no puede estar vacío

### Error: "nombre_grupo_existe"
- Usar un nombre de grupo diferente

### Error: "ya_tiene_grupo"
- El usuario ya pertenece a un grupo
- Salir del grupo actual primero

## 📝 Notas importantes:
1. El driver MySQL ya está incluido en `web/WEB-INF/lib/`
2. La aplicación usa conexiones directas JDBC
3. Las contraseñas están en texto plano (solo para desarrollo)
4. El código de grupo se genera automáticamente (6 caracteres)

## 🎯 Siguiente paso:
**Ejecutar el script `database_script.sql` en tu cliente MySQL**