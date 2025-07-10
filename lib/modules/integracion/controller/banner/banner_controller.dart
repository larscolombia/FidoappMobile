import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/banner/banner_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';

class BannerController extends GetxController {
  var banner = Rxn<BannerModel>();
  var isLoading = false.obs;
  var url = "$DOMAIN_URL/api/get-banner";

  @override
  void onInit() {
    super.onInit();
    fetchBanner();
  }

  Future<void> fetchBanner() async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        try {
          var jsonData = json.decode(response.body);
          var bannerResponse = BannerResponse.fromJson(jsonData);
          
          if (bannerResponse.success && bannerResponse.data != null) {
            banner.value = bannerResponse.data;
          } else {
            CustomSnackbar.show(
              title: 'Error',
              message: 'No se pudo cargar el banner',
              isError: true,
            );
          }
        } catch (e) {
          print('Error parsing JSON: $e');
          CustomSnackbar.show(
            title: 'Error',
            message: 'Error al procesar la respuesta del servidor',
            isError: true,
          );
        }
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'No se pudo cargar el banner (${response.statusCode})',
          isError: true,
        );
      }
    } catch (e) {
      print('Error fetching banner: $e');
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al cargar el banner',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onBannerTap() {
    // Obtener la acción del banner
    final action = banner.value?.actionButton;
    
    if (action != null && action.isNotEmpty) {
      _navigateToScreen(action);
    } else {
      print('Banner tapped - no action specified');
    }
  }

  void _navigateToScreen(String action) {
    // Convertir a minúsculas para hacer la comparación insensible a mayúsculas
    final normalizedAction = action.toLowerCase().trim();
    
    switch (normalizedAction) {
      case 'profile':
      case 'perfil':
        Get.toNamed('/profile');
        break;
        
      case 'home':
      case 'inicio':
      case 'dashboard':
        Get.toNamed('/dashboard');
        break;
        
      case 'addpet':
      case 'add-pet':
      case 'agregar-mascota':
      case 'nueva-mascota':
        Get.toNamed('/add-pet');
        break;
        
      case 'profilepet':
      case 'profile-pet':
      case 'perfil-mascota':
      case 'mascota':
        Get.toNamed('/profile-pet');
        break;
        
      case 'apprenticeship':
      case 'aprendizaje':
      case 'cursos':
      case 'training':
        Get.toNamed('/apprenticeship');
        break;
        
      case 'calendar':
      case 'agenda':
      case 'calendario':
        // Navegar a la pestaña de agenda en el home
        final homeController = Get.find<HomeController>();
        homeController.updateIndex(1);
        Get.toNamed('/dashboard');
        break;
        
      case 'diary':
      case 'diario':
        Get.toNamed('/diario');
        break;
        
      case 'explore':
      case 'explorar':
        // Navegar a la pestaña de explorar en el home
        final homeController = Get.find<HomeController>();
        homeController.updateIndex(3);
        Get.toNamed('/dashboard');
        break;
        
      case 'training':
      case 'entrenamiento':
        // Navegar a la pestaña de entrenamiento en el home
        final homeController = Get.find<HomeController>();
        homeController.updateIndex(2);
        Get.toNamed('/dashboard');
        break;
        
      case 'fidecoin':
      case 'fide-coin':
      case 'monedas':
        Get.toNamed('/fidecoin');
        break;
        
      case 'terms':
      case 'terms-conditions':
      case 'terminos':
        Get.toNamed('/terms-conditions');
        break;
        
      case 'privacy':
      case 'privacy-policy':
      case 'privacidad':
        Get.toNamed('/privacy-policy');
        break;
        
      case 'about':
      case 'sobreapp':
      case 'acerca':
        Get.toNamed('/sobreapp');
        break;
        
      default:
        print('Acción no reconocida: $action');
        // Opcional: mostrar un mensaje al usuario
        CustomSnackbar.show(
          title: 'Información',
          message: 'Acción no disponible: $action',
          isError: false,
        );
        break;
    }
  }
} 