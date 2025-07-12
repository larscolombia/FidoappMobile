import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_select_form_field_widget.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/profile/controllers/profile_controller.dart';
import 'package:pawlly/modules/profile/screens/formulario_verificacion.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final UserProfileController userCpntroller = Get.put(UserProfileController());
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const imageSize = 260.0;
    var margin = Helper.margenDefault;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Agregamos el SingleChildScrollView aquí
        child: Container(
          color: Styles.fiveColor,
          child: Column(
            children: [
              // Header
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
                  Obx(() {
                    return GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: Stack(
                        children: [
                          Container(
                            width: 124,
                            height: 124,
                            margin: const EdgeInsets.only(top: 40),
                            padding: const EdgeInsets.all(4), // Espacio entre la imagen y el borde
                            decoration: BoxDecoration(
                              color: Styles.fiveColor, // Color de fondo del borde
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Styles.iconColorBack, // Color del borde
                                width: 3, // Grosor del borde
                              ),
                            ),
                            child: ClipOval(
                              child: Container(
                                width: 124, // Ajusta el ancho si es necesario
                                height: 124, // Ajusta el alto si es necesario
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: controller.profileImagePath.value.isNotEmpty
                                        ? (controller.profileImagePath.value.startsWith('http')
                                            ? NetworkImage(controller.profileImagePath.value) as ImageProvider<Object>
                                            : FileImage(File(controller.profileImagePath.value))
                                                as ImageProvider<Object>)
                                        : const AssetImage('assets/images/avatar.png') as ImageProvider<Object>,
                                    // Imagen predeterminada
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (controller.isLoadingPhoto.value)
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            top: 40,
                            child: const SizedBox(
                              height: 124,
                              width: 124,
                              child: CircularProgressIndicator(
                                color: Styles.primaryColor,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  // Nombre del Usuario
                  Positioned(
                    bottom: -10,
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.sizeOf(context).width - 100,
                      child: Text(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        controller.user['first_name'].toString(),
                        style: Styles.dashboardTitle24,
                      ),
                    ),
                  ),
                ],
              ),

              // Contenido del Perfil
              Container(
                padding: Styles.paddingAll,
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección del Perfil
                    Container(
                      padding: const EdgeInsets.only(
                        top: 37,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width - 130,
                                  child: BarraBack(
                                      titulo: "Perfil de Usuario",
                                      size: 20,
                                      color: const Color(0xFFFF4931),
                                      callback: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                                Obx(() {
                                  return GestureDetector(
                                    onTap: () => controller.toggleEditing(),
                                    child: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: controller.isEditing.value ? Colors.white : Styles.fiveColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset('assets/icons/svg/edit-2.svg')),
                                  );
                                }),
                              ],
                            ),
                          ),
                          if (AuthServiceApis.dataCurrentUser.userRole[0] != 'user')
                            Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: ButtonDefaultWidget(
                                    callback: () {
                                      Get.to(const FormularioVerificacion());
                                    },
                                    title: 'Perfil público',
                                    svgIconPath: 'assets/icons/svg/flecha_derecha.svg',
                                    svgIconColor: Colors.white,
                                    svgIconPathSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: 260,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                      style: TextStyle(
                                        // Estilo base para todo el texto
                                        fontSize: 14,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Solicitud Confirmada, ',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: 'Lato', // Color verde para la primera parte
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'visita tu perfil público para configurar cómo se verá',
                                          style: TextStyle(
                                            color: Color(0xFF383838),
                                            fontFamily: 'Lato', // Color verde para la primera parte
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 40,
                      thickness: .5,
                      color: Color(0xFFDFDFDF),
                    ),

                    // Formulario de Perfil
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Obx(() {
                          return InputText(
                            onChanged: (value) => controller.user['first_name'] = value,
                            initialValue: controller.user['first_name'].toString(),
                            placeholderSvg: 'assets/icons/svg/profile.svg',
                            placeholder: '',
                            readOnly: !controller.isEditing.value,
                            fondoColor: controller.isEditing.value == false ? Colors.white : Styles.fiveColor,
                            borderColor: Styles.iconColorBack,
                          );
                        }),
                        SizedBox(height: margin),
                        Obx(() {
                          return Container(
                            child: InputText(
                              borderColor: Styles.iconColorBack,
                              onChanged: (value) => controller.user['last_name'] = value,
                              initialValue: controller.user['last_name'].toString(),
                              placeholder: '',
                              placeholderSvg: 'assets/icons/svg/profile.svg',
                              readOnly: !controller.isEditing.value,
                              fondoColor: controller.isEditing.value == false ? Colors.white : Styles.fiveColor,
                            ),
                          );
                        }),
                        SizedBox(height: margin),
                        Obx(() {
                          return InputText(
                            borderColor: Styles.iconColorBack,
                            onChanged: (value) => controller.user['email'] = value,
                            initialValue: controller.user['email'].toString(),
                            placeholder: '',
                            placeholderSvg: 'assets/icons/svg/sms.svg',
                            readOnly: !controller.isEditing.value,
                            fondoColor: controller.isEditing.value == false ? Colors.white : Styles.fiveColor,
                          );
                        }),
                        if (AuthServiceApis.dataCurrentUser.userType == 'vet' || AuthServiceApis.dataCurrentUser.userType == 'trainer') ...[
                        SizedBox(height: margin),
                        Obx(() {
                          return InputText(
                            borderColor: Styles.iconColorBack,
                            onChanged: (value) => controller.user['payment_account'] = value,
                            initialValue: controller.user['payment_account'].toString(),
                            placeholder: 'Cuenta paypal',
                            placeholderSvg: 'assets/icons/svg/sms.svg',
                            readOnly: !controller.isEditing.value,
                            fondoColor: controller.isEditing.value == false ? Colors.white : Styles.fiveColor,
                          );
                        }),
                        ],
                        SizedBox(height: margin),
                        Obx(
                          () => Container(
                            child: CustomSelectFormFieldWidget(
                              enabled: controller.isEditing.value,
                              controller: controller.userGenCont.value,
                              filcolorCustom: controller.isEditing.value == false ? Colors.white : Styles.fiveColor,
                              borderColor: Styles.iconColorBack,
                              onChange: (value) {
                                controller.user['gender'] = value.toString();
                                controller.userGenCont.value.text = value.toString().toLowerCase();
                              },
                              placeholder: 'Género',
                              placeholderSvg: 'assets/icons/svg/tag-user.svg',
                              items: const [
                                'Femenino',
                                'Masculino',
                                'Prefiero no decirlo',
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: margin),
                        // Obx(() {
                        //   return InputText(
                        //     borderColor: Styles.iconColorBack,
                        //     onChanged: (value) => controller.user['password'] = value,
                        //     initialValue: "********",
                        //     placeholder: '',
                        //     placeholderSvg: 'assets/icons/svg/key.svg',
                        //     readOnly: !controller.isEditing.value,
                        //     fondoColor: controller.isEditing.value == false ? Colors.white : Styles.fiveColor,
                        //   );
                        // }),
                        // SizedBox(height: margin),
                        // SizedBox(
                        //   width: MediaQuery.sizeOf(context).width,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       // Navegar a la página de cambiar contraseña
                        //       Get.to(() => ChangePasswordScreen());
                        //     },
                        //     child: Align(
                        //       alignment: Alignment.centerRight,
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           const Text(
                        //             'Cambiar Contraseña',
                        //             style: TextStyle(
                        //               color: Styles.primaryColor,
                        //               fontFamily: 'Lato',
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.w800,
                        //             ),
                        //           ),
                        //           const SizedBox(width: 4),
                        //           SvgPicture.asset(
                        //             'assets/icons/svg/flecha_derecha.svg', // Ruta del ícono
                        //             height: 10,
                        //             color: const Color(0xFFFF4931),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: margin),
                        Obx(() {
                          String title = controller.isEditing.value ? 'Guardar' : 'Editar';
                          if (controller.isLoading.value) title = 'Actualizando...';

                          return SizedBox(
                            width: MediaQuery.sizeOf(context).width - 100,
                            child: ButtonDefaultWidget(
                              title: title,
                              callback: () {
                                if (controller.isEditing.value) {
                                  controller.updateProfile();
                                  controller.isEditing.value = false;
                                } else {
                                  controller.toggleEditing();
                                }
                              },
                            ),
                          );
                        }),
                        SizedBox(height: margin),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              controller.showDeleteConfirmation();
                            },
                            child: const Text(
                              'Eliminar cuenta',
                              style: TextStyle(color: Styles.primaryColor, fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Lato'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
