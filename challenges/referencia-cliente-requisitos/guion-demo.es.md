# Guion para explicar ALDC con la referencia del cliente

## Antes de mostrar código

Abre un proyecto vacío preparado según el [README](README.md) y muestra el [encargo de negocio](requirements.es.md). Explica: «Queremos detectar una referencia que falta antes de liberar un pedido. Vamos a decidir primero qué necesitamos cambiar».

Para una demostración breve, deja el entorno y los símbolos preparados. Como orientación, reserva 15–20 minutos para recorrer encargo, diseño y especificación; la implementación y el ensayo necesitan tiempo adicional según el entorno y las respuestas. No prometas un desarrollo completo en ese tiempo sin haberlo ensayado.

## 1. Architect contrasta y pregunta

Utiliza la petición inicial del README. Pide que el agente identifique qué conoce por documentación, qué ha comprobado en los símbolos instalados y qué sigue pendiente.

**Punto didáctico:** no toda petición de negocio requiere código nuevo. Microsoft documenta una configuración general de obligatoriedad del documento externo que afecta al registro. Este encargo pide una regla por cliente en la liberación de pedidos; el agente debe justificar qué parte cubre el estándar en el entorno real y qué parte necesita ampliar.

Fuente: [External document numbers en Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/sales-how-invoice-sales#external-document-numbers). La documentación no prueba por sí sola que un evento concreto exista o cubra todas las vías de liberación.

**Pregunta a los asistentes:** «Si el pedido se vende a una empresa y se factura a otra, ¿qué cliente manda?».

Antes de seguir, revisa la propuesta. Para mantener pequeño este ejemplo, puedes aprobar estas decisiones:

- La regla consulta al **cliente de venta** actual del pedido.
- Se consulta su configuración vigente al intentar liberar, sin guardar una copia de la opción en el pedido.
- La demostración cubre la liberación manual desde el pedido y las llamadas al proceso estándar de liberación que el diseño identifique y los tests comprueben.
- No se afirma cobertura de todos los canales, aprobaciones, APIs o registro directo sin verificarlos. El requisito no es un bloqueo universal de registro.

Son decisiones propuestas para el ensayo; registra tu aprobación explícita. Si el análisis revela que no son viables, vuelve al requisito y acuerda el cambio.

## 2. Spec Agent convierte decisiones en un contrato

Entrega al agente de especificación el requisito, la arquitectura y la aprobación real. Que resuelva los casos R01–R08 y concrete los efectos de un error, los permisos, la versión y las comprobaciones de cobertura.

Petición orientativa:

> Prepara la especificación a partir del requisito y de la arquitectura aprobada. Incluye las decisiones humanas registradas, casos de aceptación y comprobaciones técnicas. Si encuentras una contradicción o necesitas cambiar la arquitectura, indícalo y detente antes de darla por aprobada. No implementes AL.

**Qué mostrar:** una decisión de arquitectura convertida en una prueba. Por ejemplo, cambiar el cliente del pedido obliga a consultar al cliente actual.

**Decisión humana:** aprueba o devuelve la especificación. La existencia de un documento no equivale a su aprobación.

## 3. Developer implementa el alcance aprobado

Selecciona el agente de desarrollo definido en tu instalación ALDC y entrega las rutas reales de los artefactos aprobados.

> Implementa el incremento de la especificación aprobada y prepara las pruebas. Verifica los símbolos y firmas reales; no inventes eventos. Si necesitas modificar una decisión de diseño o el alcance, propón el cambio antes de aplicarlo. Resume archivos modificados, compilaciones y pruebas realmente ejecutadas, con sus limitaciones.

Los nombres de objetos, eventos e IDs se resuelven con los símbolos del proyecto. Este material no proporciona una solución de referencia.

**Qué observar:** que la implementación siga lo aprobado y que los tests prueben el flujo de liberación elegido, además de cualquier función auxiliar. Una comprobación solo en la interfaz no demuestra cobertura del proceso estándar.

## 4. Reviewer revisa contra el contrato

Entrega al revisor el cambio verificable, los artefactos aprobados y los resultados reales.

> Revisa el diff frente al requisito y la especificación aprobada. Comprueba alcance, cliente consultado, error sin cambios parciales, permisos y cobertura del punto de liberación. Aplica los criterios BCQuality pertinentes si están disponibles y cita sus fuentes reales. Distingue inspección estática, compilación y pruebas ejecutadas. No inventes resultados ni modifiques código durante la revisión.

**Qué mostrar:** un criterio relacionado con una decisión y una evidencia concreta. No es obligatorio encontrar defectos; sí explicar qué se ha comprobado.

## 5. Demuestra el comportamiento

Prepara en un sandbox dos clientes de prueba y pedidos válidos para liberar. Anota previamente las configuraciones estándar que puedan afectar al resultado; no las cambies para hacer pasar un caso.

1. Cliente que exige referencia, pedido abierto sin ella: intenta liberar y comprueba mensaje, estado y ausencia de cambios por la regla.
2. Completa la referencia en el mismo pedido: reintenta y comprueba el resultado.
3. Cliente sin el requisito, referencia vacía: verifica que esta regla no bloquea. Cualquier otro error estándar se registra por separado.
4. Cambia de cliente en un pedido abierto y vuelve a probar. No presupongas cómo se conservan los datos al cambiarlo: observa el valor final y prepara las precondiciones del caso.

R01–R08 son expectativas, no una suite ya ejecutada. Si no hay tiempo o acceso, muestra hasta dónde has llegado y registra el bloqueo.

## Evidencia mínima del ejercicio

Guarda una nota en `evidence/demo-referencia-cliente.md` con:

- Versión de BC, app/commit y configuración relevante del sandbox.
- Rutas de requisito, arquitectura y especificación; decisiones aprobadas y por quién.
- Casos comprobados, resultado esperado y observado, operación utilizada y autor de la ejecución.
- Resultado de la revisión, fuentes y límites de cobertura.
- Pendientes para que otra persona pueda reproducirlo.

Cierra preguntando: «¿Podemos explicar por qué funciona y qué hemos comprobado, además de enseñar el código?».

**Roberto Corella y Javier Armesto · Companial 2026**
