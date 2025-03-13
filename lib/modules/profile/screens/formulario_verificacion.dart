import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_tag_wiget.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/integracion/controller/especialidades_controller/epeciality_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/profile/controllers/profile_controller.dart';
import 'package:pawlly/modules/profile/screens/components/profile_header.dart';
import 'package:pawlly/modules/profile/screens/perfil_publico.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/recursos.dart';

class FormularioVerificacion extends StatefulWidget {
  const FormularioVerificacion({super.key});

  @override
  State<FormularioVerificacion> createState() => _FormularioVerificacionState();
}

class _FormularioVerificacionState extends State<FormularioVerificacion> {
  final UserProfileController controller = Get.put(UserProfileController());
  final ProfileController profileController = Get.put(ProfileController());
  final SpecialityController specialityController =
      Get.put(SpecialityController());
  var margin = 16.00;
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
    specialityController.fetchSpecialities();
  }

  @override
  Widget build(BuildContext context) {
    var profile = controller.user.value.profile;

    return Scaffold(
      backgroundColor: Styles.whiteColor,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        child: Stack(children: [
          Column(
            children: [
              ProfileHeader(
                profileController: controller,
                headerHeight: MediaQuery.of(context).size.height / 8,
              ),
              const SizedBox(height: 40),
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
                          Center(
                            child: Container(
                              padding: Styles.paddingAll,
                              width: MediaQuery.of(context).size.width,
                              child: BarraBack(
                                titulo: 'Perfil de Usuario',
                                size: 20,
                                subtitle: 'Completa la informmación',
                                ColorSubtitle: Colors.black,
                                callback: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: margin),
                          Center(
                            child: Container(
                              padding: Styles.paddingAll,
                              width: MediaQuery.of(context).size.width,
                              child: InputText(
                                onChanged: (value) => profileController
                                    .user['first_name'] = value,
                                label: 'Nombre',
                                placeholder: '',
                                placeholderFontFamily: 'lato',
                                placeholderSvg: 'assets/icons/svg/profile.svg',
                                initialValue:
                                    AuthServiceApis.dataCurrentUser.firstName,
                              ),
                            ),
                          ),
                          SizedBox(height: margin),
                          Center(
                            child: Container(
                              padding: Styles.paddingAll,
                              width: MediaQuery.of(context).size.width,
                              child: InputText(
                                onChanged: (value) =>
                                    profileController.user['lastName'] = value,
                                label: 'Apellido',
                                placeholder: '',
                                placeholderSvg: 'assets/icons/svg/profile.svg',
                                initialValue:
                                    AuthServiceApis.dataCurrentUser.lastName,
                              ),
                            ),
                          ),
                          SizedBox(height: margin),
                          Center(
                            child: Container(
                              padding: Styles.paddingAll,
                              width: MediaQuery.of(context).size.width,
                              child: InputText(
                                onChanged: (value) => profileController
                                    .user['about_self'] = value,
                                label: 'Descripción sobre ti',
                                placeholder: "",
                                isTextArea: true,
                                initialValue: profile?.aboutSelf ?? '',
                              ),
                            ),
                          ),
                          SizedBox(height: margin - 8),
                          Center(
                            child: Container(
                              padding: Styles.paddingAll,
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                thickness: 1,
                                color: Helper.dividerColor,
                              ),
                            ),
                          ),
                          SizedBox(height: margin - 8),
                          Obx(() {
                            if (specialityController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Container(
                              padding: Styles.paddingAll,
                              width: MediaQuery.of(context).size.width,
                              child: InputSelect(
                                onChanged: (value) {
                                  profileController.user['expert'] =
                                      value.toString();
                                },
                                label: 'Áreas de especialización',
                                placeholder:
                                    controller.user.value.profile?.expert,
                                TextColor: Colors.black,
                                //prefiIcon: 'assets/icons/user-octagon.png',
                                // prefiIconSVG: 'assets/icons/svg/genero.svg',
                                items: specialityController.specialities
                                    .map((entry) {
                                  return DropdownMenuItem(
                                    value: entry.description,
                                    child: Text(
                                      entry.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: "Lato",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                          SizedBox(height: margin),
                          /**
             Obx(() {
             return Center(
             child: Container(
             padding: Styles.paddingAll,
             width: MediaQuery.of(context).size.width,
             child: InputText(
             initialValue:
             controller.user.value.address ?? '',
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
             child: Container(
             padding: Styles.paddingAll,
             width: MediaQuery.of(context).size.width,
             child: InputText(
             initialValue: controller.user.value.profile
             ?.validationNumber ??
             '#',
             onChanged: (value) {
             profileController
             .user['validation_number'] = value;
             },
             label: 'Nro. de validación del certificado',
             placeholder: "",
             placeholderImage: Image.asset(
             'assets/icons/personalcard.png'),
             ),
             ),
             );
             }),
             */
                          Obx(() {
                            return Center(
                              child: Container(
                                padding: Styles.paddingAll,
                                width: MediaQuery.of(context).size.width,
                                child: InputText(
                                  initialValue: controller.user.value.address,
                                  onChanged: (value) {
                                    profileController.user['address'] = value;
                                  },
                                  label: 'Dirección de vivienda',
                                  placeholder: "",
                                  prefiIcon: const Icon(
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
                              padding: Styles.paddingAll,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Añadir tabs',
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TagInputWidget(
                                    initialTags: profile?.tags ?? [],
                                    onChanged: (value) {
                                      List<String> tags =
                                          List<String>.from(value);
                                      profileController.user['tags'] = tags;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: margin + 20),
                          Column(
                            children: [
                              Center(
                                child: Container(
                                  padding: Styles.paddingAll,
                                  width: MediaQuery.of(context).size.width,
                                  child: ButtonDefaultWidget(
                                    callback: () {
                                      Get.to(PublicProfilePage());
                                    },
                                    title: 'Previsualizar Perfil',
                                    defaultColor: Styles.fiveColor,
                                    svgIconPath:
                                        'assets/icons/svg/arrow-left.svg',
                                    svgIconPathSize: 14,
                                    svgIconColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: margin),
                              Obx(
                                () => Center(
                                  child: Container(
                                    padding: Styles.paddingAll,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ButtonDefaultWidget(
                                          callback: () {
                                            profileController.updateProfile();
                                          },
                                          title: 'Finalizar',
                                        ),
                                        if (profileController.isLoading.value)
                                          Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                      ],
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
        ]),
      ),
    );
  }
}
