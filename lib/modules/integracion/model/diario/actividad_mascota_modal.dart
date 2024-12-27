class PetActivity {
  final int id;
  final int categoryId;
  final String categoryName;
  final String date;
  final String actividad;
  final String notas;
  final int petId;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

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
}
