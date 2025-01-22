import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'dart:convert';
import 'package:pawlly/modules/integracion/model/comentario/rainting.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class CommentController extends GetxController {
  var comments =
      <Comment>[].obs; // Usamos un RxList para almacenar los comentarios
  var isLoading = false.obs;
  var isFirstLoad = true.obs; // Variable para controlar si es la primera carga.

  final String baseUrl = "$DOMAIN_URL/api";
  final isComentarioPosrLoading = false.obs;
  String getEndpoint(String tipo, String itemId) {
    switch (tipo) {
      case "books":
        return "/get-book-rating-by-id-ebook?e_book_id=$itemId";
      case "video":
        return "/course-platform/subscribe/get-rating-course-video?course_platform_video_id=$itemId";
      case 'blog':
        return "/get-blog-rating?blog_id=$itemId";
      case 'user':
        return '/raiting-user?employee_id=$itemId';
      default:
        return "Comentarios";
    }
  }

  String postEnpoint(String tipo) {
    switch (tipo) {
      case "books":
        return "$baseUrl/e-book-rating";
      case "video":
        return "$baseUrl/course-platform/subscribe/rating-course-video";
      case "blog":
        return "$baseUrl/blog-list/rating";
      case 'user':
        return "$baseUrl/raiting-user";
      default:
        return "Comentarios";
    }
  }

  Future<void> fetchComments(String itemId, String tipo) async {
    print('url comentarios libro ${baseUrl + getEndpoint(tipo, itemId)}');
    try {
      comments.value = [];
      isLoading(true);
      final response = await http
          .get(Uri.parse('$baseUrl${getEndpoint(tipo, itemId)}'), headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      });

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        print('comentarios ${data['data']}');
        comments.value = (data['data'] as List)
            .map((item) => Comment.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('error en comentarios $e');
    } finally {
      isLoading(false);
    }
    isFirstLoad.value = false; // Cambiamos el flag para evitar cargas futuras.
  }

  double calculateAverageRating() {
    if (comments.isEmpty) return 0.0;

    double sum = comments.fold(0.0, (sum, comment) {
      double rating = 0.0;

      if (comment.rating != null) {
        try {
          rating = double.parse(
              comment.rating.toString()); // Intentamos convertir a double
        } catch (e) {
          print("Error al convertir el rating: $e");
        }
      }

      return sum + rating;
    });

    double average = sum / comments.length;
    return double.parse(
        average.toStringAsFixed(1)); // Redondear a una cifra decimal
  }

  var comentario = {
    'e_book_id': "",
    'user_id': AuthServiceApis.dataCurrentUser.id,
    'rating': 1,
    'review_msg': "",
    "course_platform_video_id": "",
    "blog_id": "",
    "employee_id": ""
  }.obs;

  void updateField(String key, dynamic value) {
    comentario[key] = value;
  }

  Future<void> postComment(String tipo, context) async {
    print("log comentario ${Uri.parse(postEnpoint(tipo))}");
    try {
      isComentarioPosrLoading(true);
      final response = await http.post(
        Uri.parse(postEnpoint(tipo)),
        headers: <String, String>{
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(comentario),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
          'log comentario ${json.decode(response.body)['data']['rating']}',
        );
        var rating = json.decode(response.body)['data']['rating'];
        Get.dialog(
          //pisa papel
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Comentario creado',
            description: rating < 3
                ? "Tu comentario debe ser aprobado por un administrador"
                : 'Tu comentario ha sido publicado ',
            primaryButtonText: 'Continuar',
            onPrimaryButtonPressed: () {
              Navigator.of(context).pop();
            },
          ),
          barrierDismissible: true,
        );
      }
    } finally {
      isComentarioPosrLoading(false);
    }
  }

  List<String> getTopAvatars() {
    // Devuelve un máximo de 5 avatares de la lista de comentarios
    return comments.take(5).map((comment) => comment.userAvatar ?? '').toList();
  }
}
