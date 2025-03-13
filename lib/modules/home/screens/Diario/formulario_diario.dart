import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class FormularioDiario extends StatefulWidget {
  final bool isEdit;
  bool? cambio;
  String? ImagenEdit;
  FormularioDiario({
    super.key,
    this.isEdit = false,
    this.cambio = false,
    this.ImagenEdit,
  });

  @override
  _FormularioDiarioState createState() => _FormularioDiarioState();
}

class _FormularioDiarioState extends State<FormularioDiario> {
  String? _imagePath;
  File? __imageFile;
  late final PetActivityController controller;
  final HomeController homeController = Get.put(HomeController());
  Map<String, bool> validate = {
    'actividad': false,
    'category_id': false,
    'date': false,
    'notas': false,
  };

  @override
  void initState() {
    super.initState();
    // Inicializar todas las validaciones en false
    validate = {
      'actividad': false,
      'category_id': false,
      'date': false,
      'notas': false,
    };

    if (widget.isEdit) {
      controller = Get.find<PetActivityController>();
      widget.ImagenEdit = controller.activitiesOne.value!.image ?? "";
      controller.updateField('actividadId', controller.activitiesOne.value!.id);
    } else {
      controller = Get.put(PetActivityController());
    }
  }

  void validateForm() {
    setState(() {
      // Validar solo cuando se presiona el botón
      validate['actividad'] = controller.diario['actividad']?.isEmpty ?? true;
      validate['category_id'] =
          controller.diario['category_id']?.isEmpty ?? true;
      validate['date'] = controller.diario['date']?.isEmpty ?? true;
      validate['notas'] = controller.diario['notas']?.isEmpty ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final margen = 16.0;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              color: Styles.colorContainer,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Completa la Información',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'PoetsenOne',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Añade los datos de este diario',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: margen),
                    Padding(
                      padding: const EdgeInsets.all(Helper.paddingDefault),
                      child: Column(
                        children: [
                          BarraBack(
                            titulo: 'Nuevo Registro',
                            size: 20,
                            callback: () => Get.back(),
                          ),
                          SizedBox(height: margen),
                          SizedBox(
                            width: width,
                            child: InputText(
                              initialValue: widget.isEdit
                                  ? (controller
                                          .activitiesOne.value!.actividad ??
                                      "")
                                  : "",
                              label: 'Título del registro',
                              placeholder: '',
                              errorText: validate['actividad']!
                                  ? 'Campo requerido'
                                  : '',
                              onChanged: (value) {
                                controller.updateField('actividad', value);
                                if (value.isNotEmpty &&
                                    validate['actividad']!) {
                                  setState(() => validate['actividad'] = false);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: margen),
                          SizedBox(
                            width: width,
                            child: InputSelect(
                              TextColor: const Color(0xFF383838),
                              label: 'Categoría',
                              placeholder: "Categoría del registro",
                              onChanged: (value) {
                                controller.updateField('category_id', value);
                                if (value != null && validate['category_id']!) {
                                  setState(
                                      () => validate['category_id'] = false);
                                }
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: '1',
                                  child: Text('Actividad',
                                      style: Helper.selectStyle),
                                ),
                                DropdownMenuItem(
                                  value: '2',
                                  child: Text('Informe médico',
                                      style: Helper.selectStyle),
                                ),
                                DropdownMenuItem(
                                  value: '3',
                                  child: Text('Entrenamiento',
                                      style: Helper.selectStyle),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: margen),
                          SizedBox(
                            width: width,
                            child: InputText(
                              initialValue: widget.isEdit
                                  ? controller.activitiesOne.value!.date
                                  : '',
                              label: 'Fecha del registro',
                              placeholder: 'Fecha del evento',
                              isDateField: true,
                              placeholderSvg: 'assets/icons/svg/calendar.svg',
                              placeholderSuffixSvg:
                                  'assets/icons/svg/flecha_select.svg',
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Styles.iconColorBack,
                              ),
                              errorText:
                                  validate['date']! ? 'Campo requerido' : '',
                              onChanged: (value) {
                                controller.updateField('date', value);
                                if (value.isNotEmpty && validate['date']!) {
                                  setState(() => validate['date'] = false);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: margen),
                          SizedBox(
                            width: width,
                            child: InputText(
                              isTextArea: true,
                              initialValue: widget.isEdit
                                  ? controller.activitiesOne.value!.notas
                                  : '',
                              label: 'Descripción',
                              placeholder: 'Describe el evento',
                              errorText:
                                  validate['notas']! ? 'Campo requerido' : '',
                              onChanged: (value) {
                                controller.updateField('notas', value);
                                if (value.isNotEmpty && validate['notas']!) {
                                  setState(() => validate['notas'] = false);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: margen),
                          SizedBox(
                            width: width,
                            child: InputText(
                              label: 'Adjuntar imagen',
                              placeholderSvg: 'assets/icons/svg/imagen2.svg',
                              placeholder: 'Añadir imagen .pdf',
                              placeholderSuffixSvg:
                                  'assets/icons/svg/vector_select_images.svg',
                              isImagePicker: true,
                              onChanged: (value) {
                                setState(() {
                                  widget.cambio = false;
                                  _imagePath = value;
                                  controller.updateField('image', value);
                                  __imageFile = File(value);
                                });
                              },
                            ),
                          ),
                          if (widget.isEdit &&
                              widget.cambio == false &&
                              widget.ImagenEdit != null)
                            Column(
                              children: [
                                const Text("Imagen Actual"),
                                Image.network(
                                  controller.activitiesOne.value!.image ?? "",
                                  width: width,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    return loadingProgress == null
                                        ? child
                                        : const Center(
                                            child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 250,
                                      height: 150,
                                      child: const Icon(Icons.image,
                                          color: Colors.blue),
                                    );
                                  },
                                ),
                              ],
                            ),
                          SizedBox(height: margen),
                          SizedBox(
                            width: width,
                            height: 54,
                            child: Obx(() {
                              return ButtonDefaultWidget(
                                title: widget.isEdit
                                    ? controller.isLoading.value
                                        ? 'Cargando ...'
                                        : 'Editar'
                                    : controller.isLoading.value
                                        ? 'Cargando ...'
                                        : 'Finalizar',
                                callback: () {
                                  validateForm();
                                  if (validate.containsValue(true)) {
                                    CustomSnackbar.show(
                                      title: 'Error',
                                      message:
                                          'rellene todos los campos requeridos',
                                      isError: true,
                                    );
                                    return;
                                  }
                                  ;

                                  controller.updateField(
                                    'pet_id',
                                    homeController.selectedProfile.value!.id
                                        .toString(),
                                  );

                                  widget.isEdit
                                      ? controller.editPetActivity2(
                                          "${controller.activitiesOne.value!.id}",
                                          __imageFile,
                                        )
                                      : controller.addPetActivity(__imageFile);
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
