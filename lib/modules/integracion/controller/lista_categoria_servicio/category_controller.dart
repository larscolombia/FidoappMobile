import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/category_model.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/price_model.dart';
import 'package:pawlly/modules/integracion/model/lista_categoria_servicio/service_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class CategoryControllerVet extends GetxController {
  var categories = <Category>[].obs;
  var services = <Service>[].obs;
  var precioService = RxList<Precio>();
  var isLoading = true.obs;
  var totalAmount = "".obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchprecio(String servideId, BuildContext context) async {
    isLoading.value = true;

    final response = await http.get(
      Uri.parse('${BASE_URL}service-price?service_id=$servideId'),
      headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Respuesta JSON precio: $jsonResponse');
      totalAmount.value = jsonResponse['data']['amount'].toString();
      Get.dialog(
        //pisa papel
        CustomAlertDialog(
          icon: Icons.check_circle_outline,
          title: 'Costo del servicio ',
          description: '${totalAmount.value}',
          primaryButtonText: 'Continuar',
          onPrimaryButtonPressed: () {
            Navigator.pop(context);
          },
        ),
        barrierDismissible: true,
      );
    } else {
      print('Error: ${response.statusCode}');
    }
    isLoading.value = false;
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('${BASE_URL}category-list-by-type?type=veterinary'), headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Respuesta JSON categoria: $jsonResponse');
        var fetchedCategories = (jsonResponse['data'] as List).map((category) => Category.fromJson(category)).toList();
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

  void fetchServices(categoryId) async {
    print("Cargando");
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('${BASE_URL}service-list-by-category?category_id=$categoryId'), headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Respuesta JSON categoria: $jsonResponse');
        var fetchedServices = (jsonResponse['data'] as List).map((service) => Service.fromJson(service)).toList();
        services.value = fetchedServices;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener los servicios: $e');
    } finally {
      isLoading(false);
    }
  }

  void nombreCategoria(String value) {
    final selectedCategory = categories.firstWhere(
      (category) => category.id.toString() == value,
      orElse: () => Category(id: 0, name: 'Unknown', slug: '', status: 1, categoryImage: '', createdAt: '', updatedAt: ''),
    );
  }
}
