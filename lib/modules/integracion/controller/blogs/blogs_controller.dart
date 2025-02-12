import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/blogs/blogs_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class BlogController extends GetxController {
  var isLoading = true.obs; // Estado de carga
  var blogPosts = <BlogPost>[].obs; // Lista observable de BlogPost
  var url = "$DOMAIN_URL/api/blog-list";
  var filteredBlogPosts =
      <BlogPost>[].obs; // Lista observable para blogs filtrados

  @override
  void onInit() {
    fetchBlogPosts(); // Llama a la función para obtener los posts al iniciar el controlador
    super.onInit();
  }

  Future<void> fetchBlogPosts() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      print('Solicitud a: ${Uri.parse(url)}');
      print('Respuesta HTTP: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      var jsonResponse = json.decode(response.body);
      print('Datos JSON decodificados: $jsonResponse');

      if (response.statusCode == 200) {
        if (jsonResponse['status']) {
          List<dynamic> data = jsonResponse['data'];
          print('Datos de los blogs: $data');

          blogPosts.value =
              data.map((post) => BlogPost.fromJson(post)).toList();
          filteredBlogPosts.value = blogPosts;
          print('Lista de blogs asignada: ${blogPosts.value}');
        } else {
          // Manejar el caso en que el estado no sea verdadero
          print(
              'Error en la respuesta del servidor: ${jsonResponse['message']}');
        }
      } else {
        // Manejar errores del servidor
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
    } finally {
      isLoading(false); // Asegúrate de cambiar el estado de carga
    }
  }

  // Método para obtener un post por su id
  BlogPost getBlogPostById(int id) {
    return blogPosts.firstWhere((post) => post.id == id);
  }

  // Método para buscar blogs por nombre (parcial o completo)
  List<BlogPost> getBlogPostsByName(String? name) {
    // Si el texto de búsqueda es nulo, vacío o "0", devuelve todos los blogs.

    if (name == null || name.isEmpty || name == "0") {
      print(
          'Texto de búsqueda nulo, vacío o igual a "0". Retornando todos los blogs.');
      filteredBlogPosts.value = blogPosts;
      return blogPosts.toList();
    }

    // Busca coincidencias parciales.
    var filteredBlogs = blogPosts
        .where((post) => post.name.toLowerCase().contains(name.toLowerCase()))
        .toList();

    // Si no se encontró ninguna coincidencia, se devuelven todos los blogs.
    if (filteredBlogs.isEmpty) {
      print(
          'No existen blogs que coincidan con el texto: $name. Retornando todos los blogs.');
      filteredBlogPosts.value = blogPosts;
      return blogPosts.toList();
    } else {
      filteredBlogPosts.value =
          filteredBlogs; // Actualiza la lista con los resultados
      return filteredBlogs;
    }
  }
}
