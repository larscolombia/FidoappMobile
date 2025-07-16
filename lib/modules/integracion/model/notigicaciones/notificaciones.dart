class NotificationData {
  int? id;
  int? userId;
  String? userFullName;
  String? userAvatar;
  String? type;
  String? typeText;
  String? title;
  String? description;
  int? isRead;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? eventId;

  NotificationData({
    this.id,
    this.userId,
    this.userFullName,
    this.userAvatar,
    this.type,
    this.typeText,
    this.title,
    this.description,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.eventId,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : (json['id'] is String ? int.tryParse(json['id']) : null);
    userId = json['user_id'] is int ? json['user_id'] : (json['user_id'] is String ? int.tryParse(json['user_id']) : null);
    userFullName = json['user_full_name']?.toString();
    userAvatar = json['user_avatar']?.toString();
    type = json['type']?.toString();
    typeText = json['type_text']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    isRead = json['is_read'] is int ? json['is_read'] : (json['is_read'] is String ? int.tryParse(json['is_read']) : null);
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    status = json['status']?.toString();
    eventId = json['event_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_full_name'] = userFullName;
    data['user_avatar'] = userAvatar;
    data['type'] = type;
    data['type_text'] = typeText;
    data['title'] = title;
    data['description'] = description;
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['event_id'] = eventId;
    return data;
  }
}
