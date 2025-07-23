import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/utils/api_end_points.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/common_base.dart';
import 'package:pawlly/utils/constants.dart';
import 'package:pawlly/utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pawlly/models/login_response_model.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/auth/model/app_configuration_res.dart';
import 'package:pawlly/modules/auth/model/change_password_res.dart';
import 'package:pawlly/modules/auth/model/employee_model.dart';
import 'package:pawlly/modules/auth/model/notification_model.dart';

import '../../../models/base_response_model.dart';
import '../../../models/register_user_res_model.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';

class AuthServiceApis extends GetxController {
  static const String KEY_API_TOKEN = 'apiToken';
  static const String KEY_USER_DATA = 'lastLoginResponse';
  
  static Rx<DateTime> profileChange = DateTime.now().obs;

  static ValueNotifier<LoginResponse?> currentUser = ValueNotifier(null);
  static UserData dataCurrentUser = UserData();
  
  RxString deviceToken = 'null'.obs;

  static Future<RegUserResp> createUser({required Map request}) async {
    return RegUserResp.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.register, request: request, method: HttpMethodType.POST)));
  }

  static Future<RegUserResp> createUserWithFiles({
    required Map<String, dynamic> request,
    required String certificationPath,
    required String cvPath,
  }) async {
    MultipartRequest multiPartRequest =
        await getMultiPartRequest(APIEndPoints.register);

    multiPartRequest.fields.addAll(await getMultipartFields(val: request));
    multiPartRequest.files
        .add(await MultipartFile.fromPath('certification', certificationPath));
    multiPartRequest.files
        .add(await MultipartFile.fromPath('curriculum_vitae', cvPath));

    multiPartRequest.headers
        .addAll(buildHeaderTokens(endPoint: APIEndPoints.register));

    RegUserResp response = RegUserResp(userData: UserData());
    await sendMultiPartRequest(multiPartRequest, onSuccess: (data) async {
      response = RegUserResp.fromJson(jsonDecode(data));
    }, onError: (error) {
      throw error;
    });

    return response;
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
    try {
      final prefs = await SharedPreferences.getInstance();

      // Guardar los datos completos del usuario
      await prefs.setString(KEY_USER_DATA, json.encode(response));
      await prefs.setString(KEY_API_TOKEN, response['data']['api_token']);

      // Actualizar el estado en memoria
      currentUser.value = LoginResponse.fromJson(Map<String, dynamic>.from(response));
      dataCurrentUser = UserData.fromJson(response['data']);
      
      print('=== DEBUG SAVE LOGIN DATA ===');
      print('DataCurrentUser payment account: "${dataCurrentUser.paymentAccount}"');
      print('CurrentUser payment account: "${currentUser.value?.userData.paymentAccount}"');

      // Marcar como logged in
      await prefs.setBool(SharedPreferenceConst.IS_LOGGED_IN, true);
      isLoggedIn(true);

      // Guardar credenciales si existe remember me
      if (prefs.getBool(SharedPreferenceConst.IS_REMEMBER_ME) == true) {
        if (request.containsKey('email')) {
          await prefs.setString(SharedPreferenceConst.USER_EMAIL, request['email']);
        }
        if (request.containsKey('password')) {
          await prefs.setString(SharedPreferenceConst.USER_PASSWORD, request['password']);
        }
      }
    } catch (e) {
      debugPrint('Error saving login data: $e');
    }
  }

  static Future<void> saveUpdateProfileData(Map response) async {
    try {
      print('=== DEBUG SAVE UPDATE PROFILE DATA ===');
      print('Response received: $response');
      print('Payment account in response: "${response['data']['payment_account']}"');
      print('Profile in response: ${response['data']['profile']}');
      
      final prefs = await SharedPreferences.getInstance();
      response['data']['api_token'] = AuthServiceApis.dataCurrentUser.apiToken;

      // Guardar los datos completos del usuario
      await prefs.setString(KEY_USER_DATA, json.encode(response));
      await prefs.setString(KEY_API_TOKEN, response['data']['api_token']);

      // Actualizar el estado en memoria
      currentUser.value = LoginResponse.fromJson(Map<String, dynamic>.from(response));

      dataCurrentUser = UserData.fromJson(response['data']);
      
      print('=== DEBUG SAVE UPDATE PROFILE DATA - AFTER PARSING ===');
      print('DataCurrentUser payment account: "${dataCurrentUser.paymentAccount}"');
      print('CurrentUser payment account: "${currentUser.value?.userData.paymentAccount}"');
      
      print('=== AFTER SAVE ===');
      print('DataCurrentUser payment account: "${dataCurrentUser.paymentAccount}"');
      print('CurrentUser payment account: "${currentUser.value?.userData.paymentAccount}"');

      profileChange.value = DateTime.now();

      // Marcar como logged in
      await prefs.setBool(SharedPreferenceConst.IS_LOGGED_IN, true);
      isLoggedIn(true);
      
      print('=== SAVE COMPLETED ===');
    } catch (e) {
      debugPrint('Error saving login data: $e');
    }
  }

  static Future<bool> loadLoginData() async {
    try {
      print('=== DEBUG LOAD LOGIN DATA ===');
      final prefs = await SharedPreferences.getInstance();
      final userDataStr = prefs.getString(KEY_USER_DATA);
      final apiToken = prefs.getString(KEY_API_TOKEN);
      final isLogged = prefs.getBool(SharedPreferenceConst.IS_LOGGED_IN) ?? false;

      print('User data string exists: ${userDataStr != null}');
      print('API token exists: ${apiToken != null}');
      print('Is logged in: $isLogged');

      if (userDataStr != null && apiToken != null && isLogged) {
        final userDataMap = json.decode(userDataStr);
        print('User data map: $userDataMap');
        print('Payment account in stored data: "${userDataMap['data']['payment_account']}"');
        print('Profile in stored data: ${userDataMap['data']['profile']}');
        
        currentUser.value = LoginResponse.fromJson(userDataMap);
        dataCurrentUser = UserData.fromJson(userDataMap['data']);
        isLoggedIn(true);

        print('=== AFTER LOAD ===');
        print('DataCurrentUser payment account: "${dataCurrentUser.paymentAccount}"');
        print('CurrentUser payment account: "${currentUser.value?.userData.paymentAccount}"');

        // Verificar y actualizar el token en los headers
        await saveToken(apiToken);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error loading login data: $e');
      await clearData(); // Limpiar datos corruptos
      return false;
    }
  }

  static bool hasValidUserData() {
    return currentUser.value != null &&
           dataCurrentUser.id > 0 &&
           dataCurrentUser.apiToken.isNotEmpty &&
           dataCurrentUser.email.isNotEmpty;
  }

  static Future<void> clearAllDataOnUninstall() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Limpiar TODOS los datos sin preservar nada
      await prefs.clear();

      // Limpiar GetStorage completamente
      try {
        await localStorage.erase();
      } catch (e) {
        debugPrint('Error clearing GetStorage: $e');
      }

      // Limpiar datos en memoria
      currentUser.value = null;
      dataCurrentUser = UserData();
      isLoggedIn(false);
      
      debugPrint('All data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }

  static Future<void> clearData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Preservar remember me y credenciales si está activo
      final isRememberMe = prefs.getBool(SharedPreferenceConst.IS_REMEMBER_ME) ?? false;
      final savedEmail = isRememberMe ? prefs.getString(SharedPreferenceConst.USER_EMAIL) : null;
      final savedPassword = isRememberMe ? prefs.getString(SharedPreferenceConst.USER_PASSWORD) : null;

      // Limpiar todos los datos de SharedPreferences
      await prefs.clear();

      // Limpiar GetStorage también
      try {
        await localStorage.erase();
      } catch (e) {
        debugPrint('Error clearing GetStorage: $e');
      }

      // Restaurar remember me y credenciales si necesario
      if (isRememberMe) {
        await prefs.setBool(SharedPreferenceConst.IS_REMEMBER_ME, true);
        if (savedEmail != null) {
          await prefs.setString(SharedPreferenceConst.USER_EMAIL, savedEmail);
        }
        if (savedPassword != null) {
          await prefs.setString(SharedPreferenceConst.USER_PASSWORD, savedPassword);
        }
      }

      // Limpiar datos específicos de sesión
      await prefs.remove(KEY_USER_DATA);
      await prefs.remove(KEY_API_TOKEN);
      await prefs.remove(SharedPreferenceConst.IS_LOGGED_IN);

      // Limpiar datos en memoria
      currentUser.value = null;
      dataCurrentUser = UserData();
      isLoggedIn(false);
      
      // Limpiar datos de nb_utils también
      try {
        // Limpiar datos específicos de nb_utils
        await prefs.remove('IS_LOGGED_IN');
        await prefs.remove('USER_LOGIN_DATA');
        await prefs.remove('USER_EMAIL');
        await prefs.remove('USER_PASSWORD');
        await prefs.remove('FIRST_TIME');
        await prefs.remove('IS_REMEMBER_ME');
        await prefs.remove('USER_NAME');
        await prefs.remove('AUTO_SLIDER_STATUS');
      } catch (e) {
        debugPrint('Error clearing nb_utils data: $e');
      }
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }

  static Future<ChangePassRes> changePasswordAPI({required Map request}) async {
    return ChangePassRes.fromJson(
        await handleResponse(await buildHttpResponse(APIEndPoints.changePassword, request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> forgotPasswordAPI({required Map request}) async {
    return BaseResponseModel.fromJson(
        await handleResponse(await buildHttpResponse(APIEndPoints.forgotPassword, request: request, method: HttpMethodType.POST)));
  }

  static Future<List<NotificationData>> getNotificationDetail({
    int page = 1,
    int perPage = 10,
    required List<NotificationData> notifications,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final notificationRes = NotificationRes.fromJson(
          await handleResponse(await buildHttpResponse("${APIEndPoints.getNotification}?per_page=$perPage&page=$page", method: HttpMethodType.GET)));
      if (page == 1) notifications.clear();
      notifications.addAll(notificationRes.notificationData);
      lastPageCallBack?.call(notificationRes.notificationData.length != perPage);
      return notifications;
    } else {
      return [];
    }
  }

  static Future<NotificationData> clearAllNotification() async {
    return NotificationData.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.clearAllNotification, method: HttpMethodType.GET)));
  }

  static Future<NotificationData> removeNotification({required String notificationId}) async {
    return NotificationData.fromJson(
        await handleResponse(await buildHttpResponse('${APIEndPoints.removeNotification}?id=$notificationId', method: HttpMethodType.GET)));
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
    return BaseResponseModel.fromJson(
        await handleResponse(await buildHttpResponse(APIEndPoints.deleteUserAccount, request: {}, method: HttpMethodType.POST)));
  }

  static Future<ConfigurationResponse> getAppConfigurations() async {
    return ConfigurationResponse.fromJson(await handleResponse(await buildHttpResponse(
        '${APIEndPoints.appConfiguration}?is_authenticated=${(getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true).getIntBool()}',
        request: {},
        method: HttpMethodType.GET)));
  }

  static Future<GetUserProfileResponse> viewProfile({int? id}) async {
    var res = GetUserProfileResponse.fromJson(
        await handleResponse(await buildHttpResponse('${APIEndPoints.userDetail}?id=${id ?? loginUserData.value.id}', method: HttpMethodType.GET)));
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
      MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.updateProfile);
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
        multiPartRequest.files.add(await MultipartFile.fromPath(UserKeys.profileImage, imageFile.path));
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
