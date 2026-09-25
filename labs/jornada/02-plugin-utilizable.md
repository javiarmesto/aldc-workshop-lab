# Lab 02 · Plugin utilizable

**Objetivo:** reutilizar la revisión de fechas en una sesión nueva. **Tiempo:** 18 minutos. **Punto de partida:** [`templates/plugin`](../../templates/plugin/README.md) y la función de estado del Lab 01. **Entrega:** ruta del plugin, componente usado y resultado de revisión.

## Pasos

1. **Copiar y completar.** Copia `templates/plugin` a una carpeta propia `review-dates-lab`, fuera del repositorio. Quita `.example` a `plugin.json`, `mcp.json`, `SKILL.md`, agente y comando.
2. **Registrar.** Añade su ruta absoluta en `settings.json` del usuario con [este ejemplo](../../templates/plugin-settings.json.example):

```json
"chat.pluginLocations": { "C:/ruta/absoluta/review-dates-lab": true }
```

3. **Abrir una sesión.** Localiza skill, agente y herramientas disponibles procedentes del plugin. Desactiva temporalmente las copias locales de `.github` que dupliquen la skill.
4. **Utilizar.** Invoca la revisión de la función y consulta una API AL en Microsoft Learn.

## Cuando el plugin no aparece

| Síntoma | Primera comprobación |
|---|---|
| No se descubre | Ruta real, manifiesto y sufijos de archivo |
| Aparece una skill distinta | Copias duplicadas en workspace o usuario |
| El agente no usa la skill | Petición explícita y contexto de activación |
| No se ve una herramienta MCP | Servidor disponible y herramientas habilitadas |

Instalar el plugin no demuestra haber usado la skill: guarda la invocación y su retorno.
