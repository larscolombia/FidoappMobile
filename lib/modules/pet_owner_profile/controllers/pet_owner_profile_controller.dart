import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'owner_model.dart';

class PetOwnerProfileController extends GetxController {
  var ownerName = 'Juan Pérez'.obs;
  var email = 'juan.perez@example.com'.obs;
  var phone = '+1 809 555 5555'.obs;
  var address = 'Av. Independencia, Santo Domingo, R.D.'.obs;
  var profileImagePath = ''.obs;
  var relation = 'Dueño'.obs;
  var rating = 4.5.obs; // Clasificación
  var userType = 'Veterinario'.obs; // Tipo de usuario
  var description =
      'Descripción del usuario aquí... Esta es una breve descripción de la persona asociada.'
          .obs;
  var veterinarianLinked = true.obs; // Condición si está vinculado
  var specializationArea = 'Cirugía'.obs; // Área de especialización principal
  var otherAreas = ['Cardiología', 'Dermatología', 'Oftalmología']
      .obs; // Lista de otras áreas de especialización
  var commentCount = 456.obs; // Número de comentarios
  var commenterImages = [
    'https://example.com/img1.jpg',
    'https://example.com/img2.jpg',
    'https://example.com/img3.jpg',
    'https://example.com/img4.jpg',
    'https://example.com/img5.jpg'
  ].obs; // Lista de URLs de imágenes de los comentaristas
}

class UserProfileController extends GetxController {
  var user = UserData().obs; // Observa el modelo del usuario.
  var isLoading = false.obs;

  // Dominio base de la API

  // Método para obtener los datos del usuario
  Future<void> fetchUserData(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$DOMAIN_URL/api/user-profile?user_id=$id'),
        headers: {
          'Authorization':
              'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Reemplaza con tu lógica de token.
          'Content-Type': 'application/json',
        },
      );

      print('Perfil de usuario: ${json.decode(response.body)}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        user.value =
            UserData.fromJson(data); // Actualiza el modelo con la respuesta.
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print("Error al obtener datos del usuario: $e");
    } finally {
      isLoading(false);
    }
  }
}
