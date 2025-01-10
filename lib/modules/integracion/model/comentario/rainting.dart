class CommentResponse {
  bool? status;
  List<Comment>? data;

  CommentResponse({this.status, this.data});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Comment>[];
      json['data'].forEach((v) {
        data!.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  int? id;
  String? rating;
  String? reviewMsg;
  int? userId;
  String? userFullName;
  String? userAvatar;

  Comment({
    this.id,
    this.rating,
    this.reviewMsg,
    this.userId,
    this.userFullName,
    this.userAvatar,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'].toString();
    reviewMsg = json['review_msg'];
    userId = json['user_id'];
    userFullName = json['username'];
    userAvatar = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['review_msg'] = reviewMsg;
    data['user_id'] = userId;
    data['user_full_name'] = userFullName;
    data['user_avatar'] = userAvatar;
    return data;
  }
}
