class NotificationModel {
  final String title;
  final String type;
  final DateTime date;
  final String imageUrl;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.type,
    required this.date,
    required this.imageUrl,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? title,
    String? type,
    DateTime? date,
    String? imageUrl,
    bool? isRead,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
    );
  }
}
