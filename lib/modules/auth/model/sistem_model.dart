class SystemModel {
  int id;
  String slug;
  String name;
  String description;
  int status;
  String serviceImage;
  num serviceAmount;

  SystemModel({
    this.id = -1,
    this.slug = "",
    this.name = "",
    this.description = "",
    this.status = -1,
    this.serviceImage = "",
    this.serviceAmount = 0,
  });

  factory SystemModel.fromJson(Map<String, dynamic> json) {
    return SystemModel(
      id: json['id'] is int ? json['id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is int ? json['status'] : -1,
      serviceImage:
          json['service_image'] is String ? json['service_image'] : "",
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'description': description,
      'status': status,
      'service_image': serviceImage,
      'service_amount': serviceAmount,
    };
  }
}
