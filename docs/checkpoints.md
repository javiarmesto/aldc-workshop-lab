# Guardar y recuperar checkpoints

Un commit guarda una etapa de tu trabajo. Las ramas de recuperación del instructor permiten continuar en otra carpeta si te atascas. Ninguno publica App en Business Central ni instala herramientas, plugins o credenciales.

## Guardar tu propia etapa

Desde la raíz de tu copia, revisa antes qué vas a guardar:

```powershell
git branch --show-current
git status --short
git diff
# Usa los archivos concretos indicados al cerrar cada lab.
# Ejemplo Lab 01, después de crear su evidencia:
git add -- App/src/CustomerFollowUpMgt.Codeunit.al evidence/lab01-run-note.md
git diff --cached
git commit -m "checkpoint: Lab 01 completado"
if ($LASTEXITCODE -ne 0) { throw 'Revisa el commit; puede no haber cambios nuevos.' }
$branch = git branch --show-current
git push -u origin $branch
if ($LASTEXITCODE -ne 0) { throw 'No se ha podido subir el checkpoint.' }
git fetch origin
if ($LASTEXITCODE -ne 0) { throw 'No se ha podido comprobar origin.' }
git rev-parse HEAD
git rev-parse "origin/$branch"
git status --short
```

Los dos SHA iguales confirman que ese commit está publicado. No prueban que todo el árbol de trabajo esté guardado: revisa el último `status`. Si la evidencia ya estaba en un commit anterior y no hay diff, no necesitas duplicar el commit. Añade las primitivas y documentos relevantes por sus rutas; revisa por separado los ajustes de agentes. Evita `git add .` para no incluir conexiones, cachés o telemetría.

Al cerrar Lab 04, registra el SHA de arquitectura/spec aprobadas. Antes de implementar Lab 05, registra el SHA base; después guarda el incremento y su evidencia. Esos dos SHA se usan en Lab 06. No modifiques `starter_expected` para reflejar el progreso.

## Etapas preparadas por el instructor

| Rama en la plantilla | Contenido | Continuar por | Resultado esperado, no ejecución nueva |
|---|---|---|---|
| `checkpoint/lab01` | GetReviewStatus resuelto, primitivas locales y nota de procedencia | Lab 02 | C01–C10 correctos; C11/C12 pendientes |
| `checkpoint/spec-aprobada` | Estado anterior más arquitectura, spec y criterios aprobados | Lab 05 | C01–C10 correctos; C11/C12 pendientes |

En ambas `MarkReviewed` conserva el TODO. El starter de `main` mantiene sus dos TODOs. Las ramas son copias docentes; no implican que hayas completado los labs omitidos. El checkpoint de spec no trae las primitivas locales duplicadas: prepara/registra el plugin según Lab 02 si lo necesitas. Los agentes de ALDC se instalan mediante el preflight.

## Recuperar sin sobrescribir tu copia

Ejemplo para Windows/Insiders. Cambia `$stage` a `lab01` si quieres empezar en Lab 02. Requiere acceso a la plantilla mientras sea privada.

```powershell
$root = 'C:\Workshops'
$stage = 'spec-aprobada'
$destination = Join-Path $root "recuperacion-$stage"
if (Test-Path -LiteralPath $destination) { throw "Ya existe $destination; elige otra carpeta." }
New-Item -ItemType Directory -Path $root -Force | Out-Null
git clone --single-branch --branch "checkpoint/$stage" `
    https://github.com/javiarmesto/aldc-workshop-lab.git $destination
if ($LASTEXITCODE -ne 0) { throw 'No se pudo descargar el checkpoint.' }
Set-Location -LiteralPath $destination
git switch -c "continuar-$stage"
if ($LASTEXITCODE -ne 0) { throw 'No se pudo crear la rama local.' }
# Evita publicar por accidente en el repositorio de la plantilla.
git remote rename origin plantilla
if ($LASTEXITCODE -ne 0) { throw 'Revisa los remotos antes de continuar.' }
git rev-parse HEAD
code-insiders .\aldc-workshop-lab.code-workspace
# VS Code estable: code .\aldc-workshop-lab.code-workspace
```

Conserva la carpeta original. Lee `evidence/checkpoint-source.md`, configura tu propio sandbox y sigue el preflight: toolkit ALDC, carpeta hermana BCQuality, símbolos y conexiones App/Test. No copies credenciales del instructor. Antes de ejecutar, comprueba cuál es la ventana activa y publica desde la copia recuperada: cambiar de carpeta no cambia el binario instalado.

Puedes hacer commits locales en la recuperación. Para subirlos necesitas tu propio repositorio vacío y configurarlo como `origin`; estas ramas no comparten necesariamente el historial de una copia creada mediante *Use this template*. No intentes resolverlo con un push forzado. Si no necesitas publicar la recuperación, entrega su diff y evidencia al instructor.
