import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/categoria/categoria_model.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/diary_category_model.dart';
import 'package:pawlly/services/auth_service_apis.dart'; // Para convertir JSON

class CategoryController extends GetxController {
  // Lista de categorías observable
  var categories = <Category>[].obs;
  var diaryCategories = <DiaryCategory>[].obs;
  var url = "$DOMAIN_URL/api/list-category?type=veterinary";
  // Indicador de carga
  var isLoading = true.obs;

  // Mensaje de error o éxito
  var message = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchDiaryCategories();
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

  // Método para obtener datos desde la API
  Future<void> fetchDiaryCategories() async {
    print("diario categorías");
    try {
      isLoading(true); // Inicia la carga
      final response = await http.get(
        Uri.parse("$DOMAIN_URL/api/diary-categories"),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Actualiza los datos observables
        var fetchedCategories = (jsonResponse['data'] as List).map((diaryCategory) => DiaryCategory.fromJson(diaryCategory)).toList();
        print('diario categorias $fetchedCategories');
        diaryCategories.value = fetchedCategories;
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
