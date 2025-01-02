import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/input_text.dart';
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
import 'package:pawlly/modules/home/screens/widgets/filtrar_actividad.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/modules/integracion/controller/blogs/blogs_controller.dart';

import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';

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
  final PetActivityController historialClinicoController =
      Get.put(PetActivityController());
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
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Positioned(
                      top: 0, left: 0, right: 0, child: HeaderNotification()),
                  Container(
                    decoration: const BoxDecoration(
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
                          return _buildCase5Content(context);
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
        const Explore(),
        const SizedBox(height: 16),
        const Utilities(),
        const SizedBox(height: 16),
        // if (AuthServiceApis.dataCurrentUser.userRole[0] != 'vet') Training(),
        Training(),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCase2Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Calendar(),
        const SizedBox(height: 16),
        ActivityListScreen(),
        const SizedBox(height: 126),
      ],
    );
  }

  Widget _buildCase3Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ProfilesDogs(),
        const SizedBox(height: 16),
        Training(),
        const SizedBox(height: 16),
        Commands(),
        const SizedBox(height: 20),
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
        const SizedBox(height: 16),
        TrainingPrograms(),
        const SizedBox(height: 220),
      ],
    );
  }

  Widget _buildCase5Content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ProfilesDogs(),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: InputText(
                  placeholder: 'Buscar actividades',
                  onChanged: (String value) =>
                      historialClinicoController.searchActivities(value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // FilterDialog.show(context, medicalHistoryController);
                    FiltrarActividad.show(context, historialClinicoController);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Styles.fiveColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Styles.iconColorBack,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          child: FloatingActionButton(
            onPressed: () {
              // Acción cuando el FAB es presionado
              Get.to(FormularioDiario());
            },
            shape: const CircleBorder(),
            backgroundColor: Styles.primaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          child: RecargaComponente(
            callback: () {
              final PetActivityController controller =
                  Get.put(PetActivityController());
              controller.fetchPetActivities(
                  homeController.selectedProfile.value!.id.toString());
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 330,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: DiarioMascotas(),
        ),
      ],
    );
  }

  Widget __Ebooks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Resources(),
        const SizedBox(height: 16),
        EbooksList(),
      ],
    );
  }

  Widget _Youtube() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Resources(),
        const SizedBox(height: 16),
        VideoList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
