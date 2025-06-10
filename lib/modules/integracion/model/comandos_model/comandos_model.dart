class Comando {
  int id;
  String name;
  String description;
  String type;
  bool isFavorite;
  int categoryId;
  String vozComando;
  String instructions;
  DateTime createdAt;
  DateTime updatedAt;

  Comando({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.isFavorite,
    required this.categoryId,
    required this.vozComando,
    required this.instructions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comando.fromJson(Map<String, dynamic> json) {
    return Comando(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      isFavorite: json['is_favorite'] == 1,
      categoryId: json['category_id'],
      vozComando: json['voz_comando'],
      instructions: json['instructions'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'is_favorite': isFavorite ? 1 : 0,
      'category_id': categoryId,
      'voz_comando': vozComando,
      'instructions': instructions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
