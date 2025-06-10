class PetActivity {
  int id;
  int categoryId;
  String categoryName;
  String date;
  String actividad;
  String notas;
  int petId;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;

  PetActivity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.date,
    required this.actividad,
    required this.notas,
    required this.petId,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para crear una instancia de PetActivity desde un JSON
  factory PetActivity.fromJson(Map<String, dynamic> json) {
    return PetActivity(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      date: json['date'],
      actividad: json['actividad'],
      notas: json['notas'],
      petId: json['pet_id'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Método para convertir una instancia de PetActivity a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'category_name': categoryName,
      'date': date,
      'actividad': actividad,
      'notas': notas,
      'pet_id': petId,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
