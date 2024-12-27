import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/curosos/cursos_usuarios.dart';

import '../../../../services/auth_service_apis.dart';

class CursoUsuarioController extends GetxController {
  var courses = <CursosUsuarios>[].obs; // Observable list of courses
  var isLoading = false.obs;
  var selectedCourse = CursosUsuarios(
    id: 0,
    progress: 0,
    name: '',
    description: '',
    image: '',
    duration: '',
    price: '',
    difficulty: '',
    userId: 0,
    userName: '',
    avatar: '',
  ).obs;
  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  // Método para listar cursos
  Future<void> fetchCourses() async {
    // isLoading.value = true;
    print('inicializando subscriccion de cursos');
    try {
      final response = await http.get(
        Uri.parse(
            '$DOMAIN_URL/api/course-platform/subscribe/all-courses-user?user_id=${AuthServiceApis.dataCurrentUser.id}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Respuesta JSON: ${data['data']['courses']}');
        if (data['success']) {
          List<dynamic> coursesData = data['data']['courses'];
          var coursesList = coursesData
              .map((course) => CursosUsuarios.fromJson(course))
              .toList();
          courses.assignAll(
              coursesList); // Asignar los datos a la lista observable
          print(
              'Cursos asignados: $coursesList'); // Añadir un print para depuración
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('error en cursos controller $e');
    } finally {
      //  isLoading.value = false;
    }
  }

  Future<void> subscribeToCourse(int courseId) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${BASE_URL}course-platform/subscribe'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': AuthServiceApis.dataCurrentUser.id,
          'course_platform_id': courseId,
        }),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          print('Curso suscrito exitosamente');
          fetchCourses();
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to subscribe to course');
      }
    } catch (e) {
      print('error en subscribeToCourse $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para seleccionar un curso individual
  void selectCourse(int id) {
    selectedCourse.value = courses.firstWhere((course) => course.id == id);
  }

  bool hasCourse(String courseId) {
    return courses.any((course) => course.id.toString() == courseId);
  }
}
