class Herramienta {
  int id;
  String name;
  String description;
  int typeId;
  String image;
  int? progress; // Campo opcional
  String? audio; // Campo opcional
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Herramienta({
    required this.id,
    required this.name,
    required this.description,
    required this.typeId,
    required this.image,
    this.progress, // Opcional
    this.audio, // Opcional
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Herramienta.fromJson(Map<String, dynamic> json) {
    return Herramienta(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      typeId: json['type_id'],
      image: json['image'],
      progress: json['progress'] != null ? json['progress'] as int? : null,
      audio: json['audio'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ToolType {
  final int id;
  final String type;
  final String icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  ToolType({
    required this.id,
    required this.type,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ToolType.fromJson(Map<String, dynamic> json) {
    return ToolType(
      id: json['id'],
      type: json['type'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
