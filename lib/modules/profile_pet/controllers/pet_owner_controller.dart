import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pawlly/configs.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class PetOwnerController extends GetxController {
  var associatedPersons = <Map<String, dynamic>>[].obs; // Lista observable
  var isPrimaryOwner = false.obs; // Variable para verificar si el usuario actual es el dueño principal
  var primaryOwnerId = 0.obs; // ID del dueño principal
  var isLoading = false.obs; // Variable para controlar el estado de carga
  var hasLoaded = false.obs; // Variable para evitar cargas repetidas

  @override
  void onInit() {
    super.onInit();
    // No cargar datos automáticamente aquí para evitar problemas
  }

  Future<void> fetchOwnersList(int petId) async {
    // Evitar llamadas repetidas si ya se está cargando
    if (isLoading.value) return;
    
    isLoading.value = true;
    
    final url = Uri.parse('${BASE_URL}pets/$petId/owners');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Limpia la lista y agrega el primary_owner
        associatedPersons.clear();
        primaryOwnerId.value = data['primary_owner']['id'] ?? 0;
        
        // Verificar si el usuario actual es el dueño principal
        isPrimaryOwner.value = (data['primary_owner']['id'] == AuthServiceApis.dataCurrentUser.id);
        
        associatedPersons.add({
          'id': data['primary_owner']['id'] ?? 0,
          'name': data['primary_owner']['full_name'] ?? '',
          'imageUrl': data['primary_owner']['profile_image'] ?? '',
          'relation': 'Dueño principal' ?? '',
          'mobile': data['primary_owner']['mobile'] ?? '',
          'address': data['primary_owner']['address'] ?? '',
          'gender': data['primary_owner']['gender'] ?? '',
          'full_name': data['primary_owner']['full_name'] ?? '',
          'profile_image': data['primary_owner']['profile_image'] ?? '',
        });

        // Agrega cada shared_owner si existe
        if (data['shared_owners'] != null) {
          for (var owner in data['shared_owners']) {
            associatedPersons.add({
              'id': owner['id'] ?? 0,
              'name': owner['full_name'] ?? '',
              'imageUrl': owner['profile_image'] ?? '',
              'relation': 'Dueño compartido' ?? '',
              'gender': data['primary_owner']['gender'] ?? '',
              'full_name': data['primary_owner']['full_name'] ?? '',
              'mobile': data['primary_owner']['mobile'] ?? '',
              'address': data['primary_owner']['address'] ?? '',
              'profile_image': owner['profile_image'] ?? '',
            });
          }
        }
        
        hasLoaded.value = true;
        //pisa papel
        // print('dara ${data['primary_owner']}');
      } else {
        print('Error al obtener la lista de dueños: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para cargar datos solo si no se han cargado antes
  Future<void> loadOwnersIfNeeded(int petId) async {
    if (!hasLoaded.value && !isLoading.value) {
      await fetchOwnersList(petId);
    }
  }
}
