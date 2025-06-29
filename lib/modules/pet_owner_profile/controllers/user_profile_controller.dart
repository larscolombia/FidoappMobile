import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/owner_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class UserProfileController extends GetxController {
  var user = UserData().obs; // Observa el modelo del usuario.
  var isLoading = false.obs;

  // Método para obtener los datos del usuario
  Future<void> fetchUserData(String id) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${Uri.parse('$DOMAIN_URL/api/user-profile?user_id=$id')}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body)['data'];
        print('perfil usuarioss $data');
        user.value = UserData.fromJson(data);
      } else {}
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
    } finally {
      isLoading(false);
    }
  }
}
