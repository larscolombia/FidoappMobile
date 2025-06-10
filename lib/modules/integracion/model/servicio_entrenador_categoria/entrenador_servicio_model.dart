class Service {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int status;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;

  Service({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      status: json['status'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
    };
  }
}
