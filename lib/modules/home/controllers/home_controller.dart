import 'package:get/get.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/services/pet_service_apis.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var profiles = <PetData>[].obs; // Lista de perfiles usando el modelo
  var selectedProfile =
      Rxn<PetData>(); // Perfil seleccionado, inicialmente null

  @override
  void onInit() {
    super.onInit();
    fetchProfiles(); // Llamar al método cuando el controlador se inicializa
  }

  // Método para actualizar el índice seleccionado
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  // Método para navegar a diferentes pantallas
  void pantallas(index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME);
        break;
      case 1:
        Get.toNamed(Routes.CALENDAR);
        break;
      /*
      case 2:
        Get.toNamed(Routes.APPRENTICESHIP);
        break;
        */
    }
  }

  // Método para actualizar el perfil seleccionado
  void updateProfile(PetData profile) {
    selectedProfile.value = profile;
  }

  // Método para agregar un nuevo perfil con datos de mascota
  void addProfile(Map<String, dynamic> petData) {
    profiles.add(PetData.fromJson(petData));
  }

  // Método para cargar los perfiles desde el servicio
  void fetchProfiles() async {
    // Crear una lista temporal para pasarla al servicio
    List<PetData> tempProfiles = [];

    // Llamar al servicio para obtener los perfiles
    final petsData = await PetService.getPetListApi(pets: tempProfiles);

    // Actualizar la lista observable con los datos obtenidos
    profiles.value = petsData;

    // Verificar si la lista no está vacía y actualizar el perfil seleccionado
    if (petsData.isNotEmpty) {
      selectedProfile.value =
          petsData.first; // Asignar el primer perfil completo
    }
  }
}
