# Lab 04 · Requisito a especificación

**Objetivo:** obtener una especificación que otra persona pueda revisar. **Tiempo:** 20 minutos + 6 de revisión cruzada. **Punto de partida:** contrato, starter, ALDC y BCQuality montado. **Entrega:** arquitectura, spec, criterios citados y decisiones pendientes visibles.

## Comprobar prerrequisitos

Desde la raíz del repositorio, ejecuta el [helper de este lab](../../tools/Test-Lab04.ps1):

```powershell
./tools/Test-Lab04.ps1
```

Lee sus resultados antes de continuar. No instala ni modifica el entorno; distingue archivos presentes de comprobaciones manuales dentro del agente. [Parámetros y estados](../../tools/README.md#helpers-de-comprobación).

## De dónde vienes y qué cambia ahora

En el Lab 03 mejoraste una instrucción del plugin y observaste su efecto. Ahora vas a convertir un requisito en una arquitectura y una especificación revisables. Al terminar este lab habrás completado cuatro de los ocho laboratorios.

ALDC y sus primitivas ya están preparados desde el preflight. No necesitas reinstalarlos ni restaurar las copias locales del ejercicio. Continúa en tu workspace y rama de trabajo, con GetReviewStatus resuelto y MarkReviewed pendiente.

Abre un chat nuevo y selecciona **al-architect**. Primero pide la arquitectura y revisa su respuesta. Solo después de aprobarla utiliza **al-spec.create**. La implementación corresponde al Lab 05.

Para el diseño, consulta BCQuality como conocimiento desde la carpeta del workspace; identifica las fuentes realmente leídas y las limitaciones de acceso. Conserva la implementación existente de GetReviewStatus al especificar el comportamiento completo.

## Comprobar herramientas antes de empezar

Con **al-architect** seleccionado, comprueba lectura del proyecto, BCQuality y herramientas AL de símbolos. Guarda los cambios de herramientas y abre otra sesión si los acabas de ajustar.

```text
Comprueba tu acceso a símbolos AL consultando Table Customer.
Si la herramienta requiere cargar paquetes, carga los del proyecto App
y repite la consulta. Devuelve herramienta, parámetros y resultado.
Si no puedes, indica la limitación concreta sin inventar su causa.
No modifiques código ni confundas consultar símbolos con compilar App.
```


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

## Aprobar arquitectura y especificación

Después de leer la arquitectura, resuelve las decisiones abiertas. Para el alcance estándar del taller:

```text
Apruebo la arquitectura revisada para el taller, sin eventos nuevos
OnBefore/OnAfter. Registra mi aprobación y la evidencia de fuentes
y símbolos realmente consultados. No implementes ni delegues código.
```

Ejecuta después **al-spec.create** con la petición de esta guía. Esperamos entradas, validaciones, efectos, persistencia y C01–C12, sin nuevos objetos ni código. starter_expected conserva la referencia del starter original; no se actualiza ni es una discrepancia tras Lab 01.

Tras revisarla, utiliza solo si estás de acuerdo:

```text
Apruebo la especificación revisada. Registra la aprobación y actualiza
su estado y memory.md. El siguiente paso docente será Conductor en
el Lab 05, aunque el incremento sea LOW. No cambies su complejidad
ni inicies implementación. Si hay conflicto de instrucciones, indícalo.
```


## Guardar el Lab 04

Localiza los documentos bajo el plans.root real de aldc.yaml. Añade explícitamente arquitectura, especificación, selección y criterios BCQuality, aprobación y memory.md. No añadas toda .github/plans porque puede contener telemetría.

```powershell
git status --short
# Repite esta línea para cada archivo real del Lab 04:
git add -- '<ruta-del-documento>'
git diff --cached
git commit -m "docs: aprobar arquitectura y especificacion del Lab 04"
git push
git rev-parse HEAD
```

El SHA identifica tu especificación aprobada. Publicar checkpoints reutilizables es tarea del instructor; no bloquea tu paso al Lab 05.


Si necesitas una etapa preparada para continuar, utiliza [checkpoint/spec-aprobada](../../docs/checkpoints.md) en otra carpeta y registra su procedencia.
