import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

// curso de la plataforma
class CourseController extends GetxController {
  var courses = <Course>[].obs;
  var isLoading = false.obs;
  var url = "$DOMAIN_URL/api/course-platform";

  get jsonData => null;
  @override
  void onInit() {
    super.onInit();
    fetchCourses();
    // getCourseById(AuthServiceApis.dataCurrentUser.id);
  }

  String dificultad(String dificultad) {
    switch (dificultad) {
      case '1':
        return 'Fácil';
      case '2':
        return 'Media';
      case '3':
        return 'Difícil';
      default:
        return 'Difícil';
    }
  }

  Future<void> fetchCourses() async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );
      print('Respuesta JSON: ${Uri.parse(url)}');
      print('Respuesta JSON: $response');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var coursesData = jsonData['data']['courses'] as List;
        var coursesList =
            coursesData.map((course) => Course.fromJson(course)).toList();
        courses.assignAll(coursesList);
      } else {
        Get.snackbar('Error', 'No se pudieron recuperar los cursos');
      }
    } catch (e) {
      print('error en course controller $e');
    } finally {
      isLoading(false);
    }
  }

  Course getCourseById(int id) {
    return courses.firstWhere((course) => course.id == id);
  }

  Video? findVideoById({required int courseId, required String videoId}) {
    try {
      // Obtén el curso por su ID
      final course = getCourseById(courseId);

      // Busca el video dentro de la lista de videos del curso
      return course.videos.firstWhere(
        (video) => video.id == videoId,
        orElse: () => throw Exception("Video no encontrado."),
      );
    } catch (e) {
      print("Error buscando el video: $e");
      return null;
    }
  }
}
