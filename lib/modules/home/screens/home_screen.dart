import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
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
import 'package:pawlly/modules/home/screens/profecionales/profecionales.dart';
import 'package:pawlly/modules/home/screens/training/commands.dart';
import 'package:pawlly/modules/home/screens/widgets/filtrar_actividad.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/blogs/blogs_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';

import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';
import 'package:pawlly/modules/integracion/controller/herramientas/herramientas_controller.dart';

import 'package:pawlly/modules/integracion/controller/notificaciones/notificaciones_controller.dart';

import 'package:pawlly/modules/home/screens/pages/explorar_container.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/resources.dart';
import 'package:pawlly/modules/integracion/model/calendar/calendar_model.dart';
import 'package:pawlly/modules/provider/push_provider.dart';
import 'package:pawlly/services/auth_service_apis.dart';
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
  //herramientas
  final HerramientasController _herramientasController =
      Get.put(HerramientasController());

  final UserBalanceController userBalanceController =
      Get.put(UserBalanceController());

  final NotificationController notificationController =
      Get.put(NotificationController());

  final PushProvider pushProvider = Get.put(PushProvider());
  @override
  Widget build(BuildContext context) {
    if (AuthServiceApis.dataCurrentUser.deviceToken == 'null') {
      var token = new PushProvider();
      token.setupFCM();
      print(
          'device token sin colocar: ${AuthServiceApis.dataCurrentUser.deviceToken}');
    } else {
      print(
          'token en pantaala: ${AuthServiceApis.dataCurrentUser.deviceToken}');
    }
    print(
        'AuthServiceApis.dataCurrentUser.deviceToken ${AuthServiceApis.dataCurrentUser.deviceToken}');
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
                          return _buildCase1Content(context);
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
          // Menu de Navegación siempre visible
        ],
      ),
    );
  }

  // Funciones que devuelven el contenido basado en el selectedIndex

  Widget _buildCase1Content(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (AuthServiceApis.dataCurrentUser.userType != 'user') ProfilesDogs(),
        if (AuthServiceApis.dataCurrentUser.userType == 'user')
          Container(
            child: Row(
              children: [
                // Widget del 70%
                Flexible(
                  flex: 8,
                  child: Container(
                    child:
                        ProfilesDogs(), // Asegúrate de que ProfilesDogs sea completamente responsivo.
                  ),
                ),
                // Widget del 30%
                SizedBox(width: 15),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(Profecionales());
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 47,
                          decoration: BoxDecoration(
                            color: Styles.iconColorBack,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child:
                                Image.asset('assets/icons/profecionales.png'),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Profesionales',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Lato",
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
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
        Utilities(),
        const SizedBox(height: 16),
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
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: Container(
                        width: 263,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Styles.fiveColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                    fontWeight: FontWeight.w900,
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
                                      fontWeight: FontWeight.w500,
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
                                      color: Styles.iconColorBack,
                                    ),
                                  )
                                ],
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
