class Service {
  final int? id;
  final String slug;
  final String name;
  final String? description;
  final double durationMin;
  final double defaultPrice;
  final String? type;
  final int status;
  final int? categoryId;
  final int? subCategoryId;
  final int? createdBy;
  final int? updatedBy;
  final int? deletedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Service({
    this.id,
    required this.slug,
    required this.name,
    this.description,
    required this.durationMin,
    required this.defaultPrice,
    this.type,
    required this.status,
    this.categoryId,
    this.subCategoryId,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      durationMin: (json['duration_min'] as num).toDouble(),
      defaultPrice: (json['default_price'] as num).toDouble(),
      type: json['type'],
      status: json['status'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
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
      'slug': slug,
      'name': name,
      'description': description,
      'duration_min': durationMin,
      'default_price': defaultPrice,
      'type': type,
      'status': status,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
