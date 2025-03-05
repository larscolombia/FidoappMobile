class UserDetail {
  final int id;
  final String firstName;
  final String lastName;
  final String slug;
  final String email;
  final String mobile;
  final String gender;
  final String? emailVerifiedAt;
  final String userType;
  final String createdAt;
  final String updatedAt;
  final String? aboutSelf;
  final String? expert;
  final String fullName;
  final String profileImage;
  final Profile? profile;
  final List<Media>? media;

  UserDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.slug,
    required this.email,
    required this.mobile,
    required this.gender,
    this.emailVerifiedAt,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    this.aboutSelf,
    this.expert,
    required this.fullName,
    required this.profileImage,
    this.profile,
    this.media,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      slug: json['slug'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      userType: json['user_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      aboutSelf: json['about_self'],
      expert: json['expert'],
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      media: json['media'] != null
          ? List<Media>.from(json['media'].map((x) => Media.fromJson(x)))
          : null,
    );
  }
}

class Profile {
  final int id;
  final String? aboutSelf;
  final String? expert;
  final int userId;
  final String createdAt;
  final String updatedAt;

  Profile({
    required this.id,
    this.aboutSelf,
    this.expert,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      aboutSelf: json['about_self'],
      expert: json['expert'],
      userId: json['user_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class Media {
  final int id;
  final String modelType;
  final int modelId;
  final String uuid;
  final String collectionName;
  final String name;
  final String fileName;
  final String mimeType;
  final String disk;
  final int size;
  final String createdAt;
  final String updatedAt;
  final String originalUrl;
  final String previewUrl;

  Media({
    required this.id,
    required this.modelType,
    required this.modelId,
    required this.uuid,
    required this.collectionName,
    required this.name,
    required this.fileName,
    required this.mimeType,
    required this.disk,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.originalUrl,
    required this.previewUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      modelType: json['model_type'] ?? '',
      modelId: json['model_id'],
      uuid: json['uuid'] ?? '',
      collectionName: json['collection_name'] ?? '',
      name: json['name'] ?? '',
      fileName: json['file_name'] ?? '',
      mimeType: json['mime_type'] ?? '',
      disk: json['disk'] ?? '',
      size: json['size'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      originalUrl: json['original_url'] ?? '',
      previewUrl: json['preview_url'] ?? '',
    );
  }
}
