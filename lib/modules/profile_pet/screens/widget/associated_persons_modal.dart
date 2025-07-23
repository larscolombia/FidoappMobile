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
                        userController.fetchUsers().then((_) {
                          // Mantener el filtro de correo después de cambiar el rol
                          final currentEmail = controller.emailController.value.text.trim();
                          if (currentEmail.isNotEmpty) {
                            userController.filterUsers(currentEmail);
                          }
                          // Limpiar selección cuando cambia el rol
                          userController.deselectUserForInvitation();
                        });
                        break;
                      case 'Entrenador':
                        userController.type.value = 'trainer';
                        userController.fetchUsers().then((_) {
                          // Mantener el filtro de correo después de cambiar el rol
                          final currentEmail = controller.emailController.value.text.trim();
                          if (currentEmail.isNotEmpty) {
                            userController.filterUsers(currentEmail);
                          }
                          // Limpiar selección cuando cambia el rol
                          userController.deselectUserForInvitation();
                        });
                        break;
                      case 'Dueño':
                        userController.type.value = 'User';
                        userController.fetchUsers().then((_) {
                          // Mantener el filtro de correo después de cambiar el rol
                          final currentEmail = controller.emailController.value.text.trim();
                          if (currentEmail.isNotEmpty) {
                            userController.filterUsers(currentEmail);
                          }
                          // Limpiar selección cuando cambia el rol
                          userController.deselectUserForInvitation();
                        });
                        break;
                      default:
                        userController.type.value = 'vet';
                        userController.fetchUsers().then((_) {
                          // Mantener el filtro de correo después de cambiar el rol
                          final currentEmail = controller.emailController.value.text.trim();
                          if (currentEmail.isNotEmpty) {
                            userController.filterUsers(currentEmail);
                          }
                          // Limpiar selección cuando cambia el rol
                          userController.deselectUserForInvitation();
                        });
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
                    // Limpiar selección cuando cambia el filtro
                    userController.deselectUserForInvitation();
                  },
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
                          child: GestureDetector(
                            onTap: () {
                              // Seleccionar usuario para invitación
                              userController.selectUserForInvitation(person);
                            },
                            child: Obx(() {
                              final isSelected = userController.selectedUserForInvitation.value?.id == person.id;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFC9214) : const Color(0xFFEFEFEF),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: SelectedAvatar(
                                  nombre: person.fullName ?? '',
                                  imageUrl: person.profileImage ?? '',
                                  profesion: Helper.tipoUsuario(person.userType ?? ''),
                                  showArrow: false,
                                ),
                              );
                            }),
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
                    // Determinar qué email usar: del usuario seleccionado o del input
                    String emailToSend;
                    String emailSource;
                    
                    if (userController.selectedUserForInvitation.value != null) {
                      // Usar el email del usuario seleccionado
                      emailToSend = userController.selectedUserEmail.value;
                      emailSource = 'usuario seleccionado';
                    } else {
                      // Usar el email del input
                      emailToSend = controller.emailController.value.text.trim();
                      emailSource = 'input';
                    }
                    
                    print('Email a enviar: $emailToSend (fuente: $emailSource)');
                    
                    if (emailToSend.isEmpty) {
                      CustomSnackbar.show(
                        title: 'Error',
                        message: 'Debe ingresar un correo electrónico',
                        isError: true,
                      );
                      return;
                    }
                    
                    // Verificar si hay un usuario seleccionado cuando hay resultados filtrados
                    if (userController.filteredUsers.isNotEmpty && userController.selectedUserForInvitation.value == null) {
                      CustomSnackbar.show(
                        title: 'Error',
                        message: 'Debe seleccionar una persona de la lista',
                        isError: true,
                      );
                      return;
                    }
                    
                    // Verificar si hay un usuario seleccionado (usuario existente)
                    if (userController.selectedUserForInvitation.value != null) {
                      // Usuario existe, proceder normalmente
                      await userController.getSharedOwnersWithEmail(
                        homeController.selectedProfile.value!.id.toString(),
                        emailToSend,
                      );
                      
                      // Limpiar el campo de email y la selección
                      controller.emailController.value.clear();
                      userController.deselectUserForInvitation();
                      
                      // Cerrar el modal después de la invitación
                      Navigator.of(context).pop();
                      
                      // Esperar un momento antes de actualizar la lista para evitar error 429
                      await Future.delayed(const Duration(milliseconds: 500));
                      
                      // Actualizar la lista de personas asociadas
                      await petcontroller.fetchOwnersList(homeController.selectedProfile.value!.id);
                    } else {
                      // Usuario no existe, mostrar alerta y enviar invitación
                      Get.dialog(
                        AlertDialog(
                          title: const Text(
                            'Usuario no encontrado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Lato',
                              color: Colors.black,
                            ),
                          ),
                          content: const Text(
                            'El usuario no se encuentra inscrito en la plataforma. Se enviará una invitación al correo ingresado.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Lato',
                              color: Colors.black87,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Lato',
                                  color: Color(0xFFFC9214),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.back(); // Cerrar el diálogo
                                
                                print('Enviando invitación para usuario no existente con email: $emailToSend');
                                
                                // Enviar invitación con el email ingresado
                                await userController.getSharedOwnersWithEmail(
                                  homeController.selectedProfile.value!.id.toString(),
                                  emailToSend,
                                );
                                
                                // Limpiar el campo de email y la selección
                                controller.emailController.value.clear();
                                userController.deselectUserForInvitation();
                                
                                // Cerrar el modal después de la invitación
                                Navigator.of(context).pop();
                                
                                // Esperar un momento antes de actualizar la lista para evitar error 429
                                await Future.delayed(const Duration(milliseconds: 500));
                                
                                // Actualizar la lista de personas asociadas
                                await petcontroller.fetchOwnersList(homeController.selectedProfile.value!.id);
                              },
                              child: const Text(
                                'Enviar Invitación',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Lato',
                                  color: Color(0xFFFC9214),
                                ),
                              ),
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
