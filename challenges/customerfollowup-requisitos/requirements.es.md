# Customer Follow-up · reto desde requisitos

## Encargo

El equipo comercial quiere identificar qué clientes debe revisar. En la ficha de cliente de Business Central debe poder planificar la próxima revisión, consultar su situación y marcar una revisión realizada. Hoy este seguimiento se hace fuera de Business Central.

## Requisitos de negocio

1. Cada cliente tendrá una fecha de **última revisión** y otra de **próxima revisión**. La última será de lectura en la ficha. La próxima podrá editarse y dejarse vacía.
2. La ficha mostrará un estado calculado respecto a la fecha de trabajo de la sesión: **Sin programar** si no hay próxima fecha; **Vencida** si es anterior; **Revisar hoy** si coincide; **Programada** si es posterior. El estado no se almacena en el cliente. Debe actualizarse al abrir o refrescar la ficha, tras editar la próxima fecha y tras marcar una revisión.
3. **Marcar como revisado** tomará la fecha de trabajo como fecha de revisión. Guardará esa fecha como última revisión y fijará la próxima exactamente **30 días naturales** después, contados desde la revisión realizada aunque la planificación anterior fuera distinta. Treinta días no significa un mes ni treinta días laborables.
4. Las fechas de referencia y revisión son obligatorias; no se admiten fechas de cierre contable de Business Central. Una próxima fecha vacía sí es válida, pero si se indica tampoco puede ser una fecha de cierre. Ante una fecha inválida, se mostrará un error y no se modificarán los datos del cliente.
5. Se permite revisar antes de la fecha prevista. Repetir la acción en la misma fecha mantiene las mismas dos fechas, sin acumular otros 30 días. No se exige comprobar el orden cronológico respecto de revisiones anteriores.
6. La acción conserva los demás datos del cliente y persiste el cambio. El usuario requiere sus permisos habituales de modificación de Customer y el permiso de ejecución de la funcionalidad. No se solicita elevar derechos.
7. Quedan fuera del alcance el historial de revisiones, avisos, tareas programadas, bloqueos y documentos de venta.

## Ejemplos para contrastar el resultado

| Situación | Resultado esperado |
| --- | --- |
| Próxima fecha vacía; referencia 15/10/2026 | Sin programar |
| Próxima 14/10/2026; referencia 15/10/2026 | Vencida |
| Próxima 15/10/2026; referencia 15/10/2026 | Revisar hoy |
| Próxima 16/10/2026; referencia 15/10/2026 | Programada |
| Revisión el 15/10/2026 | Última 15/10/2026; próxima 14/11/2026 |
| Revisión el 31/01/2024 | Próxima 01/03/2024 |
| Repetir la revisión del 15/10/2026 | Las fechas finales coinciden con una sola revisión |
| Fecha de revisión vacía o de cierre | Error; el cliente conserva sus datos |

## Entrega

Partid de este documento. Elaborad una arquitectura y una especificación para aprobación humana; identificad las decisiones abiertas antes de escribir AL. Implementad la funcionalidad y los tests que estiméis necesarios. Comprobad el comportamiento en un sandbox, realizad una revisión con criterios y fuentes identificables y preparad una entrega reproducible para otra pareja.

En la evidencia, distinguid el resultado **esperado**, lo **inspeccionado en código** y lo **observado en compilación o ejecución**. Registrad los bloqueos cuando no sea posible realizar una comprobación.
