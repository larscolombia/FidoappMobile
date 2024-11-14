class PetListRes {
  bool status;
  List<PetData> data;
  String message;

  PetListRes({
    required this.status,
    required this.data,
    required this.message,
  });

  factory PetListRes.fromJson(Map<String, dynamic> json) {
    return PetListRes(
      status: json['status'] ?? false,
      data:
          (json['data'] as List).map((item) => PetData.fromJson(item)).toList(),
      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
      'message': message,
    };
  }
}

class PetData {
  int id;
  String name;
  String slug;
  String pettype;
  String breed;
  int breedId;
  dynamic size;
  String? petImage;
  String? dateOfBirth;
  String age;
  String gender;
  num weight;
  String weightUnit;
  num height;
  String heightUnit;
  int userId;
  int status;
  String? qrCode;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;

  PetData({
    required this.id,
    required this.name,
    required this.slug,
    required this.pettype,
    required this.breed,
    required this.breedId,
    this.size,
    this.petImage,
    this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.weight,
    required this.weightUnit,
    required this.height,
    required this.heightUnit,
    required this.userId,
    required this.status,
    this.qrCode,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      pettype: json['pettype'] ?? "",
      breed: json['breed'] ?? "",
      breedId: json['breed_id'] ?? -1,
      size: json['size'],
      petImage: json['pet_image'],
      dateOfBirth: json['date_of_birth'],
      age: json['age'] ?? "",
      gender: json['gender'] ?? "",
      weight: json['weight'] ?? 0,
      weightUnit: json['weight_unit'] ?? "",
      height: json['height'] ?? 0,
      heightUnit: json['height_unit'] ?? "",
      userId: json['user_id'] ?? -1,
      status: json['status'] ?? -1,
      qrCode: json['qr_code'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'pettype': pettype,
      'breed': breed,
      'breed_id': breedId,
      'size': size,
      'pet_image': petImage,
      'date_of_birth': dateOfBirth,
      'age': age,
      'gender': gender,
      'weight': weight,
      'weight_unit': weightUnit,
      'height': height,
      'height_unit': heightUnit,
      'user_id': userId,
      'status': status,
      'qr_code': qrCode,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
    };
  }
}



/*

class PetData {
  final String name;
  final String slug;
  final String userId;
  final int breedId;
  final int petTypeId;
  final int updatedBy;
  final int createdBy;
  final String createdAt;
  final String updatedAt;
  final int id;
  final String petImage;
  final List<dynamic> media;

  PetData({
    required this.name,
    required this.slug,
    required this.userId,
    required this.breedId,
    required this.petTypeId,
    required this.updatedBy,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.petImage,
    required this.media,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      name: json['name'],
      slug: json['slug'],
      userId: json['user_id'],
      breedId: json['breed_id'],
      petTypeId: json['pettype_id'],
      updatedBy: json['updated_by'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      id: json['id'],
      petImage: json['pet_image'],
      media: json['media'] ?? [],
    );
  }
}


*/