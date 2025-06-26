// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

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
      data: (json['data'] as List).map((item) => PetData.fromJson(item)).toList(),
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
  String name; //
  String slug;
  String pettype; //
  String breed; //
  int breedId; //
  dynamic size; //
  String? petImage;
  String? dateOfBirth; //
  String age;
  String gender; //
  num weight; //
  String weightUnit; //
  num height; //
  String heightUnit; //
  int userId;
  int status;
  String? qrCode;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;
  String? petFur; //
  String? description;
  String? chip;
  PetData(
      {required this.id,
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
      this.description,
      this.qrCode,
      this.createdBy,
      this.updatedBy,
      this.deletedBy,
      this.petFur,
      this.chip});

  String get birthDateFormatted {
    if (dateOfBirth == null) return "Sin fecha de nacimiento";

    DateFormat inputFormat = DateFormat("dd-MM-yyyy");
    final dateTime = inputFormat.tryParse(dateOfBirth!);
    
    DateFormat outputFormat = DateFormat("d 'de' MMMM 'de' yyyy", 'es_ES');
    return dateTime == null ? '' : outputFormat.format(dateTime);
  }

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      id: int.tryParse(json['id'].toString()) ?? -1,
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      pettype: json['pettype'] ?? "",
      breed: json['breed'] ?? "No se pudo encontrar",
      breedId: json['breed_id'] ?? -1,
      size: json['size'],
      petImage: json['pet_image'],
      dateOfBirth: json['date_of_birth'],
      age: json['age'] ?? "",
      gender: json['gender'] ?? "",
      weight: json['weight'] as num? ?? 0,
      weightUnit: json['weight_unit'] ?? "",
      height: json['height'] as num? ?? 0,
      heightUnit: json['height_unit'] ?? 0,
      userId: json['user_id'] ?? -1,
      status: json['status'] ?? -1,
      qrCode: json['qr_code'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      description: json['description'],
      petFur: json['pet_fur'],
      chip: json['chip']
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
      'description': description,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
    };
  }

  Map<String, dynamic> mapToUpdate() {
    return {
      'name': name,
      'pettype': pettype,
      'breed': breed,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'weight': weight,
      'weight_unit': weightUnit,
      'height': height,
      'height_unit': heightUnit,
      'description': description,
    };
  }

  PetData copyWith({
    String? name,
    String? slug,
    String? pettype,
    String? breed,
    int? breedId,
    dynamic size,
    String? petImage,
    String? dateOfBirth,
    String? age,
    String? gender,
    num? weight,
    String? weightUnit,
    num? height,
    String? heightUnit,
    int? userId,
    int? status,
    String? qrCode,
    int? createdBy,
    int? updatedBy,
    int? deletedBy,
    String? petFur,
    String? description,
    String? chip,
  }) {
    return PetData(
      id: id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      pettype: pettype ?? this.pettype,
      breed: breed ?? this.breed,
      breedId: breedId ?? this.breedId,
      size: size ?? this.size,
      petImage: petImage ?? this.petImage,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      qrCode: qrCode ?? this.qrCode,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedBy: deletedBy ?? this.deletedBy,
      petFur: petFur ?? this.petFur,
      description: description ?? this.description,
      chip: chip ?? this.chip,
    );
  }
}
