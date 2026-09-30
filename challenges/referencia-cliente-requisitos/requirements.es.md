# Referencia del cliente antes de liberar un pedido

## Encargo de negocio

Algunos clientes exigen que sus pedidos incluyan la referencia que ellos nos facilitan. Cuando falta, el equipo pierde tiempo reclamándola y corrigiendo documentos. Queremos identificar qué clientes la requieren y detectar su ausencia antes de liberar un pedido de venta.

## Requisitos

1. Una persona con permisos podrá indicar en la ficha de un cliente que sus pedidos requieren una referencia. Para clientes que no se hayan configurado, el requisito estará desactivado.
2. La referencia se introducirá en el campo existente **N.º documento externo** del pedido. No se solicita otro campo para guardar el mismo dato.
3. Al intentar liberar un pedido de un cliente que requiere referencia, si está vacía o contiene solo espacios, la operación se rechazará con un mensaje que indique qué falta y cómo corregirlo.
4. Si se rechaza la liberación, el pedido no debe quedar liberado ni deben cambiar sus datos por esta regla. El usuario podrá completar la referencia y reintentar.
5. Si el cliente no requiere referencia, o si ya está informada, esta regla permitirá continuar. Las validaciones, permisos y aprobaciones habituales de Business Central seguirán aplicándose.
6. La comprobación debe utilizar el cliente y su configuración vigentes al intentar liberar. Un cambio de cliente o de configuración anterior a ese intento debe tenerse en cuenta.
7. El alcance de este incremento son los **pedidos de venta al liberar**. No se solicita un control general de registro, ni modificar ofertas, facturas, abonos, almacén o documentos ya registrados.
8. No se generarán referencias automáticamente, no se comprobará su unicidad y no se ampliarán permisos.

## Ejemplos de aceptación

Los pedidos de prueba deben cumplir los demás requisitos estándar para liberarse. Estos resultados son expectativas, todavía no ejecuciones.

| Caso | Situación | Resultado esperado de esta regla |
|---|---|---|
| R01 | Cliente sin requisito, referencia vacía | No impide continuar con la liberación. |
| R02 | Cliente con requisito, referencia vacía | Rechaza; mensaje claro; pedido sin liberar y sin cambios por esta regla. |
| R03 | Cliente con requisito, referencia ABC-123 | No impide continuar con la liberación. |
| R04 | Tras R02, el usuario informa ABC-123 y reintenta | No impide continuar con la liberación. |
| R05 | Cliente con requisito, referencia formada solo por espacios | Rechaza como referencia vacía. |
| R06 | Se cambia de un cliente sin requisito a otro que sí lo exige, referencia vacía | Rechaza al liberar. |
| R07 | Se cambia de un cliente que lo exige a otro que no, referencia vacía | Esta regla no bloquea. |
| R08 | Se activa el requisito del cliente después de crear el pedido y antes de liberarlo | Aplica la configuración actual y rechaza si falta referencia. |

Si el campo normaliza espacios al introducirlos, registra ese comportamiento y comprueba igualmente el resultado con el valor vacío.

## Aclaraciones que debe resolver una persona

Antes de cerrar la especificación, concretad qué significa «cliente» cuando el cliente de venta y el de facturación son distintos. Identificad también las vías de liberación incluidas en la demostración y cómo se comprobará su cobertura. No deis esas decisiones por aprobadas.

## Entrega

Preparad arquitectura y especificación revisables antes de implementar. Comprobad qué ofrece ya el estándar, justificad cualquier extensión y verificad los puntos de extensión contra la versión instalada.

Entregad el cambio, sus pruebas y una evidencia breve que distinga requisitos, inspección de código, compilación y ejecución real. Si algo no se ha podido comprobar, registrad el motivo.

**Roberto Corella y Javier Armesto · Companial 2026**
