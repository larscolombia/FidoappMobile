import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:pawlly/modules/home/controllers/home_controller.dart';

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
import 'package:pawlly/modules/home/screens/profecionales/profecionales.dart';
import 'package:pawlly/modules/home/screens/training/commands.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/blogs/blogs_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';

import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';

import 'package:pawlly/modules/home/screens/pages/explorar_container.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/resources.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/provider/push_provider.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  //controlador principal
  final HomeController homeController = Get.put(HomeController());
  //carga los cursos
  final CursoUsuarioController miscursos = Get.put(CursoUsuarioController());

  // carga el el historial de las mascotas
  final PetActivityController historialClinicoController =
      Get.put(PetActivityController());
  //carga los blogs
  final BlogController blogController = Get.put(BlogController());
  //eventos del calendario
  final CalendarController calendarController = Get.put(CalendarController());

  final UserBalanceController userBalanceController =
      Get.put(UserBalanceController());

  final NotificationController notificationController =
      Get.put(NotificationController());

  final PushProvider pushProvider = Get.put(PushProvider());

  final UserProfileController profileController =
      Get.put(UserProfileController());
  @override
  Widget build(BuildContext context) {
    if (profileController.user.value.profile == null) {
      profileController.fetchUserData('${AuthServiceApis.dataCurrentUser.id}');
    }

    print(
        'AuthServiceApis.dataCurrentUser.deviceToken ${AuthServiceApis.dataCurrentUser.deviceToken}');
    //homeController.SelectType(1);
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
                  HeaderNotification(),
                  // Agregar animación para mostrar/ocultar el contenedor de notificaciones
                  AnimatedOpacity(
                    opacity:
                        AuthServiceApis.dataCurrentUser.deviceToken == 'null'
                            ? 1.0
                            : 0.0,
                    duration:
                        Duration(milliseconds: 0), // Duración de la animación
                    child: AuthServiceApis.dataCurrentUser.deviceToken == 'null'
                        ? Center(
                            child: Container(
                              height: 50,
                              width: 300,
                              margin: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  var token = PushProvider();
                                  token.setupFCM();
                                },
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Styles.iconColorBack,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Obx(() {
                                      return Text(
                                        pushProvider.isLoading.value
                                            ? "Cargando..."
                                            : 'Activar Notificaciones aquí',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lato',
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox
                            .shrink(), // Si el token es 'null', no muestra nada
                  ),
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
                          return _buildCase1Content(context);
                        case 1:
                          return _buildCase2Content();
                        case 2:
                          return _buildCase3Content();
                        case 3:
                          return _buildCase4Content();
                        case 5:
                          return __Ebooks();
                        case 6:
                          return _Youtube();
                        default:
                          return _buildCase1Content(context);
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
        ],
      ),
    );
  }

  // Funciones que devuelven el contenido basado en el selectedIndex

  Widget _buildCase1Content(context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (AuthServiceApis.dataCurrentUser.userType != 'user')
            ProfilesDogs(),
          if (AuthServiceApis.dataCurrentUser.userType == 'user')
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Widget del 70%
                  Flexible(
                    flex: 9,
                    child: Container(
                      child:
                          ProfilesDogs(), // Asegúrate de que ProfilesDogs sea completamente responsivo.
                    ),
                  ),
                  // Widget del 30%
                  SizedBox(width: 10),
                  Flexible(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => Profecionales());
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 47,
                            decoration: BoxDecoration(
                              color: Recursos.ColorPrimario,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/svg/Group 1000003093.svg',
                              ),
                              // plus-user,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Profesionales',
                              maxLines: 1, // Limita el texto a una sola línea
                              overflow: TextOverflow
                                  .ellipsis, // Muestra "..." si el texto se desborda
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Lato",
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Resources(),
          const SizedBox(height: 16),
          const Explore(),
          const SizedBox(height: 16),
          if (calendarController.filteredCalendars.isNotEmpty)
            const Text(
              'Próximos Eventos',
              style: TextStyle(
                color: Styles.primaryColor,
                fontFamily: Styles.fuente2,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          const SizedBox(height: 16),
          if (calendarController.filteredCalendars.isNotEmpty)
            EventosProximos(calendarController: calendarController),
          if (calendarController.filteredCalendars.isNotEmpty)
            const SizedBox(height: 16),
          Utilities(),
          const SizedBox(height: 16),
          Training(),
          const SizedBox(height: 200),
        ],
      ),
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
    final CourseController cursosController = Get.put(CourseController());
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
        TrainingPrograms(
          cursosController: cursosController,
          showTitle: true,
        ),
        const SizedBox(height: 220),
      ],
    );
  }
  /** 
  Widget _buildCase5Content(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width - 100;
    var doubleHeight = 10.00;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ProfilesDogs(),
        const SizedBox(height: 20),
        SizedBox(
          width: ancho,
          child: BarraBack(
            titulo: 'Registros en el Diario',
            callback: () {
              Get.back();
            },
          ),
        ),
        SizedBox(height: doubleHeight),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: InputText(
                  fondoColor: Colors.white,
                  placeholderImage: Image.asset('assets/icons/busqueda.png'),
                  placeholderFontFamily: 'lato',
                  borderColor: const Color.fromARGB(255, 117, 113, 113),
                  placeholder: 'Realiza tu búsqueda',
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
              Get.to(() => FormularioDiario());
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
            titulo: 'Toca para mostrar actividades',
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
  }*/

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

class EventosProximos extends StatelessWidget {
  const EventosProximos({
    super.key,
    required this.calendarController,
  });

  final CalendarController calendarController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          // Obtener los eventos más próximos
          List<CalendarModel> nearestEvents =
              calendarController.getTwoNearestEvents();

          if (nearestEvents.isEmpty) {
            return const Text(
              'No hay eventos próximos.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            );
          }

          return Center(
            child: Container(
              child: Column(
                children: nearestEvents.map((event) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 100,
                    decoration: BoxDecoration(
                      color: Styles.fiveColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Center(
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Styles.fiveColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                          width: Styles.tamano(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                width: Styles.tamano(context) - 20,
                                child: Text(
                                  event.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: Styles.fuente1,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  calendarController
                                      .toggleVerMas("${event.id}");
                                },
                                child: Obx(() {
                                  return Text(
                                    event.description ?? '',
                                    maxLines: calendarController
                                                .isVerMas[event.id ?? ''] ??
                                            false
                                        ? 4
                                        : 1,
                                    overflow: calendarController
                                                .isVerMas[event.id ?? 0] ??
                                            false
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: Styles.fuente1,
                                      color: Colors.black,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    calendarController.formatEventTime(
                                            event.eventime ?? "",
                                            event.date ?? "") ??
                                        'Hora no especificada',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Lato',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    event.eventime ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: Styles.fuente1,
                                      color: Color(0XFFFc9214),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }
}
