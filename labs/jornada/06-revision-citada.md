# Lab 06 · Revisión citada

**Objetivo:** seguir un criterio desde su fuente hasta la decisión. **Tiempo:** 16 minutos. **Punto de partida:** spec, `.bcq-criteria.json`, diff y resultados. **Entrega:** criterio, fuente, aplicación, resultado y decisión.

## Petición

> Toma un criterio BCQuality declarado en nuestra especificación. Localiza su fuente y comprueba si aplica al diff. Explica qué observas y devuelve met, unmet o not evaluated con evidencia. Si propones una corrección, indica qué comprobar después. No inventes una ejecución.

## Una cita tiene que explicar una decisión

1. **Fuente:** ¿existe el archivo o sección citada en `../bcquality`?
2. **Aplicabilidad:** ¿se refiere a este cambio y a su contexto?
3. **Comprobación:** ¿qué parte del diff se ha revisado?
4. **Resultado:** met, unmet o not evaluated. «No evaluado» es un resultado válido; una ejecución inventada no lo es.

Si cambias código, repite la compilación y los casos afectados antes de decidir. Guarda la ficha en `evidence/lab06-bcquality.md`.

| Evidencia | Permite evaluar | No resuelve por sí sola |
|---|---|---|
| Criterio citado | Regla y aplicabilidad | Comportamiento ejecutado |
| Revisión del diff | Implementación frente al criterio | Todas las rutas de ejecución |
| Compilación | Validez para el compilador | Reglas de negocio |
| Tests y recorrido | Casos ejecutados | Todo escenario posible |
