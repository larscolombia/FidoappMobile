class Pet {
  final int id;
  final String name;
  final String slug;
  final int petTypeId;
  final int breedId;
  final String? size;
  final String? dateOfBirth;
  final String age;
  final String gender;
  final double weight;
  final double height;
  final String weightUnit;
  final String heightUnit;
  final int userId;
  final String? additionalInfo;
  final int status;
  final String qrCode;
  final String petImage;
  final List<Booking> bookings;
  final List<Media> media;

  Pet({
    required this.id,
    required this.name,
    required this.slug,
    required this.petTypeId,
    required this.breedId,
    this.size,
    this.dateOfBirth,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.weightUnit,
    required this.heightUnit,
    required this.userId,
    this.additionalInfo,
    required this.status,
    required this.qrCode,
    required this.petImage,
    required this.bookings,
    required this.media,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      petTypeId: json['pettype_id'],
      breedId: json['breed_id'],
      size: json['size'],
      dateOfBirth: json['date_of_birth'],
      age: json['age'],
      gender: json['gender'],
      weight: (json['weight'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      weightUnit: json['weight_unit'],
      heightUnit: json['height_unit'],
      userId: json['user_id'],
      additionalInfo: json['additional_info'],
      status: json['status'],
      qrCode: json['qr_code'],
      petImage: json['pet_image'],
      bookings: (json['bookings'] as List)
          .map((booking) => Booking.fromJson(booking))
          .toList(),
      media: (json['media'] as List)
          .map((media) => Media.fromJson(media))
          .toList(),
    );
  }
}

class Booking {
  final int id;
  final String? note;
  final String status;
  final String startDateTime;
  final int userId;
  final int branchId;
  final int employeeId;
  final int systemServiceId;
  final int petId;
  final String bookingType;
  final double totalAmount;
  final double serviceAmount;

  Booking({
    required this.id,
    this.note,
    required this.status,
    required this.startDateTime,
    required this.userId,
    required this.branchId,
    required this.employeeId,
    required this.systemServiceId,
    required this.petId,
    required this.bookingType,
    required this.totalAmount,
    required this.serviceAmount,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      note: json['note'],
      status: json['status'],
      startDateTime: json['start_date_time'],
      userId: json['user_id'],
      branchId: json['branch_id'],
      employeeId: json['employee_id'],
      systemServiceId: json['system_service_id'],
      petId: json['pet_id'],
      bookingType: json['booking_type'],
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      serviceAmount: (json['service_amount'] ?? 0).toDouble(),
    );
  }
}

class Media {
  final int id;
  final String originalUrl;

  Media({required this.id, required this.originalUrl});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      originalUrl: json['original_url'],
    );
  }
}
