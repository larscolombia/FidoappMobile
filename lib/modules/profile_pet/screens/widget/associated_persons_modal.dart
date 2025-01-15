import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/modules/auth/model/employee_model.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/pet_owner_profile.dart';
import 'package:pawlly/modules/profile_pet/controllers/pet_owner_controller.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/services/pet_owner_apis.dart';
import 'package:pawlly/styles/styles.dart';

class AssociatedPersonsModal extends StatelessWidget {
  final ProfilePetController controller;
  final PetOwnerServiceApi petOwnerServiceApi = PetOwnerServiceApi();
  final HomeController homeController = Get.put(HomeController());
  final UserController userController = Get.put(UserController());
  final PetOwnerController petcontroller = Get.put(PetOwnerController());

  AssociatedPersonsModal({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamano = MediaQuery.of(context).size.width - 100;
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
              "Asociar Persona a esta Mascota",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'lato',
              ),
            ),

            // Input de correo electrónico (sin Obx ya que no se utiliza ninguna variable reactiva aquí)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                margin: const EdgeInsets.only(top: 20),
                child: InputText(
                  placeholderImage: Image.asset('assets/icons/email.png'),
                  placeholder: 'Correo',
                  onChanged: (value) {
                    userController.filterUsers(value);
                  },
                ),
              ),
            ),

            // Selector del rol
            Center(
              child: Container(
                width: tamano,
                margin: const EdgeInsets.only(top: 20),
                child: CustomSelectFormFieldWidget(
                  // Si controller.userTypeCont es reactivo y deseas que el widget se actualice al cambiar su valor,
                  // entonces puedes envolver el widget en un Obx.
                  // Aquí se asume que el widget CustomSelectFormFieldWidget maneja internamente el controlador.
                  controller: controller.userTypeCont.value,
                  placeholder: 'Rol',
                  icon: 'assets/icons/tag-user.png',
                  filcolorCustom: Styles.fiveColor,
                  borderColor: Styles.iconColorBack,
                  onChange: (value) {
                    switch (value) {
                      case 'Veterinario':
                        userController.type.value = 'vet';
                        userController.fetchUsers();
                        break;
                      case 'Entrenador':
                        userController.type.value = 'trainer';
                        userController.fetchUsers();
                        break;
                      case 'Dueño':
                        userController.type.value = 'User';
                        userController.fetchUsers();
                        break;
                      default:
                        userController.type.value = 'vet';
                    }
                  },
                  items: const [
                    'Veterinario',
                    'Entrenador',
                    'Dueño',
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Título: "Invitados:"
            Center(
              child: SizedBox(
                width: tamano,
                child: const Text(
                  "Invitados:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lato',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Lista de personas asociadas en un Obx ya que aquí se utilizan variables reactivas
            Expanded(
              child: Obx(() {
                if (userController.filteredUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay resultados',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
                if (userController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Center(
                  child: Container(
                    width: tamano,
                    child: ListView(
                      children: userController.filteredUsers.map((person) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                person.profileImage ??
                                    'https://via.placeholder.com/150',
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
                              person.firstName ?? '',
                              style: Styles.textProfile14w700,
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                text: person.userType ?? '',
                                style: Styles.textProfile12w400,
                                children: const [
                                  TextSpan(
                                    text: ' | Pendiente',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Styles.iconColorBack,
                            ),
                            onTap: () {
                              userController.getSharedOwnersWithEmail(
                                homeController.selectedProfile.value!.id
                                    .toString(),
                                person.email,
                              );
                              petcontroller.fetchOwnersList(
                                  homeController.selectedProfile.value!.id);
                              print(homeController.selectedProfile.value!.id
                                  .toString());
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Botón de Cerrar
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: tamano,
                child: ButtonDefaultWidget(
                  title: 'Invitar Persona ',
                  callback: () {
                    Navigator.of(context).pop(); // Cierra el modal
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
