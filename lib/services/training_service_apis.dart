// /service-training/get

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/api_end_points.dart';
import 'package:pawlly/utils/app_common.dart';

class TrainingService {
  static Future<List<dynamic>> getTrainingServiceApi() async {
    if (isLoggedIn.value) {
      // Construir la URL completa con el user_id
      final url =
          Uri.parse('${BASE_URL}${APIEndPoints.getTrainingService}/get');

      // Realizar la solicitud con el token en los headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.tokenCurrentUser}',
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        return res.data;
      } else {
        // Manejo de error
        print('Error en la solicitud: ${response.statusCode}');
        return [];
      }
    } else {
      return [];
    }
  }
}
