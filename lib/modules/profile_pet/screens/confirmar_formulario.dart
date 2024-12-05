import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/profile_pet_screen.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/medical_histor_tab.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class ConfirmarFormulario extends StatelessWidget {
  final HistorialClinicoController medicalHistoryController =
      Get.put(HistorialClinicoController());
  final HomeController petController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    petController.selectType(0);
    return Scaffold(
      backgroundColor: Styles.fiveColor,
      body: Obx(() {
        return Container(
          color: Styles.fiveColor,
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Styles.fiveColor,
                  ),
                  child: const Text(
                    'Registro de Historial',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 302,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Styles.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    "Informe Médico",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Styles.primaryColor,
                                      fontFamily: 'PoetsenOne',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            label: 'Nombre del Informe',
                            placeholder: '',
                            initialValue: medicalHistoryController
                                .reportData["name"]
                                .toString(),
                            prefiIcon: Icon(
                              Icons.calendar_today,
                              color: Color.fromRGBO(252, 186, 103, 1),
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(252, 186, 103, 1),
                            ),
                            onChanged: (value) {
                              medicalHistoryController.updateField(
                                  "fecha_aplicacion", value);
                            },
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            label: 'Fecha de aplicación',
                            placeholder: '',
                            initialValue: medicalHistoryController
                                .reportData["fecha_aplicacion"]
                                .toString(),
                            prefiIcon: Icon(
                              Icons.calendar_today,
                              color: Color.fromRGBO(252, 186, 103, 1),
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(252, 186, 103, 1),
                            ),
                            onChanged: (value) {
                              medicalHistoryController.updateField(
                                  "fecha_aplicacion", value);
                            },
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            label: 'Nombre del Informe',
                            placeholder: '',
                            initialValue: medicalHistoryController
                                .reportData["fecha_refuerzo"]
                                .toString(),
                            prefiIcon: Icon(
                              Icons.calendar_today,
                              color: Color.fromRGBO(252, 186, 103, 1),
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(252, 186, 103, 1),
                            ),
                            onChanged: (value) {
                              medicalHistoryController.updateField(
                                  "fecha_aplicacion", value);
                            },
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          InputText(
                            label: 'Notas adicionales',
                            placeholder: '',
                            initialValue: medicalHistoryController
                                .reportData["notes"]
                                .toString(),
                            prefiIcon: Icon(
                              Icons.calendar_today,
                              color: Color.fromRGBO(155, 142, 127, 1),
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromRGBO(252, 186, 103, 1),
                            ),
                            onChanged: (value) {
                              medicalHistoryController.updateField(
                                  "fecha_aplicacion", value);
                            },
                            readOnly: true,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 302,
                            child: Divider(height: 0, thickness: .4),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 302,
                            child: Text(
                              'Selecciona la mascota',
                              style: Styles.textProfile15w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 305,
                            child: ProfilesDogs(
                              isSelect: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 302,
                            child: Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    medicalHistoryController.isEditing.value
                                        ? "creado ${medicalHistoryController.reportData["created_at"]}"
                                        : "Sera creado : ${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
                                    style: Styles.textProfile15w700,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    medicalHistoryController.isEditing.value
                                        ? "Editado por última vez el ${medicalHistoryController.reportData["updated_at"]}"
                                        : "",
                                    style: Styles.textProfile15w700,
                                  ),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            return medicalHistoryController.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    width: 302,
                                    child: ButtonDefaultWidget(
                                      title: 'Terminar Informe  >',
                                      callback: () {
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
                                          print(
                                              'medical history ${medicalHistoryController.reportData}');

                                          // Envía el informe
                                          medicalHistoryController
                                              .submitReport();

                                          // Actualiza el campo 'pet_id' nuevamente (esto parece redundante, tal vez quieras eliminarlo)
                                          medicalHistoryController.updateField(
                                              'pet_id', petId);

                                          // Si el controlador está cargando, navega a la página del perfil de la mascota
                                          if (medicalHistoryController
                                              .isLoading.value) {
                                            Get.toNamed(
                                              Routes.PROFILEPET,
                                              arguments: petController
                                                  .selectedProfile
                                                  .value, // Pasa el perfil de la mascota
                                            );
                                          }
                                        } else {
                                          // Si el perfil seleccionado es nulo, maneja el caso aquí (puedes mostrar un mensaje de error, por ejemplo)
                                          print(
                                              'No se ha seleccionado un perfil de mascota.');
                                        }
                                      },
                                    ),
                                  );
                          }),
                          const SizedBox(height: 20),
                        ],
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
      child: Container(
        width: 302,
        child: Column(children: [
          Container(
            width: 302,
            child: Text(
              "${label}",
              style: TextStyle(
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
                '${value}',
                // '${medicalHistoryController.reportData["name"]}',
                style: TextStyle(
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
