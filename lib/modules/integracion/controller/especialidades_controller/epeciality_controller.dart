import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/especialidades_model/especialiry_model.dart';
import 'dart:convert';

import 'package:pawlly/services/auth_service_apis.dart';

class SpecialityController extends GetxController {
  var isLoading = true.obs;
  var specialities = <SpecialityModel>[].obs;

  // URL de la API
  final String url =
      '${BASE_URL}specialities?speciality_id=${AuthServiceApis.dataCurrentUser.userType}';

  @override
  void onInit() {
    super.onInit();
    fetchSpecialities(); // Llamada a la función para obtener los datos cuando el controlador se inicializa.
  }

  // Método para hacer la solicitud HTTP
  Future<void> fetchSpecialities() async {
    try {
      isLoading(true); // Cambia el estado a cargando
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );
      print('Respuesta de la llamada a la API: $response');
      if (response.statusCode == 200) {
        // Si la llamada es exitosa, parseamos los datos
        var data = json.decode(response.body)['data'];
        specialities.value = List<SpecialityModel>.from(
          data.map((item) => SpecialityModel.fromJson(item)),
        );
      } else {
        throw Exception('Failed to load specialities');
      }
    } finally {
      isLoading(false); // Cambia el estado a no cargando
    }
  }
}
