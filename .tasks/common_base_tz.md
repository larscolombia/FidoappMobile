# Revisar conversión de fecha en CommonBase

En `lib/utils/common_base.dart` se comenta `toLocal()` (línea 339). Esto podría afectar la zona horaria.

## Objetivo
Evaluar si se debe aplicar `toLocal()` al parsear fechas o documentar claramente la decisión de mantener UTC.

## Criterios de finalización
- Determinación explícita sobre el uso de UTC vs zona local.
- Código y comentarios actualizados.
