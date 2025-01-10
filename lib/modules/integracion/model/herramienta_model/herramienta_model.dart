class Herramienta {
  int id;
  String name;
  String description;
  int typeId;
  String image;
  int progress;
  String audio;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  ToolType type;

  Herramienta({
    required this.id,
    required this.name,
    required this.description,
    required this.typeId,
    required this.image,
    required this.progress,
    required this.audio,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

  factory Herramienta.fromJson(Map<String, dynamic> json) {
    return Herramienta(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      typeId: json['type_id'],
      image: json['image'],
      progress: json['progress'],
      audio: json['audio'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      type: ToolType.fromJson(json['type']),
    );
  }
}

class ToolType {
  int id;
  String type;
  String icon;
  DateTime createdAt;
  DateTime updatedAt;

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
