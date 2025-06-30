# Unificar modelos `Pet`

Se detectaron múltiples definiciones de la clase `Pet`:
- `lib/modules/integracion/model/mascotas/mascotas_model.dart`
- `lib/modules/integracion/model/mascota/macotas_model.dart`
- `lib/models/pet_model.dart`

Además, la aplicación usa `PetData` como modelo principal.

## Objetivo
Eliminar duplicaciones y adoptar una única representación para las mascotas, preferiblemente `PetData`.

## Criterios de finalización
- Identificar cuál(es) modelos se usan realmente y depurar los sobrantes.
- Actualizar controladores y vistas que dependan de las clases eliminadas.
- Compilación y pruebas correctas.
