import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/components/regresr_components.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/comandos/comandos_controller.dart';

class CrearComando extends StatefulWidget {
  final bool isEditing;
  final int? comandoId;
  
  CrearComando({super.key, this.isEditing = false, this.comandoId});

  @override
  State<CrearComando> createState() => _CrearComandoState();
}

class _CrearComandoState extends State<CrearComando> {
  final ComandoController controller = Get.find<ComandoController>();
  final HomeController homeController = Get.find<HomeController>();

  // Declarar variables reactivas para validación
  RxBool nameValid = false.obs;
  RxBool vozComandoValid = false.obs;
  RxBool instructionsValid = false.obs;
  RxBool descriptionValid = false.obs;

  // Validación del formulario
  void validateForm() {
    nameValid.value = (controller.dataComando.value['name'] as String?)?.isEmpty ?? true;
    vozComandoValid.value = (controller.dataComando.value['voz_comando'] as String?)?.isEmpty ?? true;
    instructionsValid.value = (controller.dataComando.value['instructions'] as String?)?.isEmpty ?? true;
    descriptionValid.value = (controller.dataComando.value['description'] as String?)?.isEmpty ?? true;
  }

  // Método para obtener el valor inicial de un campo
  String getInitialValue(String fieldName) {
    if (widget.isEditing) {
      return controller.dataComando.value[fieldName]?.toString() ?? '';
    }
    return '';
  }

  // Método para manejar el proceso de creación o edición
  void handleCreateCommand() {
    if (controller.isLoading.value) return; // Evitar múltiples envíos

    validateForm();

    // Validar los campos antes de enviar la petición
    if (nameValid.value || vozComandoValid.value || instructionsValid.value || descriptionValid.value) {
      CustomSnackbar.show(
        title: 'Error',
        message: Helper.errorValidate,
        isError: true,
      );
      return;
    }

    // Actualizar el ID de la mascota seleccionada
    controller.updateField('pet_id', homeController.selectedProfile.value?.id ?? '');

    // Cambiar el estado de carga
    controller.isLoading.value = true;

    if (widget.isEditing && widget.comandoId != null) {
      // Llamar a la API para actualizar el comando
      controller.updateCommand(widget.comandoId!, controller.dataComando).then((response) {
        controller.isLoading.value = false; // Terminar carga
        controller.fetchComandos(homeController.selectedProfile.value!.id.toString());
      }).catchError((error) {
        controller.isLoading.value = false; // Terminar carga
        CustomSnackbar.show(
          title: 'Error',
          message: 'Hubo un error al actualizar el comando.',
          isError: true,
        );
      });
    } else {
      // Llamar a la API para crear el comando
      controller.postCommand(controller.dataComando).then((response) {
        controller.isLoading.value = false; // Terminar carga
        controller.fetchComandos(homeController.selectedProfile.value!.id.toString());
      }).catchError((error) {
        controller.isLoading.value = false; // Terminar carga
        CustomSnackbar.show(
          title: 'Error',
          message: 'Hubo un error al crear el comando.',
          isError: true,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Si estamos editando, cargar los datos del comando
    if (widget.isEditing && widget.comandoId != null) {
      // Los datos ya están cargados en el controlador desde editComando
      // Debug: verificar que los datos estén disponibles
      print('=== VERIFICANDO DATOS EN FORMULARIO ===');
      print('isEditing: ${widget.isEditing}');
      print('comandoId: ${widget.comandoId}');
      print('dataComando name: ${controller.dataComando.value['name']}');
      print('dataComando description: ${controller.dataComando.value['description']}');
      print('dataComando voz_comando: ${controller.dataComando.value['voz_comando']}');
      print('dataComando instructions: ${controller.dataComando.value['instructions']}');
      print('========================================');
    }
  }

  @override
  Widget build(BuildContext context) {
    const double margen = 16.0;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 148,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: Container(
              color: Styles.colorContainer,
              height: 140,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 120,
                        width: width,
                        padding: Styles.paddingAll,
                        decoration: const BoxDecoration(
                          color: Styles.colorContainer,
                        ),
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 26),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    topRight: Radius.circular(90),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Barra de Navegación
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: BarraBack(
                            titulo: widget.isEditing ? 'Editar Comando' : 'Crear Comando',
                            size: 20,
                            callback: () {
                              Get.off(HomeScreen());
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Selección de Mascota
                        const SizedBox(height: margen),
                        // Campos de Entrada para el Comando
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Selecciona la mascota",
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0XFF383838),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ProfilesDogs(
                                  showAge: true,
                                ),
                              ),
                              const SizedBox(height: margen),
                              Obx(() {
                                String initialName = widget.isEditing ? (controller.dataComando.value['name']?.toString() ?? '') : '';
                                print('Initial name value: $initialName');
                                return InputText(
                                  label: 'Nombre del Comando',
                                  placeholder: '',
                                  initialValue: initialName,
                                  errorText: nameValid.value ? 'Campo requerido' : '',
                                  onChanged: (value) {
                                    controller.updateField('name', value);
                                  },
                                );
                              }),
                              Obx(() {
                                return InputText(
                                  label: 'Descripción del Comando',
                                  placeholder: '',
                                  initialValue: getInitialValue('description'),
                                  errorText: descriptionValid.value ? 'Campo requerido' : '',
                                  onChanged: (value) {
                                    controller.updateField('description', value);
                                  },
                                );
                              }),
                              Obx(() {
                                return InputText(
                                  label: 'Voz del Comando',
                                  placeholder: '',
                                  initialValue: getInitialValue('voz_comando'),
                                  errorText: vozComandoValid.value ? 'Campo requerido' : '',
                                  onChanged: (value) {
                                    controller.updateField('voz_comando', value);
                                  },
                                );
                              }),
                              Obx(() {
                                return InputText(
                                  label: 'Instrucciones del Comando',
                                  placeholder: '',
                                  initialValue: getInitialValue('instructions'),
                                  errorText: instructionsValid.value ? 'Campo requerido' : '',
                                  onChanged: (value) {
                                    controller.updateField('instructions', value);
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: margen),
                        // Botón de Crear o Editar
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            child: ButtonDefaultWidget(
                              title: controller.isLoading.value 
                                  ? (widget.isEditing ? 'Actualizando...' : 'Creando...') 
                                  : (widget.isEditing ? 'Actualizar comando' : 'Crear comando'),
                              callback: controller.isLoading.value
                                  ? null // Desactiva el botón mientras se carga
                                  : handleCreateCommand,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
