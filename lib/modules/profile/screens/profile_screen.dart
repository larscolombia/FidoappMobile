import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child:
                                Icon(Icons.edit, color: Colors.white, size: 16),
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
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
                              Obx(
                                () => IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: controller.isEditing.value
                                          ? Colors.blue
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(Icons.edit,
                                        color: Colors.white, size: 16),
                                  ),
                                  onPressed: () {
                                    controller.toggleEditing();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1),
                        ],
                      ),
                    ),
                    // Formulario de Perfil
                    Expanded(
                      child: ListView(
                        children: [
                          Obx(
                            () => _buildTextField(
                                'Nombre',
                                controller.nombreController.value,
                                controller.isEditing.value),
                          ),
                          Obx(
                            () => _buildTextField(
                                'Apellido',
                                controller.apellidoController.value,
                                controller.isEditing.value),
                          ),
                          Obx(
                            () => _buildTextField(
                                'Correo',
                                controller.correoController.value,
                                controller.isEditing.value),
                          ),
                          Obx(
                            () => _buildSelectField(
                                'Sexo',
                                controller.sexoValue.value,
                                controller.isEditing.value),
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
                            () => _buildSelectField(
                                'Dueño de mascota',
                                controller.duenioValue.value,
                                controller.isEditing.value),
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
