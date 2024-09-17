import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/auth/password/screens/change_password_screen.dart';
import 'package:pawlly/modules/profile/controllers/profile_controller.dart';
import 'package:pawlly/styles/styles.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.height / 4;

    return Scaffold(
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
                            padding: EdgeInsets.all(
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
                                        : AssetImage('assets/images/avatar.png')
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
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Styles.iconColorBack,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nombre del Usuario
                  Positioned(
                    bottom: 16,
                    child: Text(
                      'Victoria',
                      style: Styles.dashboardTitle24,
                    ),
                  ),
                ],
              ),

              // Contenido del Perfil
              Container(
                padding: Styles.paddingAll,
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: controller.isEditing.value
                      ? Colors.grey.shade300
                      : Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección del Perfil
                    Container(
                      padding: EdgeInsets.only(
                        top: 20,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Styles.primaryColor,
                                    size: 22,
                                  ),
                                ),
                                Text(
                                  'Perfil de Usuario',
                                  style: Styles.dashboardTitle20,
                                ),
                                Container(
                                  width: 1, // Grosor de la línea
                                  height: 25, // Altura de la línea
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3), // Espacio en los lados
                                  color: Styles.greyColor, // Color de la línea
                                ),
                                Obx(
                                  () => TextButton.icon(
                                    onPressed: () {
                                      controller.toggleEditing();
                                    },
                                    icon: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: controller.isEditing.value
                                            ? Styles.iconColorBack
                                            : Styles.greyTextColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(Icons.edit,
                                          color: Colors.white, size: 24),
                                    ),
                                    label: Text(
                                      'Editar',
                                      style: TextStyle(
                                        color: controller.isEditing.value
                                            ? Styles.iconColorBack
                                            : Styles.greyTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 0, thickness: 1),
                        ],
                      ),
                    ),
                    // Formulario de Perfil
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CustomTextFormFieldWidget(
                              controller: controller.nameController.value,
                              enabled: controller.isEditing.value,
                              placeholder: 'Nombre',
                              icon: 'assets/icons/profile.png',
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CustomTextFormFieldWidget(
                              controller: controller.lastNameController.value,
                              enabled: controller.isEditing.value,
                              placeholder: 'Apellido',
                              icon: 'assets/icons/profile.png',
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CustomTextFormFieldWidget(
                              controller: controller.emailController.value,
                              enabled: controller.isEditing.value,
                              placeholder: 'Correo',
                              icon: 'assets/icons/email.png',
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CustomSelectFormFieldWidget(
                              enabled: controller.isEditing.value,
                              controller: controller.userGenCont.value,
                              placeholder: 'Género',
                              icon: 'assets/icons/tag-user.png',
                              items: [
                                'Femenino',
                                'Masculino',
                                'Prefiero no decirlo',
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: CustomTextFormFieldWidget(
                              controller: controller.passwordController.value,
                              enabled: false,
                              obscureText: true,
                              placeholder: 'Contraseña',
                              icon: 'assets/icons/key.png',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navegar a la página de cambiar contraseña
                            Get.to(() => ChangePasswordScreen());
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Cambiar Contraseña',
                              style: TextStyle(
                                color: Styles.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CustomSelectFormFieldWidget(
                              enabled: controller.isEditing.value,
                              controller: controller.userTypeCont.value,
                              placeholder: 'Tipo de Usuario',
                              icon: 'assets/icons/tag-user.png',
                              items: [
                                'Dueño de mascota',
                                'Invitado de mascota',
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              // Lógica para eliminar cuenta
                            },
                            child: Text(
                              'Eliminar cuenta',
                              style: TextStyle(color: Styles.primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
