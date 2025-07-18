import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/pet_data.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
import 'package:pawlly/services/auth_service_apis.dart';

import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';


class PetServiceApis {
  final RoleUser roleUser = Get.put(RoleUser());

  // TODO: Este método no se está utilizando
  static Future<void> addPetDetailsApi({
    int? petId,
    required Map<String, dynamic> request,
    bool isUpdateProfilePic = false,
    List<XFile>? files,
    required VoidCallback onPetAdd,
    required VoidCallback loaderOff
  }) async {
    log('FILES: $files');
    log('FILES length: ${files.validate().length}');

    String petIdparam = petId != null ? "/$petId" : "";
    var multiPartRequest = await getMultiPartRequest(APIEndPoints.addPet + petIdparam);

    if (!isUpdateProfilePic) {
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
    }

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath(
          'pet_image', files.validate().first.path.validate()));
    }

    // log("Multipart ${jsonEncode(multiPartRequest.fields)}");
    log("Multipart Images ${multiPartRequest.files.map((e) => e.filename)}");

    multiPartRequest.headers.addAll(buildHeaderTokens());

    // BaseResponseModel baseResponseModel = BaseResponseModel();
    await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
      log("Response: ${jsonDecode(temp)}");
      // baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
      // toast(baseResponseModel.message, print: true);
      onPetAdd.call();
    }, onError: (error) {
      toast(error.toString(), print: true);
      loaderOff.call();
    });
  }

  static Future<PetData?> createPet({
    required Map<String, String> body, // Recibe el body ya validado
    required String imagePath, // Ruta de la imagen
  }) async {
    if (isLoggedIn.value) {
      final url = Uri.parse('$BASE_URL${APIEndPoints.getPetList}');

      print('URL completa: $url');
      print('Cuerpo de la solicitud (JSON): ${jsonEncode(body)}');

      try {
        var request = http.MultipartRequest('POST', url);

        request.headers.addAll({
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        });

        body.forEach((key, value) {
          request.fields[key] = value;
        });

        if (imagePath.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(
            'pet_image',
            imagePath,
          ));
        }

        var response = await request.send();
        var responseData = await http.Response.fromStream(response);
        print('responseee ${responseData.statusCode}');
        print('Respuesta completa: ${responseData.body}');

        if (responseData.statusCode == 201 || responseData.statusCode == 200) {
          final responseDataJson = jsonDecode(responseData.body);
          Get.dialog(
            //pisa papel
            CustomAlertDialog(
              icon: Icons.check_circle_outline,
              title: 'Mascota creada',
              description: 'La mascota ha sido creada exitosamente.',
              primaryButtonText: 'Continuar',
              onPrimaryButtonPressed: () {
                Get.back();
                // final HomeController homeController = Get.put(HomeController());
                // homeController.fetchProfiles();
                Get.to(() => const HomeScreen());
              },
            ),
            barrierDismissible: false,
          );
          if (responseDataJson.containsKey('data')) {
            print('agregar mascota ${responseDataJson['data']}');
            final petData = PetData.fromJson(responseDataJson['data']);
            return petData;
          } else {
            print('Advertencia: la respuesta no contiene el campo "data".');
            return null;
          }
        } else {
          print('Error en la solicitud: ${responseData.statusCode}');
          print('Respuesta: ${responseData.body}');
          return null;
        }
      } catch (e) {
        print('Error al crear la mascota: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<PetData>> getPets() async {
    if (isLoggedIn.value) {
      var urlRole = '';
      if (AuthServiceApis.dataCurrentUser.userType == 'vet') {
        urlRole = '${BASE_URL}owner-pets?employee_id=${AuthServiceApis.dataCurrentUser.id}';
      } else if (AuthServiceApis.dataCurrentUser.userRole == 'trainer') {
        urlRole = '${BASE_URL}trainer-pets?employee_id=${AuthServiceApis.dataCurrentUser.id}';
      } else {
        urlRole = '${BASE_URL}pets?user_id=${AuthServiceApis.dataCurrentUser.id}';
      }
      // Construir la URL completa con el método getApiUrl
      final url = Uri.parse(urlRole);

      // Realizar la solicitud con el token en los headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('JSON RESPONSE Role: ${AuthServiceApis.dataCurrentUser.userType}');
        print('JSON RESPONSE: $jsonResponse');
        // Verificar la estructura de la respuesta para vet y trainer
        if (AuthServiceApis.dataCurrentUser.userType == 'vet' ||
            AuthServiceApis.dataCurrentUser.userType == 'trainer') {
          // Estructura para vet y trainer: data es una lista de owners que contiene listas de pets
          final owners = (jsonResponse['data'] as List);
          final petDataList = owners.expand((owner) => owner['pets'] as List).toList();
          final res = petDataList.map((item) => PetData.fromJson(item)).toList();
          return res;
        } else {
          // Estructura para user: data es una lista de pets directamente
          final res = PetListRes.fromJson(jsonResponse);
          print('Mascotas ${res.data}');
          // pets.clear();
          // pets.addAll(res.data);
          return res.data;
        }
      } else {
        // Manejo de error
        print('Error en la solicitud: ${response.statusCode}');
        return [];
      }
    } else {
      return [];
    }
  }

  static Future deletePetApi({
    required int id, // Recibe el body ya validado
  }) async {
    if (isLoggedIn.value) {
      // Construir la URL completa
      final url = Uri.parse('$BASE_URL${APIEndPoints.getPetList}/$id');

      // Imprimir la URL completa
      print('URL completa: $url');

      // Imprimir el cuerpo de la solicitud

      // Realizar la solicitud POST con el token en los headers
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      print('responseee ${response.statusCode}');
      print('Respuesta completa: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parsear la respuesta JSON
        return response;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<PetData?> updatePet({
    required int petId, // ID de la mascota a editar
    required Map<String, dynamic> body, // Recibe el body ya validado
  }) async {
    if (isLoggedIn.value) {
      // Construir la URL completa para la edición, incluyendo el ID de la mascota
      final url = Uri.parse('$BASE_URL${APIEndPoints.getPetList}/$petId');

      // Realizar la solicitud POST con el token en los headers
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body), // Convertir el body a JSON
      );

      if (response.statusCode == 200) {
        // Parsear la respuesta JSON y retornar el objeto PetData actualizado
        final petData = PetData.fromJson(jsonDecode(response.body)['data']);
        return petData;
      } else {
        // Manejo de error
        print('Error en la solicitud: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return null;
      }
    } else {
      return null;
    }
  }
}
