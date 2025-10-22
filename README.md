# 📘 Examen Práctico Unidad II - Sistema PETI Colaborativo

## 👤 Información del Estudiante
- **Nombre del Alumno:** [DIEGO FERNANDO CASTILLO MAMANI]
- **Curso:** PLANEAMIENTO ESTRATÉGICO DE TI
- **Fecha:** 22 de Octubre de 2025
- **Repositorio GitHub:** https://github.com/diegocastillo12/PE_II_EXAMEN_PRACTICO

---

## 📋 Descripción del Proyecto

**Sistema PETI (Plan Estratégico de Tecnologías de Información)** es una aplicación web colaborativa desarrollada en **Java EE** con arquitectura de **3 capas** que permite a equipos de trabajo crear, gestionar y colaborar en la elaboración de planes estratégicos empresariales de manera sincronizada y en tiempo real.

### 🎯 Objetivo del Sistema
Facilitar la creación colaborativa de planes estratégicos empresariales mediante una plataforma web que permita:
- Trabajo en equipo sincronizado
- Gestión de múltiples grupos
- Seguimiento de progreso en tiempo real
- Historial de cambios colaborativos

---

## 🏗️ Arquitectura del Sistema - 3 Capas

### **1. Capa de Datos (Conexión)**
📁 `src/java/conexion/conexion.java`
- Gestión de conexión a base de datos MySQL/MariaDB
- Pool de conexiones
- Configuración centralizada

### **2. Capa de Entidad (Modelo de Datos)**
📁 `src/java/entidad/`
- `ClsELogin.java` - Entidad de Usuarios
- `ClsEGrupo.java` - Entidad de Grupos
- `ClsEPeti.java` - Entidad de Datos PETI
- Encapsulamiento de atributos
- Validaciones de datos

### **3. Capa de Negocio (Lógica de Negocio)**
📁 `src/java/negocio/`
- `ClsNLogin.java` - Gestión de autenticación y usuarios
- `ClsNGrupo.java` - Gestión de grupos colaborativos
- `ClsNPeti.java` - Gestión de datos del PETI
- Lógica de negocio y operaciones CRUD
- Procedimientos almacenados

### **4. Capa de Presentación (Vista)**
📁 `web/`
- **JSP** - Interfaz de usuario dinámica
- **JavaScript** - Interactividad y AJAX
- **CSS** - Diseño responsivo moderno
- **Bootstrap/Font Awesome** - Componentes UI

---

## 🗄️ Base de Datos

### Tablas Principales:
1. **usuarios** - Registro de usuarios del sistema
2. **grupos** - Grupos colaborativos
3. **miembros_grupo** - Relación usuarios-grupos
4. **peti_datos** - Datos del plan estratégico por grupo
5. **peti_historial** - Historial de cambios colaborativos

### Procedimientos Almacenados:
- `CrearGrupo` - Creación automática de grupos con admin

---

## ✨ Funcionalidades Principales

### 🔐 **Sistema de Autenticación**
- Registro de nuevos usuarios
- Login con validación de credenciales
- Gestión de sesiones
- Control de acceso por roles

### 👥 **Gestión de Grupos Colaborativos**
- Crear nuevos grupos de trabajo
- Unirse a grupos existentes mediante código
- Roles: Administrador y Miembro
- Múltiples grupos por usuario

### 📊 **Dashboard Interactivo**
- Estadísticas en tiempo real
- Progreso visual del PETI
- Gráficos con Chart.js
- Métricas de colaboración

### 📝 **Módulos del PETI**
1. **Información Empresarial** - Datos básicos
2. **Misión y Visión** - Declaraciones estratégicas
3. **Valores Corporativos** - Principios organizacionales
4. **Objetivos Estratégicos** - Metas e indicadores
5. **Análisis Externo** - Oportunidades y amenazas
6. **Análisis PEST** - Factores del entorno
7. **5 Fuerzas de Porter** - Competitividad
8. **Matriz CAME** - Estrategias correctivas
9. **Cadena de Valor** - Procesos empresariales
10. **Matriz BCG** - Portafolio de productos

### 💾 **Auto-guardado**
- Guardado automático cada 30 segundos
- Sincronización en tiempo real
- Prevención de pérdida de datos

---

## 🚀 MEJORAS IMPLEMENTADAS

### ⭐ **MEJORA 1: Sistema de Notificaciones en Tiempo Real**

#### 📸 Capturas de Pantalla:
![Notificaciones en Tiempo Real](docs/screenshots/mejora1_notificaciones.png)

#### 📝 Descripción:
Sistema completo de notificaciones que permite a los usuarios ver la actividad del grupo en tiempo real sin necesidad de recargar la página.

#### 🔧 Características Técnicas:
- **Panel flotante de notificaciones** con diseño moderno
- **Actualización automática** cada 30 segundos mediante AJAX
- **Indicador de usuarios activos** del grupo
- **Historial de cambios recientes** con timestamps
- **Badges visuales** con contador de notificaciones
- **Animaciones CSS** para mejor UX

#### 📂 Archivos Implementados:
```
web/peti/api/obtenerNotificaciones.jsp  - API REST para obtener notificaciones
web/peti/js/notifications.js            - Lógica del sistema de notificaciones
src/java/negocio/ClsNPeti.java          - Método obtenerCambiosRecientes()
web/peti/dashboard.jsp                  - Integración en el dashboard
```

#### 💻 Tecnologías Utilizadas:
- **JSP** para API REST
- **JavaScript puro** (sin librerías externas)
- **AJAX** con Fetch API
- **CSS3** con animaciones
- **JSON** construcción manual sin librerías

#### ⚡ Funcionalidades:
1. **Tab de Cambios Recientes:**
   - Muestra las últimas 10 modificaciones
   - Indica usuario, sección y fecha/hora
   - Diferencia entre cambios nuevos y antiguos

2. **Tab de Miembros Activos:**
   - Lista todos los miembros del grupo
   - Muestra roles (Admin/Miembro)
   - Indicador visual de estado activo
   - Avatares con iniciales

3. **Actualización Automática:**
   - Polling cada 30 segundos
   - Timestamp de última actualización
   - Botón de actualización manual

4. **UI/UX:**
   - Diseño moderno con gradientes
   - Iconos Font Awesome
   - Animaciones suaves
   - Responsive design
   - Badge con contador pulsante

---

### ⭐ **MEJORA 2: Sistema de Respaldo y Restauración de Datos**

#### 📸 Capturas de Pantalla:
![Sistema de Respaldo](docs/screenshots/mejora2_respaldo_exportar.png)
![Sistema de Restauración](docs/screenshots/mejora2_respaldo_restaurar.png)

#### 📝 Descripción:
Sistema completo de backup y restore que permite a los administradores exportar e importar todos los datos del PETI en formato JSON, facilitando respaldos de seguridad y migración de datos.

#### 🔧 Características Técnicas:
- **Exportación a JSON** sin librerías externas
- **Construcción manual de JSON** desde Java
- **Parser JSON personalizado** sin dependencias
- **Validación de formato** de archivos
- **Control de permisos** (solo administradores)
- **Interfaz con loader** y feedback visual

#### 📂 Archivos Implementados:
```
web/peti/api/exportarRespaldo.jsp     - API para exportar datos a JSON
web/peti/api/restaurarRespaldo.jsp    - API para importar datos desde JSON
web/peti/dashboard.jsp                - Botones y funciones de respaldo
src/java/negocio/ClsNPeti.java        - Métodos de obtención de datos
```

#### 💻 Tecnologías Utilizadas:
- **JSP** para generación de JSON
- **Java** sin librerías externas
- **JavaScript** para upload de archivos
- **FileReader API** del navegador
- **Construcción manual de JSON** (sin org.json)

#### ⚡ Funcionalidades:

1. **Exportar Respaldo:**
   - Botón "Exportar Respaldo" en el dashboard
   - Genera archivo JSON con todos los datos del grupo
   - Incluye metadata (fecha, usuario, versión)
   - Nombre del archivo automático: `PETI_Respaldo_GrupoX_YYYYMMDD_HHMMSS.json`
   - Descarga automática
   - Loader visual durante el proceso

2. **Restaurar Respaldo:**
   - Botón "Restaurar" con selector de archivos
   - Validación de formato JSON
   - Confirmación de sobrescritura
   - Parser JSON manual sin librerías
   - Actualización masiva en base de datos
   - Feedback de registros restaurados
   - Recarga automática al completar

3. **Seguridad:**
   - Solo usuarios con rol "admin" pueden exportar/restaurar
   - Validación de permisos en backend
   - Escape de caracteres en JSON
   - Manejo de errores robusto

4. **Formato del Respaldo:**
```json
{
  "success": true,
  "grupoId": 7,
  "fechaExportacion": "2025-10-22 14:30:45",
  "usuarioExportacion": "admin",
  "version": "1.0",
  "datos": {
    "empresa": {
      "nombre": "Mi Empresa",
      "sector": "Tecnología",
      "ubicacion": "Lima, Perú",
      "descripcion": "Descripción de la empresa..."
    },
    "mision": {
      "declaracion": "Nuestra misión es..."
    },
    "vision": {
      "declaracion": "Nuestra visión es..."
    }
    // ... más secciones
  }
}
```

5. **UI/UX:**
   - Botones con iconos diferenciados (verde para exportar, naranja para restaurar)
   - Loader de pantalla completa durante restauración
   - Notificaciones de éxito/error
   - Animaciones suaves
   - Responsive design

---



## 🛠️ Tecnologías Utilizadas

### Backend:
- **Java 8+** - Lenguaje de programación
- **JSP (JavaServer Pages)** - Vista dinámica
- **MySQL/MariaDB 10.4** - Base de datos
- **Apache Tomcat** - Servidor de aplicaciones
- **JDBC** - Conectividad de base de datos

### Frontend:
- **HTML5** - Estructura
- **CSS3** - Estilos y animaciones
- **JavaScript ES6** - Interactividad
- **Font Awesome 6.4** - Iconos
- **Chart.js 4.4** - Gráficos estadísticos
- **AJAX/Fetch API** - Comunicación asíncrona

### Herramientas de Desarrollo:
- **NetBeans IDE** - Desarrollo
- **Git** - Control de versiones
- **GitHub** - Repositorio remoto
- **HeidiSQL** - Gestión de base de datos

---

## 📦 Instalación y Configuración

### Requisitos Previos:
- Java JDK 8 o superior
- Apache Tomcat 9.0+
- MySQL/MariaDB 10.4+
- NetBeans IDE (recomendado)

### Pasos de Instalación:

1. **Clonar el repositorio:**
```bash
git clone https://github.com/diegocastillo12/PE_II_EXAMEN_PRACTICO.git
```

2. **Configurar la base de datos:**
```bash
# Importar el script SQL
mysql -u root -p < database_script.sql

# O desde HeidiSQL, ejecutar:
database_script.sql
```

3. **Configurar la conexión:**
Editar `src/java/conexion/conexion.java`:
```java
private static final String SERVIDOR = "localhost";
private static final String PUERTO = "3306";
private static final String BASE_DATOS = "sistema_peti";
private static final String USUARIO = "root";
private static final String PASSWORD = "";
```

4. **Copiar librería MySQL Connector:**
Copiar `mysql-connector-java-8.0.x.jar` a `web/WEB-INF/lib/`

5. **Compilar y desplegar:**
- Abrir el proyecto en NetBeans
- Click derecho → Clean and Build
- Click derecho → Run

6. **Acceder al sistema:**
```
http://localhost:8080/proyecto/
`

