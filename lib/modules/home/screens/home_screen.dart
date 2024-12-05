import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/Diario/formulario_diario.dart';
import 'package:pawlly/modules/home/screens/Diario/index.dart';
import 'package:pawlly/modules/home/screens/calendar/activity_list.dart';
import 'package:pawlly/modules/home/screens/calendar/calendar.dart';
import 'package:pawlly/modules/home/screens/explore/entretaiment_blogs.dart';
import 'package:pawlly/modules/home/screens/explore/explore_input.dart';
import 'package:pawlly/modules/home/screens/explore/training_programs.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/home/screens/pages/resources_list/ebooks_list.dart';
import 'package:pawlly/modules/home/screens/pages/resources_list/video_list.dart';
import 'package:pawlly/modules/home/screens/pages/training.dart';
import 'package:pawlly/modules/home/screens/pages/utilities.dart';
import 'package:pawlly/modules/home/screens/training/commands.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/modules/integracion/controller/blogs/blogs_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';
import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';
import 'package:pawlly/screens_demo/controller/user_default_test.dart';
import 'package:pawlly/modules/home/screens/pages/explorar_container.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/resources.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController homeController = Get.put(HomeController());
  final CursoUsuarioController miscursos = Get.put(CursoUsuarioController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  final BlogController blogController = Get.put(BlogController());
  @override
  Widget build(BuildContext context) {
    homeController.SelectType(1);
    return Scaffold(
      body: Stack(
        children: [
          // Contenido desplazable
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              padding: const EdgeInsets.only(bottom: 100),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Positioned(
                      top: 20, left: 0, right: 0, child: HeaderNotification()),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: Styles.paddingAll,
                    child: Obx(() {
                      // Cambiar el contenido basado en el selectedIndex
                      switch (homeController.selectedIndex.value) {
                        case 0:
                          return _buildCase1Content();
                        case 1:
                          return _buildCase2Content();
                        case 2:
                          return _buildCase3Content();
                        case 3:
                          return _buildCase4Content();
                        case 4:
                          return _buildCase5Content();
                        case 5:
                          return __Ebooks();
                        case 6:
                          return _Youtube();
                        default:
                          return _buildCase1Content();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (homeController.selectedIndex.value == 5 ||
                homeController.selectedIndex.value == 6) {
              return const SizedBox(height: 100);
            }
            return Positioned(
              left: 25,
              right: 25,
              bottom: 30,
              child: MenuOfNavigation(),
            );
          }),
          // Menu de Navegación siempre visible
        ],
      ),
    );
  }

  // Funciones que devuelven el contenido basado en el selectedIndex

  Widget _buildCase1Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ProfilesDogs(),
        const SizedBox(height: 16),
        Resources(),
        const SizedBox(height: 16),
        Explore(),
        const SizedBox(height: 16),
        Utilities(),
        const SizedBox(height: 16),
        if (AuthServiceApis.dataCurrentUser.userRole[0] != 'vet') Training(),
        Training(),
      ],
    );
  }

  Widget _buildCase2Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Calendar(),
        SizedBox(height: 16),
        ActivityListScreen(),
      ],
    );
  }

  Widget _buildCase3Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        ProfilesDogs(),
        SizedBox(height: 16),
        Training(),
        SizedBox(height: 16),
        Commands(),
      ],
    );
  }

  Widget _buildCase4Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ProfilesDogs(),
        const SizedBox(height: 16),
        Resources(),
        const SizedBox(height: 16),
        ExploreInput(),
        const SizedBox(height: 16),
        Training(),
        const SizedBox(height: 16),
        EntertainmentBlogs(),
        SizedBox(height: 16),
        TrainingPrograms(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCase5Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ProfilesDogs(),
        const SizedBox(height: 20),
        FloatingActionButton(
          onPressed: () {
            // Acción cuando el FAB es presionado
            Get.to(FormularioDiario());
          },
          backgroundColor: Styles.primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        DiarioMascotas(),
      ],
    );
  }

  Widget __Ebooks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Resources(),
        SizedBox(height: 16),
        EbooksList(),
      ],
    );
  }

  Widget _Youtube() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Resources(),
        SizedBox(height: 16),
        VideoList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
