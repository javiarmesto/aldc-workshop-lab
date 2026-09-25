# Demo integrada · una revisión de cliente

Roberto Corella y Javier Armesto. Duración del bloque: 15 minutos.

Preparar un cliente sintético, el código revisado publicado y una sesión con permiso habitual de edición de Customer más OW FOLLOWUP. Anotar la fecha de trabajo previa y restablecerla al terminar.

| Escena | Acción | Resultado esperado |
|---|---|---|
| 1 | Fijar Work Date a 15/10/2026 y abrir Customer Card | Grupo Customer follow-up visible. |
| 2 | Dejar próxima revisión vacía | Unscheduled / Sin programar. |
| 3 | Probar 14/10, 15/10 y 16/10 | Overdue, Due today y Scheduled. |
| 4 | Poner próxima fecha 31/12 y pulsar Mark as reviewed | Última 15/10 y próxima 14/11. |
| 5 | Repetir la acción el mismo día | Las fechas permanecen iguales. |
| 6 | Cerrar y volver a abrir la ficha | Fechas persistidas y estado recalculado. |
| 7 | Cambiar Work Date a 14/11 y reabrir la ficha | Due today. |

Comprobar además que un usuario sin permiso de modificación de Customer no puede ejecutar con éxito la actualización. TestPermissions=Disabled no comprueba ese permiso.

La interfaz y los textos AL suministrados están en inglés para compartir la misma app con Directions. La explicación de la jornada está en castellano. Si se usa grabación, identificarla como ensayo previo con revisión y entorno.
