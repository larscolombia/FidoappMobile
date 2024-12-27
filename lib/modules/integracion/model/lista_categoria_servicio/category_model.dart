class Category {
  final int id;
  final String slug;
  final String name;
  final int? parentId;
  final int status;
  final String categoryImage;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Category({
    required this.id,
    required this.slug,
    required this.name,
    this.parentId,
    required this.status,
    required this.categoryImage,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      parentId: json['parent_id'],
      status: json['status'],
      categoryImage: json['category_image'],
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
      'parent_id': parentId,
      'status': status,
      'category_image': categoryImage,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
