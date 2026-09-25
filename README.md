# ALDC Workshop Lab · Customer Follow-up

Repositorio de prácticas de los talleres de **Roberto Corella y Javier Armesto** sobre desarrollo AL con agentes y ALDC. Es una plantilla: cada participante crea su propia copia y trabaja en ella durante el taller y después.

- **Jornada completa (castellano, GitHub Copilot Chat):** *De asistentes de IA a ingeniería de agentes.* [Guía de los laboratorios](labs/README.md).
- **Directions EMEA (inglés, Copilot o Claude Code):** *Spec-Driven AL Development.* [English guide](README.en.md).

## Crear tu copia

1. Pulsa **Use this template → Create a new repository** en GitHub. Hazlo privado si tu sandbox o tu código lo requieren.
2. Clónala en tu equipo y, **junto a ella** (no dentro), clona BCQuality en la revisión del taller:

```powershell
git clone https://github.com/<tu-usuario>/<tu-copia>.git aldc-workshop-lab
git clone https://github.com/microsoft/BCQuality.git bcquality
git -C bcquality checkout --detach 07e324ddbc42597c479e041e06a7833740e05d0f
```

3. Abre `aldc-workshop-lab.code-workspace` y sigue la [preparación previa](docs/preflight.md). La instalación se hace **antes** del taller.

## Qué contiene

| Ruta | Para qué |
|---|---|
| `App/`, `Test/` | Starter AL: campos, ficha, ayudantes y 12 tests. Dos TODOs en `App/src/CustomerFollowUpMgt.Codeunit.al`. |
| `contract.es.md`, `contract.md`, `cases.csv` | Contrato del caso (ES/EN) y casos de aceptación C01–C12. |
| `labs/` | Guías de los laboratorios y material de trabajo. |
| `templates/` | Primitivas (instrucciones, prompt, agente), plugin de ejemplo y fichas de evidencia. |
| `packages/october-workshop-primitives` | Paquete APM del laboratorio de distribución. |
| `docs/` | Preparación previa, hoja de referencia y agenda. |
| `evidence/` | Dónde guardar tu arquitectura, spec, resultados y decisiones. |

La solución de referencia **no** está en este repositorio; se publicará después del taller.

## Datos técnicos

- Business Central 28.0 o posterior (probado en BC online 29), runtime 16.0.
- Rangos de objetos: App **71200–71249**, Test **71300–71349**. Comprueba que tu sandbox no tiene otra extensión en esos rangos.
- Los tests no dependen de Library Assert. C12 crea y borra un cliente sintético: usa un sandbox de pruebas.
- Con el starter sin tocar fallan exactamente C02, C03, C04, C11 y C12. Tu objetivo es que pasen los 12.

## Estado

Repositorio privado hasta el taller. La licencia se publicará antes de abrirlo.

**Roberto Corella y Javier Armesto**
