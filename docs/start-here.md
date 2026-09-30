# Empieza aquí · Guía del participante

[English](start-here.en.md) · [Volver al inicio](../README.md)

Vas a trabajar sobre tu propia copia de **Customer Follow-up**, con App y Test ya preparados. No necesitas el repositorio privado de instructores ni su solución de referencia. Completa la instalación antes de la sesión; durante el taller seguirás una guía por laboratorio.

## 1. Prepara la jornada de Companial

| Sesión | Herramienta | Preparación | Primera práctica |
|---|---|---|---|
| Jornada completa, castellano | GitHub Copilot Chat en VS Code o Insiders | [Preflight ES](preflight.md) | [Lab 01](../labs/jornada/01-contrato-y-contexto.md) |

Para ejecutar AL necesitas acceso a un sandbox de Business Central y permisos de publicación; para el recorrido de cliente, permisos habituales de edición de Customer más OW FOLLOWUP. Acuerda el sandbox con la organización. Si dos personas publican la misma app en el mismo entorno, pueden sobrescribir sus versiones aunque usen compañías diferentes.

## 2. Crea tu repositorio

1. Abre [la plantilla](https://github.com/javiarmesto/aldc-workshop-lab).
2. Pulsa **Use this template → Create a new repository**. Selecciona tu cuenta y un nombre, por ejemplo `mi-workshop`.
3. Crea solo la rama predeterminada: deja **Include all branches** desmarcado. Las ramas checkpoint son ayudas de recuperación posteriores.
4. Puedes mantener tu copia privada. No hagas fork ni trabajes directamente sobre la plantilla del instructor.
5. Copia la URL HTTPS de **tu repositorio nuevo** desde Code. Git utilizará tu autenticación habitual; nunca escribas un token en la URL.

Una copia creada desde una plantilla es independiente. Los cambios posteriores de la plantilla no llegarán con `git pull` a tu repositorio; el instructor indicará cómo incorporar una corrección necesaria. No cambies origin a la plantilla para intentar actualizarla.

## 3. Descarga y abre la copia correcta

En PowerShell, cambia la URL del ejemplo. Si ya tienes estas carpetas, revisa su contenido; el bloque se detiene sin sobrescribirlas.

```powershell
$root = 'C:\Workshops'
$lab = Join-Path $root 'mi-workshop'
$bcquality = Join-Path $root 'bcquality'
$repoUrl = 'https://github.com/TU-USUARIO/TU-REPOSITORIO.git'
if ($repoUrl -match 'TU-USUARIO|TU-REPOSITORIO') {
    throw 'Sustituye repoUrl por la URL HTTPS de tu copia.'
}
if (Test-Path -LiteralPath $lab) { throw "Ya existe $lab; revisa antes de continuar." }
if (Test-Path -LiteralPath $bcquality) { throw "Ya existe $bcquality; revisa su versión antes de reutilizarla." }
New-Item -ItemType Directory -Path $root -Force | Out-Null

git clone $repoUrl $lab
if ($LASTEXITCODE -ne 0) { throw 'No se pudo clonar tu repositorio.' }
git clone https://github.com/microsoft/BCQuality.git $bcquality
if ($LASTEXITCODE -ne 0) { throw 'No se pudo clonar BCQuality. Conserva tu copia ya descargada.' }
git -C $bcquality checkout --detach 07e324ddbc42597c479e041e06a7833740e05d0f
if ($LASTEXITCODE -ne 0) { throw 'No se pudo fijar la revisión de BCQuality.' }
git -C $bcquality rev-parse HEAD
Set-Location -LiteralPath $lab
git remote -v
code-insiders .\aldc-workshop-lab.code-workspace
# Si usas VS Code estable, ejecuta en su lugar:
# code .\aldc-workshop-lab.code-workspace
```

El comando de editor debe estar instalado en tu PATH. También puedes usar **Archivo → Abrir área de trabajo desde archivo** y elegir `aldc-workshop-lab.code-workspace`. La terminal del taller debe estar en la raíz `C:\Workshops\mi-workshop`, no dentro de App, Test o BCQuality.

| Carpeta | Contenido |
|---|---|
| `C:\Workshops\mi-workshop` | Tu repositorio, con App, Test, docs, labs, tools y evidence |
| `C:\Workshops\bcquality` | Corpus externo en la revisión fijada |
| `C:\Workshops\review-dates-lab` | Se crea al llegar al Lab 02; no hace falta ahora |
| `C:\Workshops\mi-workshop\apm-consumer` | Se crea en Lab 07; no hace falta ahora |

Si un paso de clonación falló después de crear alguna carpeta, conserva lo descargado y retoma solo el paso fallido. No repitas el bloque completo ni borres tu trabajo para eliminar el aviso de carpeta existente.

## 4. Completa el preflight

Sigue la [preparación previa en castellano](preflight.md). Prepara tu tenant y sandbox en los dos launch.json, instala ALDC y el toolkit en la raíz del proyecto, descarga símbolos y comprueba herramientas y tests. No uses datos de conexión del instructor. `aldc.yaml` se prepara con el toolkit: su ausencia en la plantilla recién clonada es normal.

Antes de empezar deberías poder marcar:

- [ ] El workspace muestra raíz, App, Test y BCQuality.
- [ ] Puedes leer el contrato desde el chat y localizar los agentes ALDC.
- [ ] `aldc.yaml` identifica App/Test y la ruta real de BCQuality.
- [ ] App y Test compilan y apuntan al mismo sandbox; App se ha publicado.
- [ ] Una consulta de Customer devuelve símbolos reales y Learn devuelve una referencia.
- [ ] Has ejecutado los tests del starter y guardado los resultados reales.
- [ ] `apm --version` responde; has registrado las versiones de tus herramientas.

Usa [la ficha de preflight](../templates/evidence/preflight.md) como `evidence/preflight.md`. No contiene contraseñas ni tokens.

**El starter tiene fallos deliberados.** En la suite completa deben pasar 7/12 y fallar exactamente C02, C03, C04, C11 y C12. Tras Lab 01 se esperan 10/12; tras Lab 05, 12/12. Otros fallos necesitan diagnóstico. No cambies `cases.csv → starter_expected` al avanzar.

## 5. Durante el taller

En la jornada, sigue [el índice de ocho labs](../labs/README.md). Cada guía indica objetivo, helper previo, agente, prompt, comprobación y guardado. Ejecuta `./tools/Test-Lab01.ps1` antes del primero y el correspondiente al avanzar. PRESENTE no equivale a aprobado: completa también los pasos MANUAL.

Mantén ALDC preparado durante toda la jornada. Labs 01–03 añaden y trasladan primitivas del ejercicio; Lab 04 empieza a usar explícitamente Architect y Spec Agent. No implementes por adelantado todos los TODOs: cada etapa tiene su objetivo.

Guarda avances según [checkpoints](checkpoints.md). Si te atascas, conserva archivo, comando y mensaje y consulta [Ayuda](help.md). El instructor puede indicar una rama preparada para abrir en otra carpeta; cambiar de archivos no publica una nueva App en BC.

## 6. Qué entregarás

Tu código y diff, arquitectura/spec con decisiones humanas, resultados de pruebas, revisión citada, evidencia del paquete APM y un handoff que otra persona pueda comprobar. Usa [evidence](../evidence/README.md). La aceptación del Lab 08 la decide la pareja receptora tras su comprobación; una recomendación del agente no la sustituye.
