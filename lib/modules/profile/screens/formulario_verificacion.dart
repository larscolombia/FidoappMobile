import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_tag_wiget.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
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
  var margin = 20.00;
  final Map<String, String> expertos = {
    "Comportamiento": "Comportamiento",
    "Cardiología": "Cardiología",
    "Dermatología": "Dermatología",
    "Emergencias y Cuidados Críticos": "Emergencias y Cuidados Críticos",
    "Cirugía Ortopédica": "Cirugía Ortopédica",
    "Cirugía Ortopédica": "c",
    "Anestesiología": "Anestesiología",
  };
  @override
  void initState() {
    super.initState();
    // Llamamos al fetchUserData sólo aquí, para que no se repita en cada build
    controller.fetchUserData("${AuthServiceApis.dataCurrentUser.id}");
  }

  @override
  Widget build(BuildContext context) {
    var profile = controller.user.value.profile;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: const Stack(
              children: [
                BorderRedondiado(top: 160),
                Center(
                  child: Text(
                    'Formulario de Verificación',
                    style: Styles.TextTituloBlack,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      if (controller.user.value.profile == null)
                        SizedBox(
                          child: RecargaComponente(
                            titulo: 'Cargar más',
                            callback: () {
                              controller.fetchUserData(
                                  "${AuthServiceApis.dataCurrentUser.id}");
                            },
                          ),
                        ),
                      SizedBox(height: margin),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: BarraBack(
                            titulo: 'Verificación Profesional',
                            subtitle: 'Añade tu información profesional',
                            ColorSubtitle: Colors.black,
                            callback: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: margin),
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
                      SizedBox(height: margin),
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
                      SizedBox(height: margin),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            onChanged: (value) =>
                                profileController.user['about_self'] = value,
                            label: 'Descripción sobre ti',
                            placeholder: "",
                            isTextArea: true,
                            initialValue: profile?.aboutSelf ?? '',
                          ),
                        ),
                      ),
                      SizedBox(height: margin),
                      Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: InputSelect(
                              onChanged: (value) {
                                profileController.user['expert'] =
                                    value.toString();
                              },
                              label: 'Áreas de especialización',
                              placeholder:
                                  controller.user.value.profile?.expert,
                              TextColor: Colors.black,
                              prefiIcon: 'assets/icons/user-octagon.png',
                              items: expertos.entries.map((entry) {
                                return DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(entry.value,
                                      style: TextStyle(
                                        fontFamily: "Lato",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      )),
                                );
                              }).toList(),
                            )),
                      ),
                      SizedBox(height: margin),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: const Divider(
                            thickness: .2,
                            color: Color.fromRGBO(167, 157, 157, 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: InputText(
                              initialValue: controller.user.value.address ?? '',
                              onChanged: (value) {},
                              label: 'Título o certificación profesional',
                              isFilePicker: true,
                              placeholder: "",
                              placeholderImage:
                                  Image.asset('assets/icons/file.png'),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: margin),
                      Obx(() {
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: InputText(
                              initialValue: controller
                                      .user.value.profile?.validationNumber ??
                                  '#',
                              onChanged: (value) {
                                profileController.user['validation_number'] =
                                    value;
                              },
                              label: 'Nro. de validación del certificado',
                              placeholder: "",
                              placeholderImage:
                                  Image.asset('assets/icons/personalcard.png'),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: margin),
                      Obx(() {
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: InputText(
                              initialValue: controller.user.value.address,
                              onChanged: (value) {
                                profileController.user['address'] = value;
                              },
                              label: 'Dirección de vivienda',
                              placeholder: "",
                              prefiIcon: Icon(
                                Icons.location_on,
                                color: Styles.primaryColor,
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: margin),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Añadir tabs',
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TagInputWidget(
                                initialTags: profile?.tags ?? [],
                                onChanged: (value) {
                                  print("tagas $value");
                                  List<String> tags = List<String>.from(value);
                                  profileController.user['tags'] = tags;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: margin),
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
                          SizedBox(height: margin),
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
                      SizedBox(height: margin),
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
