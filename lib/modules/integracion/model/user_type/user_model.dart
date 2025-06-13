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
  List<int>? pets; // IDs de mascotas vinculadas al usuario autenticado

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
    this.pets,
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
      pets: json['pets'] != null
          ? List<int>.from(json['pets'].map((x) => int.tryParse('$x') ?? 0))
          : null,
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
  String? paymentAccount;
  int? specialityId;
  List<String>? tags;

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
    this.paymentAccount,
    this.specialityId,
    this.tags,
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
      paymentAccount: json['payment_account'],
      specialityId: json['speciality_id'],
      tags: json['tags'] != null
          ? json['tags'].toString().split(',').map((e) => e.trim()).toList()
          : null,
    );
  }
}
