import 'package:pawlly/models/user_data_model.dart';

class LoginResponseModel {
  bool status;
  UserData userData;
  String message;

  LoginResponseModel({
    this.status = false,
    required this.userData,
    this.message = "",
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
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
