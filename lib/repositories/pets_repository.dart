import 'package:get/get.dart';

import '../models/pet_data.dart';
import '../services/pet_service_apis.dart';

/// Repositorio que centraliza el manejo de las mascotas del usuario.
/// Proporciona una única fuente de verdad para la mascota seleccionada y
/// el listado de mascotas disponibles.
class PetsRepository extends GetxService {
  /// Mascota actualmente seleccionada.
  final Rxn<PetData> selectedPet = Rxn<PetData>();

  /// Listado de mascotas del usuario.
  final RxList<PetData> petsProfiles = <PetData>[].obs;

  // TODO: Implementar un método para anexar los archivos
  // y conectarlo con el método addPetDetailsApi del servicio.
  
  /// Crea una nueva mascota en el backend y la agrega al listado local.
  /// También se establece como mascota seleccionada.
  Future<PetData?> createPet({
    required Map<String, String> body,
    required String imagePath,
  }) async {
    final pet = await PetServiceApis.createPet(
      body: body,
      imagePath: imagePath,
    );

    if (pet != null) {
      petsProfiles.add(pet);
      selectedPet.value = pet;
    }
    return pet;
  }

  /// Elimina una mascota del backend y la remueve del listado local.
  Future<bool> deletePet(int id) async {
    final response = await PetServiceApis.deletePetApi(id: id);

    if (response != null) {
      petsProfiles.removeWhere((p) => p.id == id);
      if (selectedPet.value?.id == id) {
        selectedPet.value = petsProfiles.isNotEmpty ? petsProfiles.first : null;
      }
      return true;
    }
    return false;
  }

  /// Obtiene la lista de mascotas desde el backend y actualiza los
  /// observables correspondientes. Si no hay mascota seleccionada se
  /// asigna la primera disponible.
  Future<void> loadPetsData() async {
    final loadedPets = await PetServiceApis.getPets();

    petsProfiles.assignAll(loadedPets);
    
    if (petsProfiles.isNotEmpty && selectedPet.value == null) {
      selectedPet.value = petsProfiles.first;
    }
  }

  /// Actualiza una mascota en el backend y en el listado local.
  Future<PetData?> updatePet(PetData petData) async {
    final updated = await PetServiceApis.updatePet(
      petId: petData.id,
      body: petData.mapToUpdate(),
    );
    if (updated != null) {
      final index = petsProfiles.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        petsProfiles[index] = updated;
        petsProfiles.refresh();
      }
      if (selectedPet.value?.id == petData.id) {
        selectedPet.value = updated;
      }
    }
    return updated;
  }

  /// Establece la mascota seleccionada.
  void selectPet(PetData pet) {
    selectedPet.value = pet;
  }
}
