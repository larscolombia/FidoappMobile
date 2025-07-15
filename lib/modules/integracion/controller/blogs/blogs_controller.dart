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

      var jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse['status']) {
          List<dynamic> data = jsonResponse['data'];

          blogPosts.value =
              data.map((post) => BlogPost.fromJson(post)).toList();
          filteredBlogPosts.value = blogPosts;
          
          // Debug: Imprimir información detallada de los blogs
          print('Blogs cargados con éxito: ${filteredBlogPosts.length} blogs');
          for (var i = 0; i < filteredBlogPosts.length; i++) {
            var blog = filteredBlogPosts[i];
            print('Blog $i: ID=${blog.id}, Name="${blog.name}", URL_Video="${blog.url_video}"');
          }
          
          print(
              'Blogs cargados con éxito: ${jsonEncode(filteredBlogPosts.map((post) => post.toJson()).toList())}');
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
      isLoading.value = false; // Corregido: usar .value = false
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

    // Actualiza la lista filtrada con los resultados
    filteredBlogPosts.value = filteredBlogs;
    print('Búsqueda: "$name" - Encontrados: ${filteredBlogs.length} blogs');
    return filteredBlogs;
  }
}
