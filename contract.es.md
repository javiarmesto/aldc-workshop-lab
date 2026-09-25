# Customer Follow-up · contrato docente v1

Coautores: Roberto Corella y Javier Armesto. Caso original del workshop.

## Requisito

El equipo comercial quiere identificar qué clientes debe revisar. En Customer Card puede indicar la próxima revisión, consultar su estado y marcar una revisión realizada. La acción registra la fecha de trabajo de BC y programa la siguiente a 30 días naturales.

## Decisiones de negocio del alcance base

- Dos campos en Customer: `OW Last Review Date` y `OW Next Review Date`. La última revisión es de lectura en la ficha. La próxima fecha se puede editar o dejar vacía.
- `GetReviewStatus(NextReviewDate, AsOfDate)` calcula el estado. Recibe la fecha de referencia explícita, sin leer el reloj ni modificar registros.
- Sin próxima fecha (`0D`): `Unscheduled` / Sin programar. Fecha anterior a la referencia: `Overdue` / Vencida. Misma fecha: `DueToday` / Revisar hoy. Posterior: `Scheduled` / Programada.
- La fecha de referencia/revisión es obligatoria. Las fechas de cierre contable quedan excluidas. Los ayudantes de validación ya vienen preparados.
- La interfaz pasa `WorkDate()` de la sesión. Los tests pasan fechas fijas. El estado se calcula al abrir/actualizar la ficha y tras editar la fecha o ejecutar la acción; no se almacena en Customer.
- `MarkReviewed(Customer, ReviewDate)` actualiza última revisión a ReviewDate y próxima a ReviewDate + 30 días naturales. Cuenta desde la revisión realizada, aunque la planificación anterior sea distinta. No significa un mes ni días laborables.
- Se permite una revisión anticipada. Repetir la acción con la misma fecha deja las mismas fechas. Si se usa una fecha de trabajo anterior, se registra esa fecha explícita; no se comprueba orden cronológico respecto a la última ejecución en este alcance docente.
- La acción conserva el resto de campos y persiste los cambios. No eleva permisos. El usuario necesita su acceso habitual de edición a Customer y el permiso de ejecución del workshop.
- El alcance base no incluye historial, avisos por email, tareas programadas, reglas de bloqueo ni documentos de venta. El historial queda como ampliación opcional fuera del horario principal.

## Ejemplo común

Fecha de referencia: **15 de octubre de 2026**. Próxima revisión vacía → Sin programar; 14/10 → Vencida; 15/10 → Revisar hoy; 16/10 → Programada. Marcar revisado el 15/10 deja última 15/10 y próxima **14/11/2026**. Repetir ese día mantiene 14/11.

## Implementación suministrada y trabajo del asistente

El starter incluye campos, enum, extensión de ficha, permisos, ayudantes de validación/cálculo de 30 días y 12 tests AL. El asistente completa dos TODOs de `CustomerFollowUpMgt.Codeunit.al`: selección del estado y actualización persistente del cliente. Puede proponer otra implementación que satisfaga el contrato, preservando las interfaces utilizadas por la ficha y los tests.

## Aceptación y evidencia

`cases.csv` define C01–C12. En el starter se esperan pendientes/fallidos C02, C03, C04, C11 y C12. La referencia debe superar los 12. Esta tabla describe expectativas, no resultados ejecutados. La comprobación de interfaz y permisos se realiza además con el usuario de la demo. La compilación y ejecución en sandbox están pendientes de registrar.

Fuentes técnicas: [WorkDate](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/system/system-workdate-method), [Date y 0D](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/date/date-data-type), [extensión de Customer](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-extension-example). Las reglas comerciales anteriores son decisiones del ejercicio.
