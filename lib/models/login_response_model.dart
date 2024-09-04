import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/modules/auth/model/login_response_model.dart';

class LoginResponse {
  bool status;
  UserData userData;
  String message;

  LoginResponse({
    this.status = false,
    required this.userData,
    this.message = "",
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] is bool ? json['status'] : false,
      userData:
          json['data'] is Map ? UserData.fromJson(json['data']) : UserData(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': userData.toJson(),
      'message': message,
    };
  }
}
