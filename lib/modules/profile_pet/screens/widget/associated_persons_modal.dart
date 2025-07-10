import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';
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
    var tamano = MediaQuery.sizeOf(context).width - 100;
    return FractionallySizedBox(
      heightFactor: 0.7, // Ocupa el 70% de la pantalla
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Styles.whiteColor, // Fondo del modal
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Personas Asociadas a\nesta Mascota",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'lato',
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    'assets/icons/svg/x.svg',
                    width: 24, // Ajusta el tamaño si es necesario
                    height: 24,
                    colorFilter: ColorFilter.mode(Color(0XFFBEBEBE),
                        BlendMode.srcIn), // Aplica color rojo
                  ),
                ),
              ],
            ),

            // Input de correo electrónico
            Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.only(top: 20),
                child: InputText(
                  controller: controller.emailController.value,
                  placeholderSvg: 'assets/icons/svg/sms.svg',
                  placeholder: 'Correo electrónico',
                  onChanged: (value) {
                    userController.filterUsers(value);
                  },
                ),
              ),
            ),

            // Selector del rol
            Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.only(top: 20),
                child: CustomSelectFormFieldWidget(
                  // Si controller.userTypeCont es reactivo y deseas que el widget se actualice al cambiar su valor,
                  // entonces puedes envolver el widget en un Obx.
                  // Aquí se asume que el widget CustomSelectFormFieldWidget maneja internamente el controlador.
                  controller: controller.userTypeCont.value,
                  placeholder: 'Rol',
                  placeholderSvg: 'assets/icons/svg/tag-user.svg',
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
                width: MediaQuery.sizeOf(context).width,
                child: const Text(
                  "Invitados:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
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
                    width: MediaQuery.sizeOf(context).width,
                    child: ListView(
                      children: userController.filteredUsers.map((person) {
                        // Añadir un SizedBox con altura entre cada tarjeta
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom:
                                  10), // Espacio vertical entre las tarjetas
                          child: SelectedAvatar(
                            nombre: person.fullName ?? '',
                            imageUrl: person.profileImage ?? '',
                            profesion:
                                Helper.tipoUsuario(person.userType ?? ''),
                            showArrow: false,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Botón de Invitar
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: tamano,
                child: ButtonDefaultWidget(
                  title: 'Invitar Persona ',
                  callback: () async {
                    // Obtener el email del input
                    final email = controller.emailController.value.text.trim();
                    print('Email obtenido del input: $email');
                    
                    if (email.isEmpty) {
                      CustomSnackbar.show(
                        title: 'Error',
                        message: 'Debe ingresar un correo electrónico',
                        isError: true,
                      );
                      return;
                    }
                    
                    // Verificar si hay un usuario seleccionado (usuario existente)
                    if (userController.filteredUsers.isNotEmpty) {
                      final selectedUser = userController.filteredUsers.first;
                      final selectedEmail = selectedUser.email ?? '';
                      
                      if (selectedEmail.isNotEmpty) {
                        // Usuario existe, proceder normalmente
                        await userController.getSharedOwnersWithEmail(
                          homeController.selectedProfile.value!.id.toString(),
                          selectedEmail,
                        );
                        
                        // Limpiar el campo de email
                        controller.emailController.value.clear();
                        
                        // Cerrar el modal después de la invitación
                        Navigator.of(context).pop();
                        
                        // Actualizar la lista de personas asociadas
                        petcontroller.fetchOwnersList(homeController.selectedProfile.value!.id);
                      } else {
                        CustomSnackbar.show(
                          title: 'Error',
                          message: 'No se pudo obtener el email del usuario seleccionado',
                          isError: true,
                        );
                      }
                    } else {
                      // Usuario no existe, mostrar alerta y enviar invitación
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Usuario no encontrado'),
                          content: const Text(
                            'El usuario no se encuentra inscrito en la plataforma. Se enviará una invitación al correo ingresado.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.back(); // Cerrar el diálogo
                                
                                print('Enviando invitación para usuario no existente con email: $email');
                                
                                // Enviar invitación con el email ingresado
                                await userController.getSharedOwnersWithEmail(
                                  homeController.selectedProfile.value!.id.toString(),
                                  email,
                                );
                                
                                // Limpiar el campo de email
                                controller.emailController.value.clear();
                                
                                // Cerrar el modal después de la invitación
                                Navigator.of(context).pop();
                                
                                // Actualizar la lista de personas asociadas
                                petcontroller.fetchOwnersList(homeController.selectedProfile.value!.id);
                              },
                              child: const Text('Enviar Invitación'),
                            ),
                          ],
                        ),
                      );
                    }
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
