# 📸 Guía para Capturas de Pantalla

Para completar el README.md, necesitas tomar las siguientes capturas de pantalla del sistema en funcionamiento:

## Capturas Requeridas:

### 1. **login.png**
- Página de inicio de sesión
- URL: `http://localhost:8080/proyecto/`

### 2. **menu_principal.png**
- Menú principal con opciones de grupos
- Después de hacer login exitoso

### 3. **dashboard.png**
- Dashboard principal con estadísticas y gráficos
- URL: `http://localhost:8080/proyecto/peti/dashboard.jsp`

### 4. **mision_vision.png**
- Módulo de Misión y Visión colaborativo
- URL: `http://localhost:8080/proyecto/peti/mision_colaborativo.jsp`

### 5. MEJORA 1: Sistema de Notificaciones
#### **mejora1_notificaciones.png**
- Panel de notificaciones abierto mostrando cambios recientes
- Click en el ícono de campana flotante en el dashboard

#### **mejora1_panel_notificaciones.png**
- Vista completa del panel con tabs de "Cambios Recientes" y "Miembros Activos"

### 6. MEJORA 2: Sistema de Respaldo
#### **mejora2_respaldo_exportar.png**
- Dashboard con los botones "Exportar Respaldo" y "Restaurar" visibles (usuario admin)

#### **mejora2_exportar.png**
- Proceso de exportación con el loader visible y archivo descargado

#### **mejora2_restaurar.png**
- Proceso de restauración mostrando el diálogo de confirmación o loader

## Instrucciones para Tomar las Capturas:

1. **Ejecutar el proyecto:**
   ```
   - Abrir NetBeans
   - Click derecho en el proyecto → Run
   ```

2. **Crear datos de prueba:**
   - Registrar al menos 2 usuarios
   - Crear un grupo con uno de ellos (será admin)
   - Unir el otro usuario al grupo
   - Completar algunas secciones del PETI (misión, visión, etc.)

3. **Tomar capturas:**
   - Usar `Recortes de Windows` (Windows + Shift + S)
   - O `Snipping Tool`
   - Guardar en formato PNG
   - Nombres exactos como se indican arriba

4. **Ubicación:**
   Guardar todas las capturas en:
   ```
   proyecto/docs/screenshots/
   ```

5. **Tamaño recomendado:**
   - Resolución: 1920x1080 o 1366x768
   - Formato: PNG
   - Calidad: Alta

## Recomendaciones Visuales:

- ✅ Asegúrate que se vean los datos claramente
- ✅ Captura pantalla completa o ventana del navegador
- ✅ Usa navegador en modo ventana (no modo incógnito)
- ✅ Para las mejoras, destaca los elementos nuevos
- ✅ En las notificaciones, asegúrate que haya datos para mostrar
- ✅ Para el respaldo, muestra el archivo JSON descargado

## Archivos a Generar:

```
docs/screenshots/
├── login.png
├── menu_principal.png
├── dashboard.png
├── mision_vision.png
├── mejora1_notificaciones.png
├── mejora1_panel_notificaciones.png
├── mejora2_respaldo_exportar.png
├── mejora2_exportar.png
└── mejora2_restaurar.png
```

Una vez tengas todas las capturas guardadas, haz commit y push:

```bash
git add docs/screenshots/
git commit -m "Agregar capturas de pantalla del sistema y mejoras"
git push origin main
```

## Alternativa si No Puedes Ejecutar el Sistema:

Si por alguna razón no puedes ejecutar el sistema para tomar capturas, puedes:

1. Usar placeholders temporales
2. Crear mockups con herramientas como Figma
3. Usar capturas de diseño del código en el editor

Pero lo ideal es tomar capturas del sistema real en ejecución.
