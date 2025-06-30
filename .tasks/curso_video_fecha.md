# Validar formato de fecha en CursoVideo

En `lib/modules/home/screens/explore/show/curso_video.dart` hay un TODO (línea 125) para verificar el formato de `dateCreated`.

## Objetivo
Asegurar que `DateHelper.formatUiDateLongFromString` maneje correctamente la cadena recibida o aplicar una validación previa.

## Criterios de finalización
- Manejo seguro de formatos inválidos sin romper la vista.
- Pruebas que cubran distintos formatos de fecha.
