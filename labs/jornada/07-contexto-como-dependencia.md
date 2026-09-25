# Lab 07 · Contexto como dependencia

**Objetivo:** instalar y utilizar una skill desde un paquete del equipo. **Tiempo:** 18 minutos. **Punto de partida:** paquete local [`packages/october-workshop-primitives`](../../packages/october-workshop-primitives/README.md) y APM instalado (`apm --version`). **Entrega:** manifiesto, lockfile, archivos proyectados e invocación.

## Comprobar prerrequisitos

Desde la raíz del repositorio, ejecuta el [helper de este lab](../../tools/Test-Lab07.ps1):

```powershell
./tools/Test-Lab07.ps1
```

Lee sus resultados antes de continuar. No instala ni modifica el entorno; distingue archivos presentes de comprobaciones manuales dentro del agente. [Parámetros y estados](../../tools/README.md#helpers-de-comprobación).

## Pasos

Haz esta parte en PowerShell. Sustituye la ruta por la de **tu copia** si tiene otro nombre. Conserva la variable `$lab` en esta terminal para volver después al repositorio principal.

```powershell
$lab = 'C:\Workshops\aldc-workshop-rehearsal'
Set-Location -LiteralPath $lab
if (Test-Path '.\apm-consumer') {
    throw 'apm-consumer ya existe; revisa su contenido antes de continuar.'
}
New-Item -ItemType Directory -Path '.\apm-consumer' | Out-Null
Set-Location '.\apm-consumer'

apm --version
if ($LASTEXITCODE -ne 0) { throw 'APM no está disponible en esta terminal.' }
apm install ../packages/october-workshop-primitives --target copilot
if ($LASTEXITCODE -ne 0) { throw 'Instalación fallida; conserva el diagnóstico.' }
Get-Content .\apm.yml
Get-Content .\apm.lock.yaml
apm install --frozen --target copilot
if ($LASTEXITCODE -ne 0) { throw 'Instalación frozen fallida; revisa el diagnóstico.' }
apm audit
if ($LASTEXITCODE -ne 0) { throw 'Audit requiere revisión; conserva sus hallazgos.' }
Get-Content .\.agents\skills\review-al-evidence\SKILL.md
```

Compara manifiesto, lockfile, `.github/instructions/` y `.agents/skills/`. En el ensayo del 25/09/2026, **APM 0.23.1** instaló el paquete **1.1.0**, `--frozen` terminó correctamente y `audit` informó `No drift detected` y tres archivos sin incidencias. Son resultados históricos, no los de tu equipo: registra tu propia salida. En esa versión, la salida de `--frozen` confirma presencia del lockfile y remite a `audit` para integridad; no prueba por sí sola que una dependencia local sea inmutable. No se necesita `apm pack` en este lab.

Si PowerShell presenta una salida nativa como `NativeCommandError`, conserva el texto y comprueba `$LASTEXITCODE` inmediatamente después del comando; el color rojo por sí solo no distingue un mensaje de progreso de un fallo.

### Abrir la ventana correcta

Sigues en `C:\Workshops\aldc-workshop-rehearsal\apm-consumer`. Abre **solo esa carpeta**, en una ventana nueva:

```powershell
code-insiders -n .
# Si utilizas VS Code estable, ejecuta en su lugar: code -n .
```

En la nueva ventana, confirma que Explorer muestra `apm.yml` en la raíz. Abre un chat nuevo en modo **Agent** y utiliza el prompt siguiente. Esta ventana contiene el consumidor APM, no App/Test ni la spec del taller. Pega la evidencia que deba revisar; no presupongas acceso a la ventana anterior. Si solo aportas un resumen, es correcto que la skill declare que no puede verificar el código ni los 12 tests.

`apm-consumer/` está ignorado por Git. La entrega se guarda en `evidence/lab07-apm.md` **del repositorio principal**. Una terminal nueva en el consumidor no conserva la variable `$lab`: vuelve con la ruta explícita del último bloque.

## Una actualización también necesita revisión

Si cambia una instrucción del equipo, ¿qué comportamiento puede alterar? Si entra una dependencia nueva, ¿de dónde viene y qué capacidades trae? ¿Qué versión ha cambiado en el consumidor y quién acepta la actualización? El [ejemplo de política](../material/apm-policy.yml.example) muestra reglas de instalación.

## Agente y prompt de uso

Ejecuta los comandos APM de la sección Pasos tú mismo. Si fallan, conserva versión y error; no supongas que se instaló el paquete. Abre el consumidor en una ventana separada de VS Code y usa modo **Agent**, con lectura de la skill proyectada. Facilita una copia del informe del Lab 05/06 para que no dependa del acceso al workspace anterior.

```text
Usa la skill review-al-evidence instalada en este consumidor.
Indica su ruta real y lee sus instrucciones antes de revisar.
Te proporciono esta evidencia del taller: <pegar informe real>.
Distingue especificación, revisión estática, compilación y tests.
Señala información ausente sin inventarla. No modifiques código,
no ejecutes tests y devuelve el resultado en el chat.
```


## Resultado y cierre

Esperamos demostrar uso de la skill instalada, no solo que el comando de instalación terminó. Comprueba versión, manifiesto, lockfile, archivos proyectados y lecturas de la sesión.

```text
Prepara el texto para evidence/lab07-apm.md a partir de las salidas
APM y la revisión que te proporciono. Incluye versión, comandos,
resultados reales, rutas y origen de la skill, y qué quedó pendiente.
No afirmes reproducibilidad o auditoría correcta sin sus resultados.
Devuelve Markdown en el chat. No uses Git ni escribas archivos.
```

Guarda el texto en evidence/ del repositorio principal, no dentro del consumidor ignorado. Conserva allí también extractos del manifiesto/lockfile o referencias suficientes para identificar la dependencia.

```powershell
# Vuelve a la terminal del repositorio principal; adapta esta ruta:
Set-Location -LiteralPath 'C:\Workshops\aldc-workshop-rehearsal'
git add -- evidence/lab07-apm.md
git diff --cached
git commit -m "docs: registrar dependencia de contexto del Lab 07"
git push
```

