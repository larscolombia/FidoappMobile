class Pet {
  final String id;
  final String name;
  final String slug;
  final String pettype;
  final String breed;
  final String breedId;
  final String? size;
  final String? petImage;
  final DateTime? dateOfBirth;
  final String age;
  final String gender;
  final double weight;
  final String? weightUnit;
  final String? height;
  final String? heightUnit;
  final String userId;
  final String status;
  final String qrCode;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedBy;

  Pet({
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
    this.weightUnit,
    this.height,
    this.heightUnit,
    required this.userId,
    required this.status,
    required this.qrCode,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'].toString(), // Convertir a String
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      pettype: json['pettype'] ?? '',
      breed: json['breed'] ?? '',
      breedId: json['breed_id'].toString(), // Convertir a String
      size: json['size'],
      petImage: json['pet_image'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
      weight: (json['weight'] != null) ? json['weight'].toDouble() : 0.0,
      weightUnit: json['weight_unit'],
      height: json['height']?.toString(), // Convertir a String si no es nulo
      heightUnit: json['height_unit'],
      userId: json['user_id'].toString(), // Convertir a String
      status: json['status'].toString(), // Convertir a String
      qrCode: json['qr_code'] ?? '',
      createdBy:
          json['created_by']?.toString(), // Convertir a String si no es nulo
      updatedBy:
          json['updated_by']?.toString(), // Convertir a String si no es nulo
      deletedBy:
          json['deleted_by']?.toString(), // Convertir a String si no es nulo
    );
  }
}
