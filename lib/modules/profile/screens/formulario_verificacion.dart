import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/profile/controllers/profile_controller.dart';
import 'package:pawlly/modules/profile/screens/perfil_publico.dart';
import 'package:pawlly/modules/profile/screens/profile_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class FormularioVerificacion extends StatefulWidget {
  const FormularioVerificacion({super.key});

  @override
  State<FormularioVerificacion> createState() => _FormularioVerificacionState();
}

class _FormularioVerificacionState extends State<FormularioVerificacion> {
  final UserProfileController controller = Get.put(UserProfileController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // Llamamos al fetchUserData sólo aquí, para que no se repita en cada build
    controller.fetchUserData("${AuthServiceApis.dataCurrentUser.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: const Center(
              child: Text(
                'Formulario de Verificación',
                style: Styles.TextTituloBlack,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: BarraBack(
                            titulo: 'Verificación Profesional',
                            callback: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            onChanged: (value) =>
                                profileController.user['first_name'] = value,
                            label: 'Nombre',
                            placeholder: '',
                            placeholderFontFamily: 'lato',
                            prefiIcon: const Icon(
                              Icons.person,
                              color: Styles.iconColorBack,
                            ),
                            initialValue:
                                AuthServiceApis.dataCurrentUser.firstName,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            onChanged: (value) =>
                                profileController.user['lastName'] = value,
                            label: 'Apellido',
                            placeholder: '',
                            prefiIcon: const Icon(
                              Icons.person,
                              color: Styles.iconColorBack,
                            ),
                            initialValue:
                                AuthServiceApis.dataCurrentUser.lastName,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        print(
                            'sobremi ${controller.user.value.profile?.aboutSelf ?? ''}');
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: InputText(
                              onChanged: (value) =>
                                  profileController.user['about_self'] = value,
                              label: 'Descripción sobre ti',
                              placeholder: "",
                              isTextArea: true,
                              initialValue:
                                  controller.user.value.profile?.aboutSelf ??
                                      '',
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: InputText(
                              onChanged: (value) =>
                                  profileController.user['address'] = value,
                              label: 'Localización',
                              placeholder: "",
                              prefiIcon: Icon(
                                Icons.location_on,
                                color: Styles.iconColorBack,
                              ),
                              initialValue: controller.user.value.address ?? '',
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: const Divider(
                            height: 1,
                            color: Color.fromRGBO(158, 158, 158, 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputSelect(
                            onChanged: (value) {},
                            label: 'Áreas de especialización',
                            placeholder: 'Áreas de especialización',
                            TextColor: Colors.black,
                            prefiIcon: 'assets/icons/genero.png',
                            items: const [
                              DropdownMenuItem(
                                value: 'vet',
                                child: Text('Veterinario'),
                              ),
                              DropdownMenuItem(
                                value: 'user',
                                child: Text('Usuario'),
                              ),
                              DropdownMenuItem(
                                value: 'trainer',
                                child: Text('Entrenador'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Ejemplos de campos comentados
                      // ...
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: ButtonDefaultWidget(
                                callback: () {
                                  Get.to(PublicProfilePage());
                                },
                                title: 'Previsualizar Perfil >',
                                defaultColor: Styles.fiveColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 100,
                                child: ButtonDefaultWidget(
                                  callback: () {
                                    profileController.updateProfile();
                                  },
                                  title:
                                      profileController.isLoading.value == true
                                          ? "Procesando"
                                          : 'Finalizar',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
