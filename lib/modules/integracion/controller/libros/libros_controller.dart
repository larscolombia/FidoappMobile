import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'dart:convert';
import 'package:pawlly/modules/integracion/model/libros/libros_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class EBookController extends GetxController {
  var ebooks = <EBook>[].obs; // Lista de e-books
  var selectedEBook = EBook().obs; // E-book seleccionado
  var isLoading = false.obs; // Indicador de carga
  var idLibro = "".obs;

  void setIdLibro(String id) {
    idLibro.value = id;
  }

  // Método para obtener los e-books desde la API
  Future<void> fetchEBooks() async {
    isLoading.value = true;
    final url =
        '${DOMINIO_LOCAL}/api/e-books'; // Reemplaza con la URL de tu API
    print('url $url');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );
      final data = json.decode(response.body);
      print('libros $data');
      if (response.statusCode == 200) {
        if (data['success']) {
          // Mapear la lista de e-books desde el JSON
          ebooks.value = (data['data'] as List)
              .map((ebook) => EBook.fromJson(ebook))
              .toList();
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching eBooks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEBookById(String id) async {
    isLoading(true);
    final url =
        '${DOMINIO_LOCAL}/api/e-books/$id'; // Reemplaza con la URL de tu API

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      final data = json.decode(response.body);
      print('buscar libro $data');
      if (response.statusCode == 200) {
        if (data['success']) {
          // Mapear el e-book desde el JSON
          selectedEBook.value = EBook.fromJson(data['data']);
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching eBook: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
