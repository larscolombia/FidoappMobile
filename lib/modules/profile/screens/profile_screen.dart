import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/auth/password/screens/change_password_screen.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/profile/controllers/profile_controller.dart';
import 'package:pawlly/modules/profile/screens/formulario_verificacion.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final UserProfileController userCpntroller = Get.put(UserProfileController());
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.height / 4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Agregamos el SingleChildScrollView aquí
        child: Container(
          color: Styles.fiveColor,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Contenedor de la Imagen
                  Container(
                    height: imageSize,
                    width: double.infinity,
                    color: Styles.fiveColor,
                  ),
                  // Imagen Circular con Borde
                  Obx(
                    () => GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(
                                4), // Espacio entre la imagen y el borde
                            decoration: BoxDecoration(
                              color:
                                  Styles.fiveColor, // Color de fondo del borde
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Styles.iconColorBack, // Color del borde
                                width: 3, // Grosor del borde
                              ),
                            ),
                            child: ClipOval(
                              child: Container(
                                width: 92, // Ajusta el ancho si es necesario
                                height: 92, // Ajusta el alto si es necesario
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: controller
                                            .profileImagePath.value.isNotEmpty
                                        ? (controller.profileImagePath.value
                                                .startsWith('http')
                                            ? NetworkImage(controller
                                                .profileImagePath
                                                .value) // Imagen desde URL
                                            : FileImage(File(controller
                                                .profileImagePath
                                                .value))) // Imagen local
                                        : const AssetImage(
                                                'assets/images/avatar.png')
                                            as ImageProvider, // Imagen predeterminada
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Styles.iconColorBack,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.edit,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nombre del Usuario
                  Positioned(
                    bottom: -5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        textAlign: TextAlign.center,
                        '${controller.user['first_name'].toString()}',
                        style: Styles.dashboardTitle24,
                      ),
                    ),
                  ),
                ],
              ),

              // Contenido del Perfil
              Container(
                padding: Styles.paddingAll,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección del Perfil
                    Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  child: BarraBack(
                                      titulo: "Perfil de Usuario",
                                      callback: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                                Obx(() {
                                  return GestureDetector(
                                    onTap: () => controller.toggleEditing(),
                                    child: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: controller.isEditing.value
                                              ? Styles.fiveColor
                                              : Styles.greyTextColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Image.asset(
                                            'assets/icons/edit-2.png')),
                                  );
                                }),
                              ],
                            ),
                          ),
                          if (AuthServiceApis.dataCurrentUser.userRole[0] !=
                              'user')
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: ButtonDefaultWidget(
                                callback: () {
                                  Get.to(FormularioVerificacion());
                                },
                                title: 'Verificación Profesional >',
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Formulario de Perfil
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Obx(() {
                          return InputText(
                            onChanged: (value) =>
                                controller.user['first_name'] = value,
                            initialValue:
                                controller.user['first_name'].toString(),
                            placeholderImage:
                                Image.asset('assets/icons/profile.png'),
                            placeholder: '',
                            readOnly: !controller.isEditing.value,
                            fondoColor: controller.isEditing.value == false
                                ? Colors.white
                                : Styles.fiveColor,
                          );
                        }),
                        const SizedBox(height: 20),
                        Obx(() {
                          return InputText(
                            onChanged: (value) =>
                                controller.user['last_name'] = value,
                            initialValue:
                                controller.user['last_name'].toString(),
                            placeholder: '',
                            placeholderImage:
                                Image.asset('assets/icons/profile.png'),
                            readOnly: !controller.isEditing.value,
                            fondoColor: controller.isEditing.value == false
                                ? Colors.white
                                : Styles.fiveColor,
                          );
                        }),
                        const SizedBox(height: 20),
                        Obx(() {
                          return InputText(
                            onChanged: (value) =>
                                controller.user['email'] = value,
                            initialValue: controller.user['email'].toString(),
                            placeholder: '',
                            placeholderImage:
                                Image.asset('assets/icons/sms.png'),
                            readOnly: !controller.isEditing.value,
                            fondoColor: controller.isEditing.value == false
                                ? Colors.white
                                : Styles.fiveColor,
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navegar a la página de cambiar contraseña
                            Get.to(() => ChangePasswordScreen());
                          },
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Cambiar Contraseña  >',
                              style: TextStyle(
                                color: Styles.primaryColor,
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CustomSelectFormFieldWidget(
                              enabled: controller.isEditing.value,
                              controller: controller.userGenCont.value,
                              filcolorCustom: Colors.white,
                              borderColor: Styles.iconColorBack,
                              onChange: (value) {
                                controller.user['gender'] = value.toString();
                                controller.userGenCont.value.text =
                                    value.toString().toLowerCase();
                              },
                              placeholder: 'Género',
                              icon: 'assets/icons/tag-user.png',
                              items: const [
                                'Femenino',
                                'Masculino',
                                'Prefiero no decirlo',
                              ],
                            ),
                          ),
                        ),
                        /**
                        Obx(
                          () => Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: CustomTextFormFieldWidget(
                              controller: controller.passwordController.value,
                              callback: (value) {
                                controller.user['password'] = value.toString();
                              },
                              enabled: false,
                              obscureText: true,
                              placeholder: 'Contraseña',
                              icon: 'assets/icons/key.png',
                            ),
                          ),
                        ),
                         */

                        /** 
                        Obx(
                          () => Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CustomSelectFormFieldWidget(
                              enabled: controller.isEditing.value,
                              controller: controller.userTypeCont.value,
                              placeholder: 'Tipo de Usuario',
                              icon: 'assets/icons/tag-user.png',
                              onChange: (value) {
                                controller.user['userType'] = value.toString();
                              },
                              items: const [
                                'Dueño de mascota',
                                'Invitado de mascota',
                              ],
                            ),
                          ),
                        ),*/
                        const SizedBox(height: 20),
                        Obx(
                          () => controller.isEditing.value == true
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: ButtonDefaultWidget(
                                    title: controller.isLoading.value
                                        ? 'Actualizando ...'
                                        : 'Editar',
                                    callback: () {
                                      controller.updateProfile();
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              // Lógica para eliminar cuenta
                            },
                            child: const Text(
                              'Eliminar cuenta',
                              style: TextStyle(color: Styles.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
