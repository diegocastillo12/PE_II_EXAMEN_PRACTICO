# Sistema PETI Colaborativo - Funcionalidades Implementadas

## 🚀 Características Principales

### 1. **Modo Colaborativo vs Individual**
- **Modo Colaborativo**: Usuarios que pertenecen a un grupo pueden editar y guardar datos del PETI en tiempo real
- **Modo Individual**: Usuarios sin grupo pueden explorar las funcionalidades pero no guardar cambios
- Acceso diferenciado desde el menú principal según el estado del usuario

### 2. **Sistema de Grupos**
- Los usuarios pueden crear grupos o unirse a grupos existentes usando códigos
- Roles de administrador y miembro
- Sistema de permisos para edición colaborativa

### 3. **Base de Datos Actualizada**
Se agregaron nuevas tablas:
- `peti_datos`: Almacena todos los datos del PETI por grupo
- `peti_historial`: Mantiene un historial de cambios con autor y timestamp

### 4. **Funcionalidades de Colaboración**

#### En el Dashboard:
- **Progreso visual** del PETI por grupo
- **Indicadores de actividad** en tiempo real
- **Historial de cambios** recientes
- **Estadísticas del grupo** (miembros, cambios, etc.)

#### En las páginas de edición (ej: Misión):
- **Auto-guardado** cada 30 segundos
- **Indicadores visuales** de modo colaborativo
- **Notificaciones** de éxito/error al guardar
- **Vista previa en tiempo real**
- **Historial de sección** específica
- **Datos persistentes** del grupo

### 5. **Interfaz Adaptativa**
- **Alertas contextuales** según el modo
- **Botones dinámicos** (habilitados/deshabilitados según permisos)
- **Información del grupo** en headers
- **Indicadores de estado** (admin/miembro)

## 🛠️ Arquitectura Técnica

### Backend (Java - 3 Capas):
1. **Conexión**: `conexion.java` - Manejo de DB
2. **Entidad**: `ClsEPeti.java` - Modelo de datos PETI
3. **Negocio**: `ClsNPeti.java` - Lógica de negocio colaborativa

### Frontend (JSP + JavaScript):
- **Dashboard colaborativo** con información en tiempo real
- **Páginas de edición** adaptadas para colaboración
- **APIs REST** para guardar/obtener datos (`guardarDato.jsp`, `checkUpdates.jsp`)

### Base de Datos:
- **Tablas nuevas** para datos PETI y historial
- **Relaciones** con sistema de usuarios y grupos existente
- **Índices optimizados** para consultas colaborativas

## 📋 Cómo Probar el Sistema

### 1. **Configurar Base de Datos**
```sql
-- Ejecutar el script database_script.sql actualizado en HeidiSQL
-- Esto creará las nuevas tablas: peti_datos y peti_historial
```

### 2. **Probar Modo Individual**
1. Iniciar sesión sin unirse a un grupo
2. Hacer clic en "🚀 Explorar Sistema PETI (Modo Individual)"
3. Navegar por las secciones (solo lectura)

### 3. **Probar Modo Colaborativo**
1. Crear un grupo desde el menú principal
2. Hacer clic en "🚀 Acceder al Sistema PETI (Modo Colaborativo)"
3. Editar secciones como Misión/Visión
4. Ver el progreso y historial en el dashboard

### 4. **Probar Colaboración Multi-Usuario**
1. Crear una cuenta adicional
2. Unirse al grupo usando el código generado
3. Ambos usuarios pueden editar simultáneamente
4. Ver cambios reflejados en tiempo real

## 🔧 Funcionalidades Avanzadas

### Auto-actualización:
- Verificación automática de cambios cada 30 segundos
- Notificaciones cuando otros usuarios hacen cambios

### Historial Completo:
- Tracking de todos los cambios con usuario y timestamp
- Posibilidad de ver evolución de cada sección

### Permisos Granulares:
- Solo miembros del grupo pueden editar
- Verificación de permisos en cada operación

### Datos Persistentes:
- Todos los datos se guardan por grupo
- Recuperación automática al ingresar al sistema

## 🚦 Estados del Sistema

### Usuario sin Grupo:
- ✅ Puede explorar en modo individual
- ❌ No puede guardar cambios
- 🔗 Puede crear/unirse a grupos

### Usuario con Grupo (Miembro):
- ✅ Puede editar y guardar
- ✅ Ve cambios de otros miembros
- ✅ Acceso completo al PETI colaborativo

### Usuario con Grupo (Admin):
- ✅ Todas las funciones de miembro
- ✅ Puede gestionar miembros
- ✅ Puede generar códigos nuevos
- 👑 Indicador visual de admin

## 📁 Archivos Modificados/Creados

### Nuevos Archivos:
- `src/java/entidad/ClsEPeti.java`
- `src/java/negocio/ClsNPeti.java`
- `web/peti/api/guardarDato.jsp`
- `web/peti/api/checkUpdates.jsp`

### Archivos Modificados:
- `database_script.sql` - Nuevas tablas
- `web/menuprincipal.jsp` - Enlaces colaborativos
- `web/peti/dashboard.jsp` - Dashboard colaborativo
- `web/peti/mision.jsp` - Ejemplo de página colaborativa
- `web/validarLogin.jsp` - Manejo de sesión mejorado

¡El sistema está listo para probar la funcionalidad colaborativa! Los usuarios pueden trabajar en equipo editando el PETI en tiempo real.