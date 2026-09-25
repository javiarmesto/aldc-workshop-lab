# Nota · BCQuality disponible y revisión ejecutada

## Observación del ensayo del 25/09/2026

Conductor informó: “BCQuality not live-invoked this phase (criteria checked by direct source inspection)”.

BCQuality estaba disponible y había aportado conocimiento y criterios en el diseño. En esta fase el revisor declaró contrastar el código directamente con los criterios seleccionados; no declaró una invocación del proveedor de revisión. No debe registrarse como “BCQuality ausente” ni como “revisión del proveedor ejecutada”.

## Cómo registrarlo

- **Disponibilidad:** corpus/configuración de BCQuality accesibles; indicar revisión fijada si se ha comprobado.
- **Operación real:** inspección directa frente a criterios, o invocación del proveedor con su evidencia.
- **Resultado:** hallazgos y criterios evaluados, no evaluados y no aplicables, con recuentos coherentes.
- **Pendiente:** averiguar por qué se eligió la inspección directa si se esperaba invocar el proveedor. No atribuirlo sin comprobar a instalación, herramientas o configuración.

La publicación y ejecución manual de los tests es otro asunto. El agente declaró no poder controlar AL Test Explorer; el participante ejecutó la validación y compartió una captura con C01–C12 correctos. Ese resultado no demuestra que BCQuality se haya invocado.

## Continuidad del taller

El Lab 05 practica implementación delegada, revisión y validación del incremento. Conserva esta limitación en su evidencia y comprueba expresamente el flujo de revisión de BCQuality en el Lab 06. No repitas una instalación únicamente por el mensaje “not live-invoked”.
