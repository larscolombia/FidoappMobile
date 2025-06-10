class User {
  int? id;
  String? firstName;
  String? lastName;
  String? fullName; // Nuevo campo
  String email;
  String? profileImage;
  String? userType;
  String? gender;
  double? rating; // Cambiado de String a double
  String? address;
  Profile? profile; // Nuevo campo para el objeto anidado 'profile'

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    required this.email,
    this.profileImage,
    this.userType,
    this.gender,
    this.rating,
    this.address,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'], // Asignar el nuevo campo
      email: json['email'],
      profileImage: json['profile_image'],
      userType: json['user_type'],
      gender: json['gender']?.toString(),
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      address: json['address']?.toString(),
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }
}

class Profile {
  int? id;
  String? aboutSelf;
  String? expert;
  String? description;
  String? facebookLink;
  String? instagramLink;
  String? twitterLink;
  String? dribbbleLink;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Profile({
    this.id,
    this.aboutSelf,
    this.expert,
    this.description,
    this.facebookLink,
    this.instagramLink,
    this.twitterLink,
    this.dribbbleLink,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      aboutSelf: json['about_self'],
      expert: json['expert'],
      description: json['description'],
      facebookLink: json['facebook_link'],
      instagramLink: json['instagram_link'],
      twitterLink: json['twitter_link'],
      dribbbleLink: json['dribbble_link'],
      userId: json['user_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}
