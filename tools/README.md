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
