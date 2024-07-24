class AboutDataModel {
  int id;
  String slug;
  String name;
  String url;

  AboutDataModel({
    this.id = -1,
    this.slug = "",
    this.name = "",
    this.url = "",
  });

  factory AboutDataModel.fromJson(Map<String, dynamic> json) {
    return AboutDataModel(
      id: json['id'] is int ? json['id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      name: json['name'] is String ? json['name'] : "",
      url: json['url'] is String ? json['url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'url': url,
    };
  }
}
