import 'package:pawlly/modules/auth/model/about_data_model.dart';

class AboutPageResModel {
  bool status;
  List<AboutDataModel> data;
  String message;

  AboutPageResModel({
    this.status = false,
    this.data = const <AboutDataModel>[],
    this.message = "",
  });

  factory AboutPageResModel.fromJson(Map<String, dynamic> json) {
    return AboutPageResModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List
          ? List<AboutDataModel>.from(
              json['data'].map((x) => AboutDataModel.fromJson(x)))
          : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}
