import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/dashboard/screens/pages.dart';
import 'package:pawlly/modules/profile/screens/profile_screen.dart';
import 'package:pawlly/styles/styles.dart';

class DashboardScreen extends StatelessWidget {
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
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Styles.iconColorBack,
                        width: 3), // Borde azul alrededor de la imagen
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/150'),
                      fit: BoxFit.cover,
                    ),
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
                              Get.to(() => _getPageForIndex(index));
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

  // Método auxiliar para obtener la página correspondiente
  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return MiPerfilPageScreen();
      case 1:
        return MascotasPage();
      case 2:
        return TerminosCondicionesPage();
      case 3:
        return PoliticasPrivacidadPage();
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
