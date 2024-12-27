import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/category_model.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/price_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class CategoryControllerVet extends GetxController {
  var categories = <Category>[].obs;
  var precioService = RxList<Precio>();
  var isLoading = true.obs;
  var totalAmount = "".obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchprecio(String type) async {
    isLoading.value = true;

    final response = await http.get(
      Uri.parse('${BASE_URL}service-price?service_id=$type'),
      headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Respuesta JSON precio: $jsonResponse');
      totalAmount.value = jsonResponse['data']['amount'].toString();
    } else {
      print('Error: ${response.statusCode}');
    }
    isLoading.value = false;
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      final response = await http.get(
          Uri.parse('${BASE_URL}category-list-by-type?type=veterinary'),
          headers: {
            'Authorization':
                'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Respuesta JSON categoria: $jsonResponse');
        var fetchedCategories = (jsonResponse['data'] as List)
            .map((category) => Category.fromJson(category))
            .toList();
        categories.value = fetchedCategories;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las categorías: $e');
    } finally {
      isLoading(false);
    }
  }
}
