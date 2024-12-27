class UserBalance {
  final int id;
  final int userId;
  final String balance;
  final String createdAt;
  final String updatedAt;

  UserBalance({
    required this.id,
    required this.userId,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      id: json['id'],
      userId: json['user_id'],
      balance: json['balance'],
      createdAt: DateTime.parse(json['created_at']).toString(),
      updatedAt: DateTime.parse(json['updated_at']).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
