import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/herramienta_model/herramienta_model.dart';
import 'dart:convert';

import 'package:pawlly/services/auth_service_apis.dart';

class HerramientasController extends GetxController {
  var tools = <Herramienta>[].obs; // Lista observable de herramientas
  var isLoading = false.obs; // Controla la carga de datos
  var errorMessage = ''.obs; // Mensaje de error en caso de fallo
  @override
  void onInit() {
    super.onInit();
    fetchTools(); // Llama a la función para cargar las herramientas al inicializar
  }

  // Método para obtener las herramientas desde la API
  Future<void> fetchTools() async {
    const String apiUrl = "${BASE_URL}herramientas"; // Reemplaza con tu API
    print('url sonido $apiUrl');
    try {
      isLoading(true);
      errorMessage('');

      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      });
      print('data tools ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        print('data tools ${data['data']}');
        tools.value = (data['data'] as List)
            .map((toolJson) => Herramienta.fromJson(toolJson))
            .toList();
        print('tools ${tools.value.length}');
      } else {
        errorMessage('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      errorMessage('Error al conectar con la API: $e');
    } finally {
      isLoading(false);
    }
  }
}
