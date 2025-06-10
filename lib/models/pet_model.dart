class Pet {
  String? name;
  int? breedId;
  String? breedName;
  String? size;
  String? dateOfBirth;
  String? age;
  String? gender;
  double? weight;
  double? height;
  String? weightUnit;
  String? heightUnit;
  int userId;
  String? additionalInfo;
  bool? status;

  Pet({
    required this.name,
    this.breedId,
    this.breedName,
    this.size,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.weight,
    this.height,
    this.weightUnit,
    this.heightUnit,
    required this.userId,
    this.additionalInfo,
    this.status = true, // Por defecto es activo
  });

  // Método para convertir la instancia de Pet a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'breed_id': breedId,
      'breed_name': breedName,
      'size': size,
      'date_of_birth': dateOfBirth,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'weight_unit': weightUnit,
      'height_unit': heightUnit,
      'user_id': userId,
      'additional_info': additionalInfo,
      'status': status == true ? 1 : 0, // Convierte bool a 1 o 0
    };
  }

  // Método para crear una instancia de Pet desde JSON (opcional)
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'],
      breedId: json['breed_id'],
      breedName: json['breed_name'],
      size: json['size'],
      dateOfBirth: json['date_of_birth'],
      age: json['age'],
      gender: json['gender'],
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      weightUnit: json['weight_unit'],
      heightUnit: json['height_unit'],
      userId: json['user_id'],
      additionalInfo: json['additional_info'],
      status: json['status'] == 1,
    );
  }
}
