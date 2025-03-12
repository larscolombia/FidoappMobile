import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/model/historial_clinico/historial_clinico_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

import 'package:pawlly/styles/styles.dart';

class ConfirmarFormulario extends StatelessWidget {
  final HistorialClinicoController medicalHistoryController =
      Get.put(HistorialClinicoController());
  final HomeController petController = Get.find<HomeController>();
  final bool isEdit;
  final HistorialClinico historialClinico;
  ConfirmarFormulario({
    super.key,
    this.isEdit = false,
    required this.historialClinico,
  });
  @override
  Widget build(BuildContext context) {
    // petController.selectType(0);
    print(
        'historial en vista ${AuthServiceApis.dataCurrentUser.userType}  ${isEdit}');

    return Scaffold(
      backgroundColor: Styles.fiveColor,
      body: Obx(() {
        return Container(
          color: Styles.fiveColor,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Styles.fiveColor,
                  ),
                  child: const Center(
                    child: Text(
                      'Registro de Historial',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: Styles.paddingAll,
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: BarraBack(
                                titulo: isEdit == false
                                    ? "Informe Médico"
                                    : "${historialClinico!.categoryName}" ?? '',
                                callback: () {
                                  Get.back();
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (isEdit == true)
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: InputSelect(
                                  onChanged: (value) {
                                    historialClinico!.reportName =
                                        medicalHistoryController
                                            .reporType(value);
                                    historialClinico!.reportType = value;
                                  },
                                  TextColor: Colors.white,
                                  isReadOnly: isEdit,
                                  color: Styles.primaryColor,
                                  placeholder: medicalHistoryController
                                      .reporType(medicalHistoryController
                                          .reportData['report_type']
                                          .toString()),
                                  prefiIcon: 'assets/icons/categori.png',
                                  items: const [
                                    DropdownMenuItem(
                                      value: '1',
                                      child: Text('Vacunas'),
                                    ),
                                    DropdownMenuItem(
                                      value: '2',
                                      child: Text('Antiparasitante'),
                                    ),
                                    DropdownMenuItem(
                                      value: '3',
                                      child: Text('Antigarrapata'),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: InputText(
                                label: 'Nombre del Informe',
                                placeholder: '',
                                initialValue:
                                    historialClinico!.reportName.toString() ??
                                        '',
                                onChanged: (value) {
                                  historialClinico!.reportName = value;
                                },
                                readOnly: isEdit,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: InputText(
                                isDateField: true,
                                label: 'Fecha de aplicación',
                                placeholder: '',
                                initialValue: historialClinico.fechaAplicacion,
                                placeholderSvg: 'assets/icons/svg/calendar.svg',
                                suffixIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color.fromRGBO(252, 186, 103, 1),
                                ),
                                onChanged: (value) {
                                  historialClinico!.applicationDate = value;
                                },
                                readOnly: isEdit,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: InputText(
                                label: 'Fecha de refuerzo',
                                placeholder: '',
                                isDateField: true,
                                initialValue:
                                    historialClinico!.fechaRefuerzo.toString(),
                                placeholderSvg: 'assets/icons/svg/calendar.svg',
                                suffixIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color.fromRGBO(252, 186, 103, 1),
                                ),
                                onChanged: (value) {
                                  historialClinico!.fechaRefuerzo = value;
                                },
                                readOnly: isEdit,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: InputText(
                                label: 'notas',
                                placeholder: '',
                                initialValue: historialClinico!
                                    .medicalConditions
                                    .toString(),
                                onChanged: (value) {
                                  historialClinico!.medicalConditions = value;
                                  historialClinico!.notes = value;
                                },
                                readOnly: isEdit,
                              ),
                            ),
                            /** 
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Styles.fiveColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Styles.iconColorBack.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              width: 305,
                              height: 200,
                              child: TextField(
                                expands: true,
                                maxLines: null,
                                readOnly: isEdit! ? false : true,
                                keyboardType: TextInputType.multiline,
                                onChanged: (value) => medicalHistoryController
                                    .updateField('notes', value),
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Quitar el borde
                                  hintText: historial.notes ?? '',
                                ),
                              ),
                            ),*/
                            const SizedBox(height: 20),
                            const SizedBox(
                              width: 302,
                              child: Divider(height: 0, thickness: .4),
                            ),
                            const SizedBox(height: 20),
                            isEdit == false
                                ? SizedBox(
                                    width: 302,
                                    child: Text(
                                      'Selecciona la mascota',
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF383838)),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 10),
                            isEdit == false
                                ? SizedBox(
                                    width: 324,
                                    child: ProfilesDogs(
                                      isSelect: true,
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 302,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    medicalHistoryController.isEditing.value
                                        ? "creado ${historialClinico!.createdAt}"
                                        : "Sera creado : ${historialClinico!.createdAt}",
                                    style: Styles.textProfile15w700,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    medicalHistoryController.isEditing.value
                                        ? "Editado por última vez el ${historialClinico!.updatedAt}"
                                        : "",
                                    style: Styles.textProfile15w700,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (AuthServiceApis.dataCurrentUser.userType !=
                                'user')
                              isEdit == true
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      child: ButtonDefaultWidget(
                                        title: medicalHistoryController
                                                .isLoading.value
                                            ? 'Cargando ...'
                                            : 'Actualizar',
                                        callback: () {
                                          medicalHistoryController
                                              .updateReport(historialClinico);
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                            SizedBox(
                              width: 302,
                              child: !medicalHistoryController.isEditing.value
                                  ? ButtonDefaultWidget(
                                      title: 'Terminar Informe  >',
                                      callback: () {
                                        print(
                                            'Informe medico ${jsonEncode(medicalHistoryController.reportData)}');

                                        // Asegúrate de que selectedProfile no sea nulo antes de acceder a sus propiedades
                                        if (petController
                                                .selectedProfile.value !=
                                            null) {
                                          // Accede al valor del perfil de la mascota correctamente
                                          final petId = petController
                                              .selectedProfile.value!.id
                                              .toString();

                                          // Actualiza el campo 'pet_id' en el controlador de historial médico
                                          medicalHistoryController.updateField(
                                              'pet_id', petId);

                                          // Envía el informe
                                          medicalHistoryController
                                              .submitReport();
                                        } else {
                                          // Si el perfil seleccionado es nulo, maneja el caso aquí (puedes mostrar un mensaje de error, por ejemplo)
                                          print(
                                              'No se ha seleccionado un perfil de mascota.');
                                        }
                                      },
                                    )
                                  : const SizedBox(),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ShowHistorial extends StatelessWidget {
  const ShowHistorial({
    super.key,
    this.label,
    this.value,
  });

  final String? label;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 302,
        child: Column(children: [
          SizedBox(
            width: 302,
            child: Text(
              "$label",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Lato',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 302,
            height: 54,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '$value',
                // '${medicalHistoryController.reportData["name"]}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
