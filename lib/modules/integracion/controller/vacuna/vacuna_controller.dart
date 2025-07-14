import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/modules/integracion/model/vacuna/vacuna_model.dart';

class VacunaController extends GetxController {
  var vacunas = <Vacuna>[].obs;
  var isLoading = false.obs;

  Future<void> fetchVacunas(int petId) async {
    final url = '$DOMAIN_URL/api/vaccines-given-to-pet?pet_id=$petId';
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          vacunas.value = (data['data'] as List)
              .map((e) => Vacuna.fromJson(e))
              .toList();
        }
      } else {
        print('Error HTTP vacunas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener vacunas: $e');
    } finally {
      isLoading(false);
    }
  }
}
