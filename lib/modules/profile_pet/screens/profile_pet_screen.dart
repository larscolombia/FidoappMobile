import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/styles/styles.dart';

class ProfilePetScreen extends StatelessWidget {
  final ProfilePetController controller = Get.put(ProfilePetController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.height / 4;

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            height: imageSize + 36,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/600x400'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido del perfil
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: imageSize + 16),
                  padding: Styles.paddingAll,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección del Perfil
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
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
                                  'Perfil de la Mascota',
                                  style: Styles.dashboardTitle20,
                                ),
                                /*
                                Container(
                                  width: 1,
                                  height: 25,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  color: Styles.greyColor,
                                ),
                                */
                                Obx(
                                  () => ElevatedButton(
                                    onPressed: controller.toggleEditing,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor:
                                          controller.isEditing.value
                                              ? Styles.iconColorBack
                                              : Styles.greyTextColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      minimumSize: Size(
                                          48, 48), // Ajusta el tamaño del botón
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Pestañas
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(
                              () => ButtonDefaultWidget(
                                title: 'Información',
                                callback: () => controller.changeTab(0),
                                widthButtom: (MediaQuery.of(context)
                                            .size
                                            .width /
                                        2) -
                                    30, // Ajusta el ancho para que los dos botones ocupen el ancho total
                                defaultColor: controller.selectedTab.value == 0
                                    ? Styles.primaryColor
                                    : Colors.transparent,
                                textColor: controller.selectedTab.value == 0
                                    ? Styles.whiteColor
                                    : Colors.black,
                                border: controller.selectedTab.value == 0
                                    ? null
                                    : BorderSide(color: Colors.grey, width: 1),
                                textSize: 14,
                              ),
                            ),
                            Obx(
                              () => ButtonDefaultWidget(
                                title: 'Historial Médico',
                                callback: () => controller.changeTab(1),
                                widthButtom: (MediaQuery.of(context)
                                            .size
                                            .width /
                                        2) -
                                    30, // Ajusta el ancho para que los dos botones ocupen el ancho total
                                defaultColor: controller.selectedTab.value == 1
                                    ? Styles.primaryColor
                                    : Colors.transparent,
                                textColor: controller.selectedTab.value == 1
                                    ? Styles.whiteColor
                                    : Colors.black,
                                border: controller.selectedTab.value == 1
                                    ? null
                                    : BorderSide(color: Colors.grey, width: 1),
                                textSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(height: 40, thickness: 1),

                      // Contenido de las pestañas
                      Expanded(
                        child: Obx(() {
                          if (controller.selectedTab.value == 0) {
                            return _buildInformationTab();
                          } else {
                            return _buildMedicalHistoryTab();
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Construir pestaña de Información
  Widget _buildInformationTab() {
    return ListView(
      padding: EdgeInsets.only(top: 2),
      children: [
        // Nombre de la mascota y botón de compartir
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Nombre',
                  style: Styles.textProfile14w400,
                ),
                Text(
                  controller.petName.value,
                  style: Styles.dashboardTitle20,
                ),
              ],
            ),
            ButtonDefaultWidget(
              title: 'Compartir',
              callback: () {
                // Lógica para compartir perfil
              },
              defaultColor: Colors.transparent, // Fondo blanco o transparente
              border: BorderSide(color: Colors.grey, width: 1), // Borde gris
              textColor: Colors.black, // Texto negro
              icon: Icons.share, // Icono de compartir
              iconAfterText: true, // Icono despues del texto
              widthButtom: 150, // Ajusta el ancho según sea necesario
              textSize: 14,
              borderSize: 25,
              heigthButtom: 40,
            ),
/*
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para compartir perfil
              },
              label: Text('Compartir'),
              icon: Icon(Icons.share),
            ),
            .*/
          ],
        ),
        SizedBox(height: 20),
        // Card de la raza
        Card(
          color: Styles.fiveColor,
          child: ListTile(
            leading: Icon(
              Icons.pets,
              color: Styles.iconColorBack,
            ),
            title: Text(
              'Raza:',
              style: Styles.textProfile14w400,
            ),
            subtitle: Text(
              controller.petBreed.value,
              style: Styles.textProfile14w800,
            ),
          ),
        ),
        SizedBox(height: 20),
        // Sección sobre la mascota
        Text(
          'Sobre ${controller.petName.value}',
          style: Styles.textProfile15w700,
        ),
        Text(
          controller.petDescription.value,
          style: Styles.textProfile15w400,
        ),
        SizedBox(height: 20),
        // Card de cumpleaños y fecha de nacimiento
        Card(
          color: Styles.fiveColor,
          child: ListTile(
            leading: Icon(
              Icons.cake,
              color: Styles.iconColorBack,
            ),
            title: Text(
              'Edad:',
              style: Styles.textProfile14w400,
            ),
            subtitle: Text(
              controller.petAge.value,
              style: Styles.textProfile14w800,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fecha de nacimiento:',
                  style: Styles.textProfile14w400,
                ),
                Text(
                  controller.petBirthDate.value,
                  style: Styles.textProfile14w800,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        // Cards de peso y sexo
        Row(
          children: [
            Expanded(
              child: Card(
                color: Styles.fiveColor,
                child: ListTile(
                  leading: Icon(
                    Icons.line_weight,
                    color: Styles.iconColorBack,
                  ),
                  title: Text(
                    'Peso:',
                    style: Styles.textProfile14w400,
                  ),
                  subtitle: Text(
                    controller.petWeight.value,
                    style: Styles.textProfile14w800,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: Styles.fiveColor,
                child: ListTile(
                  leading: Icon(
                    Icons.female,
                    color: Styles.iconColorBack,
                  ),
                  title: Text(
                    'Sexo:',
                    style: Styles.textProfile14w400,
                  ),
                  subtitle: Text(
                    controller.petGender.value,
                    style: Styles.textProfile14w800,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        // Sección de compartir QR
        Text(
          'Comparte este perfil con este QR:',
          style: Styles.textProfile14w700,
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              'https://via.placeholder.com/300', // Imagen QR agrandada
              width: double.infinity,
            ),
          ),
        ),
        SizedBox(height: 20),
        // Personas asociadas a la mascota
        Row(
          children: [
            Expanded(
              child: Text(
                'Personas Asociadas a esta Mascota',
                style: Styles.textTitleHome,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.iconColorBack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: controller.associatedPersons.map((person) {
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1), // Borde de 1 px color gris
                borderRadius: BorderRadius.circular(8), // Radio de borde
              ),
              color: Colors.white, // Fondo transparente
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30, // Aumenta el tamaño de la imagen
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                  backgroundColor: Colors
                      .transparent, // Asegura que el fondo sea transparente
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Styles.iconColorBack, // Color del borde
                        width: 1.0, // Grosor del borde
                      ),
                    ),
                  ),
                ),
                title: Text(
                  person['name'] ?? '',
                  style: Styles.textProfile14w700,
                ),
                subtitle: Text(
                  person['relation'] ?? '',
                  style: Styles.textProfile12w400,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios, // Icono de flecha ">"
                  color: Styles.iconColorBack, // Color del icono
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        // Botón de eliminar mascota
        Center(
          child: TextButton(
            onPressed: controller.deletePet,
            child: Text(
              'Eliminar mascota',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Construir pestaña de Historial Médico
  Widget _buildMedicalHistoryTab() {
    return Center(
      child: Text(
        'Historial Médico',
        style: Styles.dashboardTitle20,
      ),
    );
  }
}
