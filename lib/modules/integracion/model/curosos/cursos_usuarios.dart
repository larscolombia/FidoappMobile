class CursosUsuarios {
  final int id;
  final int progress;
  final String name;
  final String description;
  final String image;
  final String duration;
  final String price;
  final String difficulty;
  final int userId;
  final String userName;
  final String avatar;

  CursosUsuarios({
    required this.id,
    required this.progress,
    required this.name,
    required this.description,
    required this.image,
    required this.duration,
    required this.price,
    required this.difficulty,
    required this.userId,
    required this.userName,
    required this.avatar,
  });

  factory CursosUsuarios.fromJson(Map<String, dynamic> json) {
    return CursosUsuarios(
      id: json['id'] ?? 0, // Valor predeterminado si es nulo
      progress: json['progress'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] ?? '',
      difficulty: json['difficulty'] ?? '',
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  // Método para convertir un objeto en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'progress': progress,
      'name': name,
      'description': description,
      'image': image,
      'duration': duration,
      'price': price,
      'difficulty': difficulty,
      'user_id': userId,
      'user_name': userName,
      'avatar': avatar,
    };
  }
}
