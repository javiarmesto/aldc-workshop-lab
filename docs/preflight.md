# Antes de la jornada

La instalación se hace **antes** del taller. Si un paso falla, anota la operación, la versión y el mensaje: no lo des por resuelto.

## Qué necesitas

- VS Code actualizado con **GitHub Copilot Chat** (modo agente) y sesión iniciada. Es la única superficie de la jornada.
- Extensión **AL Language** y Git.
- **ALDC 5.0.0**: `code --install-extension javierarmestogonzalez.al-development-collection@5.0.0` y comprueba con `code --list-extensions --show-versions`.
- **APM** instalado: `apm --version` debe responder. [Instalación](https://microsoft.github.io/apm/).
- Un **sandbox de Business Central** (28.0 o posterior) con un usuario que pueda publicar extensiones y editar clientes. Comprueba que no tiene otra extensión con objetos en **71200–71349**.
- Acceso a **Microsoft Learn MCP** desde el chat.
- Opcional: [AI Engineer Coach](https://github.com/microsoft/AI-Engineering-Coach) para el Lab 03.

## Preparar tu copia

1. Crea tu repositorio desde esta plantilla y clónalo. Clona BCQuality al lado en la revisión `07e324ddbc42597c479e041e06a7833740e05d0f` (ver [README](../README.md)).
2. Abre `aldc-workshop-lab.code-workspace`.
3. Copia `App/.vscode/launch.json.example` y `Test/.vscode/launch.json.example` como `launch.json` y pon tu tenant y tu sandbox. Ese archivo no se sube a Git.
4. **AL: Download symbols** en App y Test. Compila App y después Test.
5. En la raíz: **AL Collection: Open Project Manager** → perfil compatible con BC28 → instalar el toolkit. Revisa que `aldc.yaml` apunta a `App` y `Test`.
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

7. **AL Collection: Run Doctor** y `al-initialize` sobre el proyecto existente (no crees otra app). Recarga y comprueba que aparecen Architect, AL Spec Agent, Conductor y Developer Reviewer.
8. Haz commit: `preparado para la jornada`.

## Prueba breve

1. Pide al chat que lea `contract.es.md` y resuma entradas, salidas y decisiones que no debe adivinar.
2. Consulta un símbolo real de Customer y una página de Microsoft Learn.
3. Publica App y Test en tu sandbox y ejecuta los tests: con el starter sin tocar deben fallar **exactamente C02, C03, C04, C11 y C12**.
4. Abre **Agent Debug Logs** desde el chat.
