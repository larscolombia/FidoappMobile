import 'package:pawlly/modules/auth/model/status_model.dart';

class StatusListResModel {
  bool status;
  List<StatusModel> data;
  String message;

  StatusListResModel({
    this.status = false,
    this.data = const <StatusModel>[],
    this.message = "",
  });

  factory StatusListResModel.fromJson(Map<String, dynamic> json) {
    return StatusListResModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List
          ? List<StatusModel>.from(
              json['data'].map((x) => StatusModel.fromJson(x)))
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
