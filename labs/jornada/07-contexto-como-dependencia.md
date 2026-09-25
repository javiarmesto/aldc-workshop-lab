# Lab 07 · Contexto como dependencia

**Objetivo:** instalar y utilizar una skill desde un paquete del equipo. **Tiempo:** 18 minutos. **Punto de partida:** paquete local [`packages/october-workshop-primitives`](../../packages/october-workshop-primitives/README.md) y APM instalado (`apm --version`). **Entrega:** manifiesto, lockfile, archivos proyectados e invocación.

## Pasos

Desde la raíz de tu repositorio:

```powershell
mkdir apm-consumer
cd apm-consumer
apm install ../packages/october-workshop-primitives --target copilot
apm install --frozen --target copilot
```

1. Compara `apm.yml`, `apm.lock.yaml` y los archivos instalados (`.github/instructions/` y `.agents/skills/`).
2. Abre `apm-consumer` en VS Code e invoca la skill `review-al-evidence`.
3. `apm audit` comprueba que lo instalado coincide con el lockfile.

`apm-consumer/` está en `.gitignore`: guarda en `evidence/lab07-apm.md` la versión de APM, el destino y la salida de los comandos.

## Una actualización también necesita revisión

Si cambia una instrucción del equipo, ¿qué comportamiento puede alterar? Si entra una dependencia nueva, ¿de dónde viene y qué capacidades trae? ¿Qué versión ha cambiado en el consumidor y quién acepta la actualización? El [ejemplo de política](../material/apm-policy.yml.example) muestra reglas de instalación.
