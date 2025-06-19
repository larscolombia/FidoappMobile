import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:pawlly/modules/dashboard/screens/pacientes.dart';
import 'package:pawlly/modules/diario/diario.dart';
import 'package:pawlly/modules/home/screens/widgets/widget_profile_dogs.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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
            // Header section
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
                        ? NetworkImage(AuthServiceApis.dataCurrentUser.profileImage)
                        : const AssetImage('assets/images/avatar.png') as ImageProvider,
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
                            width: MediaQuery.sizeOf(context).width - 100,
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
                    // Menu List
                    Expanded(
                      child: ListView(
                        children: [
                          _buildMenuItem(DashboardMenuItem.profile, context),
                          _buildMenuItem(DashboardMenuItem.changePassword, context),
                          _buildMenuItem(DashboardMenuItem.patientsOrPets, context),
                          _buildMenuItem(DashboardMenuItem.diary, context),
                          _buildMenuItem(DashboardMenuItem.termsAndConditions, context),
                          _buildMenuItem(DashboardMenuItem.termsAndConditions, context),
                          _buildMenuItem(DashboardMenuItem.aboutApp, context),
                          _buildMenuItem(DashboardMenuItem.logout, context),
                        ],
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

  // Método auxiliar para construir un elemento de menú
  Widget _buildMenuItem(DashboardMenuItem item, BuildContext context) {
    return InkWell(
      onTap: () {
        _onItemTap(item, context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Styles.fiveColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SvgPicture.asset(
                    _getItemIcon(item),
                    width: 24,
                    height: 24,
                    color: Styles.iconColorBack,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _getItemTitle(item),
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
  }

  // Helper method to get item title
  String _getItemTitle(DashboardMenuItem item) {
    switch (item) {
      case DashboardMenuItem.profile:
        return 'Mi perfil';

      case DashboardMenuItem.changePassword:
        return 'Cambiar contraseña';
      
      case DashboardMenuItem.patientsOrPets:
        return roleUser.roleUser() == roleUser.tipoUsuario('vet')
            ? 'Pacientes'
            : 'Mascotas';

      case DashboardMenuItem.diary:
        return 'Diario de Mascotas';

      case DashboardMenuItem.termsAndConditions:
        return 'Términos y Condiciones';

      case DashboardMenuItem.privacyPolicy:
        return 'Políticas de privacidad';

      case DashboardMenuItem.aboutApp:
        return 'Sobre la app';

      case DashboardMenuItem.logout:
        return 'Cerrar Sesión';

    }
  }

  void _onItemTap(DashboardMenuItem item, BuildContext context) {
    if (item == DashboardMenuItem.patientsOrPets) {
      // Show modal for item 1
      if (roleUser.roleUser() == roleUser.tipoUsuario('vet')) {
        Get.to(() => Pacientes());
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
    } else if (item == DashboardMenuItem.logout) {
      // Show logout confirmation dialog
      _showLogoutConfirmationDialog(context);
    } else {
      // Navigate to corresponding view for other cases
      var route = _getPageForIndex(item);

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

  Object _getPageForIndex(DashboardMenuItem index) {
    // final HomeController homeController = Get.find<HomeController>();
    // final PetActivityController historialClinicoController = Get.put(PetActivityController());
    switch (index) {
      case DashboardMenuItem.profile:
        return Routes.PROFILE;

      case DashboardMenuItem.changePassword:
        return Routes.CHANGEPASSWORD;
      
      case DashboardMenuItem.patientsOrPets:
        return '';

      case DashboardMenuItem.diary:
        return Diario();

      case DashboardMenuItem.termsAndConditions:
        return Routes.TERMSCONDITIONS;

      case DashboardMenuItem.privacyPolicy:
        return Routes.PRIVACYPOLICY;

      case DashboardMenuItem.aboutApp:
        return Routes.SOBREAPP;

      case DashboardMenuItem.logout:
        return Container();
    }
  }

  // Helper method to get item icon
  String _getItemIcon(DashboardMenuItem index) {
    switch (index) {
      case DashboardMenuItem.profile:
        return 'assets/icons/svg/frame.svg';

      case DashboardMenuItem.changePassword:
        return 'assets/icons/svg/key.svg';
      
      case DashboardMenuItem.patientsOrPets:
        return 'assets/icons/svg/dashicons_pets.svg';

      case DashboardMenuItem.diary:
        return 'assets/icons/svg/archive-book.svg';

      case DashboardMenuItem.termsAndConditions:
        return 'assets/icons/svg/note-2.svg';

      case DashboardMenuItem.privacyPolicy:
        return 'assets/icons/svg/book.svg';

      case DashboardMenuItem.aboutApp:
        return 'assets/icons/svg/info-circle.svg';

      case DashboardMenuItem.logout:
        return 'assets/icons/svg/logout.svg';

    }
  }
}

enum DashboardMenuItem {
  profile,
  changePassword,
  patientsOrPets,
  diary,
  termsAndConditions,
  privacyPolicy,
  aboutApp,
  logout,
}
