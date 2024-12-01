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
      id: json['id'],
      progress: json['progress'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      duration: json['duration'],
      price: json['price'],
      difficulty: json['difficulty'],
      userId: json['user_id'],
      userName: json['user_name'],
      avatar: json['avatar'],
    );
  }
}
