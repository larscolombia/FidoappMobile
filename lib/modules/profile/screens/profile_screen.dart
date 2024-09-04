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
      body: Container(
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
                            color: Styles.fiveColor, // Color de fondo del borde
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Styles.iconColorBack, // Color del borde
                              width: 3, // Grosor del borde
                            ),
                          ),
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: controller
                                          .profileImagePath.value.isNotEmpty
                                      ? FileImage(File(
                                          controller.profileImagePath.value))
                                      : NetworkImage(
                                              'https://via.placeholder.com/150')
                                          as ImageProvider,
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
                            child:
                                Icon(Icons.edit, color: Colors.white, size: 24),
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
            Expanded(
              child: Container(
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
                    Expanded(
                      child: ListView(
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
                                placeholder: 'Genero',
                                icon: 'assets/icons/tag-user.png',
                                items: [
                                  'Femenino',
                                  'Masculino',
                                  'Prefiero no decirlo',
                                ],
                              ),
                            ),
                            /*
                          _buildSelectField(
                                'Sexo',
                                controller.sexoValue.value,
                                controller.isEditing.value),
                          ),
                          */
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
                          /*
                          _buildTextField('Contraseña',
                              TextEditingController(text: '********'), false),
                              */
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
                                placeholder: 'Tipo de Usuarios',
                                icon: 'assets/icons/tag-user.png',
                                items: [
                                  'Dueño de mascota',
                                  'Invitado de mascota',
                                ],
                              ),
                            ),
                            /*
                            
                             _buildSelectField(
                                'Dueño de mascota',
                                controller.duenioValue.value,
                                controller.isEditing.value,
                                ),
                                */
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        enabled: enabled,
      ),
    );
  }

  Widget _buildSelectField(String label, String value, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: value,
        items: ['Femenino', 'Masculino', 'Prefiero no decirlo', 'Sí', 'No']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: enabled
            ? (String? newValue) {
                if (label == 'Sexo') {
                  controller.updateSexo(newValue);
                } else if (label == 'Dueño de mascota') {
                  controller.updateDuenio(newValue);
                }
              }
            : null,
        disabledHint: Text(value),
      ),
    );
  }
}

class CambiarContrasenaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Contraseña'),
      ),
      body: Center(
        child: Text('Página para cambiar la contraseña'),
      ),
    );
  }
}
