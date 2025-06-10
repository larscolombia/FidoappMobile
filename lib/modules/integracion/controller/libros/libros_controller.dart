import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'dart:convert';
import 'package:pawlly/modules/integracion/model/libros/libros_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:url_launcher/url_launcher.dart';

class EBookController extends GetxController {
  var ebooks = <EBook>[].obs; // Lista de e-books
  var selectedEBook = EBook().obs; // E-book seleccionado
  var isLoading = false.obs; // Indicador de carga
  var idLibro = "".obs;
  var filteredEBooks = <EBook>[].obs; // Lista de libros filtrados

  void setIdLibro(String id) {
    idLibro.value = id;
  }

  @override
  void onInit() {
    super.onInit();
    fetchEBooks();
  }

  Future<void> openStripeCheckout(String url) async {
    final Uri uri = Uri.parse(url); // Convierte la URL en un objeto Uri

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Abre en el navegador externo
    )) {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  // Método para obtener los e-books desde la API
  Future<void> fetchEBooks() async {
    isLoading.value = true;
    const url = '$DOMAIN_URL/api/e-books'; // Reemplaza con la URL de tu API
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
          print('cargando libros en el sistema ${data['data']}');
          filteredEBooks.value = ebooks;
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

  // Método para seleccionar un e-book de la lista sin hacer una petición
  void selectEBookById(String id) {
    try {
      idLibro.value = id;
      final ebook = ebooks.firstWhere((book) => book.id.toString() == id,
          orElse: () => EBook());
      if (ebook.id != null) {
        selectedEBook.value = ebook;
      } else {
        print('E-book no encontrado');
      }
    } catch (e) {
      print('Error seleccionando eBook: $e');
    }
  }

  void filterEBooks(String? query) {
    if (query == null || query.isEmpty || query == "0") {
      filteredEBooks.value =
          ebooks; // Mostrar todos los libros si no hay filtro
    } else {
      filteredEBooks.value = ebooks
          .where((book) =>
              book.description?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    }
  }
}
