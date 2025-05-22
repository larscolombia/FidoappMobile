import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

// curso de la plataforma
class CourseController extends GetxController {
  var courses = <Course>[].obs;
  var mycourses = <Course>[].obs;
  var isLoading = false.obs;
  var url = "$DOMAIN_URL/api/course-platform";
  var filteredCourses = <Course>[].obs;
  get jsonData => null;
  var selectedButton = 'Principiante'.obs;
  var selectButton = {
    '1': 'Principiante',
    '2': 'Intermedio',
    '3': 'Avanzado',
  };
  @override
  void onInit() {
    super.onInit();
    fetchCourses();
    // Inicializamos filteredCourses con todos los cursos
    ever(courses, (_) {
      filteredCourses.assignAll(courses);
    });
  }

  String dificultad(String dificultad) {
    switch (dificultad) {
      case '1':
        return 'Principiante';
      case '2':
        return 'Intermedio';
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
      print('Solicitud a: ${Uri.parse(url)}');
      print('Respuesta HTTP: $response');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var coursesData = jsonData['data']['courses'] as List;
        var coursesList =
            coursesData.map((course) => Course.fromJson(course)).toList();
        courses.assignAll(coursesList);
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'No se pudieron recuperar los cursos',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al cargar los cursos',
        isError: true,
      );
    } finally {
      isLoading.value = false;
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

  /// Método para filtrar cursos por el nombre
  void filterCoursesByName(String query) {
    // Si el query está vacío, se restauran todos los cursos
    if (query.isEmpty) {
      filteredCourses.assignAll(courses);
    } else {
      // Se filtran ignorando mayúsculas y minúsculas
      var filteredList = courses
          .where((course) =>
              course.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredCourses.assignAll(filteredList);
    }
  }

  void filterCoursesByDificultad() {
    if (selectedButton.value.isEmpty) {
      filteredCourses.assignAll(courses);
    } else {
      var difficultyFilter = selectedButton.value;
      var filteredList = courses.where((course) {
        // Compara la dificultad del curso con la dificultad seleccionada
        return course.difficulty == difficultyFilter;
      }).toList();
      filteredCourses.assignAll(filteredList);
    }
  }
}
