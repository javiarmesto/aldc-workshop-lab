# Lab 07 · Contexto como dependencia

**Objetivo:** instalar y utilizar una skill desde un paquete del equipo. **Tiempo:** 18 minutos. **Punto de partida:** paquete local [`packages/october-workshop-primitives`](../../packages/october-workshop-primitives/README.md) y APM instalado (`apm --version`). **Entrega:** manifiesto, lockfile, archivos proyectados e invocación.

## Comprobar prerrequisitos

Desde la raíz del repositorio, ejecuta el [helper de este lab](../../tools/Test-Lab07.ps1):

```powershell
./tools/Test-Lab07.ps1
```

Lee sus resultados antes de continuar. No instala ni modifica el entorno; distingue archivos presentes de comprobaciones manuales dentro del agente. [Parámetros y estados](../../tools/README.md#helpers-de-comprobación).

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

## Agente y prompt de uso

Ejecuta los comandos APM de la sección Pasos tú mismo. Si fallan, conserva versión y error; no supongas que se instaló el paquete. Abre el consumidor en una ventana separada de VS Code y usa modo **Agent**, con lectura de la skill proyectada. Facilita una copia del informe del Lab 05/06 para que no dependa del acceso al workspace anterior.

```text
Usa la skill review-al-evidence instalada en este consumidor.
Indica su ruta real y lee sus instrucciones antes de revisar.
Te proporciono esta evidencia del taller: <pegar informe real>.
Distingue especificación, revisión estática, compilación y tests.
Señala información ausente sin inventarla. No modifiques código,
no ejecutes tests y devuelve el resultado en el chat.
```


## Resultado y cierre

Esperamos demostrar uso de la skill instalada, no solo que el comando de instalación terminó. Comprueba versión, manifiesto, lockfile, archivos proyectados y lecturas de la sesión.

```text
Prepara el texto para evidence/lab07-apm.md a partir de las salidas
APM y la revisión que te proporciono. Incluye versión, comandos,
resultados reales, rutas y origen de la skill, y qué quedó pendiente.
No afirmes reproducibilidad o auditoría correcta sin sus resultados.
Devuelve Markdown en el chat. No uses Git ni escribas archivos.
```

Guarda el texto en evidence/ del repositorio principal, no dentro del consumidor ignorado. Conserva allí también extractos del manifiesto/lockfile o referencias suficientes para identificar la dependencia.

```powershell
# Desde la raíz del repositorio principal:
git add -- evidence/lab07-apm.md
git diff --cached
git commit -m "docs: registrar dependencia de contexto del Lab 07"
git push
```
