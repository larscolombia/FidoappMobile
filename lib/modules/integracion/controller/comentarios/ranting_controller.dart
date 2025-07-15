import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/comentario/rainting.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class CommentController extends GetxController {
  var comments = <Comment>[].obs; // Usamos un RxList para almacenar los comentarios
  var isLoading = false.obs;
  var isFirstLoad = true.obs; // Variable para controlar si es la primera carga.
  var visualizacion = 0.obs;
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
    try {
      comments.value = [];
      isLoading(true);
      
      // Logs para debugging fetchComments
      print('=== DEBUG FETCH COMMENTS ===');
      print('ItemId: $itemId');
      print('Tipo: $tipo');
      print('Endpoint: ${getEndpoint(tipo, itemId)}');
      print('URL completa: $baseUrl${getEndpoint(tipo, itemId)}');
      print('Token: ${AuthServiceApis.dataCurrentUser.apiToken}');
      
      final response = await http.get(Uri.parse('$baseUrl${getEndpoint(tipo, itemId)}'), headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      });

      print('=== FETCH RESPONSE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('Response Body Length: ${response.body.length}');
      print('Response Body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        print('=== SUCCESS FETCH COMMENTS ===');
        print('Parsed data: $data');
        
        try {
          comments.value = (data['data'] as List).map((item) => Comment.fromJson(item)).toList();
          print('Comments loaded successfully: ${comments.length} comments');
        } catch (parseError) {
          print('=== ERROR PARSING COMMENTS ===');
          print('Parse error: $parseError');
          print('Data that failed to parse: $data');
        }
      } else {
        print('=== ERROR FETCH COMMENTS ===');
        print('Status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('=== CATCH ERROR FETCH COMMENTS ===');
      print('Error en comentarios: $e');
      print('Error type: ${e.runtimeType}');
    } finally {
      isLoading(false);
      isComentarioPosrLoading(false);
    }
    isFirstLoad.value = false; // Cambiamos el flag para evitar cargas futuras.
  }

  Future<void> visualizaciones(String blogId) async {
    final url = Uri.parse('${baseUrl}/blogs/$blogId/visualization');

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
      );

      if (response.statusCode == 200) {
        // Éxito
        final Map<String, dynamic> data = json.decode(response.body);

        visualizacion.value = data['visualizations'];
      } else {
        // Error
        print('Error al actualizar la visualización. Código de estado: ${response.statusCode}');
        print('Cuerpo de respuesta: ${response.body}');
      }
    } catch (e) {
      // Error de conexión u otro error
      print('Error: $e');
    }
  }

  double calculateAverageRating() {
    print('=== CALCULATE AVERAGE RATING ===');
    print('Total de comentarios: ${comments.length}');
    
    if (comments.isEmpty) {
      print('No hay comentarios, retornando 0.0');
      return 0.0;
    }

    double sum = 0.0;
    int validRatings = 0;
    
    for (var i = 0; i < comments.length; i++) {
      var comment = comments[i];
      print('Comentario $i: ID=${comment.id}, Rating="${comment.rating}"');
      
      if (comment.rating != null && comment.rating!.isNotEmpty) {
        try {
          double rating = double.parse(comment.rating!);
          sum += rating;
          validRatings++;
          print('Rating válido: $rating');
        } catch (e) {
          print('Error al convertir rating "${comment.rating}": $e');
        }
      } else {
        print('Rating nulo o vacío para comentario $i');
      }
    }
    
    if (validRatings == 0) {
      print('No hay ratings válidos, retornando 0.0');
      return 0.0;
    }
    
    double average = sum / validRatings;
    double roundedAverage = double.parse(average.toStringAsFixed(1));
    
    print('Suma total: $sum');
    print('Ratings válidos: $validRatings');
    print('Promedio: $average');
    print('Promedio redondeado: $roundedAverage');
    
    return roundedAverage;
  }

  // Método para obtener los avatars de los comentarios
  List<String> getTopAvatars() {
    print('=== GET TOP AVATARS ===');
    print('Total de comentarios: ${comments.length}');
    
    List<String> avatars = [];
    
    for (var i = 0; i < comments.length && i < 5; i++) {
      var comment = comments[i];
      if (comment.userAvatar != null && comment.userAvatar!.isNotEmpty) {
        avatars.add(comment.userAvatar!);
        print('Avatar $i: ${comment.userAvatar}');
      } else {
        print('Avatar $i: nulo o vacío');
      }
    }
    
    print('Avatars encontrados: ${avatars.length}');
    return avatars;
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

  // Función para limpiar los campos de comentario y calificación
  void clearCommentFields() {
    comentario['review_msg'] = "";
    comentario['rating'] = 1;
    // Mantener los IDs específicos del tipo de contenido
    // comentario['e_book_id'] = "";
    // comentario['course_platform_video_id'] = "";
    // comentario['blog_id'] = "";
    // comentario['employee_id'] = "";
  }

  Future<void> postComment(String tipo, context) async {
    if (comentario['review_msg'] == "") {
      Get.dialog(
        //pisa papel
        CustomAlertDialog(
          icon: Icons.sd_card_alert,
          title: 'Alerta',
          description: "El comentario no puede estar vacío",
          onPrimaryButtonPressed: () {
            isComentarioPosrLoading(false);
            isLoading(false);
            Navigator.of(context).pop();
          },
          primaryButtonText: 'Ok',
        ),

        barrierDismissible: true,
      );
      return;
    }
    try {
      isComentarioPosrLoading(true);

      // Logs para debugging
      print('=== DEBUG POST COMMENT ===');
      print('Tipo: $tipo');
      print('Endpoint: ${postEnpoint(tipo)}');
      print('URL completa: ${Uri.parse(postEnpoint(tipo))}');
      print('Token: ${AuthServiceApis.dataCurrentUser.apiToken}');
      print('Body a enviar: ${jsonEncode(comentario)}');
      print('Comentario object: $comentario');

      final response = await http.post(
        Uri.parse(postEnpoint(tipo)),
        headers: <String, String>{
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(comentario),
      );

      print('=== RESPONSE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('Response Body Length: ${response.body.length}');
      print('Response Body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('=== SUCCESS RESPONSE ===');
        print('Response body for parsing: ${response.body}');
        
        try {
          var responseData = json.decode(response.body);
          print('Parsed response data: $responseData');
          
          var rating = responseData['data']['rating'];
          print('Rating from response: $rating');

          // Limpiar los campos después de enviar exitosamente
          clearCommentFields();

          // Actualizar la lista de comentarios después de enviar exitosamente
          String itemId = "";
          switch (tipo) {
            case "books":
              itemId = comentario['e_book_id'].toString();
              break;
            case "video":
              itemId = comentario['course_platform_video_id'].toString();
              break;
            case "blog":
              itemId = comentario['blog_id'].toString();
              break;
            case "user":
              itemId = comentario['employee_id'].toString();
              break;
          }
          
          print('ItemId for fetchComments: $itemId');
          
          if (itemId.isNotEmpty) {
            await fetchComments(itemId, tipo);
          }

          Get.dialog(
            //pisa papel
            CustomAlertDialog(
              icon: Icons.check_circle_outline,
              title: 'Comentario creado',
              description: rating < 3 ? "Tu comentario está bajo revisión y esperamos publicarlo pronto." : 'Tu comentario ha sido publicado',
              primaryButtonText: 'Continuar',
              onPrimaryButtonPressed: () {
                isComentarioPosrLoading(false);
                isLoading(false);
                Navigator.of(context).pop();
              },
            ),
            barrierDismissible: true,
          );
        } catch (parseError) {
          print('=== ERROR PARSING RESPONSE ===');
          print('Parse error: $parseError');
          print('Response body that failed to parse: ${response.body}');
          
          Get.dialog(
            CustomAlertDialog(
              icon: Icons.error,
              title: 'Error',
              description: 'Error al procesar la respuesta del servidor: $parseError',
              primaryButtonText: 'Ok',
              onPrimaryButtonPressed: () {
                isComentarioPosrLoading(false);
                isLoading(false);
                Navigator.of(context).pop();
              },
            ),
            barrierDismissible: true,
          );
        }
      } else {
        print('=== ERROR RESPONSE ===');
        print('Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.error,
            title: 'Error',
            description: 'Error del servidor: ${response.statusCode}\n${response.body}',
            primaryButtonText: 'Ok',
            onPrimaryButtonPressed: () {
              isComentarioPosrLoading(false);
              isLoading(false);
              Navigator.of(context).pop();
            },
          ),
          barrierDismissible: true,
        );
      }
    } finally {
      isComentarioPosrLoading(false);
      isLoading(false);
    }
  }
}
