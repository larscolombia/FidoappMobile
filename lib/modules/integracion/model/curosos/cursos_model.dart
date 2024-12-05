class Video {
  String id;
  String coursePlatformId;
  String url;
  String video;
  String? visualizations;

  DateTime createdAt;
  DateTime updatedAt;

  Video({
    required this.id,
    required this.coursePlatformId,
    required this.url,
    required this.video,
    required this.visualizations,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'].toString(),
      coursePlatformId: json['course_platform_id'].toString(),
      url: json['url'],
      video: json['video'],
      visualizations: json['visualizations'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Course {
  int id;
  String name;
  String description;
  String image;
  String duration;
  String price;
  String difficulty;
  List<Video> videos;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.duration,
    required this.price,
    required this.difficulty,
    required this.videos,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var list = json['videos'] as List;
    List<Video> videosList = list.map((i) => Video.fromJson(i)).toList();

    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      duration: json['duration'],
      price: json['price'],
      difficulty: json['difficulty'],
      videos: videosList,
    );
  }
}
