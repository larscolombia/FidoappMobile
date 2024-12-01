import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascotas/mascotas_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/profile_pet_screen.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/medical_histor_tab.dart';
import 'package:pawlly/styles/styles.dart';

class ConfirmarFormulario extends StatelessWidget {
  final HistorialClinicoController medicalHistoryController =
      Get.put(HistorialClinicoController());
  final PetControllerv2 petController = Get.put(PetControllerv2());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.fiveColor,
      body: Obx(() {
        if (medicalHistoryController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

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
                          ShowHistorial(
                            label: 'Nombre del Informe',
                            value: medicalHistoryController.reportData["name"]
                                .toString(),
                          ),
                          const SizedBox(height: 20),
                          ShowHistorial(
                            label: 'Fecha de aplicación',
                            value: medicalHistoryController
                                .reportData["fecha_aplicacion"]
                                .toString(),
                          ),
                          const SizedBox(height: 20),
                          ShowHistorial(
                            label: 'Fecha de refuerzo de vacuna:',
                            value: medicalHistoryController
                                .reportData["fecha_refuerzo"]
                                .toString(),
                          ),
                          const SizedBox(height: 20),
                          ShowHistorial(
                            label: 'Nota adicionales',
                            value: medicalHistoryController
                                .reportData["fecha_refuerzo"]
                                .toString(),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 302,
                            child: Text(
                              'Selecciona la mascota',
                              style: Styles.textProfile15w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 302,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: const NetworkImage(
                                    "https://via.placeholder.com/150"),
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Styles
                                          .iconColorBack, // Cambia al color que desees
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                petController.selectedPet.value!.name,
                                style: Styles.textProfile14w700,
                              ),
                              subtitle: RichText(
                                text: TextSpan(
                                  text: petController.selectedPet.value!.age
                                          .toString() ??
                                      '',
                                  style: Styles
                                      .textProfile12w400, // Usa tu estilo aquí
                                  children: const [
                                    TextSpan(
                                      text: ' | Pendiente',
                                      style: TextStyle(
                                          color:
                                              Colors.black), // Texto en negro
                                    ),
                                  ],
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Styles
                                    .iconColorBack, // Cambia al color que desees
                              ),
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
                                        medicalHistoryController.submitReport();

                                        if (medicalHistoryController
                                            .isSuccess.value) {
                                          print('');
                                          Get.to(ProfilePetScreen());
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
