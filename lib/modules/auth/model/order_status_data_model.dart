class OrderStatusDataModel {
  int id;
  String name;
  String type;
  String value;
  int sequence;
  String subType;
  int status;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  OrderStatusDataModel({
    this.id = -1,
    this.name = "",
    this.type = "",
    this.value = "",
    this.sequence = -1,
    this.subType = "",
    this.status = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory OrderStatusDataModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusDataModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      value: json['value'] is String ? json['value'] : "",
      sequence: json['sequence'] is int ? json['sequence'] : -1,
      subType: json['sub_type'] is String ? json['sub_type'] : "",
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'value': value,
      'sequence': sequence,
      'sub_type': subType,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
