import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:pawlly/modules/dashboard/screens/pacientes.dart';
import 'package:pawlly/modules/diario/diario.dart';
import 'package:pawlly/modules/fideo_coin/FideCoin.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';

import 'package:pawlly/modules/home/screens/widgets/widget_profile_dogs.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';

import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.put(DashboardController());
  final RoleUser roleUser = Get.put(RoleUser());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.height /
        4; // Cambia a /3 si necesitas una tercera parte de la altura

    return Scaffold(
      body: Container(
        color: Styles.fiveColor,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Contenedor de la Imagen
                Container(
                  height: imageSize,
                  width: double.infinity,
                  color: Styles
                      .fiveColor, // Color de fondo para representar la imagen de fondo
                ),
                // Imagen Circular con Borde
                Container(
                  width: 100,
                  height: 120,
                  padding: const EdgeInsets.all(
                      4), // Espacio entre la imagen y el borde
                  decoration: BoxDecoration(
                    color: Styles.fiveColor, // Fondo del borde
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Styles.iconColorBack, // Color del borde
                      width: 3.0, // Grosor del borde
                    ),
                  ),
                  child: Obx(
                    () => CircleAvatar(
                      radius:
                          46, // Ajustar el radio para que la imagen se adapte mejor al contenedor
                      backgroundImage: controller.profileImagePath.isNotEmpty
                          ? NetworkImage(AuthServiceApis.dataCurrentUser
                              .profileImage) // Carga la imagen desde la red si hay una URL
                          : const AssetImage('assets/images/avatar.png')
                              as ImageProvider, // Imagen predeterminada si la URL está vacía
                      backgroundColor: Colors.transparent, // Fondo transparente
                    ),
                  ),
                ),
                // Nombre del Usuario
                Container(
                  height: 220,
                  width: 250,
                  alignment: Alignment.bottomCenter,
                  child: Obx(
                    () => Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      controller
                          .name.value, // Acceder al valor de name con .value
                      style: Styles.dashboardTitle24,
                    ),
                  ),
                ),
              ],
            ),

            // Contenido del Dashboard
            Expanded(
              child: Container(
                padding: Styles.paddingAll,
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  color: Styles.whiteColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección del Dashboard
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: BarraBack(
                              titulo: 'Dashboard',
                              callback: () {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _onItemTap(index,
                                  context); // Llama al método que maneja el modal y la navegación
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Styles
                                              .fiveColor, // Fondo del ícono
                                          borderRadius: BorderRadius.circular(
                                              15), // Bordes redondeados
                                        ),
                                        child: SvgPicture.asset(
                                          _getItemIcon(index),
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        _getItemTitle(index),
                                        style: Styles.boxTitleDashboard,
                                      ),
                                    ],
                                  ),
                                  // Esta parte también se envuelve en el GestureDetector
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF383838),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para obtener el título del ítem
  String _getItemTitle(int index) {
    switch (index) {
      case 0:
        return 'Mi perfil';
      case 1:
        return roleUser.roleUser() == roleUser.tipoUsuario('vet')
            ? 'Pacientes'
            : 'Mascotas';
      case 2:
        return 'Diario de Mascotas';
      case 3:
        return 'Términos y Condiciones';
      case 4:
        return 'Políticas de privacidad';
      case 5:
        return 'Sobre la app';
      case 6:
        return 'FidoCoins';
      case 7:
        return 'Cerrar Sesión';
      default:
        return '';
    }
  }

  void _onItemTap(int index, BuildContext context) {
    if (index == 7) {
      // Get.to(Pacientes());
    }
    if (index == 1) {
      // Mostrar el modal para el caso 1
      if (roleUser.roleUser() == roleUser.tipoUsuario('vet')) {
        Get.to(Pacientes());
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return ProfileModal();
          },
        );
      }
    } else if (index == 7) {
      // Mostrar el diálogo de confirmación para cerrar sesión
      _showLogoutConfirmationDialog(context);
    } else {
      // Navegar a la vista correspondiente para otros casos
      var route = _getPageForIndex(index);
      if (route is String) {
        Get.toNamed(route);
      } else if (route is Widget) {
        Get.to(() => route);
      }
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          icon: Icons.exit_to_app, // Ícono más apropiado para logout
          title: "Cerrar sesión",
          description: "¿Estás seguro de que deseas cerrar sesión?",
          buttonCancelar: true,
          primaryButtonText: "Aceptar",
          onPrimaryButtonPressed: () async {
            await controller.logoutUser();
            Get.back(); // Cierra el modal después de cerrar sesión
          },
        );
      },
    );
  }

  Object _getPageForIndex(int index) {
    final HomeController homeController = Get.find<HomeController>();
    final PetActivityController historialClinicoController =
        Get.put(PetActivityController());
    switch (index) {
      case 0:
        return Routes.PROFILE;
      case 1:
        return '';
      // Devuelve una cadena vacía o cualquier valor que indique que no se debe navegar
      case 2:
        return Diario();
      case 3:
        return Routes.TERMSCONDITIONS;
      case 4:
        return Routes.PRIVACYPOLICY;
      case 5:
        return Routes.SOBREAPP;
      case 6:
        return FideCoin();
      case 7:
        return "";
      default:
        return Container();
    }
  }

  // Método auxiliar para obtener el icono del ítem
  String _getItemIcon(int index) {
    switch (index) {
      case 0:
        return 'assets/icons/svg/frame.svg';
      case 1:
        return 'assets/icons/svg/dashicons_pets.svg';
      case 2:
        return 'assets/icons/svg/archive-book.svg';
      case 3:
        return 'assets/icons/svg/note-2.svg';
      case 4:
        return 'assets/icons/svg/book.svg';
      case 5:
        return 'assets/icons/svg/info-circle.svg';
      case 6:
        return 'assets/icons/svg/fidocoins.svg';
      case 7:
        return 'assets/icons/svg/logout.svg';
      default:
        return 'assets/icons/svg/logout.svg';
    }
  }
}
