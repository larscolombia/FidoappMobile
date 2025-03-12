import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
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

  Future<void> updateVideoAsWatched({
    required int userId,
    required int coursePlatformId,
    required int coursePlatformVideoId,
    required bool watched,
  }) async {
    // Asegúrate de poner la URL base correcta en tu API.
    isLoading.value = true;
    final url =
        Uri.parse('${BASE_URL}course-platform/subscribe/mark-video-as-watched');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
    };

    final body = jsonEncode({
      'user_id': userId,
      'course_platform_id': coursePlatformId,
      'course_platform_video_id': coursePlatformVideoId,
      'watched': watched,
    });
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );
      print('respuesta del put $response');

      if (response.statusCode == 200) {
        // La actualización fue exitosa.
        CustomSnackbar.show(
          title: 'Éxito',
          message: 'El video ha sido marcado como visto',
          isError: false,
        );
        fetchCourses();
      } else {
        // Se produjo un error en la petición.
        throw Exception(
            'Error al actualizar el video. Código: ${response.statusCode}, respuesta: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error en la comunicación: $error');
    } finally {
      isLoading.value = false;
    }
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
      var data = json.decode(response.body);
      print('data de mis cursos ${data}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          Get.dialog(
            //pisa papel
            CustomAlertDialog(
              icon: Icons.check_circle_outline,
              title: '¡Felicidades!',
              description: 'El curso ha sido adquirido con exito.',
              primaryButtonText: 'Continuar',
              onPrimaryButtonPressed: () {
                fetchCourses();
                print('curo id ${courseId}');
                Get.to(() => CursosDetalles(
                      cursoId: courseId.toString(),
                    ));
              },
            ),
            barrierDismissible: true,
          );
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to subscribe to course');
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al suscribirse al curso: $e',
        isError: true,
      );
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
