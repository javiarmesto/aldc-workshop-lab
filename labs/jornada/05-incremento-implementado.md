# Lab 05 · Incremento implementado

**Objetivo:** completar el comportamiento y comprobarlo con C01–C12. **Tiempo:** 27 minutos. **Punto de partida:** arquitectura y spec aprobadas; starter con el trabajo del Lab 01. **Entrega:** diff acotado, compilación, resultados y revisión inicial.

## Petición al Conductor

> Usa la arquitectura y la especificación aprobadas. Planifica y delega la implementación y revisión de Customer Follow-up. Completa los TODOs pendientes sin cambiar firmas, IDs ni validaciones suministradas. Conserva el trabajo válido de GetReviewStatus. Devuelve diff, operaciones ejecutadas, resultados y pendientes.

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
