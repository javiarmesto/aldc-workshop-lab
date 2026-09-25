# Lab 02 · Plugin utilizable

**Objetivo:** montar, registrar y usar un plugin local a partir de un ejemplo suministrado, para reutilizar la revisión de fechas en una sesión nueva. **Tiempo:** 18 minutos. **Punto de partida:** [`templates/plugin`](../../templates/plugin/README.md) y la función de estado del Lab 01. **Entrega:** ruta del plugin, componente usado y resultado de revisión.

## Comprobar prerrequisitos

Desde la raíz del repositorio, ejecuta el [helper de este lab](../../tools/Test-Lab02.ps1):

```powershell
./tools/Test-Lab02.ps1
```

Lee sus resultados antes de continuar. No instala ni modifica el entorno; distingue archivos presentes de comprobaciones manuales dentro del agente. [Parámetros y estados](../../tools/README.md#helpers-de-comprobación).

## Qué viene preparado y qué haces tú

El contenido del plugin ya está escrito en `templates/plugin`: manifiesto, skill de revisión de fechas, recursos, agente, comando y configuración MCP. Los archivos que deben activarse llevan el sufijo `.example`.

En este lab preparas una copia utilizable, la registras en VS Code y compruebas su uso. No necesitas tener el plugin creado antes de empezar: **la copia y el renombrado del paso 1 preparan el paquete local**. No generan contenido con IA, no compilan un VSIX y no registran por sí solos el plugin en el editor.

Antes de copiar, abre los archivos y localiza qué aporta cada uno:

| Plantilla | Función al quitar `.example` |
|---|---|
| `plugin.json.example` | Identidad y formato del paquete |
| `skills/review-date-rules/SKILL.md.example` | Procedimiento reutilizable de revisión |
| `skills/review-date-rules/boundary-cases.md` | Casos de apoyo; conserva su nombre |
| `com.github.copilot/agents/followup-reviewer.agent.md.example` | Agente revisor para Copilot |
| `com.github.copilot/commands/review-followup.md.example` | Comando de revisión para Copilot |
| `mcp.json.example` | Configuración del servidor Microsoft Learn |

La skill retoma la revisión utilizada en el Lab 01. Ahora se prueba su distribución dentro del plugin. Las instrucciones del proyecto y de ALDC permanecen en el workspace.

## 1. Preparar el paquete local

Desde la raíz de tu copia, puedes ejecutar el [script incluido](../../tools/Prepare-Lab02.ps1):

```powershell
./tools/Prepare-Lab02.ps1 -Action Prepare
```

Crea la carpeta hermana `review-dates-lab` y renombra las plantillas. Si ya preparaste esa carpeta, no repitas el paso. Puedes revisar los parámetros y las protecciones en [Scripts para participantes](../../tools/README.md).

Para entender las operaciones o hacerlas manualmente, este es el bloque equivalente de **PowerShell**:

```powershell
$lab = (Get-Location).Path
$plugin = Join-Path (Split-Path $lab -Parent) 'review-dates-lab'

if (-not (Test-Path -LiteralPath (Join-Path $lab 'templates/plugin/plugin.json.example'))) {
    throw 'Ejecuta este bloque desde la raiz del repositorio del laboratorio.'
}
if (Test-Path -LiteralPath $plugin) {
    throw "Ya existe $plugin. Revisa su contenido antes de continuar."
}

Copy-Item -LiteralPath (Join-Path $lab 'templates/plugin') -Destination $plugin -Recurse -ErrorAction Stop
Get-ChildItem -LiteralPath $plugin -Recurse -File -Filter '*.example' |
    Rename-Item -NewName { $_.Name -replace '\.example$', '' } -ErrorAction Stop

Write-Host "Paquete preparado en: $plugin"
```

Por ejemplo, si tu copia está en `C:\Workshops\aldc-workshop-rehearsal`, el paquete queda en `C:\Workshops\review-dates-lab`. Conserva las subcarpetas. Comprueba que existen `plugin.json`, `mcp.json` y `skills/review-date-rules/SKILL.md` sin el sufijo. **El paquete está preparado; falta registrarlo.**

## 2. Registrar en VS Code

**Ruta principal · Personalización del chat**

1. Abre la personalización del chat y entra en **Plugins**.
2. Pulsa **Install from Source**.
3. Introduce la ruta de la carpeta que contiene `plugin.json`, por ejemplo `C:\Workshops\review-dates-lab`, y confirma con Enter.
4. Comprueba que aparece **review-dates-lab** y que está habilitado. Localiza también la skill **review-date-rules** y el agente **Follow-up Reviewer**.

Selecciona la carpeta exacta del paquete, no la carpeta padre `C:\Workshops`. Si la interfaz muestra una ruta abreviada, comprueba la fuente instalada. No registres de nuevo el mismo plugin mediante otro método si ya aparece.

**Alternativa · Ajustes JSON**

Si tu versión no ofrece esa entrada, abre **Preferences: Open User Settings (JSON)**. Incorpora estas propiedades, adaptando la ruta a la carpeta creada:

```json
"chat.plugins.enabled": true,
"chat.pluginLocations": {
    "C:/Workshops/review-dates-lab": true
}
```

Si ya tienes `chat.pluginLocations`, añade una entrada a ese mismo objeto: conserva los otros plugins y no dupliques la propiedad. Estos ajustes son del usuario; no sustituyas todo el archivo ni publiques tu configuración personal. [Ejemplo de ajustes](../../templates/plugin-settings.json.example).

## 3. Evitar duplicados y abrir una sesión nueva

Guarda el trabajo del Lab 01 en un commit. Ejecuta el script desde la raíz:

```powershell
./tools/Prepare-Lab02.ps1 -Action DisableLocal
```

Este paso mueve temporalmente **fuera del workspace**, a la carpeta hermana `lab01-primitivas-reserva`, las copias de los componentes que ahora suministra el plugin:

- `.github/skills/review-date-rules/`
- `.github/agents/followup-reviewer.agent.md`
- `.github/prompts/review-followup.prompt.md`

Conserva esa copia de reserva. Si ya moviste los componentes manualmente, no repitas el paso. Para volver a las primitivas locales, desactiva primero el plugin en Personalización y ejecuta:

```powershell
./tools/Prepare-Lab02.ps1 -Action RestoreLocal
```

También puedes mover esas tres rutas manualmente siguiendo la tabla del [README de scripts](../../tools/README.md). Git mostrará las rutas retiradas como eliminaciones locales: son parte de la prueba de cambiar el origen de los componentes, no una pérdida del checkpoint.

**Mantén activas las instrucciones de `.github/instructions/` y `.github/copilot-instructions.md`, así como el resto de ALDC.** Recarga la ventana y abre una sesión nueva. Localiza la skill, el agente y las herramientas procedentes del plugin. La presencia de una ruta en los ajustes no demuestra que se haya cargado.

## 4. Usar y comprobar

En Copilot Chat, modo Agent, utiliza esta petición:

> Revisa GetReviewStatus de Customer Follow-up usando la skill review-date-rules del plugin review-dates-lab. Contrasta el código con contract.es.md y los casos límite. No modifiques archivos. Indica el origen y la ruta de la skill utilizada, los hallazgos y las comprobaciones pendientes. Consulta además mediante Microsoft Learn MCP la API WorkDate y explica su relación con la fecha explícita que recibe esta función. Si no puedes acceder a la skill o al MCP, indícalo.

Inspecciona las lecturas y llamadas que exponga la sesión; no te quedes solo con la afirmación del agente. Guarda en `evidence/lab02-run-note.md`:

- Ruta del paquete y componente realmente usado, con su origen observado.
- Invocación/lectura de la skill y resultado de la revisión.
- Llamada a Microsoft Learn MCP y retorno; si no se ejecutó, indícalo.
- Archivos modificados, si los hubiera, y comprobaciones pendientes.

El lab puede terminar sin hallazgos si la función es correcta. El éxito es demostrar el uso del plugin y la consulta real a Learn; una revisión textual no equivale a ejecutar tests.

## Cuando el plugin no aparece

| Síntoma | Primera comprobación |
|---|---|
| No se descubre | Ruta real, manifiesto y sufijos de archivo |
| Aparece una skill distinta | Copias duplicadas en workspace o usuario |
| El agente no usa la skill | Petición explícita y contexto de activación |
| No se ve una herramienta MCP | Servidor disponible y herramientas habilitadas |

Instalar el plugin no demuestra haber usado la skill: guarda la invocación y su retorno.

## Cierre guiado

Usa el prompt del paso 4 con lectura del plugin y herramientas Microsoft Learn habilitadas. Tras revisar la respuesta, guarda la evidencia tú mismo si el revisor no puede escribir. Puedes pedir el contenido en el chat:

```text
Resume esta sesión para evidence/lab02-run-note.md:
ruta y origen de la skill realmente utilizada, revisión realizada,
consulta Microsoft Learn y resultado, limitaciones y archivos cambiados.
No atribuyas el origen de un servidor MCP al plugin sin comprobarlo.
Devuelve el texto en el chat. No modifiques archivos ni uses Git.
```

El resultado esperado es identificar y utilizar el plugin; no hace falta encontrar un defecto. Registra las eliminaciones de las copias locales como parte de la transición y conserva ALDC.

## Guardar el laboratorio

Guarda la evidencia indicada y revisa los archivos antes del commit. Los comandos los ejecutas tú desde la raíz; el agente no necesita permisos de escritura en Git.

```powershell
git status --short
git add -u -- .github/agents/followup-reviewer.agent.md .github/prompts/review-followup.prompt.md .github/skills/review-date-rules/
git add -- evidence/lab02-run-note.md
git diff --cached --stat
git diff --cached
git commit -m "docs: cerrar Lab 02"
git push
git rev-parse HEAD
```

Si aún no hay upstream, usa `git push -u origin <tu-rama>`. No ejecutes el commit si el área preparada incluye cambios ajenos al lab; retíralos del staging sin borrar tu trabajo. No incluyas configuración personal, paquetes, cobertura ni telemetría.
