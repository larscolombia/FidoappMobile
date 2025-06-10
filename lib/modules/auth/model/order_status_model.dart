import 'package:pawlly/modules/auth/model/order_status_data_model.dart';

class OrderStatusModel {
  List<OrderStatusDataModel> data;
  String message;
  bool status;

  OrderStatusModel({
    this.status = false,
    this.data = const <OrderStatusDataModel>[],
    this.message = "",
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List
          ? List<OrderStatusDataModel>.from(
              json['data'].map((x) => OrderStatusDataModel.fromJson(x)))
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
