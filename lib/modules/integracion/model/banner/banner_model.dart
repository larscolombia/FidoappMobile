class BannerModel {
  final int? id;
  final String? title;
  final String? subtitle;
  final String? textButton;
  final String? actionButton;
  final String? image;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    this.id,
    this.title,
    this.subtitle,
    this.textButton,
    this.actionButton,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      textButton: json['text_button'],
      actionButton: json['action_button'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'text_button': textButton,
      'action_button': actionButton,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class BannerResponse {
  final bool success;
  final BannerModel? data;

  BannerResponse({
    required this.success,
    this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? BannerModel.fromJson(json['data']) : null,
    );
  }
} 