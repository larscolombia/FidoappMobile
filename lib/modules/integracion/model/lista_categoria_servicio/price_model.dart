class Precio {
  final String? amount;
  final String? tax;
  final String? totalAmount;

  Precio({
    this.amount,
    this.tax,
    this.totalAmount,
  });

  factory Precio.fromJson(Map<String, dynamic> json) {
    return Precio(
      amount: json['amount'].toString(),
      tax: json['tax'].toString(),
      totalAmount: json['total_amount'].toString(),
    );
  }
}
