# Ejemplo de paquete Agent Plugins 1.0

**Este directorio contiene el ejemplo ya escrito, no un plugin ya registrado.** El Lab 02 consiste en preparar una copia local, registrarla en VS Code y comprobar su uso. No tienes que escribir el paquete desde cero ni compilar un VSIX.

1. **Preparar:** copiar esta carpeta fuera del repositorio y quitar `.example` a sus plantillas. Los comandos de la guía solo automatizan esa copia y ese renombrado.
2. **Registrar:** abrir Personalización del chat → Plugins → **Install from Source**, seleccionar la carpeta exacta que contiene `plugin.json` y comprobar que queda habilitado. La configuración con `chat.pluginLocations` es una alternativa; no registres dos veces el mismo paquete.
3. **Comprobar:** abrir una sesión nueva, evitar duplicados con las primitivas del Lab 01 y observar el componente usado.

Sigue el [Lab 02 paso a paso](../../labs/jornada/02-plugin-utilizable.md), que incluye los comandos y el resultado esperado de cada etapa.

Los archivos se entregan como `.example` para activarlos deliberadamente en el laboratorio. Copia esta carpeta a una ubicación de trabajo llamada review-dates-lab y elimina ese sufijo de cada plantilla. Conserva las carpetas. El README es documentación; no necesita cambiarse.

El formato se declara en plugin.json. La skill se distribuye bajo skills/; el MCP en mcp.json. Agentes y comandos específicos de Copilot se alojan bajo com.github.copilot/. Las convenciones del workspace se mantienen en el proyecto del alumno.

Puedes preparar el paquete con `./tools/Prepare-Lab02.ps1 -Action Prepare` desde la raíz del laboratorio. El mismo script permite retirar/restaurar las copias locales del Lab 01: [comandos y parámetros](../../tools/README.md).

Como alternativa a Personalización, la configuración local del editor se realiza en settings.json del usuario usando una ruta absoluta y chat.pluginLocations. No distribuyas rutas locales propias como si fueran universales. Antes de usar el paquete revisa sus componentes y herramientas efectivas.

Fuentes: [formato del paquete](https://agent-plugins.org/plugin-authors/manifest), [MCP portable](https://agent-plugins.org/plugin-authors/mcp-servers), [plugins en VS Code](https://code.visualstudio.com/docs/agent-customization/agent-plugins).

