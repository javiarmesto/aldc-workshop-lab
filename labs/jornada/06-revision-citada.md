# Lab 06 · Revisión citada

**Objetivo:** seguir un criterio desde su fuente hasta una decisión sobre el cambio. **Tiempo:** 16 minutos. **Punto de partida:** especificación y criterios, commits base/final del Lab 05 y resultados. **Entrega:** fuente, aplicabilidad, evidencia, resultado y decisión en `evidence/lab06-bcquality.md`.

## Comprobar prerrequisitos

Desde la raíz del repositorio, ejecuta el [helper de este lab](../../tools/Test-Lab06.ps1):

```powershell
./tools/Test-Lab06.ps1
```

**Qué aprenderás con esta comprobación:** preparar una revisión trazable desde los dos commits y la fuente BCQuality.

**Qué hace `Test-Lab06.ps1`:** llama a `Test-LabPrerequisites.ps1` para comprobar el contrato y App/Test, Git, selección BCQuality, nota del Lab 05 y entrada de BCQuality; con `-BaseCommit` y `-IncrementCommit` muestra el diff local de la codeunit usando `--ignore-space-at-eol` para evitar ruido de finales de línea. Comprueba el cambio sustantivo y no atribuyas modificaciones a líneas que solo difieren en formato. Es una comprobación de lectura: no instala ni modifica archivos, no compila ni ejecuta tests. Las líneas `MANUAL` te piden confirmar que Reviewer vea el diff y aplique el protocolo BCQuality; un archivo presente no demuestra ejecución del proveedor. `PRESENTE` solo acredita que la ruta existe, no que el agente la haya usado ni que el laboratorio esté aprobado.

Lee `FALTA` y `REVISAR` antes de continuar. [Parámetros y estados](../../tools/README.md#helpers-de-comprobación).

## Preparar la revisión

Abre un chat nuevo con **AL Developer Reviewer**. Comprueba acceso de lectura al proyecto y BCQuality. Para el diff puede usar Git local o herramientas GitHub equivalentes. Guarda la configuración de herramientas antes de abrir la sesión. Su contrato puede impedir escribir informes: devolverlos en el chat es suficiente.

Sustituye los marcadores por tu repositorio y SHA, no los del instructor. Usa los dos commits anotados al cerrar Lab 05.

## Prompt principal

```text
Comenzamos el Lab 06 de Customer Follow-up: revisión citada.
Repositorio: <propietario/repositorio>.
Commit base: <commit-base>.
Commit del incremento: <commit-lab05>.
Resultados aportados por el participante: <casos y resultados reales>.
No repitas los tests ni presentes esa ejecución como tuya.

1. Obtén el diff de App/src/CustomerFollowUpMgt.Codeunit.al mediante
Git en lectura o herramientas GitHub equivalentes. Si usas el patch de
un commit, verifica que su padre es la base; si no, compara ambas refs.
Si el patch completo muestra un cambio de finales de línea, usa también
`git diff --ignore-space-at-eol <commit-base> <commit-lab05> --
App/src/CustomerFollowUpMgt.Codeunit.al` y declara ese filtro.
Si no tienes ninguna vía, pide el diff y espera antes de revisar.

2. Lee aldc.yaml y el pipeline ALDC. Sigue el punto de entrada y el
flujo de revisión BCQuality configurado. Identifica las instrucciones
cargadas, selección de skill, trabajo realizado y limitaciones.
Una skill puede ejecutarse siguiendo sus instrucciones; no requiere
por definición una llamada a un servicio externo.

3. Selecciona de la especificación el criterio sobre transacción
implícita y ausencia de Commit explícito. Lee su fuente real,
explica por qué aplica y contrástala con el diff verificado.

4. Devuelve fuente/ruta, evidencia de código, resultado met/unmet/
not evaluated y decisión de conservar o proponer corrección.
No es obligatorio encontrar defectos.

Separa el resultado del criterio de la cobertura del flujo BCQuality.
No marques ejecutado solo por leer su entrada: explica los pasos que
realmente has aplicado. Distingue revisión fijada en configuración
de revisión del clon comprobada.
Devuelve la evidencia en el chat. No escribas archivos, no modifiques
AL ni tests y no ejecutes operaciones de escritura en Git.
```


## Si el agente no puede obtener el diff

Puedes facilitarlo tú:
```powershell
git diff --ignore-space-at-eol <commit-base> <commit-lab05> -- App/src/CustomerFollowUpMgt.Codeunit.al
```

La alternativa GitHub es válida para commits publicados. Una lista ordenada de commits no sustituye comprobar el padre o comparar explícitamente ambas refs. Leer únicamente el archivo actual no prueba qué cambió.

## Qué revisar en la respuesta

1. **Fuente:** artículo o sección real de BCQuality.
2. **Aplicabilidad:** relación del criterio con este cambio.
3. **Evidencia:** fragmento del diff y procedencia.
4. **Resultado:** met, unmet o not evaluated, con justificación.
5. **Decisión:** conservar o corregir; sin introducir cambios para fabricar un hallazgo.

Ejecutar el protocolo de una skill como agente puede ser una ejecución del flujo BCQuality. Debe haber evidencia de selección y aplicación, no solo de archivos disponibles. Si únicamente se inspeccionó un artículo, decláralo como tal. Un criterio puede comprobarse por inspección aunque una revisión más amplia siga pendiente.

La ausencia de Commit explícito no demuestra por sí sola todos los límites transaccionales del llamador. Limita la conclusión al criterio y al código revisados. Los resultados 12/12 previos siguen siendo evidencia del participante; no hace falta repetirlos si no cambia código.

## Cerrar y guardar

Pide una versión breve de la evidencia:

```text
Resume la revisión anterior para evidence/lab06-bcquality.md.
Incluye commits y vía de obtención del diff, criterio/fuente, aplicación,
resultado, decisión y estado real del flujo BCQuality.
Conserva las limitaciones y la atribución de los tests al participante.
Devuelve el Markdown en el chat, sin escribir archivos ni usar Git.
```

Copia el texto revisado al archivo. Si propones cambios, su implementación y las comprobaciones afectadas van después de la decisión humana.

```powershell
git add -- evidence/lab06-bcquality.md
git diff --cached
git commit -m "docs: registrar revision citada del Lab 06"
git push
git rev-parse HEAD
```

Después realiza el [recorrido de aceptación](../material/demo-storyboard.md) y conserva sus resultados para el Lab 08.

| Evidencia | Permite evaluar | No demuestra por sí sola |
|---|---|---|
| Criterio citado y diff | Regla, aplicabilidad e implementación | Todas las rutas de ejecución |
| Compilación | Validez para el compilador | Reglas de negocio |
| Tests y recorrido | Casos ejecutados | Todo escenario posible |
