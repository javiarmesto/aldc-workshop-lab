# Lab 08 · Entregar a otra persona

**Objetivo:** conseguir que otra pareja pueda entender y comprobar el incremento. **Tiempo:** 10 minutos de revisión entre parejas + 7 de diseño de vuestro flujo. **Punto de partida:** spec aprobada, cambio, resultados y recorrido funcional. **Entrega:** aceptación independiente o una devolución concreta.

## Comprobar prerrequisitos

Desde la raíz del repositorio, ejecuta el [helper de este lab](../../tools/Test-Lab08.ps1):

```powershell
./tools/Test-Lab08.ps1
```

Lee sus resultados antes de continuar. No instala ni modifica el entorno; distingue archivos presentes de comprobaciones manuales dentro del agente. [Parámetros y estados](../../tools/README.md#helpers-de-comprobación).

## El paquete de entrega

| Pieza | Debe permitir |
|---|---|
| Requisito y spec | Entender el comportamiento acordado |
| Diff final | Identificar el cambio realizado |
| Resultados | Saber qué código y casos se comprobaron |
| Revisión | Entender criterios y hallazgos tratados |
| Recorrido de aceptación | Repetir la comprobación en la ficha |

## Revisión entre parejas

1. Intercambiad la entrega con otra pareja (por ejemplo, compartiendo vuestro repositorio).
2. Reproducid un caso de fecha y la persistencia.
3. Aceptad o devolved indicando exactamente qué falta. Decide una persona que no implementó el cambio.

## Diseñar un flujo para vuestro equipo

Elegid un cambio pequeño y frecuente de vuestro backlog y completad:

| Decisión | Vuestra respuesta |
|---|---|
| Cambio concreto | ¿Qué resultado necesita el usuario? |
| Contrato | ¿Qué debe quedar escrito antes del código? |
| Roles | ¿Qué responsabilidades conviene separar? |
| Checkpoint | ¿Dónde decide una persona? |
| Evidencia | ¿Qué prueba o revisión permite aceptar? |

Quitad los pasos que no mejoran el resultado. Guardad la propuesta en `evidence/`.

## Prompts para preparar y revisar la entrega

En modo **Agent** con lectura del proyecto, prepara el traspaso:

```text
Prepara una entrega de Customer Follow-up para otra pareja.
Localiza requisito/spec aprobada, diff o commits, revisión, resultados
y recorrido funcional realmente registrados. Indica rutas y pendientes.
Distingue pruebas ejecutadas de expectativas; no inventes aceptación.
Devuelve en el chat una ficha para evidence/lab08-handoff.md.
No modifiques código ni tests y no uses Git.
```

La pareja receptora puede usar un chat nuevo con un revisor de solo lectura:

```text
Revisa esta entrega como apoyo a la pareja receptora.
Comprueba que se puede entender el requisito, identificar el cambio
y localizar las evidencias. Señala ausencias concretas.
Propón un caso de fecha y una comprobación de persistencia para que
la pareja los reproduzca. No afirmes haberlos ejecutado.
Devuelve recomendación razonada; la aceptación la decide la persona.
No escribas archivos ni modifiques código.
```


## Registrar la decisión humana

Tras el recorrido real, facilita los resultados:

```text
La pareja receptora ha comprobado <casos y resultados reales>.
Su decisión es <aceptar/devolver> por <motivo>.
Redacta la sección de aceptación de evidence/lab08-handoff.md,
atribuyendo las comprobaciones y decisión a la pareja, no al agente.
Incluye los pendientes. Devuelve el texto sin usar Git.
```

No aceptes automáticamente porque el agente recomiende hacerlo. Guarda además la tabla de vuestro flujo en `evidence/lab08-team-flow.md`. Puedes pedir ayuda:

```text
Nuestro cambio frecuente es <cambio del backlog>.
Propón un flujo breve con contrato, responsabilidades, decisión humana
y evidencia de aceptación. Explica qué paso aporta cada comprobación.
Devuelve una propuesta para revisar, no una política ya aprobada.
```


## Guardar el cierre

Copia los textos revisados a sus archivos:
```powershell
git add -- evidence/lab08-handoff.md evidence/lab08-team-flow.md
git diff --cached
git commit -m "docs: registrar entrega y flujo del equipo del Lab 08"
git push
git rev-parse HEAD
```

El resultado esperado es una aceptación independiente o una devolución concreta y un flujo que podáis adaptar a vuestro equipo. Una devolución bien justificada también completa el ejercicio.

