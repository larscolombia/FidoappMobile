import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

class Helper extends GetX {
  const Helper({super.key, required super.builder});

  static Helper get instance => Get.find<Helper>();
  static const errorValidate = "Por favor, rellene todos los campos requeridos.";
  static const margenDefault = 16.0;
  static const paddingDefault = 26.0;
  static const String funte1 = 'Lato';
  static const String funte2 = 'PoetsenOne';
  static const Color dividerColor = Color(0xFFEAEAEA);
  static const selectStyle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.3,
    letterSpacing: 0,
  );

  static const tuttleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static String formatDate(String date) {
    if (date.isEmpty) return date;
    final parts = date.split('/');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}'; // Formato DD/MM/AAAA
    }
    return date;
  }

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

  static Future<void> showMyDialog(BuildContext context, UserController controller) async {
    final UserController userController = Get.put(UserController(), permanent: true);
    final CalendarController calendarController = Get.put(CalendarController());
    String typedEmail = '';
    controller.fetchUsers(controller.type.value);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0), // Ajusta el valor del radio según desees
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
                              colorFilter: const ColorFilter.mode(Color(0XFFBEBEBE), BlendMode.srcIn), // Aplica color rojo
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
                    onChanged: (value) {
                      typedEmail = value;
                      userController.filterUsers(value);
                    },
                  ),
                  Obx(() {
                    var filteredUsers = userController.filteredUsers;
                    if (filteredUsers.isEmpty) {
                      final tipo = calendarController.event['tipo'];
                      final message = tipo == 'evento'
                          ? 'No se encontró el usuario, el evento se creará sin invitado'
                          : 'El usuario no se encuentra registrado en la plataforma, se asignará un profesional aleatoriamente';
                      return Text(message);
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
                          nombre: filteredUsers.first.firstName,
                          imageUrl: filteredUsers.first.profileImage,
                          profesion: Helper.tipoUsuario(filteredUsers.first.userType ?? ""),
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
                          calendarController.updateField('user_email', '');
                          userController.deselectUser();
                          userController.selectUser(userController.filteredUsers.first);
                          Navigator.of(context).pop();
                        } else {
                          final tipo = calendarController.event['tipo'];
                          if (tipo == 'evento') {
                            // Permitir crear el evento sin invitado
                            userController.deselectUser();
                            calendarController.updateField('owner_id', []);
                            if (typedEmail.isNotEmpty) {
                              calendarController.updateField('user_email', typedEmail);
                            }
                            CustomSnackbar.show(
                              title: 'Aviso',
                              message: 'No se encontró el usuario, el evento se creará sin invitado',
                              isError: false,
                            );
                            Navigator.of(context).pop();
                          } else {
                            CustomSnackbar.show(
                              title: 'Aviso',
                              message: 'El usuario no se encuentra registrado en la plataforma, se asignará un profesional aleatoriamente',
                              isError: false,
                            );
                            if (userController.users.isNotEmpty) {
                              final randomUser = userController.users[Random().nextInt(userController.users.length)];
                              calendarController.updateField('owner_id', [randomUser.id]);
                              userController.selectUser(randomUser);
                            }
                            if (typedEmail.isNotEmpty) {
                              calendarController.updateField('user_email', typedEmail);
                            }
                            Navigator.of(context).pop();
                          }
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

  static String cleanNumberString(String input) {
    RegExp regExp = RegExp(r'[0-9\.]');
    String cleanedString = regExp.allMatches(input).map((m) => m.group(0)).join();
    return cleanedString;
  }
}
