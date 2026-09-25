# Lab 03 · Una mejora observable

**Objetivo:** mejorar una ejecución a partir de lo que ha ocurrido. **Tiempo:** 13 minutos. **Punto de partida:** sesión del plugin y registros disponibles. **Entrega:** comparación antes/después con un cambio identificable.

## Qué mirar en una sesión

Archivos consultados, skill o agente invocado, llamada de herramienta, salida o error y diff. El lab se hace con **Agent Debug Logs** (menú del chat). **AI Engineer Coach** es opcional: si lo tienes instalado, usa Context Health, Anti-Patterns y Skill Finder como fuente adicional de señales; si no, el ponente lo enseña en la demo.

## Pasos

1. Localiza una señal en Agent Debug Logs (o en Coach, si lo tienes).
2. Cambia una sola instrucción o una petición concreta (por ejemplo, cuándo debe activarse `review-date-rules`).
3. Repite la tarea en una sesión nueva y compara operaciones y salida.

Completa [`material/before-after.md`](../material/before-after.md) y guárdalo como `evidence/lab03-before-after.md`. Si el efecto no aparece, anótalo así. Un indicador de Coach no sustituye a compilar o ejecutar tests.
