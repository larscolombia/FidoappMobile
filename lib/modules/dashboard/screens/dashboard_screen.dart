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
    final imageSize = size.height / 4;

    return Scaffold(
      body: Container(
        color: Styles.fiveColor,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Image Container
                Container(
                  height: imageSize,
                  width: double.infinity,
                  color: Styles.fiveColor,
                ),
                // Circular Image with Border
                Container(
                  width: 100,
                  height: 120,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Styles.fiveColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Styles.iconColorBack,
                      width: 3.0,
                    ),
                  ),
                  child: Obx(
                    () => CircleAvatar(
                      radius: 46,
                      backgroundImage: controller.profileImagePath.isNotEmpty
                          ? NetworkImage(
                              AuthServiceApis.dataCurrentUser.profileImage)
                          : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                // User Name
                Container(
                  height: 220,
                  width: 250,
                  alignment: Alignment.bottomCenter,
                  child: Obx(
                    () => Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      controller.name.value,
                      style: Styles.dashboardTitle24,
                    ),
                  ),
                ),
              ],
            ),
            // Dashboard Content
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
                    // Dashboard Section Title
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
                          return InkWell(
                            // Changed to InkWell for better touch feedback
                            onTap: () {
                              _onItemTap(index, context);
                            },
                            child: Container(
                              // GestureDetector replaced by InkWell + Container

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
                                          color: Styles.fiveColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
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

  // Helper method to get item title
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
      // Show modal for item 1
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
      // Show logout confirmation dialog
      _showLogoutConfirmationDialog(context);
    } else {
      // Navigate to corresponding view for other cases
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
          icon: Icons.exit_to_app, // More appropriate icon for logout
          title: "Cerrar sesión",
          description: "¿Estás seguro de que deseas cerrar sesión?",
          buttonCancelar: true,
          primaryButtonText: "Aceptar",
          onPrimaryButtonPressed: () async {
            await controller.logoutUser();
            Get.back(); // Close modal after logout
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
        return ''; // Return empty string or any value to indicate no navigation
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

  // Helper method to get item icon
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
