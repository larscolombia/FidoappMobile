class UserModel {
  bool? success;
  UserData? data;

  UserModel({this.success, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? loginType;
  String? playerId;
  String? webPlayerId;
  String? gender;
  String? dateOfBirth;
  int? isManager;
  int? showInCalender;
  String? emailVerifiedAt;
  String? avatar;
  int? isBanned;
  int? isSubscribe;
  int? status;
  String? lastNotificationSeen;
  String? userSetting;
  String? address;
  String? userType;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? latitude;
  String? longitude;
  String? fullName;
  String? profileImage;
  String? publicProfile; // Nuevo campo agregado
  Profile? profile;
  List<Pets>? pets;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.loginType,
    this.playerId,
    this.webPlayerId,
    this.gender,
    this.dateOfBirth,
    this.isManager,
    this.showInCalender,
    this.emailVerifiedAt,
    this.avatar,
    this.isBanned,
    this.isSubscribe,
    this.status,
    this.lastNotificationSeen,
    this.userSetting,
    this.address,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.latitude,
    this.longitude,
    this.fullName,
    this.profileImage,
    this.publicProfile, // Nuevo campo agregado
    this.profile,
    this.pets,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      mobile: json['mobile'],
      loginType: json['login_type'],
      playerId: json['player_id'],
      webPlayerId: json['web_player_id'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      isManager: json['is_manager'],
      avatar: json['avatar'],
      isBanned: json['is_banned'],
      isSubscribe: json['is_subscribe'],
      status: json['status'],
      lastNotificationSeen: json['last_notification_seen'],
      userSetting: json['user_setting'],
      address: json['address'],
      userType: json['user_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      fullName: json['full_name'],
      profileImage: json['profile_image'],
      publicProfile: json['public_profile'], // Nuevo campo agregado
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      pets: json['pets'] != null
          ? List<Pets>.from(json['pets'].map((x) => Pets.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'login_type': loginType,
      'player_id': playerId,
      'web_player_id': webPlayerId,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'is_manager': isManager,
      'show_in_calender': showInCalender,
      'email_verified_at': emailVerifiedAt,
      'avatar': avatar,
      'is_banned': isBanned,
      'is_subscribe': isSubscribe,
      'status': status,
      'last_notification_seen': lastNotificationSeen,
      'user_setting': userSetting,
      'address': address,
      'user_type': userType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'latitude': latitude,
      'longitude': longitude,
      'full_name': fullName,
      'profile_image': profileImage,
      'public_profile': publicProfile, // Nuevo campo agregado
      'profile': profile?.toJson(),
      'pets': pets != null
          ? List<dynamic>.from(pets!.map((x) => x.toJson()))
          : null,
    };
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
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? validationNumber;
  String? profecionalTitle;
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
    this.validationNumber,
    this.profecionalTitle,
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      validationNumber: json['validation_number'],
      profecionalTitle: json['profecional_title'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about_self': aboutSelf,
      'expert': expert,
      'description': description,
      'facebook_link': facebookLink,
      'instagram_link': instagramLink,
      'twitter_link': twitterLink,
      'dribbble_link': dribbbleLink,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'validation_number': validationNumber,
      'profecional_title': profecionalTitle,
      'tags': tags,
    };
  }
}

class Pets {
  int? id;
  String? name;
  String? slug;
  String? passport;
  int? pettypeId;
  int? breedId;
  String? size;
  String? petFur;
  String? dateOfBirth;
  String? age;
  String? petImage;
  String? gender;
  int? weight;
  int? height;
  String? weightUnit;
  String? heightUnit;
  int? userId;
  String? additionalInfo;
  int? status;
  int? lost;
  String? lostDate;
  String? qrCode;
  String? pet_public_profile;

  Pets({
    this.id,
    this.name,
    this.slug,
    this.passport,
    this.pettypeId,
    this.breedId,
    this.size,
    this.petFur,
    this.dateOfBirth,
    this.age,
    this.petImage,
    this.gender,
    this.weight,
    this.height,
    this.weightUnit,
    this.heightUnit,
    this.userId,
    this.additionalInfo,
    this.status,
    this.lost,
    this.lostDate,
    this.qrCode,
    this.pet_public_profile,
  });

  factory Pets.fromJson(Map<String, dynamic> json) {
    return Pets(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      passport: json['passport'],
      pettypeId: json['pettype_id'],
      breedId: json['breed_id'],
      size: json['size'],
      petFur: json['pet_fur'],
      dateOfBirth: json['date_of_birth'],
      age: json['age'],
      petImage: json['pet_image'],
      gender: json['gender'],
      weight: json['weight'],
      height: json['height'],
      weightUnit: json['weight_unit'],
      heightUnit: json['height_unit'],
      userId: json['user_id'],
      additionalInfo: json['additional_info'],
      status: json['status'],
      lost: json['lost'],
      lostDate: json['lost_date'],
      qrCode: json['qr_code'],
      pet_public_profile: json['pet_public_profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'passport': passport,
      'pettype_id': pettypeId,
      'breed_id': breedId,
      'size': size,
      'pet_fur': petFur,
      'date_of_birth': dateOfBirth,
      'age': age,
      'pet_image': petImage,
      'gender': gender,
      'weight': weight,
      'height': height,
      'weight_unit': weightUnit,
      'height_unit': heightUnit,
      'user_id': userId,
      'additional_info': additionalInfo,
      'status': status,
      'lost': lost,
      'lost_date': lostDate,
      'qr_code': qrCode,
      'pet_public_profile': pet_public_profile,
    };
  }
}
