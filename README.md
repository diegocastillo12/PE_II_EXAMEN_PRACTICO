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

### ⭐ **MEJORA 1: Dashboard Estadístico en Tiempo Real**

#### 📸 Capturas de Pantalla:
<img width="1595" height="447" alt="image" src="https://github.com/user-attachments/assets/7b5564ef-0a7d-4827-9da7-a459bb257f49" />


#### 📝 Descripción:
Sistema completo de dashboard con métricas estadísticas y gráficos interactivos que permite visualizar el progreso del PETI, actividad del equipo y rendimiento colaborativo en tiempo real.

#### 🔧 Características Técnicas:
- **8 tarjetas estadísticas animadas** con datos en tiempo real
- **2 gráficos interactivos** con Chart.js (barras y líneas)
- **Actualización automática** cada 30 segundos
- **Cálculo dinámico** de métricas desde base de datos
- **Diseño responsivo** con animaciones CSS3
- **Indicadores visuales** con colores y tendencias

#### 📊 Métricas Implementadas:
1. **Progreso PETI** - Porcentaje de completitud con barra de progreso
2. **Miembros Activos** - Cantidad de colaboradores del equipo
3. **Cambios Hoy** - Modificaciones realizadas en el día actual
4. **Cambios Esta Semana** - Actividad de los últimos 7 días
5. **Secciones Completadas** - Contador de secciones finalizadas (de 9 totales)
6. **Sección Más Editada** - Área con mayor actividad
7. **Usuario Más Activo** - Colaborador con más contribuciones
8. **Última Actividad** - Timestamp de la modificación más reciente

#### � Gráficos Interactivos:
1. **Progreso por Sección (Gráfico de Barras):**
   - 9 secciones del PETI visualizadas
   - Código de colores por sección
   - Porcentaje de completitud
   - Animación al cargar

2. **Actividad de la Semana (Gráfico de Líneas):**
   - Cambios por día de los últimos 7 días
   - Vista de tendencia temporal
   - Área sombreada bajo la curva
   - Interactividad al hacer hover

#### 📂 Archivos Implementados:
```
web/peti/dashboard.jsp                  - Dashboard completo con tarjetas y gráficos
src/java/negocio/ClsNPeti.java          - Métodos de cálculo de estadísticas
web/peti/dashboard.css                  - Estilos modernos y animaciones
```

#### 💻 Tecnologías Utilizadas:
- **JSP** con scriptlets para cálculo dinámico
- **Chart.js 4.4** para gráficos interactivos
- **JavaScript ES6** para actualización automática
- **CSS3** con animaciones y gradientes
- **Font Awesome 6.4** para iconos
- **Java** para lógica de negocio en backend

#### ⚡ Funcionalidades:
1. **Tarjetas Animadas:**
   - Efecto fadeInUp escalonado
   - Hover con elevación
   - Iconos temáticos por métrica
   - Valores en tiempo real

2. **Historial de Actividad:**
   - Feed de cambios recientes (últimos 10)
   - Avatar de usuario con iniciales
   - Previsualización de contenido
   - Timestamps relativos
   - Botón para ver historial completo

3. **Auto-actualización:**
   - Verificación de cambios cada 30 segundos
   - Recarga inteligente solo si hay modificaciones
   - Sin interrumpir la experiencia del usuario

4. **UI/UX Premium:**
   - Diseño moderno tipo neumorfismo
   - Paleta de colores profesional
   - Transiciones suaves
   - 100% responsive
   - Degradados sutiles

---

### ⭐ **MEJORA 2: Feed de Actividad Reciente del Grupo**

#### 📸 Capturas de Pantalla:
<img width="1571" height="426" alt="image" src="https://github.com/user-attachments/assets/33b9dad2-980a-4863-a964-9f393376193c" />


#### 📝 Descripción:
Sistema de feed de actividad en tiempo real que muestra un historial detallado de todas las modificaciones realizadas por los miembros del grupo, permitiendo un seguimiento completo de los cambios en el PETI con acceso al historial completo.

#### 🔧 Características Técnicas:
- **Feed en tiempo real** de las últimas 10 actividades
- **Avatares personalizados** con iniciales de usuarios
- **Previsualización de contenido** modificado
- **Timestamps precisos** de cada cambio
- **Iconos contextuales** según el tipo de acción
- **Botón de acceso al historial completo** integrado

#### 📂 Archivos Implementados:
```
web/peti/dashboard.jsp                  - Sección de actividad reciente
web/peti/historial_cambios.jsp         - Vista completa del historial
src/java/negocio/ClsNPeti.java          - Método obtenerHistorial()
web/peti/dashboard.css                  - Estilos del feed de actividad
```

#### 💻 Tecnologías Utilizadas:
- **JSP** con JSTL para renderizado dinámico
- **Java** para consultas a base de datos
- **JavaScript** para actualización automática
- **CSS3** con efectos hover y transiciones
- **Font Awesome** para iconografía
- **MySQL** con tabla peti_historial

#### ⚡ Funcionalidades:

1. **Feed de Actividad:**
   - Muestra las últimas 10 modificaciones del grupo
   - Cada elemento incluye:
     * Avatar circular con iniciales del usuario
     * Nombre del usuario que realizó el cambio
     * Acción realizada (modificó, agregó, eliminó)
     * Campo específico modificado
     * Sección del PETI afectada
     * Vista previa del contenido nuevo (truncado)
     * Timestamp con fecha y hora exacta

2. **Indicadores Visuales:**
   - Avatar con color distintivo por usuario
   - Iconos según el tipo de cambio (edición, adición, eliminación)
   - Hover effect con elevación de tarjeta
   - Colores por sección del PETI
   - Timestamp formateado (DD/MM/YYYY HH:MM)

3. **Interactividad:**
   - Botón "Ver Historial Completo" para acceder a todos los cambios
   - Actualización automática cada 30 segundos
   - Smooth scroll en el contenedor
   - Click en cada item para ver detalle (opcional)

4. **Historial Completo:**
   - Página dedicada (`historial_cambios.jsp`)
   - Todos los cambios sin límite
   - Filtros por usuario, sección y fecha
   - Búsqueda de cambios específicos
   - Exportación de historial

5. **UI/UX:**
   - Diseño tipo timeline moderno
   - Estado vacío con mensaje amigable
   - Animaciones de carga
   - Responsive para móviles
   - Scroll suave en lista larga

#### 🎯 Beneficios:
- **Transparencia total** de cambios en el equipo
- **Trazabilidad completa** de modificaciones
- **Auditoría de actividad** colaborativa
- **Detección de conflictos** entre usuarios
- **Seguimiento de progreso** en tiempo real

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

