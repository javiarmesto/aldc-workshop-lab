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
3. Compilad y ejecutad C01–C12 sobre el código actual. Registrad código comprobado, operación, resultado y pendientes.

## Después de comer · revisión y corrección

**18 minutos.** Intercambiad papeles y revisad spec, diff y resultados.

> Revisa el diff frente a la especificación aprobada. Aplica los criterios de calidad seleccionados. Para cada hallazgo, indica archivo, comportamiento afectado, evidencia y corrección propuesta. No modifiques el código durante esta revisión. Distingue lo revisado estáticamente de lo ejecutado.

Un hallazgo útil tiene criterio, localización, observación, consecuencia y corrección con prueba. Corregid un hallazgo aplicable o documentad la revisión, y repetid las comprobaciones afectadas.

## Aceptación y recorrido en Customer Card (tras el Lab 06)

Sigue [`material/demo-storyboard.md`](../material/demo-storyboard.md): WorkDate 15/10/2026, cuatro estados, **Mark as reviewed** (última 15/10, próxima 14/11), cerrar y reabrir, repetir la acción. Asigna el permission set **OW FOLLOWUP** junto a un rol que pueda editar Customer.
