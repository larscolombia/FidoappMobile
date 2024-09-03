import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:pawlly/modules/dashboard/screens/pages.dart';
import 'package:pawlly/modules/home/screens/widgets/widget_profile_dogs.dart';
import 'package:pawlly/modules/profile/screens/profile_screen.dart';
import 'package:pawlly/modules/profile_pet/screens/profile_pet_screen.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
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
                  height: 100,
                  padding:
                      EdgeInsets.all(4), // Espacio entre la imagen y el borde
                  decoration: BoxDecoration(
                    color: Styles.fiveColor, // Fondo del borde
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Styles.iconColorBack, // Color del borde
                      width: 3.0, // Grosor del borde
                    ),
                  ),
                  child: CircleAvatar(
                    radius:
                        46, // Ajustar el radio para que la imagen se adapte mejor al contenedor
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                    backgroundColor: Colors
                        .transparent, // Fondo transparente si la imagen no se carga
                  ),
                ),
                // Nombre del Usuario
                Container(
                  height: imageSize,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Victoria',
                    style: Styles.dashboardTitle24,
                  ),
                ),
              ],
            ),

            // Contenido del Dashboard
            Expanded(
              child: Container(
                padding: Styles.paddingAll,
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Styles.whiteColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección del Dashboard
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pop(context), // Acción de retroceso
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Styles.greyTextColor,
                              size: 22,
                            ),
                          ),
                          Text(
                            'Dashboard',
                            style: Styles.dashboardTitle20,
                          ),
                          SizedBox(width: 40),
                          SizedBox(
                              width: 40), // Para mantener el texto centrado
                        ],
                      ),
                    ),
                    // Divider con espacio
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0),
                      child: Divider(height: 10, thickness: 1),
                    ),
                    // Lista de Ítems
                    Expanded(
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Navegar a la vista correspondiente
                              _onItemTap(index,
                                  context); // Llama al nuevo método que maneja el modal y la navegación
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Styles.whiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Styles
                                              .fiveColor, // Fondo del ícono
                                          borderRadius: BorderRadius.circular(
                                              15), // Bordes redondeados
                                        ),
                                        child: Icon(
                                          _getItemIcon(
                                              index), // Icono específico para cada ítem
                                          color: Styles.iconColorBack,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        _getItemTitle(index),
                                        style: Styles.boxTitleDashboard,
                                      ),
                                    ],
                                  ),
                                  Icon(
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
        return 'Mascotas';
      case 2:
        return 'Términos y Condiciones';
      case 3:
        return 'Políticas de Privacidad';
      case 4:
        return 'Sobre la App';
      case 5:
        return 'Cerrar Sesión';
      default:
        return '';
    }
  }

  void _onItemTap(int index, BuildContext context) {
    if (index == 1) {
      // Mostrar el modal para el caso 1
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return ProfileModal();
        },
      );
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
        return CerrarSesionPage();
      default:
        return Container();
    }
  }

  // Método auxiliar para obtener el icono del ítem
  IconData _getItemIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.pets;
      case 2:
        return Icons.description;
      case 3:
        return Icons.lock;
      case 4:
        return Icons.info;
      case 5:
        return Icons.exit_to_app;
      default:
        return Icons.help;
    }
  }
}
