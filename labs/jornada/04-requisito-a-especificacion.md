# Lab 04 · Requisito a especificación

**Objetivo:** obtener una especificación que otra persona pueda revisar. **Tiempo:** 20 minutos + 6 de revisión cruzada. **Punto de partida:** contrato, starter, ALDC y BCQuality montado. **Entrega:** arquitectura, spec, criterios citados y decisiones pendientes visibles.

## De dónde vienes y qué cambia ahora

En el Lab 03 mejoraste una instrucción del plugin y observaste su efecto. Ahora vas a convertir un requisito en una arquitectura y una especificación revisables. Al terminar este lab habrás completado cuatro de los ocho laboratorios.

ALDC y sus primitivas ya están preparados desde el preflight. No necesitas reinstalarlos ni restaurar las copias locales del ejercicio. Continúa en tu workspace y rama de trabajo, con GetReviewStatus resuelto y MarkReviewed pendiente.

Abre un chat nuevo y selecciona **al-architect**. Primero pide la arquitectura y revisa su respuesta. Solo después de aprobarla utiliza **al-spec.create**. La implementación corresponde al Lab 05.

Para el diseño, consulta BCQuality como conocimiento desde la carpeta del workspace; identifica las fuentes realmente leídas y las limitaciones de acceso. Conserva la implementación existente de GetReviewStatus al especificar el comportamiento completo.

## Requisito

«Desde la ficha de cliente, indicar la próxima revisión, ver su estado y marcar una revisión realizada. Al hacerlo, registrar la fecha de trabajo y programar la siguiente a 30 días naturales.» Fuera de alcance: historial, correos, tareas programadas, bloqueos y documentos de venta.

## Petición al Architect

> Analiza Customer Follow-up con el contrato y el starter. Define alcance, objetos, dependencias y separación entre interfaz y lógica. Consulta los símbolos y el conocimiento BCQuality disponible que resulte pertinente. Expón decisiones abiertas y criterios de diseño con su origen. Entrega arquitectura; todavía no implementes.

## Petición al Spec Agent (`al-spec.create`)

> A partir de la arquitectura aprobada, especifica GetReviewStatus y MarkReviewed. Incluye entradas, validaciones, efectos, casos C01–C12 y límites del alcance. Declara los criterios BCQuality seleccionados y sus referencias en .bcq-criteria.json. Separa las decisiones pendientes. No generes todavía el código AL.

## Reglas que deben quedar cerradas

| Decisión | Contrato del ejercicio |
|---|---|
| Fecha vacía | Próxima vacía: Sin programar; referencia vacía: error |
| Fecha de cierre | Próxima revisión con fecha de cierre: error de validación |
| Referencia | La interfaz pasa WorkDate; la lógica recibe Date |
| Próxima revisión | Fecha de revisión + 30 días naturales |
| Repetición | Misma fecha de revisión, mismas fechas guardadas |
| Persistencia | Al reabrir, los valores siguen guardados |
| Otros campos | Se conservan; no se elevan permisos |

## Checkpoint humano y revisión cruzada

La otra persona explica las reglas con sus palabras, anotáis una corrección si hay ambigüedad y registráis **aprobar, devolver con cambios o detener**. Usa la [ficha de checkpoint](../../templates/evidence/human-checkpoint.md), la [hoja de especificación](../material/specification-workbook.md) y la [ficha de diseño BCQuality](../../templates/evidence/bcq-design-evidence.md). Haz commit al aprobar.
