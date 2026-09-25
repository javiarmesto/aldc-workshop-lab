# Scripts de preparación para participantes

Estos scripts automatizan pasos explicados en las guías. No instalan ALDC, no implementan AL, no ejecutan tests y no modifican los ajustes personales de VS Code.

Ejecuta desde la raíz de tu copia, en PowerShell:

| Momento | Comando | Resultado |
|---|---|---|
| [Lab 01](../labs/jornada/01-contrato-y-contexto.md) | `./tools/Prepare-Lab01.ps1` | Copia las seis primitivas y recursos. Conserva el archivo de instrucciones de ALDC. |
| [Lab 02](../labs/jornada/02-plugin-utilizable.md), preparar | `./tools/Prepare-Lab02.ps1 -Action Prepare` | Crea `../review-dates-lab` y quita los sufijos `.example`. |
| Lab 02, retirar duplicados | `./tools/Prepare-Lab02.ps1 -Action DisableLocal` | Mueve skill, agente y prompt locales a `../lab01-primitivas-reserva`. |
| Volver a componentes locales | `./tools/Prepare-Lab02.ps1 -Action RestoreLocal` | Restaura esos tres componentes. Desactiva antes el plugin en VS Code. |

Después de preparar el plugin, regístralo desde **Personalización del chat → Plugins → Install from Source**, seleccionando la carpeta exacta que contiene `plugin.json`. Copiar el paquete no lo registra.

Los scripts calculan la raíz a partir de su propia ubicación; puedes indicar `-ProjectRoot`. Lab 02 admite `-PluginPath` y `-BackupPath` si necesitas otros destinos fuera del workspace. Conserva las mismas rutas al retirar y restaurar.

Antes de retirar componentes, guarda el estado del Lab 01 en Git. El script del Lab 01 permite repetir la copia si los destinos son idénticos y se detiene si contienen cambios. El del Lab 02 se detiene ante una carpeta de plugin/reserva existente o un destino que se sobrescribiría: comprueba si ya completaste ese paso. No hace falta repetirlo durante el ensayo.

La restauración conserva la carpeta de reserva vacía. Para otro ensayo, elige un nuevo `-BackupPath` o revisa y retira manualmente la carpeta vacía.

Si PowerShell bloquea la ejecución por una política de tu equipo, sigue la alternativa manual de la guía o consulta con tu administrador. No es necesario cambiar la política para comprender o realizar el laboratorio.

## Helpers de comprobación

Ejecuta `./tools/Test-Lab01.ps1` hasta `./tools/Test-Lab08.ps1` antes del lab correspondiente. Comparten `Test-LabPrerequisites.ps1`, compatible por diseño con PowerShell 5.1. No instalan dependencias, publican apps, ejecutan tests ni modifican archivos. Git se consulta en lectura; APM solo con version/help.

| Lab | Comprobaciones específicas |
|---|---|
| 01 | Plantillas, script de preparación y configuración ALDC |
| 02 | Plantilla de plugin y existencia de copia previa |
| 03 | Skill externa y evidencia del Lab 02 |
| 04 | Configuración, corpus BCQuality y carpeta de símbolos |
| 05 | Documentos de diseño, criterios y presencia de launch.json |
| 06 | Criterios, evidencia, corpus y diff opcional |
| 07 | APM/version/ayuda, manifiesto y consumidor previo |
| 08 | Evidencias, especificación y recorrido de aceptación |

Estados: **PRESENTE/DISPONIBLE** solo confirma presencia; **FALTA/REVISAR** requiere revisar; **MANUAL** necesita comprobación por el participante o desde el agente. La ausencia del plugin antes de prepararlo en Lab 02 es normal. El helper no determina un aprobado global ni verifica la semántica de aprobaciones o resultados.

Parámetros compartidos: `-ProjectRoot`, `-PluginPath`, `-BCQualityPath`, `-PlansPath`. Los valores predeterminados son raíz del repo, carpetas hermanas review-dates-lab/bcquality y .github/plans. Si aldc.yaml usa otras rutas, pásalas explícitamente; no se analiza YAML por aproximación. No se imprime launch.json ni configuración de credenciales.

```powershell
./tools/Test-Lab06.ps1 -BaseCommit '<SHA-base>' -IncrementCommit '<SHA-lab05>'
./tools/Test-Lab04.ps1 -BCQualityPath 'D:\equipo\bcquality'
./tools/Test-Lab07.ps1
```

Las herramientas visibles en PowerShell no demuestran acceso desde un agente. Guarda los cambios de herramientas y comprueba su uso en una sesión nueva. GitHub es una alternativa para leer commits publicados; un diff manual también sirve.

Validación inicial: revisión estática; pendiente de ejecución de estos helpers en Windows/PowerShell durante el ensayo. No ejecutan apm audit: muestran su ayuda para revisar compatibilidad antes de instalar.
