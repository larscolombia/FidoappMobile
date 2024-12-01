import 'package:pawlly/services/auth_service_apis.dart';

class Util {
  static Map<String, String> headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': AuthServiceApis.dataCurrentUser.apiToken
    };
  }
}
