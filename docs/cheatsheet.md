# Hoja de referencia · ALDC y agentes de código

| Necesito… | Pieza que considerar | Qué comprobar |
|---|---|---|
| Convenciones persistentes del proyecto | Instrucciones | Alcance y ausencia de reglas contradictorias |
| Repetir una tarea | Prompt | Entrada y resultado solicitados |
| Reutilizar un procedimiento | Skill | Descripción de activación y recursos |
| Especializar responsabilidad | Agente personalizado | Lista efectiva de herramientas |
| Consultar o actuar | Herramienta nativa o MCP | Entrada, retorno y permisos |
| Ejecutar una acción en un evento | Hook | Evento soportado y efecto concreto |
| Compartir capacidades | Plugin | Formato, componentes y activación |

## Elegir flujo ALDC

Cambio acotado: `al-spec.create` → AL Implementation Specialist.

Trabajo MED/HIGH: AL Architecture & Design Specialist → `al-spec.create` → AL Development Conductor, con planificación, implementación y revisión.

Antes de elegir, identifica responsabilidades, archivos compartidos y evidencia necesaria. La coordinación tiene valor cuando responde a dependencias y responsabilidades reales.

## Herramientas

Microsoft Learn MCP: documentación oficial. Herramientas AL del chat: símbolos y operaciones sobre el proyecto. AL MCP de desarrollo: acceso desde otros clientes cuando corresponda. El MCP de Business Central para datos y acciones tiene otra finalidad. BCQuality aporta conocimiento al diseño, la especificación y la revisión; se monta antes del arquitecto en este taller.

## Cuatro preguntas de observación

¿Qué se descubrió? ¿Qué se invocó? ¿Qué cambió? ¿Qué se verificó?

Agent Debug Logs permite seguir eventos; Chat Debug inspecciona solicitudes. AI Engineer Coach añade Context Health, Anti-Patterns y Skill Finder. Un indicador del Coach necesita interpretación; una compilación o un test aporta evidencia técnica distinta.

## Evidencia mínima de una entrega

Contrato y revisión utilizados, commit o diff, versión y entorno, operación ejecutada, resultado real y límites de lo comprobado. Una prueba no ejecutada se registra como pendiente. Una traza anterior se conserva como historia, no como prueba del código actual.


## APM y BCQuality

APM distribuye las primitivas que soporta el destino elegido. El manifiesto declara la dependencia y el lockfile generado fija su resolución. Usa `--target copilot` o `--target claude` en la ficha de instalación. [Lab 07](../labs/jornada/07-contexto-como-dependencia.md).

BCQuality informa decisiones del arquitecto y criterios del Spec Agent que se retoman en revisión. Comprueba lectura, selección, aplicación y estado de ejecución por separado. Conserva aparte la evidencia de compilación y tests. [Lab 06](../labs/jornada/06-revision-citada.md).

