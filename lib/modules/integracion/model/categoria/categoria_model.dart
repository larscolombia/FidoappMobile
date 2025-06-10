class Category {
  final int id;
  final String slug;
  final String name;
  final int? parentId;
  final int status;
  final String categoryImage;
  final String? createdAt;
  final String? updatedAt;

  Category({
    required this.id,
    required this.slug,
    required this.name,
    this.parentId,
    required this.status,
    required this.categoryImage,
    this.createdAt,
    this.updatedAt,
  });

  // Factory para mapear los datos de JSON a un objeto de Dart
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      parentId: json['parent_id'],
      status: json['status'],
      categoryImage: json['category_image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ApiResponse {
  final bool status;
  final List<Category> data;
  final String message;

  ApiResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  // Factory para mapear toda la respuesta JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      data: (json['data'] as List).map((e) => Category.fromJson(e)).toList(),
      message: json['message'],
    );
  }
}
