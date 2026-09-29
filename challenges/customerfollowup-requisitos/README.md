# Reto opcional · Customer Follow-up desde requisitos

Este reto se realiza **después** de la jornada guiada, en otra carpeta. La copia generada contiene [solo el encargo de negocio](requirements.es.md), manifiestos AL vacíos y configuración de ejemplo. No copia el starter, sus tests, `cases.csv`, planes, especificaciones ni solución de referencia.

Desde la raíz de tu copia de `aldc-workshop-lab`, en PowerShell:

```powershell
./tools/Prepare-RequirementsChallenge.ps1
```

Se crea `../customer-followup-requisitos`. Si prefieres otra carpeta o tus rangos de objetos son distintos:

```powershell
./tools/Prepare-RequirementsChallenge.ps1 -Destination 'C:\Workshops\mi-reto' -AppObjectIdFrom 71400 -TestObjectIdFrom 71500
```

El script se detiene si la carpeta de destino ya existe; nunca la mezcla ni la sobrescribe. Genera GUID propios para App y Test, y deja las carpetas `src` vacías. Comprueba que los rangos elegidos están disponibles en tu sandbox, especialmente si varias personas comparten entorno. El proyecto declara BC 28 / runtime 16, como el starter; confirma compatibilidad con tu sandbox.

Abre `customer-followup-requisitos.code-workspace`, copia el `launch.json.example` de App y Test a `launch.json` y ajusta tenant y entorno. Prepara ALDC con **AL Collection: Open Project Manager** sobre la raíz de este nuevo proyecto. Si usas BCQuality, mantén el clon como carpeta hermana `../bcquality` y configura su ruta en `aldc.yaml` después de instalar el toolkit. Descarga símbolos antes de compilar. El script no instala extensiones, no publica apps en BC ni escribe `.vscode/mcp.json`.

La app Test depende de la app principal; publica App antes de Test cuando hayas creado objetos y pruebas. Guarda por separado las evidencias de arquitectura, especificación, compilación, ejecución y revisión. El README y los ocho laboratorios originales siguen correspondiendo al starter guiado.
