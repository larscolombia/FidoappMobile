import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/mascotas/mascotas_model.dart';

import 'package:pawlly/services/auth_service_apis.dart';
import 'dart:convert';

class PetControllerv2 extends GetxController {
  var pets = <Pet>[].obs;
  var isLoading = true.obs;
  var selectedPet = Rxn<Pet>();
  var url =
      '${DOMAIN_URL}/api/pets?user_id=${AuthServiceApis.dataCurrentUser.id}';

  get selectedPetIds => null;
  @override
  void onInit() {
    fetchPets();
    super.onInit();
  }

  void fetchPets() async {
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse('${url}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = jsonResponse['data'] as List;
        pets.value = data.map((item) => Pet.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch pets');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    } finally {
      isLoading(false);
      isLoading.value = false;
    }
  }

  void showPet(String id) async {
    var uriShow = '${DOMAIN_URL}/api/pets/$id';
    try {
      isLoading(true);
      print('uriShow $uriShow');
      var response = await http.get(
        Uri.parse('${DOMAIN_URL}/api/pets/$id'),
        headers: {
          'Authorization':
              'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Ajusta según tu autenticación
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        selectedPet.value = Pet.fromJson(jsonResponse['data']);
        print('seleccionado ${jsonResponse['data']}');
      } else {
        Get.snackbar('Error', 'Failed to fetch pet profile');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
