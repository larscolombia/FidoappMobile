class EBook {
  String? id;
  String? title;
  String? author;
  String? url;
  String? coverImage;
  String? description;
  String? number_of_pages;
  String? createdAt;
  String? updatedAt;
  String? lenguaje;
  String? price;
  List<BookRating>? bookRatings;

  EBook({
    this.id,
    this.title,
    this.author,
    this.url,
    this.coverImage,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.number_of_pages,
    this.lenguaje,
    this.bookRatings,
    this.price,
  });

  factory EBook.fromJson(Map<String, dynamic> json) {
    var list = json['book_ratings'] as List;
    // Filtrar elementos null antes de procesarlos
    List<dynamic> validData = list.where((item) => item != null).toList();
    List<BookRating> bookRatingsList =
        validData.map((i) => BookRating.fromJson(i)).toList();

    return EBook(
      id: json['id'].toString(),
      title: json['title'],
      author: json['author'],
      url: json['url'],
      coverImage: json['cover_image'],
      description: json['description'],
      lenguaje: json['language'],
      number_of_pages: json['number_of_pages'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      price: json['price'].toString().split('ƒ')[0],
      bookRatings: bookRatingsList,
    );
  }

  // Método para calcular el promedio de las valoraciones (ratings)
  double getAverageRating() {
    if (bookRatings == null || bookRatings!.isEmpty) {
      return 0.0; // Si no hay valoraciones, devolvemos 0.0
    }

    double totalRating = 0.0;

    // Sumar todas las valoraciones
    for (var rating in bookRatings!) {
      totalRating +=
          rating.rating ?? 0.0; // Asegúrate de que rating no sea nulo
    }

    // Calcular el promedio
    return totalRating / bookRatings!.length;
  }
}

class BookRating {
  final int? id;
  final int? eBookId;
  final int? userId;
  final String? reviewMsg;
  final double? rating; // Este tipo está bien como double?
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookRating({
    this.id,
    this.eBookId,
    this.userId,
    this.reviewMsg,
    required this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory BookRating.fromJson(Map<String, dynamic> json) {
    return BookRating(
      id: json['id'] is int ? json['id'] : (json['id'] is String ? int.tryParse(json['id']) : null),
      eBookId: json['e_book_id'] is int ? json['e_book_id'] : (json['e_book_id'] is String ? int.tryParse(json['e_book_id']) : null),
      userId: json['user_id'] is int ? json['user_id'] : (json['user_id'] is String ? int.tryParse(json['user_id']) : null),
      reviewMsg: json['review_msg']?.toString(),
      rating: (json['rating'] is double)
          ? json['rating']
          : (json['rating'] is num)
              ? json['rating'].toDouble()
              : (json['rating'] is String)
                  ? double.tryParse(json['rating'])
                  : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}
