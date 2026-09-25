# Lab 01 · Contrato y contexto

**Objetivo:** completar `GetReviewStatus` usando reglas explícitas. **Tiempo:** 20 minutos en parejas. Una persona conduce y la otra cuestiona y revisa.

**Punto de partida:** starter, [contrato](../../contract.es.md) y skill de fechas de [`templates`](../../templates/README.md). **Entrega:** diff acotado y tabla de C01–C06 observados.

## Preparar las primitivas

Desde la raíz de tu copia, ejecuta el [script de preparación](../../tools/Prepare-Lab01.ps1):

```powershell
./tools/Prepare-Lab01.ps1
```

Automatiza las copias de los pasos 1–4 y conserva las instrucciones de ALDC. Si ya preparaste las primitivas, no necesitas repetirlo. Revisa qué hace cada paso a continuación; puedes realizar las mismas operaciones manualmente. [Ayuda de los scripts](../../tools/README.md).

1. Crea `.github/instructions`, `.github/prompts`, `.github/agents` y `.github/skills` en la raíz del repositorio.
2. Copia las [plantillas de primitivas](../../templates/primitives/README.md) a su destino y quita `.example`. **No sobrescribas `.github/copilot-instructions.md`**: lo ha instalado ALDC en el preflight. Las convenciones del taller van en `.github/instructions/workshop-project.instructions.md`.
3. Copia `packages/october-workshop-primitives/.apm/instructions/workshop-al.instructions.md` a `.github/instructions/`. Fíjate en `applyTo: "**/*.al"`.
4. Copia `templates/plugin/skills/review-date-rules` a `.github/skills/review-date-rules`, renombra `SKILL.md.example` y conserva `boundary-cases.md`.
5. Abre una sesión nueva de chat y localiza el revisor y sus herramientas efectivas.

## Petición

> Lee el contrato de Customer Follow-up y las instrucciones aplicables. Completa únicamente GetReviewStatus. Mantén la fecha de referencia explícita y las validaciones existentes. Usa review-date-rules para revisar los límites. Devuelve el diff y distingue resultados ejecutados de comprobaciones pendientes.

## Pasos

1. Revisad el contrato y las instrucciones aplicables.
2. Completad la función y revisad el diff. `MarkReviewed` se queda pendiente.
3. Compilad y ejecutad C01–C06 siguiendo [cómo ejecutar los tests](../../docs/preflight.md#ejecutar-los-tests); guardad el resultado en `evidence/lab01-run-note.md` con la [ficha de ejecución](../../templates/evidence/run-note.md).

4. Ejecutad después C01–C12 para comprobar el estado completo: deben pasar C01–C10 y fallar solo C11 y C12. Registrad el resultado observado; ejecutar únicamente C01–C06 no demuestra el estado de los otros seis casos.
5. Comprobad que el diff del lab no modifica `.github/copilot-instructions.md` y que existen `workshop-al.instructions.md` y `workshop-project.instructions.md` en `.github/instructions/`. En una sesión nueva, inspeccionad las instrucciones usadas en una tarea AL; distinguid archivos presentes de contexto realmente aplicado.

## Resultado esperado

Con fecha de referencia 15/10/2026: vacía → Sin programar; 14/10 → Vencida; 15/10 → Revisar hoy; 16/10 → Programada. Referencia vacía y fecha de cierre → error de validación. **Esperado y observado son dos columnas diferentes.**

Puesta en común: ¿qué decisión habría quedado implícita sin el contrato? ¿Qué instrucción o skill influyó en el cambio? ¿Qué prueba os obligó a corregir una suposición? Conservad esta implementación para el ciclo con ALDC.

## Agente y cierre guiado

Usa un chat nuevo en modo **Agent** con lectura y edición de App y acceso a la skill local. El agente Follow-up Reviewer sirve para revisar; no le encargues implementar si su contrato es solo lectura. El prompt de la sección Petición es el inicio del ejercicio.

Después de ejecutar los tests, sustituye los marcadores por tus resultados y pide:

```text
Documenta el Lab 01 en evidence/lab01-run-note.md.
He ejecutado <casos> en <entorno> mediante <operación>.
Resultados observados: <resultados y errores reales>.
Distingue mis ejecuciones de tus comprobaciones estáticas.
Indica qué instrucciones y skill se utilizaron. No implementes
MarkReviewed, no cambies tests ni cases.csv y no hagas operaciones Git.
```

Esperamos un diff limitado a GetReviewStatus y las primitivas preparadas, con evidencia de C01–C10 correctos y C11–C12 pendientes cuando hayas ejecutado la suite completa.

## Guardar el laboratorio

Guarda la evidencia indicada y revisa los archivos antes del commit. Los comandos los ejecutas tú desde la raíz; el agente no necesita permisos de escritura en Git.

```powershell
git status --short
git add -- App/src/CustomerFollowUpMgt.Codeunit.al
git add -- .github/instructions/workshop-project.instructions.md
git add -- .github/instructions/workshop-al.instructions.md
git add -- .github/prompts/review-followup.prompt.md
git add -- .github/agents/followup-reviewer.agent.md
git add -- .github/skills/review-date-rules/
git add -- evidence/lab01-run-note.md
git diff --cached --stat
git diff --cached
git commit -m "docs: cerrar Lab 01"
git push
git rev-parse HEAD
```

Si aún no hay upstream, usa `git push -u origin <tu-rama>`. No ejecutes el commit si el área preparada incluye cambios ajenos al lab; retíralos del staging sin borrar tu trabajo. No incluyas configuración personal, paquetes, cobertura ni telemetría.
