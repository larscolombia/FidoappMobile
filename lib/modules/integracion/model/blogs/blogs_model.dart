import 'package:intl/intl.dart';

class BlogPost {
  final int id;
  final String description;
  final String name;
  final String? tags;
  final int status;
  final String blogImage;
  final int createdBy;
  final int updatedBy;
  final String? url_video;
  final int? deletedBy;
  final String createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  final String? duration;
  BlogPost({
    required this.id,
    required this.description,
    required this.name,
    this.tags,
    required this.status,
    required this.blogImage,
    required this.createdBy,
    required this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.url_video,
    this.duration,
  });

  // Método para crear una instancia de BlogPost desde un JSON
  factory BlogPost.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('dd-MM-yyyy');
    return BlogPost(
      id: json['id'] ?? 0, // Asegurar que no sea nulo
      description: json['description'] ?? '',
      name: json['name'] ?? '',
      tags: json['tags'],
      status: json['status'] ?? 0, // Asegurar que no sea nulo
      blogImage: json['blog_image'] ?? '',
      createdBy: json['created_by'] ?? 0, // Asegurar que no sea nulo
      updatedBy: json['updated_by'] ?? 0, // Asegurar que no sea nulo
      deletedBy: json['deleted_by'], // Asegurar que permita nulos
      url_video: json['url_video'],
      duration: json['duration'],
      createdAt: json['created_at'],
      updatedAt: dateFormat.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? dateFormat.parse(json['deleted_at'])
          : null, // Permitir nulos
    );
  }

  // Método para convertir una instancia de BlogPost a JSON
  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('dd-MM-yyyy');
    return {
      'id': id,
      'description': description,
      'name': name,
      'tags': tags,
      'status': status,
      'blog_image': blogImage,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'url_video': url_video,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': dateFormat.format(updatedAt),
      'duration': duration,
      'deleted_at': deletedAt != null ? dateFormat.format(deletedAt!) : null,
      'duration': duration,
    };
  }
}

/*

Tengo este error:
Exception has occurred.
FlutterError (Looking up a deactivated widget's ancestor is unsafe.
At this point the state of the widget's element tree is no longer stable.
To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.)
....
en esta vista:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:pawlly/modules/dashboard/screens/pacientes.dart';
import 'package:pawlly/modules/dashboard/screens/pages.dart';
import 'package:pawlly/modules/fideo_coin/FideCoin.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/home/screens/widgets/widget_profile_dogs.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
import 'package:pawlly/modules/profile/screens/profile_screen.dart';
import 'package:pawlly/modules/profile_pet/screens/profile_pet_screen.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  final RoleUser roleUser = Get.put(RoleUser());

  DashboardScreen({super.key});
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
                const SizedBox(height: 20),
                Container(
                  height: imageSize + 20,
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

                    Expanded(
                      child: ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // print('jqpwoijskpqowkspq');
                              _onItemTap(index,
                                  context); // Llama al nuevo método que maneja el modal y la navegación
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
                                        child: Container(
                                          child:
                                              Image.asset(_getItemIcon(index)),
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
                                    color: Styles.greyTextColor,
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
        return 'Mi Perfil';
      case 1:
        return roleUser.roleUser() == roleUser.tipoUsuario('vet')
            ? 'Pacientes'
            : 'Mascotas';
      case 2:
        return 'Términos y Condiciones';
      case 3:
        return 'Políticas de Privacidad';
      case 4:
        return 'Sobre la App';
      case 5:
        return 'FidoCoins';
      case 6:
        return 'Cerrar Sesión';
      default:
        return '';
    }
  }

  void _onItemTap(int index, BuildContext context) {
    if (index == 6) {
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
    } else if (index == 6) {
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
        return AlertDialog(
          title: const Text("Cerrar Sesión"),
          content: const Text("¿Desea cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Si el usuario elige "No", simplemente cierra el modal
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // Si el usuario elige "Sí", llama a la función de logout y cierra el modal
                await controller.logoutUser();
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: const Text("Sí"),
            ),
          ],
        );
      },
    );
  }

  Object _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return Routes.PROFILE;
      case 1:
        return ''; // Devuelve una cadena vacía o cualquier valor que indique que no se debe navegar
      case 2:
        return Routes.TERMSCONDITIONS;
      case 3:
        return Routes.PRIVACYPOLICY;
      case 4:
        return SobreAppPage();
      case 5:
        return FideCoin();
      case 6:
        return "";
      default:
        return Container();
    }
  }

  // Método auxiliar para obtener el icono del ítem
  String _getItemIcon(int index) {
    switch (index) {
      case 0:
        return 'assets/icons/profile.png';
      case 1:
        return 'assets/icons/pacientes.png';
      case 2:
        return 'assets/icons/terminos.png';
      case 3:
        return 'assets/icons/book.png';
      case 4:
        return 'assets/icons/info-circle.png';
      case 5:
        return 'assets/icons/info-circle.png';
      case 6:
        return 'assets/icons/logout.png';
      default:
        return 'assets/icons/logout.png';
    }
  }
}


*/