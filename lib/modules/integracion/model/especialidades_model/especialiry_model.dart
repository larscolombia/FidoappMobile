class SpecialityModel {
  final int id;
  final String description;
  final String createdAt;
  final String updatedAt;

  SpecialityModel({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SpecialityModel.fromJson(Map<String, dynamic> json) {
    return SpecialityModel(
      id: json['id'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
