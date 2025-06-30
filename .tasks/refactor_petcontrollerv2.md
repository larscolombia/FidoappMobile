# Refactorizar PetControllerv2

El controlador `lib/modules/integracion/controller/mascotas/mascotas_controller.dart` incluye varios TODO (líneas 16, 35 y 120) que advierten sobre diseño y llamadas directas a la API.

## Objetivo
- Unificar el modelo utilizado (`PetData` en lugar de modelos alternos).
- Delegar las peticiones de red al `PetsRepository`.
- Revisar la lógica duplicada de `fetchPets`.

## Criterios de finalización
- Controlador simplificado y sin TODOs.
- Pruebas o revisiones que demuestren la correcta integración con `PetsRepository`.
