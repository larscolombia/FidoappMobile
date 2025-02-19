class Onerw {
  String? id;
  String? email;

  Onerw({
    this.id,
    this.email,
  });
}

class CalendarModel {
  String? id;
  String name;
  String? description;
  String? startDate;
  String? endDate;
  String date;
  String? eventime;
  String? slug;
  int? userId;
  String? userEmail; // Añadido para el email del usuario
  String? tipo;
  int? status;
  String? location; // Añadido para la ubicación
  int? petId; // Añadido para el id de la mascota
  List<Owner> owners; // Añadido para la lista de dueños
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? eventImage;
  bool? invited; // Nuevo campo

  CalendarModel({
    this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    required this.date,
    this.eventime,
    this.slug,
    this.userId,
    this.userEmail,
    this.tipo,
    this.status,
    this.location,
    this.petId,
    this.owners = const [], // Inicializar la lista de dueños
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.eventImage,
    this.invited, // Nuevo campo
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      id: json['id']?.toString(),
      name: json['name'],
      description: json['description'],
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      date: json['date'].toString(),
      eventime: json['event_time']?.toString(),
      slug: json['slug'],
      userId: json['user_id'],
      userEmail: json['user_email'], // Nuevo campo
      tipo: json['tipo'],
      status: json['status'],
      location: json['location'], // Nuevo campo
      petId: json['pet_id'], // Nuevo campo
      owners: json['owners'] != null
          ? (json['owners'] as List).map((i) => Owner.fromJson(i)).toList()
          : [], // Convertir la lista de dueños
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      eventImage: json['event_image'],
      invited: json['invited'], // Nuevo campo
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "start_date": startDate,
        "end_date": endDate,
        "date": date,
        "event_time": eventime,
        "slug": slug,
        "user_id": userId,
        "user_email": userEmail, // Nuevo campo
        "tipo": tipo,
        "status": status,
        "location": location, // Nuevo campo
        "pet_id": petId, // Nuevo campo
        "owners": owners
            .map((owner) => owner.toJson())
            .toList(), // Convertir la lista de dueños
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "event_image": eventImage,
        "invited": invited, // Nuevo campo
      };
}

class Owner {
  int? id;
  String? email;
  String? avatar;

  Owner({
    this.id,
    this.email,
    this.avatar,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "avatar": avatar,
      };
}
