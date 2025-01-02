class Transaction {
  final String amount;
  final String description;
  final String type;
  final String createdAt;

  Transaction({
    required this.amount,
    required this.description,
    required this.type,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'].toString(),
      description: json['description'],
      type: json['type'],
      createdAt: json['created_at'],
    );
  }
}
