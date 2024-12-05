class NotificationData {
  int? id;
  int? userId;
  String? type;
  String? description;
  int? isRead;
  String? createdAt;
  String? updatedAt;

  NotificationData({
    this.id,
    this.userId,
    this.type,
    this.description,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    description = json['description'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['description'] = this.description;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
