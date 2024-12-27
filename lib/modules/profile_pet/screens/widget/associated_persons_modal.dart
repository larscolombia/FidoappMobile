import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/pet_owner_profile.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/services/pet_owner_apis.dart';
import 'package:pawlly/styles/styles.dart';

class AssociatedPersonsModal extends StatelessWidget {
  final ProfilePetController controller;
  PetOwnerServiceApi petOwnerServiceApi = PetOwnerServiceApi();
  AssociatedPersonsModal({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    print('petOwnerServiceApi');
    print(petOwnerServiceApi);
    return FractionallySizedBox(
      heightFactor: 0.7, // Ocupa el 70% de la pantalla
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Styles.whiteColor, // Fondo del modal
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              "Personas Asociadas a esta Mascota",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'lato',
              ),
            ),

            // Input de correo electrónico
            Obx(
              () => Container(
                margin: const EdgeInsets.only(top: 20),
                child: CustomTextFormFieldWidget(
                  controller: controller.emailController.value,
                  placeholder: 'Correo',
                  icon: 'assets/icons/email.png',
                ),
              ),
            ),
            Obx(
              () => Container(
                margin: const EdgeInsets.only(top: 20),
                child: CustomSelectFormFieldWidget(
                  controller: controller.userTypeCont.value,
                  placeholder: 'Rol',
                  icon: 'assets/icons/tag-user.png',
                  items: const [
                    'Dueño de mascota',
                    'Veterinario',
                    'Entrenador',
                    'Invitado de mascota',
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Título: "Invitados:"
            const Text(
              "Invitados:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'lato',
              ),
            ),

            const SizedBox(height: 10),

            // Lista de personas asociadas
            Expanded(
              child: ListView(
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
                              color: Styles
                                  .iconColorBack, // Cambia al color que desees
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        person['name'] ?? '',
                        style: Styles.textProfile14w700,
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: person['relation'] ?? '',
                          style: Styles.textProfile12w400, // Usa tu estilo aquí
                          children: const [
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
                        color:
                            Styles.iconColorBack, // Cambia al color que desees
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Botón de Cerrar
            Align(
              alignment: Alignment.center,
              child: ButtonDefaultWidget(
                title: 'Invitar Persona +',
                callback: () {
                  Navigator.of(context).pop(); // Cierra el modal
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
