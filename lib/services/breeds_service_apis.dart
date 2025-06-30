import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/brear_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/api_end_points.dart';

class BreedsServiceApis {
  static Future<List<BreedModel>> getBreedsListApi() async {
    // Construir la URL
    final url = Uri.parse('$BASE_URL${APIEndPoints.getBreedsList}');

    // Realizar la solicitud con el token en los headers (si es necesario)
    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Ajusta según tu autenticación
      },
    );

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      final res = BreedListResponse.fromJson(jsonDecode(response.body));
      return res.data; // Devolver la lista de razas
    } else {
      // Manejo de error
      print('Error en la solicitud: ${response.statusCode}');
      return [];
    }
  }
}
