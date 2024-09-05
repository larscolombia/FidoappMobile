import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/models/brear_model.dart';
import 'package:pawlly/models/pet_list_res_model.dart';
import 'package:pawlly/models/pet_note_model.dart';
import 'package:pawlly/models/pet_type_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import '../../../models/base_response_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';

class PetService {
  static Future<PetTypeRes> getPetTypeApi() async {
    return PetTypeRes.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.getPetTypeList,
        method: HttpMethodType.GET)));
  }

  static Future<List<NotePetModel>> getNoteApi({
    int page = 1,
    required int petId,
    int perPage = Constants.perPageItem,
    required List<NotePetModel> notes,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final petNoteRes = PetNoteRes.fromJson(await handleResponse(
          await buildHttpResponse(
              "${APIEndPoints.getNote}?pet_id=$petId&per_page=$perPage&page=$page",
              method: HttpMethodType.GET)));
      if (page == 1) notes.clear();
      notes.addAll(petNoteRes.data);
      lastPageCallBack?.call(petNoteRes.data.length != perPage);
      return notes;
    } else {
      return [];
    }
  }

  static Future<BaseResponseModel> addNoteApi(
      {required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.addNote,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> deleteNote({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.deleteNote}/$id",
            method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> deletePet({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.addPet}/$id",
            method: HttpMethodType.DELETE)));
  }

  static Future<List<PetData>> getPetListApi({
    required List<PetData> pets,
  }) async {
    if (isLoggedIn.value) {
      // Construir la URL completa con el user_id
      final url = Uri.parse(
          '${BASE_URL}${APIEndPoints.getPetList}?user_id=${AuthServiceApis.dataCurrentUser.id}');

      // Realizar la solicitud con el token en los headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
      );

      if (response.statusCode == 200) {
        final res = PetListRes.fromJson(jsonDecode(response.body));
        pets.clear();
        pets.addAll(res.data);
        return res.data;
      } else {
        // Manejo de error
        print('Error en la solicitud: ${response.statusCode}');
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<List<BreedModel>> getBreedsListApi() async {
    // Construir la URL
    final url = Uri.parse('${BASE_URL}${APIEndPoints.getBreedsList}');

    // Realizar la solicitud con el token en los headers (si es necesario)
    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Ajusta según tu autenticación
      },
    );

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      final res = BreedListResponse.fromJson(jsonDecode(response.body));
      return res.data; // Devolver la lista de razas
    } else {
      // Manejo de error
      print('Error en la solicitud: ${response.statusCode}');
      return [];
    }
  }

  static Future<PetData?> postCreatePetApi({
    required Map<String, dynamic> body, // Recibe el body ya validado
  }) async {
    if (isLoggedIn.value) {
      // Construir la URL completa
      final url = Uri.parse('${BASE_URL}${APIEndPoints.getPetList}');

      // Imprimir la URL completa
      print('URL completa: $url');

      // Imprimir el cuerpo de la solicitud
      print('Cuerpo de la solicitud (JSON): ${jsonEncode(body)}');

      // Realizar la solicitud POST con el token en los headers
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body), // Convertir el body a JSON
      );

      print('responseee ${response.statusCode}');
      print('Respuesta completa: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          // Parsear la respuesta JSON
          final responseData = jsonDecode(response.body);
          if (responseData.containsKey('data')) {
            // Asegúrate de que el modelo PetData pueda manejar los datos correctamente
            final petData = PetData.fromJson(responseData['data']);
            return petData;
          } else {
            print('Advertencia: la respuesta no contiene el campo "data".');
            return null;
          }
        } catch (e) {
          print('Error al parsear la respuesta: $e');
          return null;
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return null;
      }
    } else {
      return null;
    }
  }

  static Future deletePetApi({
    required int id, // Recibe el body ya validado
  }) async {
    if (isLoggedIn.value) {
      // Construir la URL completa
      final url = Uri.parse('${BASE_URL}${APIEndPoints.getPetList}/${id}');

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

  static Future<PetData?> postEditPetApi({
    required int petId, // ID de la mascota a editar
    required Map<String, dynamic> body, // Recibe el body ya validado
  }) async {
    if (isLoggedIn.value) {
      // Construir la URL completa para la edición, incluyendo el ID de la mascota
      final url = Uri.parse('${BASE_URL}${APIEndPoints.getPetList}/$petId');

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

  static Future<PetData?> getPetDetailsApi({
    required int petId, // ID de la mascota a recuperar
  }) async {
    if (isLoggedIn.value) {
      // Construir la URL completa con el ID de la mascota
      final url = Uri.parse('${BASE_URL}${APIEndPoints.getPetList}/$petId');

      // Realizar la solicitud GET con el token en los headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
      );

      if (response.statusCode == 200) {
        // Parsear la respuesta JSON y retornar el objeto PetData
        final petData = PetData.fromJson(jsonDecode(response.body)['data']);
        return petData;
      } else if (response.statusCode == 404) {
        // Manejo del caso donde la mascota no es encontrada
        print('Mascota no encontrada.');
        return null;
      } else {
        // Manejo de otros errores
        print('Error en la solicitud: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<void> addPetDetailsApi(
      {int? petId,
      required Map<String, dynamic> request,
      bool isUpdateProfilePic = false,
      List<XFile>? files,
      required VoidCallback onPetAdd,
      required VoidCallback loaderOff}) async {
    log('FILES: $files');
    log('FILES length: ${files.validate().length}');
    String petIdparam = petId != null ? "/$petId" : "";
    var multiPartRequest =
        await getMultiPartRequest(APIEndPoints.addPet + petIdparam);
    if (!isUpdateProfilePic) {
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
    }

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await MultipartFile.fromPath(
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
}
