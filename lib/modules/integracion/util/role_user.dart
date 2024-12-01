import 'package:pawlly/services/auth_service_apis.dart';

String getRoleUser() {
  //TODO: implement getRoleUser
  return AuthServiceApis.dataCurrentUser.userRole[0];
}
