# Hoja de especificación · Customer Follow-up

Roberto Corella y Javier Armesto.

Requisito: programar revisiones de clientes y marcar una revisión realizada. Leer el [contrato](../../contract.es.md). La hoja ayuda a preparar decisiones; los artefactos finales siguen las ubicaciones y contratos del ALDC instalado.

| Pregunta | Decisión del equipo y referencia |
|---|---|
| ¿Qué objetos estándar y suministrados consume el cambio? | |
| ¿Cómo se representa una fecha sin programar? | |
| ¿Qué ocurre el mismo día de la revisión? | |
| ¿Qué capa obtiene WorkDate y cuál recibe una fecha explícita? | |
| ¿Desde qué fecha cuentan los 30 días? ¿Son naturales? | |
| ¿Qué sucede al repetir la acción el mismo día? | |
| ¿Cómo se conserva el resto del cliente y se persisten las fechas? | |
| ¿Qué comprueban C01–C12 y qué queda para la ficha/permisos? | |
| ¿Qué queda fuera del incremento? | |
| ¿Qué artículos BCQuality se leyeron y por qué aplican a BC28 y este cambio? | |
| ¿Qué decisión de arquitectura o criterio de spec cambió por esa lectura? | |
| ¿Qué criterio verificará el revisor y qué requiere ejecución AL/BC? | |

1. Pedir arquitectura acotada antes de código. Consultar símbolos de Customer y Customer Card.
2. Revisar el diseño y lanzar al-spec.create o /aldc:al-spec-create para el **Spec Agent**. Registrar lectura, selección y aplicación con la [ficha de diseño](../../templates/evidence/bcq-design-evidence.md). Mantener una spec y comprobar plans.root.
3. Asociar los criterios a casos de aceptación, sin pegar la solución.
4. Registrar versión de spec, responsable humano y aprobación o corrección necesaria.

Las respuestas de negocio están fijadas en el contrato de formación. Si se propone variarlas, registrar el cambio de alcance y revisar tests antes de implementarlo.
