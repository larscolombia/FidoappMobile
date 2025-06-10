class StatusModel {
  String status;
  String title;
  bool isDisabled;

  StatusModel({
    this.status = "",
    this.title = "",
    this.isDisabled = false,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      status: json['status'] is String ? json['status'] : "",
      title: json['title'] is String ? json['title'] : "",
      isDisabled: json['is_disabled'] is bool ? json['is_disabled'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'title': title,
      'is_disabled': isDisabled,
    };
  }
}
