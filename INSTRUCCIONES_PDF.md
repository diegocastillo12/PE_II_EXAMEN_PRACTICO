# 📄 Cómo Convertir README.md a PDF

## Opción 1: Usando Visual Studio Code (Recomendado)

### Requisitos:
- Visual Studio Code instalado
- Extensión "Markdown PDF" de yzane

### Pasos:
1. Abrir VS Code
2. Instalar extensión:
   - Ir a Extensions (Ctrl + Shift + X)
   - Buscar "Markdown PDF"
   - Instalar la de "yzane"

3. Abrir el archivo README.md

4. Convertir a PDF:
   - Presionar `Ctrl + Shift + P`
   - Escribir "Markdown PDF: Export (pdf)"
   - Presionar Enter
   - El PDF se guardará en la misma carpeta

---

## Opción 2: Usando GitHub (Más Fácil)

### Pasos:
1. Abrir el repositorio en GitHub:
   ```
   https://github.com/diegocastillo12/PE_II_EXAMEN_PRACTICO
   ```

2. Click en el archivo README.md

3. Copiar todo el contenido del README

4. Ir a cualquiera de estos sitios:
   - https://www.markdowntopdf.com/
   - https://md2pdf.netlify.app/
   - https://www.browserling.com/tools/markdown-to-pdf

5. Pegar el contenido del README

6. Click en "Convert" o "Generate PDF"

7. Descargar el PDF generado

8. Renombrar el archivo como:
   ```
   EXAMEN_UNIDAD_II_PETI_TU_NOMBRE.pdf
   ```

---

## Opción 3: Usando Navegador (Chrome/Edge)

### Pasos:
1. Abrir el README.md en GitHub:
   ```
   https://github.com/diegocastillo12/PE_II_EXAMEN_PRACTICO/blob/main/README.md
   ```

2. GitHub renderiza el Markdown automáticamente

3. Presionar `Ctrl + P` (Imprimir)

4. En "Destino", seleccionar "Guardar como PDF"

5. Configurar:
   - Diseño: Vertical
   - Márgenes: Normal
   - Opciones: Marcar "Gráficos de fondo"

6. Click en "Guardar"

7. Elegir ubicación y nombre del archivo

---

## Opción 4: Usando Pandoc (Avanzado)

### Requisitos:
- Pandoc instalado
- LaTeX instalado (MiKTeX en Windows)

### Instalación:
```bash
# Descargar e instalar Pandoc desde:
https://pandoc.org/installing.html

# Descargar e instalar MiKTeX desde:
https://miktex.org/download
```

### Convertir:
```bash
cd C:\Users\HP\Pictures\planeamiento\Proyecto_avance_PETI-\proyecto

pandoc README.md -o EXAMEN_UNIDAD_II_PETI.pdf --pdf-engine=xelatex
```

---

## Opción 5: Usando Herramientas Online

### Sitios Recomendados:

1. **Markdown to PDF Online**
   - URL: https://www.markdowntopdf.com/
   - Ventajas: Simple, rápido, sin registro

2. **CloudConvert**
   - URL: https://cloudconvert.com/md-to-pdf
   - Ventajas: Más opciones de formato

3. **DILLINGER**
   - URL: https://dillinger.io/
   - Ventajas: Editor en vivo + exportar PDF

4. **Markdown Live Preview**
   - URL: https://markdownlivepreview.com/
   - Ventajas: Vista previa + imprimir a PDF

---

## 📝 Checklist Antes de Convertir

Antes de convertir el README a PDF, asegúrate de:

- [ ] Completar tu nombre completo en la sección "Información del Estudiante"
- [ ] Agregar tu email en la sección "Autor"
- [ ] Verificar que la URL del repositorio sea correcta
- [ ] Agregar las capturas de pantalla en la carpeta `docs/screenshots/`
- [ ] Hacer commit y push de las capturas
- [ ] Verificar que las imágenes se vean en GitHub
- [ ] Reemplazar `[TU NOMBRE COMPLETO AQUÍ]` con tu nombre real

---

## 📤 Subir el PDF al Aula Virtual

Una vez tengas el PDF:

1. Renombrar el archivo:
   ```
   EXAMEN_UNIDAD_II_PETI_[TU_APELLIDO]_[TU_NOMBRE].pdf
   ```

2. Verificar que el PDF contenga:
   - ✅ Tu nombre completo
   - ✅ Fecha (22 de Octubre de 2025)
   - ✅ URL del repositorio GitHub
   - ✅ Descripción de las 2 mejoras
   - ✅ Capturas de pantalla (si lograste agregarlas)

3. Subir al aula virtual según las instrucciones del docente

---

## 💡 Recomendación

La **Opción 2 (GitHub + Sitio Web)** es la más fácil y rápida:
1. Abrir README en GitHub
2. Copiar contenido
3. Ir a https://www.markdowntopdf.com/
4. Pegar y convertir
5. Descargar PDF
6. Subir al aula virtual

**Tiempo estimado: 2-3 minutos**

---

## ❓ Problemas Comunes

### Las imágenes no aparecen:
- Las capturas deben estar en la carpeta correcta
- Hacer commit y push antes de convertir
- Usar URLs completas de GitHub en el README

### El formato se ve mal:
- Probar con otro convertidor
- Usar la opción de "Imprimir a PDF" del navegador

### El archivo es muy grande:
- Comprimir las imágenes antes de agregarlas
- Usar herramientas como TinyPNG

---

## 📞 Ayuda Adicional

Si tienes problemas, puedes:
1. Consultar con el docente
2. Usar la opción más simple (Opción 2)
3. Pedir ayuda a un compañero que ya lo haya hecho
