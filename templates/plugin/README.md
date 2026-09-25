# Ejemplo de paquete Agent Plugins 1.0

Los archivos se entregan como `.example` para activarlos deliberadamente en el laboratorio. Copia esta carpeta a una ubicación de trabajo llamada review-dates-lab y elimina ese sufijo de cada plantilla. Conserva las carpetas. El README es documentación; no necesita cambiarse.

El formato se declara en plugin.json. La skill se distribuye bajo skills/; el MCP en mcp.json. Agentes y comandos específicos de Copilot se alojan bajo com.github.copilot/. Las convenciones del workspace se mantienen en el proyecto del alumno.

La configuración local del editor se realiza en settings.json del usuario usando una ruta absoluta y chat.pluginLocations. No distribuyas rutas locales propias como si fueran universales. Antes de usar el paquete revisa sus componentes y herramientas efectivas.

Fuentes: [formato del paquete](https://agent-plugins.org/plugin-authors/manifest), [MCP portable](https://agent-plugins.org/plugin-authors/mcp-servers), [plugins en VS Code](https://code.visualstudio.com/docs/agent-customization/agent-plugins).
