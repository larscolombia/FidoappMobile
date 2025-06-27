// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pawlly/models/pet_data.dart';

class PetListRes {
  bool status;
  List<PetData> data;
  String message;

  PetListRes({
    required this.status,
    required this.data,
    required this.message,
  });

  factory PetListRes.fromJson(Map<String, dynamic> json) {
    return PetListRes(
      status: json['status'] ?? false,
      data: (json['data'] as List).map((item) => PetData.fromJson(item)).toList(),
      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
      'message': message,
    };
  }
}
