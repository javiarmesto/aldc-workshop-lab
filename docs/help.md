# Ayuda durante el taller · Workshop help

[Inicio ES](start-here.md) · [Start EN](start-here.en.md)

Si te atascas, conserva tu trabajo y avisa al instructor. / Preserve your work and ask the instructor when blocked.

| Síntoma / Symptom | Primera comprobación / First check |
|---|---|
| GitHub 404 | Repositorio privado o cuenta sin acceso. Comprueba la cuenta y el enlace; no necesitas OctoberWorkshops. / Check account and template access. |
| Falta aldc.yaml | Instala el toolkit en la raíz, además de la extensión. / Install the project toolkit, not just the extension. |
| BCQuality no aparece | Carpeta hermana ../bcquality y revisión fijada. / Check sibling directory and pinned revision. |
| Herramienta ausente en el agente | Guarda la configuración y abre una sesión nueva con ese agente. / Save tools and open a new session with the intended agent. |
| Customer no se resuelve | Cargar los paquetes de App cuando la herramienta lo requiera. / Load App symbol packages if required. |
| C11/C12 siguen con el error del stub | Publicar App, confirmar sandbox y mirar una ejecución nueva. / Publish App, check environment and latest run. |
| Skill duplicada | Comprueba origen local/plugin; retira solo las copias del ejercicio. / Check local/plugin origin; retain ALDC. |
| Revisor no escribe el informe | Es válido recibir Markdown en chat y guardarlo tú. / Save the returned Markdown yourself. |
| Consumidor APM no ve el código AL | Es otra carpeta; aporta spec, diff y resultados. / Supply review inputs explicitly. |
| Mensaje Git/APM en rojo | Lee el resultado y LASTEXITCODE; stderr no siempre es un fallo. / Inspect message and exit code. |
| Carpeta ya existente | No borrar ni sobrescribir para repetir el montaje. / Inspect and resume the failed step only. |

## Qué facilitar / What to provide

Copia esta ficha al chat del instructor o a una incidencia del repositorio, si está habilitada. Elimina tokens, contraseñas, URLs con credenciales y datos de clientes antes de compartir. / Use this in the instructor chat or repository issue if enabled; remove credentials and customer data.

```text
Lab / step:
Editor + channel + version:
Agent / model:
ALDC + APM versions (if relevant):
Repository revision / git rev-parse HEAD:
Working directory (redact your personal path if needed):
Operation / command:
Expected result:
Actual result + exit code / exact error:
Files changed before the problem:
Checks already performed:
```

[Recuperación sin sobrescribir / Recovery instructions (ES)](checkpoints.md). Solo retoma desde una etapa preparada cuando corresponda; registra qué parte procede del checkpoint. / Identify any work supplied by a recovery checkpoint.
