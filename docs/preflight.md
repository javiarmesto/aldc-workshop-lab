# Antes de la jornada

Si usas VS Code Insiders, sustituye `code` por `code-insiders` en los comandos de esta guía y utiliza siempre el mismo editor/perfil. APM 0.23.1 es la versión del ensayo Copilot; registra tu versión y comprueba su ayuda antes de los comandos del Lab 07.

La instalación se hace **antes** del taller. Si un paso falla, anota la operación, la versión y el mensaje: no lo des por resuelto.

## Qué necesitas

- VS Code actualizado con **GitHub Copilot Chat** (modo agente) y sesión iniciada. Es la única superficie de la jornada.
- Extensión **AL Language** y Git.
- **Node.js LTS**: el instalador de BCQuality del toolkit lo usa para leer `aldc.yaml`. Comprueba con `node --version`.
- **ALDC 5.0.0**: `code --install-extension javierarmestogonzalez.al-development-collection@5.0.0` y comprueba con `code --list-extensions --show-versions`.
- **APM** instalado: `apm --version` debe responder. [Instalación](https://microsoft.github.io/apm/).
- Un **sandbox de Business Central** (28.0 o posterior) con un usuario que pueda publicar extensiones y editar clientes. Comprueba que no tiene otra extensión con objetos en **71200–71349**.
- Acceso a **Microsoft Learn MCP** desde el chat.
- Opcional: [AI Engineer Coach](https://github.com/microsoft/AI-Engineering-Coach). No es necesario instalarlo para completar el Lab 03: se trabaja con Agent Debug Logs y el ponente muestra Coach en la demo.

## Preparar tu copia

1. Crea tu repositorio desde esta plantilla y clónalo. Clona BCQuality al lado en la revisión `07e324ddbc42597c479e041e06a7833740e05d0f` (ver [README](../README.md)).
2. Abre `aldc-workshop-lab.code-workspace`.
3. Copia `App/.vscode/launch.json.example` y `Test/.vscode/launch.json.example` como `launch.json` y pon tu tenant y tu sandbox. Ese archivo no se sube a Git.
4. Descarga símbolos y compila **App** primero; publícala en tu sandbox para que esté disponible como dependencia si Test la necesita. Después descarga símbolos y compila **Test**. Selecciona la carpeta/proyecto AL correcto en cada operación.
5. Instala la extensión **ALDC 5.0.0** indicada arriba y ejecuta **Developer: Reload Window**. La extensión y el toolkit del proyecto son pasos distintos. Abre **AL Collection: Open Project Manager**, selecciona **la raíz de tu copia** (no App, Test ni BCQuality), elige el perfil compatible con BC28 e instala el toolkit. `aldc.yaml` no viene en esta plantilla: comprueba que está en la raíz después de preparar el toolkit y que `solution.roots.application` es `App` y `solution.roots.test` es `Test`. Si falta, revisa el destino y el resultado de la instalación antes de continuar. Las apps usan BC28/runtime 16 aunque el sandbox sea BC29.
6. Añade BCQuality a `aldc.yaml` y ejecuta su instalador desde el toolkit:

```yaml
external:
  bcquality:
    mode: external-multiroot
    enabled: auto
    url: https://github.com/microsoft/BCQuality.git
    ref: main
    pinnedCommit: 07e324ddbc42597c479e041e06a7833740e05d0f
    home: ../bcquality
    entryPoint: skills/entry.md
    pilotSkills: []
```

7. Recarga la ventana y ejecuta **AL Collection: Run Doctor**. Comprueba que aparecen Architect, AL Spec Agent, Conductor y Developer Reviewer. Ejecuta `al-initialize` indicando: «Inicializa el contexto del proyecto existente: aplicación en App y tests en Test. No crees otra aplicación ni implementes los TODOs». Verifica que el agente puede leer `../bcquality/skills/entry.md`.
8. Revisa `git status` y el diff antes del commit `preparado para la jornada`: no incluyas `launch.json`, paquetes compilados, cachés ni credenciales.


## Qué queda preparado para los laboratorios

Al terminar este preflight, ALDC ya está instalado y su toolkit aporta agentes, instrucciones y skills al proyecto. No se instala por primera vez en el Lab 04.

Las primitivas del ejercicio son otro conjunto: la skill `review-date-rules`, el agente `followup-reviewer` y el prompt de revisión. En el Lab 01 las copias al proyecto; en el Lab 02 las empaquetas en un plugin y retiras únicamente esas copias locales; en el Lab 03 mejoras la skill del plugin. Conserva los archivos de ALDC.

Los primeros labs se realizan con ALDC presente: sus instrucciones y otras skills pueden influir en las respuestas. Registra las que se utilicen; no interpretes el Lab 03 como un experimento aislado. En el Lab 04 empezarás a utilizar explícitamente el flujo Architect → aprobación humana → Spec Agent.

## Ejecutar los tests

Los 12 tests están en la codeunit **71300 "OW Follow-up Tests"** de **Test**. No dependen de Library Assert.

### Ruta principal · Test Explorer de VS Code (BC28+)

1. Abre el workspace suministrado y confirma que incluye **App** y **Test**, con sus configuraciones de sandbox y símbolos preparados.
2. Abre la vista **Testing**. El explorador integrado de AL descubre los tests del workspace y los agrupa por app y codeunit. Localiza Test → 71300 → C01–C12.
3. Selecciona el perfil **Publish & Run** para la codeunit completa o los casos elegidos. Publica el proyecto de tests y sus dependencias modificadas antes de ejecutar. Tras cambiar código, no uses **Run** hasta haberlo publicado: ese perfil no publica.
4. Consulta **Test Results** y guarda en `evidence/` el commit o diff probado, versiones de AL/BC, perfil, casos ejecutados y resultados **observados**.

Esta ruta no ejecuta los tests bajo una codeunit TestRunner; no exige instalar la app Microsoft Test Runner como requisito general. Véase [la documentación de Microsoft](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-test-explorer-vscode).

Si no aparecen los tests, revisa que Test esté en el workspace, que AL Language esté activo y que no haya errores de carga/compilación. Si falla la ejecución, registra el mensaje y comprueba publicación, autenticación, entorno y compatibilidad; no atribuyas todos los fallos a un runner ausente.

### Alternativa · Runner preparado por los instructores

Si usas **AL Test Tool**, el sandbox necesita el toolkit/runner que proporciona esa página y sus dependencias. Confirma su disponibilidad con el instructor o administrador; no es un requisito de la ruta integrada anterior.

Publica **App** y después **Test** con **AL: Publish without debugging**, seleccionando el proyecto correspondiente. En el entorno preparado, abre **AL Test Tool** (130451), usa **Get Test Codeunits → Select Test Codeunits**, selecciona 71300 y ejecuta **Run All**. Si la página o las acciones no están disponibles, anota las versiones y solicita la preparación del runner; no instales paquetes al azar.

### Resultados esperados

| Etapa | Pasan | Fallan |
|---|---|---|
| Starter sin modificar | C01, C05, C06, C07, C08, C09, C10 | C02, C03, C04, C11, C12 |
| Tras Lab 01, suite completa | C01–C10 | C11, C12 |
| Tras Lab 05 / Directions Lab 2 | C01–C12 | Ninguno |

En el starter, C02–C04 indican estado `Unscheduled` donde se esperaba otro; C11 y C12 muestran `Workshop action pending implementation.`. Esta tabla expresa expectativas: registra aparte lo que realmente ocurra.

C12 crea un cliente sintético y contiene su borrado al final; un fallo puede impedir llegar a esa línea. Conserva el aislamiento de tests y comprueba la limpieza al usar otro runner. `TestPermissions = Disabled`: estos tests no demuestran los permisos de un usuario. No ejecutes en producción.

## Prueba breve

1. Pide al chat que lea `contract.es.md` y resuma entradas, salidas y decisiones que no debe adivinar.
2. Consulta un símbolo real de Customer y una página de Microsoft Learn.
3. Sigue [Ejecutar los tests](#ejecutar-los-tests) en tu sandbox: con el starter sin tocar deben fallar **exactamente C02, C03, C04, C11 y C12**.
4. Abre **Agent Debug Logs** desde el chat.

