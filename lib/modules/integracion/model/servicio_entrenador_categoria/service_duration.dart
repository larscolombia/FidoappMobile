class ServiceDuration {
  final int? id;
  final String duration;
  final double price;
  final String? type;
  final int status;
  final int? createdBy;
  final int? updatedBy;
  final int? deletedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ServiceDuration({
    this.id,
    required this.duration,
    required this.price,
    this.type,
    required this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ServiceDuration.fromJson(Map<String, dynamic> json) {
    return ServiceDuration(
      id: json['id'],
      duration: json['duration'],
      price: (json['price'] as num).toDouble(),
      type: json['type'],
      status: json['status'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'price': price,
      'type': type,
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
