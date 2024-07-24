import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_text_custom.dart';
import 'package:pawlly/components/select_input_text.dart';
import 'package:pawlly/modules/profile/controllers/prodile_controller.dart';
import 'package:pawlly/styles/styles.dart';

class MiPerfilPageScreen extends StatelessWidget {
  final MiPerfilController controller = Get.put(MiPerfilController());

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
                Obx(() => GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Styles.iconColorBack, width: 3),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: controller.profileImagePath.value.isNotEmpty
                                ? FileImage(
                                    File(controller.profileImagePath.value))
                                : NetworkImage(
                                        'https://via.placeholder.com/150')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
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
                      ),
                    )),
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
                                    color: Styles.greyTextColor,
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
                          /*
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: CustomTextFormField(
                              controller: controller.nombreController.value,
                              enabled: controller.isEditing.value,
                              pleholder: 'Confirmar contraseña',
                              icon: 'assets/icons/key.png',
                            ),
                          ),
                          
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: SelecInputText(
                              enabled: controller.isEditing.value,
                              controller: null,
                              placeholder: 'Tipo de Usuarios',
                              icon: 'assets/icons/tag-user.png',
                              items: ['Entrenador', 'Dueño de Mascota'],
                              isDropdown: true,
                            ),
                          ),
                          */
                          Obx(
                            () => Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                controller: controller.nombreController.value,
                                enabled: controller.isEditing.value,
                                pleholder: 'Nombre',
                                icon: 'assets/icons/tag-user.png',
                              ),
                            ),
                          ),
                          Obx(
                            () => Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                controller: controller.apellidoController.value,
                                enabled: controller.isEditing.value,
                                pleholder: 'Apellido',
                                icon: 'assets/icons/tag-user.png',
                              ),
                            ),
                          ),
                          Obx(
                            () => Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                controller: controller.apellidoController.value,
                                enabled: controller.isEditing.value,
                                pleholder: 'Correo',
                                icon: 'assets/icons/tag-user.png',
                              ),
                            ),
                          ),
                          Obx(
                            () => Container(
                              margin: EdgeInsets.only(top: 20),
                              child: SelecInputText(
                                enabled: controller.isEditing.value,
                                controller: null,
                                placeholder: 'Tipo de Usuarios',
                                icon: 'assets/icons/tag-user.png',
                                items: [
                                  'Femenino',
                                  'Masculino',
                                  'Prefiero no decirlo',
                                ],
                                isDropdown: true,
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
                          _buildTextField('Contraseña',
                              TextEditingController(text: '********'), false),
                          GestureDetector(
                            onTap: () {
                              // Navegar a la página de cambiar contraseña
                              Get.to(() => CambiarContrasenaPage());
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Cambiar Contraseña',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => Container(
                              margin: EdgeInsets.only(top: 20),
                              child: SelecInputText(
                                enabled: controller.isEditing.value,
                                controller: null,
                                placeholder: 'Tipo de Usuarios',
                                icon: 'assets/icons/tag-user.png',
                                items: [
                                  'Si',
                                  'No',
                                ],
                                isDropdown: true,
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
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
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
