# Mini reto desde cero con ALDC · Referencia del cliente

Una regla pequeña para explicar el recorrido completo de ALDC: entender un encargo, contrastar el estándar, decidir, especificar, implementar y revisar. El objetivo es impedir la liberación de determinados pedidos si falta la referencia del cliente.

- [Encargo y casos de aceptación](requirements.es.md): el único contenido funcional que recibe el agente al comenzar.
- [Guion de demostración](guion-demo.es.md): apoyo para quien presenta, con pausas y decisiones.
- [Volver a los retos y al workshop](../../README.md#reto-opcional-desde-requisitos).

Es un ejemplo independiente de Customer Follow-up y de los ocho laboratorios. Se entrega sin objetos AL, arquitectura resuelta, especificación técnica ni tests preescritos.

## Preparar un proyecto vacío

Parte de un equipo con VS Code/Insiders, AL Language, ALDC y acceso a un sandbox, según el [preflight del taller](../../docs/preflight.md).

1. Crea un proyecto independiente, por ejemplo en `C:\Workshops\referencia-cliente`, con **AL: Go!** desde la paleta de comandos. No lo crees dentro de tu copia de los laboratorios.
2. Retira únicamente el ejemplo `HelloWorld.al` recién generado. Conserva el manifiesto y configura la conexión a tu sandbox. Revisa identidad de la app, versión de destino y un rango de objetos libre.
3. Copia [requirements.es.md](requirements.es.md) a la raíz del nuevo proyecto. No copies el starter, los tests ni el contrato de Customer Follow-up.
4. Abre **AL Collection: Open Project Manager** y prepara el toolkit sobre este nuevo proyecto. Comprueba que `aldc.yaml` apunta a la carpeta AL real. Si usas BCQuality, configura la ruta real del corpus según el taller.
5. Descarga símbolos y comprueba el acceso desde el agente que vas a usar. Si necesitas MCP, utiliza la configuración de tu entorno y comprueba cada conexión; este reto no distribuye ni modifica `.vscode/mcp.json`.

El proyecto de pruebas se decidirá y preparará durante el diseño y la implementación. No reutilices los rangos del starter si sus extensiones siguen publicadas en tu sandbox.

Guía oficial del arranque AL: [Get started with AL](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-get-started).

## Primera petición

Selecciona **AL Architect** y abre una sesión nueva:

> Lee las instrucciones ALDC del proyecto y requirements.es.md. Primero contrasta el encargo con el estándar de la versión instalada. Identifica las dudas de negocio, comprueba los símbolos y puntos de extensión que necesites y propón una arquitectura mínima. No implementes código. Señala qué decisiones necesitan mi aprobación y qué no has podido verificar.

La siguiente acción depende de lo que devuelva el agente. Usa [el guion](guion-demo.es.md) para conducir la conversación; no encadenes prompts sin revisar sus resultados.

## Qué debes poder enseñar al terminar

Un pedido que se bloquea cuando falta la referencia y que puede continuar tras completarla; otro cliente al que no se aplica esta regla; y el vínculo entre requisito, decisión humana, especificación, cambio y evidencia.

El material está preparado para desarrollar y ensayar. No contiene una implementación compilada ni una ejecución validada en Business Central.

**Roberto Corella y Javier Armesto**
