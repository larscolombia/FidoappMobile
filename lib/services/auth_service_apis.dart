import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pawlly/models/login_response_model.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/auth/model/app_configuration_res.dart';
import 'package:pawlly/modules/auth/model/change_password_res.dart';
import 'package:pawlly/modules/auth/model/employee_model.dart';
import 'package:pawlly/modules/auth/model/login_response_model.dart';
import 'package:pawlly/modules/auth/model/notification_model.dart';

import '../../../models/base_response_model.dart';
import '../../../models/register_user_res_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';

class AuthServiceApis {
  static ValueNotifier<LoginResponse?> currentUser = ValueNotifier(null);
  static UserData dataCurrentUser = UserData();
  RxString deviceToken = 'null'.obs;
  static Future<RegUserResp> createUser({required Map request}) async {
    return RegUserResp.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.register,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiToken', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('apiToken');
  }

  static Future<LoginResponse> loginUser({
    required Map request,
    bool isSocialLogin = false,
  }) async {
    // Realiza la solicitud y captura la respuesta

    var responseJson = await handleResponse(await buildHttpResponse(
      isSocialLogin ? APIEndPoints.socialLogin : APIEndPoints.login,
      request: request,
      method: HttpMethodType.POST,
    ));

    // Asignar la data del usuario al modelo UserData usando fromJson
    dataCurrentUser = UserData.fromJson(responseJson['data']);
    print('DATA:::::::: $dataCurrentUser');

    // Guarda la solicitud y la respuesta en SharedPreferences
    await saveLoginData(request, responseJson);

    // Actualiza el ValueNotifier con el usuario logueado
    currentUser.value = LoginResponse.fromJson(responseJson);

    return currentUser.value!;
  }

  static Future<void> saveLoginData(Map request, Map response) async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar la respuesta completa del login
    await prefs.setString('lastLoginResponse', json.encode(response));

    // Guardar el token
    await prefs.setString('apiToken', response['data']['api_token']);

    // Guardar email y contraseña si existe
    if (request.containsKey('email')) {
      await prefs.setString(SharedPreferenceConst.USER_EMAIL, request['email']);
    }

    if (request.containsKey('password')) {
      await prefs.setString(
          SharedPreferenceConst.USER_PASSWORD, request['password']);
    }

    // Marcar como logged in
    await prefs.setBool(SharedPreferenceConst.IS_LOGGED_IN, true);
    isLoggedIn(true);
  }

  static Future<bool> loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastLoginResponse = prefs.getString('lastLoginResponse');
    String? apiToken = prefs.getString('apiToken');
    bool? isLogged = prefs.getBool(SharedPreferenceConst.IS_LOGGED_IN);

    // Verificación más estricta del estado de la sesión
    if (lastLoginResponse == null || apiToken == null || !isLogged!) {
      await clearData(); // Limpiar datos si algo falta
      return false;
    }

    try {
      Map<String, dynamic> responseMap = jsonDecode(lastLoginResponse);
      currentUser.value = LoginResponse.fromJson(responseMap);
      dataCurrentUser = UserData.fromJson(responseMap['data']);
      isLoggedIn(true);
      return true;
    } catch (e) {
      print("Error al cargar los datos de sesión: $e");
      await clearData();
      return false;
    }
  }

  static Future<ChangePassRes> changePasswordAPI({required Map request}) async {
    return ChangePassRes.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.changePassword,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> forgotPasswordAPI(
      {required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.forgotPassword,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<List<NotificationData>> getNotificationDetail({
    int page = 1,
    int perPage = 10,
    required List<NotificationData> notifications,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final notificationRes = NotificationRes.fromJson(await handleResponse(
          await buildHttpResponse(
              "${APIEndPoints.getNotification}?per_page=$perPage&page=$page",
              method: HttpMethodType.GET)));
      if (page == 1) notifications.clear();
      notifications.addAll(notificationRes.notificationData);
      lastPageCallBack
          ?.call(notificationRes.notificationData.length != perPage);
      return notifications;
    } else {
      return [];
    }
  }

  static Future<NotificationData> clearAllNotification() async {
    return NotificationData.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.clearAllNotification,
            method: HttpMethodType.GET)));
  }

  static Future<NotificationData> removeNotification(
      {required String notificationId}) async {
    return NotificationData.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.removeNotification}?id=$notificationId',
            method: HttpMethodType.GET)));
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();

    // Mantener email y contraseña si isRememberMe es true
    final isRememberMe =
        prefs.getBool(SharedPreferenceConst.IS_REMEMBER_ME) ?? false;
    final savedEmail = prefs.getString(SharedPreferenceConst.USER_EMAIL);
    final savedPassword = prefs.getString(SharedPreferenceConst.USER_PASSWORD);

    // Limpiar TODOS los datos de sesión primero
    await prefs.clear();

    // Si remember me está activo, restaurar SOLO las credenciales
    if (isRememberMe) {
      await prefs.setString(SharedPreferenceConst.USER_EMAIL, savedEmail ?? '');
      await prefs.setString(
          SharedPreferenceConst.USER_PASSWORD, savedPassword ?? '');
      await prefs.setBool(SharedPreferenceConst.IS_REMEMBER_ME, true);
    }

    // Asegurarnos de que los datos de sesión estén limpios
    await prefs.remove('lastLoginResponse');
    await prefs.remove('apiToken');
    await prefs.remove(SharedPreferenceConst.IS_LOGGED_IN);

    // Limpiar datos en memoria
    currentUser.value = null;
    dataCurrentUser = UserData();
    isLoggedIn(false);
  }

  static Future<BaseResponseModel> logoutApi() async {
    try {
      // Obtener el token antes de limpiarlo
      final token = await getToken();
      if (token == null || token.isEmpty) {
        throw 'Token no encontrado';
      }

      // Realizar la llamada al API con el token
      final response = await handleResponse(
        await buildHttpResponse(
          APIEndPoints.logout,
          method: HttpMethodType.GET,
          extraKeys: {'authorization': 'Bearer $token'},
        ),
        avoidTokenError: true,
      );

      // Limpiar datos después de un logout exitoso
      await clearData();
      return BaseResponseModel.fromJson(response);
    } catch (e) {
      print('Error en logoutApi: $e');
      // Limpiar datos locales aunque falle el servidor
      await clearData();
      return BaseResponseModel(
        message: 'Logged out successfully',
        status: true,
      );
    }
  }

  static Future<BaseResponseModel> deleteAccountCompletely() async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.deleteUserAccount,
            request: {}, method: HttpMethodType.POST)));
  }

  static Future<ConfigurationResponse> getAppConfigurations() async {
    return ConfigurationResponse.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.appConfiguration}?is_authenticated=${(getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true).getIntBool()}',
            request: {},
            method: HttpMethodType.GET)));
  }

  static Future<GetUserProfileResponse> viewProfile({int? id}) async {
    var res = GetUserProfileResponse.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.userDetail}?id=${id ?? loginUserData.value.id}',
            method: HttpMethodType.GET)));
    return res;
  }

  static Future<dynamic> updateProfile({
    File? imageFile,
    String firstName = '',
    String lastName = '',
    String mobile = '',
    String address = '',
    String playerId = '',
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest =
          await getMultiPartRequest(APIEndPoints.updateProfile);
      if (firstName.isNotEmpty) {
        multiPartRequest.fields[UserKeys.firstName] = firstName;
      }
      if (lastName.isNotEmpty) {
        multiPartRequest.fields[UserKeys.lastName] = lastName;
      }
      if (mobile.isNotEmpty) multiPartRequest.fields[UserKeys.mobile] = mobile;
      if (address.isNotEmpty) {
        multiPartRequest.fields[UserKeys.address] = address;
      }
      if (playerId.isNotEmpty) {
        multiPartRequest.fields[UserKeys.playerId] = playerId;
      }

      if (imageFile != null) {
        multiPartRequest.files.add(await MultipartFile.fromPath(
            UserKeys.profileImage, imageFile.path));
      }

      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }
}
