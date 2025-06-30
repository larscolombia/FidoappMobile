# Revisión de TODOs y clases duplicadas

Este documento resume los comentarios `// TODO:` encontrados en `lib/` y los posibles problemas asociados. También se analiza la coexistencia de varias clases `Pet`.

## Lista de TODOs relevantes

1. **PetServiceApis**
   - Archivo: `lib/services/pet_service_apis.dart`
   - Línea: 24
   - Comentario: "Este método no se está utilizando".
   - Posible impacto: código muerto que puede generar confusión sobre la forma correcta de enviar los detalles de la mascota.

2. **PetsRepository**
   - Archivo: `lib/repositories/pets_repository.dart`
   - Línea: 16
   - Comentario: "Implementar un método para anexar los archivos y conectarlo con el método addPetDetailsApi del servicio".
   - Posible impacto: actualmente no hay soporte para subir imágenes u otros archivos al crear mascotas desde el repositorio, por lo que cada pantalla debe manejarlo por su cuenta.

3. **Cursos** y **BanerComentarios**
   - Archivos: `lib/modules/apprenticeship/component/cursos.dart` y `lib/modules/components/baner_comentarios.dart`
   - Líneas: 22 y 111 respectivamente
   - Comentario: "implement build".
   - Posible impacto: son restos de plantillas; no afectan el funcionamiento pero deberían eliminarse para mantener el código limpio.

4. **ProfilePetController**
   - Archivo: `lib/modules/profile_pet/controllers/profile_pet_controller.dart`
   - Línea: 167
   - Comentario: "Verificar cuántos modales están abiertos en este punto".
   - Posible impacto: si `Get.close(3)` no coincide con la pila real de diálogos, podría cerrarse más (o menos) de lo necesario y provocar estados inesperados en la navegación.

5. **PetPassportForm**
   - Archivo: `lib/modules/profile_pet/screens/pet_passport_form.dart`
   - Línea: 32
   - Comentario: "Revisa los comentarios en la clase PetControllerv2".
   - Posible impacto: indica que el formulario depende de la lógica de `PetControllerv2`, la cual necesita refactorización.

6. **CursoVideo**
   - Archivo: `lib/modules/home/screens/explore/show/curso_video.dart`
   - Línea: 125
   - Comentario: "Validar el formato recibido en dateCreated".
   - Posible impacto: si `widget.dateCreated` viene en un formato inesperado, `DateHelper.formatUiDateLongFromString` podría lanzar una excepción y fallar la vista.

7. **Pacientes**
   - Archivo: `lib/modules/dashboard/screens/pacientes.dart`
   - Línea: 100
   - Comentario: "Reemplazar esta forma de inyectar los datos de la mascota".
   - Posible impacto: pasar toda la instancia de `PetData` por argumentos puede generar problemas de serialización o estados no sincronizados; se sugiere pasar solo el id y cargar la mascota en la vista destino.

8. **HistorialClinicoController**
   - Archivo: `lib/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart`
   - Línea: 29
   - Comentario: "implement onInit".
   - Posible impacto: el controlador no ejecuta ninguna carga inicial de datos; la vista que lo use podría mostrarse vacía o sin inicializar.

9. **PetControllerv2**
   - Archivo: `lib/modules/integracion/controller/mascotas/mascotas_controller.dart`
   - Líneas: 16, 35 y 120
   - Comentarios: "Ojo con esta clase"; "Verificar, aparentemente este método vuelve a cargar las mascotas..."; "Este método está enviando la información directamente al backend".
   - Posible impacto: la clase mezcla lógica de controlador con llamadas directas a la API y usa un modelo `Pet` distinto de `PetData`. Esto complica el mantenimiento y puede provocar incoherencias en la aplicación.

10. **CommonBase**
    - Archivo: `lib/utils/common_base.dart`
    - Línea: 339
    - Comentario: "toLocal() Removed for UTC Time".
    - Posible impacto: los tiempos pueden no ajustarse a la zona horaria correcta. Revisar si es necesario aplicar `toLocal()` al parsear fechas.

11. **DateTimeExt**
    - Archivo: `lib/utils/date_time_ext.dart`
    - Línea: 7
    - Comentario: "Cambiar esta extensión por un helper".
    - Posible impacto: se plantea mover esta lógica a otra clase; no es un error pero se sugiere unificar la utilería de fechas.

## Duplicidad de modelos `Pet`

Se detectaron tres clases con el nombre `Pet`:

- `lib/modules/integracion/model/mascotas/mascotas_model.dart`
- `lib/modules/integracion/model/mascota/macotas_model.dart`
- `lib/models/pet_model.dart`

La clase `PetControllerv2` utiliza la definida en `mascotas_model.dart`, mientras que en el resto de la aplicación se maneja principalmente `PetData` (`lib/models/pet_data.dart`). Tener varias definiciones para la misma entidad complica la conversión de datos y puede producir errores al mapear campos o al serializar/deserializar información.

En particular, el archivo `macotas_model.dart` (nótese el nombre) no parece estar referenciado en ninguna parte del código, por lo que podría tratarse de código muerto. Además, `PetData` es la estructura que utiliza el repositorio oficial (`PetsRepository`) y las vistas principales, por lo que mantener otra clase `Pet` en el controlador `PetControllerv2` genera redundancia y riesgo de inconsistencia.

## Conclusiones

- Es recomendable unificar la estructura de datos de las mascotas usando `PetData` y eliminar modelos duplicados o sin uso.
- `PetControllerv2` debería delegar la lógica de red al `PetsRepository` para mantener un flujo único de datos.
- Se sugiere revisar cada TODO y decidir si debe implementarse o eliminarse. Varios de ellos son restos de plantillas (`implement build`) o comentarios de refactorización pendientes.

