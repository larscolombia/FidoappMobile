import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

class Helper extends GetX {
  Helper({required super.builder});

  static Helper get instance => Get.find<Helper>();

  static const margenDefault = 16.0;
  static const paddingDefault = 26.0;
  static const String funte1 = 'Lato';
  static const Color dividerColor = Color(0xFFEAEAEA);

  static String tipoUsuario(String userType) {
    switch (userType) {
      case 'vet':
        return 'Veterinario';
      case 'trainer':
        return 'Entrenador';
      case 'user':
        return 'Usuario';
      default:
        return 'Usuario';
    }
  }

  static String formatDateToSpanish(String? date) {
    if (date == null || date.isEmpty) return "Fecha no disponible";

    try {
      // Definir el formato de entrada según el formato de la fecha proporcionada
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');

      // Analizar la fecha de entrada
      DateTime parsedDate = inputFormat.parse(date);

      // Definir el formato de salida
      DateFormat outputFormat = DateFormat("d 'de' MMMM 'de' yyyy", 'es_ES');

      // Formatear la fecha al formato deseado
      String formattedDate = outputFormat.format(parsedDate);

      return formattedDate;
    } catch (e) {
      return "Fecha inválida";
    }
  }

  static Widget closeButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SvgPicture.asset(
        'assets/icons/svg/x.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Color(0XFFBEBEBE), BlendMode.srcIn),
      ),
    );
  }

  static Future<void> showMyDialog(
      BuildContext context, UserController controller) async {
    final UserController userController =
        Get.put(UserController(), permanent: true);
    final CalendarController calendarController = Get.put(CalendarController());
    controller.type.value = 'vet';
    controller.fetchUsers();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                28.0), // Ajusta el valor del radio según desees
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 302,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 302,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Invitar personas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Lato',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SvgPicture.asset(
                              'assets/icons/svg/x.svg',
                              width: 24, // Ajusta el tamaño si es necesario
                              height: 24,
                              colorFilter: ColorFilter.mode(Color(0XFFBEBEBE),
                                  BlendMode.srcIn), // Aplica color rojo
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InputText(
                    label: '',
                    placeholder: 'Correo Electrónico',
                    placeholderSvg: 'assets/icons/svg/sms.svg',
                    onChanged: (value) => userController.filterUsers(value),
                  ),
                  Obx(() {
                    var filteredUsers = userController.filteredUsers;
                    if (filteredUsers.isEmpty) {
                      return const Text("No se encontraron usuarios");
                    }
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        const SizedBox(
                          width: 300,
                          child: Text(
                            "Invitados:",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SelectedAvatar(
                          width: 300,
                          nombre: filteredUsers.first.firstName,
                          imageUrl: filteredUsers.first.profileImage,
                          profesion: Helper.tipoUsuario(
                              filteredUsers.first.userType ?? ""),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: ButtonDefaultWidget(
                      title: 'Invitar Persona',
                      callback: () {
                        if (userController.filteredUsers.isNotEmpty) {
                          calendarController.updateField(
                            'owner_id',
                            [userController.filteredUsers.first.id],
                          );
                          userController.deselectUser();
                          userController
                              .selectUser(userController.filteredUsers.first);
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'No hay usuarios disponibles para invitar'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget titulo(title) {
    return Text(
      title,
      style: const TextStyle(
        color: Styles.primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        fontFamily: 'PoetsenOne',
        height: 1.3,
      ),
    );
  }

  static void showErrorSnackBar(String message) {
    GetSnackBar(
      title: "Error",
      message: message,
      icon: const Icon(Icons.error, color: Colors.white),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    );
  }
}
