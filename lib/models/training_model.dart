class TrainingModel {
  final int id;
  final String name;
  final String? slug; // Opcional
  final String? description; // Opcional
  final int? status; // Opcional
  final String? image; // Opcional
  final double? progress; // Opcional
  final String? level; // Opcional

  TrainingModel({
    required this.id, // Requerido
    required this.name, // Requerido
    this.slug, // Opcionales
    this.description,
    this.status,
    this.image,
    this.progress,
    this.level,
  });

  // Factory constructor para convertir JSON a un objeto de tipo TrainingModel
  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['id'], // Requerido
      name: json['name'], // Requerido
      slug: json['slug'], // Opcional
      description: json['description'], // Opcional
      status: json['status'], // Opcional
      image: json['image'], // Opcional
      progress: (json['progress'] != null)
          ? json['progress'].toDouble()
          : null, // Opcional
      level: json['level'], // Opcional
    );
  }

  // Método para convertir una lista de JSON a una lista de TrainingModel
  static List<TrainingModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TrainingModel.fromJson(json)).toList();
  }
}
