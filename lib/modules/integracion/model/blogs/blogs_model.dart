class BlogPost {
  final int id;
  final String description;
  final String name;
  final String? tags;
  final int status;
  final String blogImage;
  final int createdBy;
  final int updatedBy;
  final int? deletedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  BlogPost({
    required this.id,
    required this.description,
    required this.name,
    this.tags,
    required this.status,
    required this.blogImage,
    required this.createdBy,
    required this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  // Método para crear una instancia de BlogPost desde un JSON
  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] ?? 0, // Asegurar que no sea nulo
      description: json['description'] ?? '',
      name: json['name'] ?? '',
      tags: json['tags'],
      status: json['status'] ?? 0, // Asegurar que no sea nulo
      blogImage: json['blog_image'] ?? '',
      createdBy: json['created_by'] ?? 0, // Asegurar que no sea nulo
      updatedBy: json['updated_by'] ?? 0, // Asegurar que no sea nulo
      deletedBy: json['deleted_by'], // Asegurar que permita nulos
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null, // Permitir nulos
    );
  }
}
