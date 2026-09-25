# Checkpoint de recuperación · Especificación aprobada

Preparado el 25/09/2026 para continuar por Lab 05. Parte de checkpoint/lab01 (`6208f990d664cf378a287744078c4f67fe1ff8f6`) y recupera arquitectura, spec, selección y criterios desde el ensayo `f4bf86a39d1d8e27af2e8b1a9f939ee5adb4a288`, de javiarmesto/aldc-workshop-rehearsal.

La aprobación humana registrada en esos documentos es histórica, del 25/09/2026. No es una aprobación nueva de tu implementación. GetReviewStatus está resuelto; MarkReviewed conserva el TODO. Resultado esperado: C01–C10 correctos; C11/C12 pendientes. No se ha compilado ni ejecutado esta rama al publicarla. Tests, contrato, IDs y cases.csv se conservan.

Correcciones editoriales de recuperación: las menciones residuales a TD-04 abierto se alinean con su decisión aprobada (sin eventos); el recuento es 19 criterios, no 18; consultar símbolos compilados no se presenta como compilar App. No se cambia ninguna decisión del contrato. La memoria original se conserva y una entrada final aclara el estado vigente.

Las lecturas de herramientas/BCQuality y las referencias a evidence/lab03-before-after.md de los documentos corresponden al ensayo original, no al entorno actual. Ese informe histórico no se incluye. Las rutas .github/skills y reglas de ALDC citadas dependen del toolkit que instales; no son archivos distribuidos por el checkpoint. No se trasladan agentes con permisos personales desde 892a672….

Antes de usar Conductor:

1. Sigue docs/preflight.md: instala ALDC 5.0.0 y el toolkit compatible en esta copia; conserva los planes recuperados bajo .github/plans. Verifica plans.root y las herramientas efectivas de los agentes.
2. Monta ../bcquality en 07e324ddbc42597c479e041e06a7833740e05d0f. bcVersion 28 en la selección es el objetivo de App/app.json; el sandbox histórico era BC29. Registra tu entorno real.
3. Configura App/Test, descarga símbolos y comprueba Customer con el agente; una lectura histórica no prueba que tus herramientas estén listas.
4. El plugin review-dates-lab se prepara/registra fuera del proyecto siguiendo Lab 02 si todavía lo necesitas. Esta rama no contiene las copias locales de skill/agente/prompt para evitar duplicarlas; conserva las instrucciones del proyecto.
5. Lee arquitectura/spec y usa tools/Test-Lab05.ps1. Inicia Lab 05 con Conductor para el objetivo docente aunque el incremento sea LOW. Revisa el plan antes de autorizar código.

No se incluyen implementación de MarkReviewed, evidencia 12/12 ni revisión posterior. La aceptación independiente sigue siendo una actividad futura. Consulta docs/checkpoints.md para recuperar sin sobrescribir tu trabajo.
