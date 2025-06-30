import 'package:get/get.dart';
import '../models/pet_data.dart';
import '../services/pet_service_apis.dart';

/// Repositorio que centraliza el manejo de las mascotas del usuario.
/// Proporciona una única fuente de verdad para la mascota seleccionada y
/// el listado de mascotas disponibles.
class PetRepository extends GetxService {
  /// Mascota actualmente seleccionada.
  final Rxn<PetData> selectedPet = Rxn<PetData>();

  /// Listado de mascotas del usuario.
  final RxList<PetData> userPets = <PetData>[].obs;

  /// Obtiene la lista de mascotas desde el backend y actualiza los
  /// observables correspondientes. Si no hay mascota seleccionada se
  /// asigna la primera disponible.
  Future<void> loadUserPets() async {
    final pets = await PetService.getPetListApi(pets: []);
    userPets.assignAll(pets);
    if (userPets.isNotEmpty && selectedPet.value == null) {
      selectedPet.value = userPets.first;
    }
  }

  /// Establece la mascota seleccionada.
  void selectPet(PetData pet) {
    selectedPet.value = pet;
  }

  /// Crea una nueva mascota en el backend y la agrega al listado local.
  /// También se establece como mascota seleccionada.
  Future<PetData?> createPet({
    required PetData petData,
    required String imagePath,
  }) async {
    final pet = await PetService.postCreatePetApi(
      body: petData.mapToCreate(),
      imagePath: imagePath,
    );
    if (pet != null) {
      userPets.add(pet);
      selectedPet.value = pet;
    }
    return pet;
  }

  /// Actualiza una mascota en el backend y en el listado local.
  Future<PetData?> updatePet({
    required PetData petData,
  }) async {
    final updated = await PetService.postEditPetApi(
      petId: petData.id,
      body: petData.mapToUpdate(),
    );
    if (updated != null) {
      final index = userPets.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        userPets[index] = updated;
        userPets.refresh();
      }
      if (selectedPet.value?.id == updated.id) {
        selectedPet.value = updated;
      }
    }
    return updated;
  }

  /// Elimina una mascota del backend y la remueve del listado local.
  Future<bool> deletePet(int id) async {
    final response = await PetService.deletePetApi(id: id);
    if (response != null) {
      userPets.removeWhere((p) => p.id == id);
      if (selectedPet.value?.id == id) {
        selectedPet.value = userPets.isNotEmpty ? userPets.first : null;
      }
      return true;
    }
    return false;
  }
}

