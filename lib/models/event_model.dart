class EventListRes {
  bool? success;
  String? message;
  List<EventData> data;

  EventListRes({
    this.success,
    this.message,
    required this.data,
  });

  factory EventListRes.fromJson(Map<String, dynamic> json) {
    return EventListRes(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List)
          .map((item) => EventData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EventData {
  int? id;
  String? name;
  DateTime? date;
  DateTime? endDate;
  String? image;
  String? slug;
  int? userId;
  String? description;
  String? location;
  String? tipo;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? eventImage;
  List<EventMedia>? media;

  EventData({
    this.id,
    this.name,
    this.date,
    this.endDate,
    this.image,
    this.slug,
    this.userId,
    this.description,
    this.location,
    this.tipo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.eventImage,
    this.media,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'],
      name: json['name'],
      date: DateTime.tryParse(json['date']),
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      image: json['image'],
      slug: json['slug'],
      userId: json['user_id'],
      description: json['description'],
      location: json['location'],
      tipo: json['tipo'],
      status: json['status'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      eventImage: json['event_image'],
      media: json['media'] != null
          ? (json['media'] as List)
              .map((item) => EventMedia.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'image': image,
      'slug': slug,
      'user_id': userId,
      'description': description,
      'location': location,
      'tipo': tipo,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'event_image': eventImage,
      'media': media?.map((item) => item.toJson()).toList(),
    };
  }
}

class EventMedia {
  int? id;
  String? modelType;
  int? modelId;
  String? uuid;
  String? collectionName;
  String? name;
  String? fileName;
  String? mimeType;
  String? originalUrl;

  EventMedia({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.originalUrl,
  });

  factory EventMedia.fromJson(Map<String, dynamic> json) {
    return EventMedia(
      id: json['id'],
      modelType: json['model_type'],
      modelId: json['model_id'],
      uuid: json['uuid'],
      collectionName: json['collection_name'],
      name: json['name'],
      fileName: json['file_name'],
      mimeType: json['mime_type'],
      originalUrl: json['original_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_type': modelType,
      'model_id': modelId,
      'uuid': uuid,
      'collection_name': collectionName,
      'name': name,
      'file_name': fileName,
      'mime_type': mimeType,
      'original_url': originalUrl,
    };
  }
}
