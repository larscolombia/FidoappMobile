class NotificationData {
  int? id;
  int? userId;
  String? type;
  String? description;
  int? isRead;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? status;
  String? eventId;
  NotificationData({
    this.id,
    this.userId,
    this.type,
    this.description,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.status,
    this.eventId,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    description = json['description'];
    isRead = json['is_read'];
    title = json['title'];
    status = json['status'];
    eventId = json['event_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['title'] = title;
    data['description'] = description;
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
