# Lab 05 · Incremento implementado

**Objetivo:** completar el comportamiento y comprobarlo con C01–C12. **Tiempo:** 27 minutos. **Punto de partida:** arquitectura y spec aprobadas; starter con el trabajo del Lab 01. **Entrega:** diff acotado, compilación, resultados y revisión inicial.

## Comprobar prerrequisitos

Desde la raíz del repositorio, ejecuta el [helper de este lab](../../tools/Test-Lab05.ps1):

```powershell
./tools/Test-Lab05.ps1
```

**Qué aprenderás con esta comprobación:** distinguir un entorno preparado de una implementación validada. El helper confirma que los documentos aprobados y las configuraciones locales están localizables antes de pedir a Conductor que planifique el incremento.

**Qué hace `Test-Lab05.ps1`:** llama a `Test-LabPrerequisites.ps1 -Lab 5`. Lee el contrato y los `app.json`, consulta rama, SHA y estado de Git, busca arquitectura, spec y selección de criterios BCQuality bajo `.github/plans`, y comprueba la presencia de `App/.vscode/launch.json` y `Test/.vscode/launch.json`. Muestra `PRESENTE`, `FALTA` o `REVISAR` para los archivos, y `MANUAL` para lo que debes confirmar en el editor: aprobaciones, delegación y sandbox. No instala, modifica, publica, compila ni ejecuta tests; tampoco imprime el contenido de `launch.json`. `PRESENTE` no demuestra que Conductor pueda acceder a un recurso.

Lee sus resultados antes de continuar. Si ves `REVISAR` para criterios BCQuality, comprueba la selección real del proyecto antes de concluir que faltan: pueden estar en `customer-follow-up.bcq-selection.json`. [Parámetros y estados](../../tools/README.md#helpers-de-comprobación).

## Preparar el chat

Selecciona Conductor y utiliza los [prompts de planificación, aprobación y cierre](#prompts-para-planificar-aprobar-y-cerrar) de esta guía. Primero revisa el plan; después autoriza la implementación.

## Casos que completan el incremento

| Caso | Entrada o acción | Esperado |
|---|---|---|
| C07 | Fecha de revisión vacía | Error |
| C08 | 15/10/2026 + 30 días | 14/11/2026 |
| C09 | 31/01/2024 + 30 días | 01/03/2024 |
| C10 | 15/12/2026 + 30 días | 14/01/2027 |
| C11 | Revisar dos veces con la misma fecha | Mismas fechas; nombre conservado |
| C12 | Guardar y volver a leer Customer | Fechas persistidas |

## Pasos

1. Observad el plan y las delegaciones.
2. Completad la persistencia y revisad el alcance del diff: no deben cambiar firmas, IDs, tests ni ayudantes.
3. Compilad y ejecutad C01–C12 sobre el código actual siguiendo [cómo ejecutar los tests](../../docs/preflight.md#ejecutar-los-tests). **Objetivo: 12 de 12.** Registrad código comprobado, operación, resultado y pendientes.

## Publicar y validar el incremento

El agente puede implementar, compilar y revisar sin disponer de una herramienta para controlar AL Test Explorer. Si declara esa limitación, realiza tú la publicación y los tests; después comunica los resultados a Conductor. La aceptación sigue pendiente hasta ejecutar la suite.

1. Guarda el código y publica explícitamente **App** con **AL: Publish without debugging**, seleccionando el sandbox del ensayo. Compilar un paquete no actualiza por sí solo la app instalada.
2. En Testing, selecciona **Test → codeunit 71300 → C01–C12** y utiliza **Publish & Run**. Comprueba que App y Test apuntan al mismo sandbox.
3. Consulta el resultado de la nueva ejecución, no una entrada histórica. Esperamos **12/12**.
4. Registra en `evidence/lab05-run-note.md` la fecha, entorno, código probado (commit base y diff si aún no hay commit), operación, resultados por caso y quién ejecutó la prueba. Conserva una captura o salida si está disponible.
5. Comunica el resultado a Conductor para cerrar el plan y guardar código y evidencia. Si falla algún caso, conserva el mensaje exacto y mantén abierta la aceptación.

### Si C11 y C12 todavía muestran el error del starter

`Workshop action pending implementation.` es el mensaje del cuerpo pendiente de MarkReviewed. Si el código local ya no lo contiene, comprueba primero la publicación de App, el sandbox de ambos proyectos y que estás mirando una ejecución nueva. No cambies la implementación solo por un resultado antiguo.

En el ensayo del 25/09/2026 se observó primero 10/12 con ese mensaje y, tras el paso de publicación y nueva ejecución manual, una captura con C01–C12 correctos. Es evidencia del ensayo, no un resultado automático para las copias de los participantes.

### Qué significa la revisión de BCQuality

Que BCQuality esté disponible no demuestra que se haya invocado su flujo de revisión. Distingue la inspección directa del código contra criterios seleccionados de una ejecución del proveedor. Véase la [nota aparte sobre BCQuality en el Lab 05](../../docs/lab05-bcquality-nota.md). Los tests y la revisión de calidad son comprobaciones distintas.

## Después de comer · revisión y corrección

**18 minutos.** Intercambiad papeles y revisad spec, diff y resultados.

> Revisa el diff frente a la especificación aprobada. Aplica los criterios de calidad seleccionados. Para cada hallazgo, indica archivo, comportamiento afectado, evidencia y corrección propuesta. No modifiques el código durante esta revisión. Distingue lo revisado estáticamente de lo ejecutado.

Un hallazgo útil tiene criterio, localización, observación, consecuencia y corrección con prueba. Corregid un hallazgo aplicable o documentad la revisión, y repetid las comprobaciones afectadas.

## Aceptación y recorrido en Customer Card (tras el Lab 06)

Sigue [`material/demo-storyboard.md`](../material/demo-storyboard.md): WorkDate 15/10/2026, cuatro estados, **Mark as reviewed** (última 15/10, próxima 14/11), cerrar y reabrir, repetir la acción. Asigna el permission set **OW FOLLOWUP** junto a un rol que pueda editar Customer.

## Prompts para planificar, aprobar y cerrar

Abre un chat nuevo con **AL Development Conductor**. Necesita lectura del proyecto y capacidad de delegación; las herramientas de edición y compilación deben estar disponibles para los agentes que las utilicen.

```text
Usa la arquitectura y especificación aprobadas de Customer Follow-up.
Invoco Conductor para practicar el recorrido del taller aunque sea LOW.
Planifica una fase mínima para implementar solo MarkReviewed y delegar
implementación y revisión. Conserva GetReviewStatus, GetNextReviewDate,
firmas, objetos, validaciones y tests.
Presenta el plan y espera mi aprobación antes de implementar o delegar
cambios. Si hay conflicto con tus instrucciones, explícalo.
La aceptación requiere resultados reales de compilación y C01–C12.
```

Lee el plan y, si encaja:

```text
Apruebo el plan. Guárdalo y procede con implementación delegada y
revisión. Si necesitas publicación o tests manuales, indica la operación
y espera mis resultados. No presentes operaciones pendientes como hechas.
No hagas operaciones de escritura en Git.
```

Después de publicar y ejecutar:

```text
He ejecutado manualmente <casos> tras publicar App en <sandbox>.
Resultado real: <resultado y errores, si existen>.
Regístralo en evidence/lab05-run-note.md con fecha <fecha>, atribuyéndome
la ejecución. No inventes logs ni capturas.
Actualiza el cierre y el plan; actualiza memory.md solo si existe en
el proyecto. Si hay fallos, conserva la
aceptación pendiente. Distingue la revisión directa de criterios de la
ejecución del flujo BCQuality y comprueba los recuentos del informe.
No cambies más código ni tests, no uses Git y no empieces el Lab 06.
```


## Guardar el Lab 05

Anota el commit base antes de guardar el incremento (`git rev-parse HEAD`). Añade el código y evidencia, y después cada documento de plan/revisión/cierre modificado por su ruta real; excluye telemetría.

```powershell
git add -- App/src/CustomerFollowUpMgt.Codeunit.al evidence/lab05-run-note.md
# Repite para cada documento del plan o revisión:
git add -- '<ruta-del-documento>'
git diff --cached
git commit -m "feat: completar MarkReviewed y validar Lab 05"
git push
git rev-parse HEAD
```

Conserva ambos SHA para el Lab 06. No cierres la aceptación hasta confirmar los 12 tests.
