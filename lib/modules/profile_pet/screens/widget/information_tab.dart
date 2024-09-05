import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/associated_persons_modal.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class InformationTab extends StatelessWidget {
  final ProfilePetController controller;

  InformationTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 2),
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
              defaultColor: Colors.transparent,
              border: const BorderSide(color: Colors.grey, width: 1),
              textColor: Colors.black,
              icon: Icons.share,
              iconAfterText: true,
              widthButtom: 150,
              textSize: 14,
              borderSize: 25,
              heigthButtom: 40,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Card de la raza
        Card(
          color: Styles.fiveColor,
          child: ListTile(
            leading: const Icon(
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
        const SizedBox(height: 20),
        // Sección sobre la mascota
        Text(
          'Sobre ${controller.petName.value}',
          style: Styles.textProfile15w700,
        ),
        Text(
          controller.petDescription.value,
          style: Styles.textProfile15w400,
        ),
        const SizedBox(height: 20),
        // Card de cumpleaños y fecha de nacimiento
        Card(
          color: Styles.fiveColor,
          child: ListTile(
            leading: const Icon(
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
        const SizedBox(height: 20),
        // Cards de peso y sexo
        Row(
          children: [
            Expanded(
              child: Card(
                color: Styles.fiveColor,
                child: ListTile(
                  leading: const Icon(
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
                  leading: const Icon(
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
        const SizedBox(height: 20),
        // Sección de compartir QR
        Text(
          'Comparte este perfil con este QR:',
          style: Styles.textProfile14w700,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
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
        const SizedBox(height: 20),
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return AssociatedPersonsModal(controller: controller);
                  },
                );
              },
              /*
              onPressed: () {
                showAssociatedPersonsDialog(context, controller);
              },
              */
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.iconColorBack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: controller.associatedPersons.map((person) {
            return GestureDetector(
              onTap: () {
                // Navegar a la ruta 'PETOWNERPROFILE' y pasar los datos del perfil si es necesario
                Get.toNamed(Routes.PETOWNERPROFILE, arguments: person);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side:
                      BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      person['imageUrl'] ??
                          'https://via.placeholder.com/150', // Cambiar por la URL de la persona
                    ),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Styles.iconColorBack,
                          width: 1.0,
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
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Styles.iconColorBack,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        // Botón de eliminar mascota
        Center(
          child: TextButton(
            onPressed: controller
                .deletePet, // Llamar a la función para mostrar el modal
            child: const Text(
              'Eliminar mascota',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void showAssociatedPersonsDialog(
      BuildContext context, ProfilePetController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Personas Asociadas a esta Mascota"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input de correo electrónico
                TextField(
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Input de rol
                TextField(
                  decoration: InputDecoration(
                    labelText: "Rol",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Título: "Invitados:"
                Text("Invitados:",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                SizedBox(height: 10),

                // Lista de personas asociadas
                Column(
                  children: controller.associatedPersons.map((person) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.grey.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: const NetworkImage(
                              'https://via.placeholder.com/150'),
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Colors.grey, // Cambia al color que desees
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          person['name'] ?? '',
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Usa tu estilo aquí
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            text: person['relation'] ?? '',
                            style: TextStyle(
                                color: Colors.grey), // Usa tu estilo aquí
                            children: [
                              TextSpan(
                                text: ' | Pendiente',
                                style: TextStyle(
                                    color: Colors.black), // Texto en negro
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey, // Cambia al color que desees
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
