# Lab 03 · Una mejora observable

**Objetivo:** mejorar una revisión a partir de una señal real y comparar el resultado. **Tiempo:** 13 minutos. **Punto de partida:** plugin del Lab 02, respuesta de revisión y registros disponibles. **Entrega:** `evidence/lab03-before-after.md` con una única modificación y sus efectos observados.

## Qué vas a conseguir

En el Lab 02 comprobaste que el plugin se carga y se utiliza. Ahora vas a revisar cómo interpreta el contexto, cambiar una instrucción concreta y repetir la misma tarea. El objetivo es aprender a justificar una mejora con evidencia.

Usa **Agent Debug Logs** (menú del chat) para inspeccionar lecturas, herramientas, retornos y errores. **AI Engineer Coach** es opcional: si lo tienes, Context Health, Anti-Patterns y Skill Finder pueden aportar señales adicionales; si no, el ponente lo enseña en la demo. Puedes completar todo el lab sin Coach.

## 1. Elige una señal y conserva el antes · 3 minutos

Revisa la respuesta del Lab 02. En el ensayo del 25/09/2026, el revisor sugirió comprobar si había que cambiar `starter_expected` de `fail` a `pass` para C02–C04 después de implementar GetReviewStatus.

Esa columna describe deliberadamente **el starter original**. Los resultados de cada etapa se guardan en `evidence/`; no hay que actualizar `cases.csv` al resolver un TODO. La función puede ser correcta aunque sus resultados difieran de `starter_expected`.

Si tu revisión contiene esa sugerencia, guarda el fragmento literal o una captura como evidencia inicial. Anota la hipótesis: «Aclarar el significado de starter_expected en la skill evitará recomendar un cambio en esa columna».

**Si tu revisor ya lo interpretó correctamente**, no inventes el fallo ni provoques cambios incorrectos en el CSV. Puedes añadir la misma aclaración como refuerzo y registrar que no había defecto inicial; o elegir otra señal real del Lab 02 y modificar una sola instrucción relacionada. No es obligatorio obtener la misma respuesta que el ensayo.

## 2. Cambia una sola instrucción · 3 minutos

Abre la skill de la copia de trabajo del plugin que preparaste en el Lab 02:

```text
C:\Workshops\review-dates-lab\skills\review-date-rules\SKILL.md
```

Adapta la ruta si usaste otra carpeta. Añade al final:

```markdown
## Interpretar los casos del taller

En cases.csv, la columna starter_expected describe el resultado esperado
del starter original, antes de resolver los TODOs. No debe actualizarse
al completar un laboratorio. Contrasta el comportamiento actual con el
contrato y los resultados esperados de la etapa; registra los resultados
observados en evidence/. No presentes la diferencia respecto a
starter_expected como un defecto del código ni del archivo de casos.
```

Guarda el archivo y conserva el fragmento añadido en tu evidencia: el plugin está fuera del repositorio, por lo que un commit del proyecto no guarda automáticamente esa edición.

Mantén el mismo código AL, tests, CSV y prompt de revisión. No modifiques también la plantilla original de `templates/plugin` durante esta comparación. Si elegiste otra señal real, sustituye este cambio por una instrucción que trate esa señal y documenta cuál.

## 3. Repite la revisión · 4 minutos

Recarga la ventana y abre un **chat nuevo**. Repite exactamente el prompt del Lab 02, sin adelantar al revisor la conclusión que esperas:

> Revisa GetReviewStatus de Customer Follow-up usando la skill review-date-rules del plugin review-dates-lab. Contrasta el código con contract.es.md y los casos límite. No modifiques archivos. Indica el origen y la ruta de la skill utilizada, los hallazgos y las comprobaciones pendientes. Consulta además mediante Microsoft Learn MCP la API WorkDate y explica su relación con la fecha explícita que recibe esta función. Si no puedes acceder a la skill o al MCP, indícalo.

Conserva el mismo modelo y herramientas si es posible; registra cualquier diferencia. Comprueba en las lecturas de la sesión o en Agent Debug Logs la ruta y el contenido de la skill usada.

Si la instalación utiliza una copia distinta de la carpeta editada y sigue leyendo el contenido anterior, actualiza o vuelve a instalar el plugin desde su fuente mediante Personalización. Abre otra sesión y comprueba la lectura antes de comparar. No añadas un segundo registro del mismo plugin. Si no consigues cargar el cambio, registra el bloqueo: todavía no se ha probado la nueva instrucción.

## 4. Compara y guarda · 3 minutos

Copia [la ficha antes/después](../material/before-after.md) a `evidence/lab03-before-after.md` y complétala:

| Pregunta | Qué comprobar |
|---|---|
| ¿Se utilizó la modificación? | Ruta y lectura del contenido actualizado |
| ¿Cambió la interpretación? | Distingue starter original y estado posterior al Lab 01 |
| ¿Desapareció la recomendación incorrecta? | Fragmentos de ambas respuestas, si existía esa recomendación |
| ¿Se respetó el alcance? | Sin cambios en código, tests ni CSV |
| ¿Qué queda sin demostrar? | Compilación, tests y consistencia entre ejecuciones |

Guarda el cambio exacto de la skill y referencias a las respuestas antes/después. Puedes concluir «mejoró en esta ejecución», «no se observó cambio», «no había defecto inicial» o «la nueva instrucción no llegó a cargarse», según la evidencia.

**Una ejecución no demuestra consistencia general ni causalidad por sí sola.** Un indicador de Coach o una revisión estática tampoco sustituye a compilar o ejecutar tests.

## Qué conservas para el siguiente lab

La skill mejorada en tu plugin de trabajo y la comparación en `evidence/`. Revisa y guarda la evidencia en Git antes de pasar al Lab 04. No necesitas completar MarkReviewed en este laboratorio.

## Paso al Lab 04

ALDC lleva instalado desde el preflight; ahora comenzarás a utilizar expresamente su flujo de arquitectura y especificación. Conserva el plugin y abre un chat nuevo con **al-architect**, siguiendo la [guía del Lab 04](04-requisito-a-especificacion.md). No necesitas crear un checkpoint de recuperación para continuar: esas ramas las prepara el instructor.

Para comparar este lab, utiliza la respuesta real del Lab 02, no una sesión antigua con otras primitivas. Ambas revisiones pueden haber usado ya el plugin. Basta con conservar las respuestas y comprobar las lecturas pertinentes; no hace falta una búsqueda extensa por el historial de sesiones. Si intervienen otras skills, instrucciones o herramientas, anótalo como una limitación de la comparación.
