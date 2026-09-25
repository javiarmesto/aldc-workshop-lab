# Lab 01 · Contrato y contexto

**Objetivo:** completar `GetReviewStatus` usando reglas explícitas. **Tiempo:** 20 minutos en parejas. Una persona conduce y la otra cuestiona y revisa.

**Punto de partida:** starter, [contrato](../../contract.es.md) y skill de fechas de [`templates`](../../templates/README.md). **Entrega:** diff acotado y tabla de C01–C06 observados.

## Preparar las primitivas

1. Crea `.github/instructions`, `.github/prompts`, `.github/agents` y `.github/skills` en la raíz del repositorio.
2. Copia las [plantillas de primitivas](../../templates/primitives/README.md) a su destino y quita `.example`.
3. Copia `packages/october-workshop-primitives/.apm/instructions/workshop-al.instructions.md` a `.github/instructions/`. Fíjate en `applyTo: "**/*.al"`.
4. Copia `templates/plugin/skills/review-date-rules` a `.github/skills/review-date-rules`, renombra `SKILL.md.example` y conserva `boundary-cases.md`.
5. Abre una sesión nueva de chat y localiza el revisor y sus herramientas efectivas.

## Petición

> Lee el contrato de Customer Follow-up y las instrucciones aplicables. Completa únicamente GetReviewStatus. Mantén la fecha de referencia explícita y las validaciones existentes. Usa review-date-rules para revisar los límites. Devuelve el diff y distingue resultados ejecutados de comprobaciones pendientes.

## Pasos

1. Revisad el contrato y las instrucciones aplicables.
2. Completad la función y revisad el diff. `MarkReviewed` se queda pendiente.
3. Compilad y ejecutad C01–C06; guardad el resultado en `evidence/lab01-run-note.md` con la [ficha de ejecución](../../templates/evidence/run-note.md).

## Resultado esperado

Con fecha de referencia 15/10/2026: vacía → Sin programar; 14/10 → Vencida; 15/10 → Revisar hoy; 16/10 → Programada. Referencia vacía y fecha de cierre → error de validación. **Esperado y observado son dos columnas diferentes.**

Puesta en común: ¿qué decisión habría quedado implícita sin el contrato? ¿Qué instrucción o skill influyó en el cambio? ¿Qué prueba os obligó a corregir una suposición? Conservad esta implementación para el ciclo con ALDC.
