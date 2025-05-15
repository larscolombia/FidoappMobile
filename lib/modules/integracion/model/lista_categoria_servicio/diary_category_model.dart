class DiaryCategory {
  final int id;
  final String slug;
  final String name;
  final int? parentId;
  final String status;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  DiaryCategory({
    required this.id,
    required this.slug,
    required this.name,
    this.parentId,
    required this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory DiaryCategory.fromJson(Map<String, dynamic> json) {
    return DiaryCategory(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      parentId: json['parent_id'],
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
      'slug': slug,
      'name': name,
      'parent_id': parentId,
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
