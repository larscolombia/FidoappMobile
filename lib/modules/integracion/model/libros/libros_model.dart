class EBook {
  final int? id;
  final String? title;
  final String? author;
  final String? url;
  final String? coverImage;
  final String? description;
  final String? number_of_pages;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? lenguaje;
  final List<BookRating>? bookRatings;

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
  });

  factory EBook.fromJson(Map<String, dynamic> json) {
    var list = json['book_ratings'] as List;
    List<BookRating> bookRatingsList =
        list.map((i) => BookRating.fromJson(i)).toList();

    return EBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      url: json['url'],
      coverImage: json['cover_image'],
      description: json['description'],
      lenguaje: json['lenguaje'],
      number_of_pages: json['number_of_pages'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      bookRatings: bookRatingsList,
    );
  }

  double get averageRating {
    if (bookRatings == null || bookRatings!.isEmpty) {
      return 0.0;
    }
    var totalRating = bookRatings!.fold(0, (sum, item) => sum + item.rating);
    return totalRating / bookRatings!.length;
  }
}

class BookRating {
  final int? id;
  final int? eBookId;
  final int? userId;
  final String? reviewMsg;
  final int rating;
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
      id: json['id'],
      eBookId: json['e_book_id'],
      userId: json['user_id'],
      reviewMsg: json['review_msg'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
