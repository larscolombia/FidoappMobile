import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'dart:convert';

import 'package:pawlly/modules/integracion/model/categoria/categoria_model.dart';
import 'package:pawlly/services/auth_service_apis.dart'; // Para convertir JSON

class CategoryController extends GetxController {
  // Lista de categorías observable
  var categories = <Category>[].obs;
  var url = "${DOMAIN_URL}/api/list-category?type=veterinary";
  // Indicador de carga
  var isLoading = true.obs;

  // Mensaje de error o éxito
  var message = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Método para obtener datos desde la API
  Future<void> fetchCategories() async {
    try {
      isLoading(true); // Inicia la carga
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonResponse);
        print('categorias ${ApiResponse.fromJson(jsonResponse)}');
        // Actualiza los datos observables
        categories.value = apiResponse.data;
        message.value = apiResponse.message;
      } else {
        // Manejo de errores
        message.value = "Error: ${response.statusCode}";
      }
    } catch (e) {
      // Manejo de excepciones
      message.value = "Error: $e";
    } finally {
      isLoading(false); // Finaliza la carga
    }
  }
}
