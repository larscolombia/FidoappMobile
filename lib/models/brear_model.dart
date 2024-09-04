class BreedListResponse {
  final bool status;
  final List<BreedModel> data;
  final String message;

  BreedListResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  // Factory constructor para crear una instancia de BreedListResponse desde un JSON
  factory BreedListResponse.fromJson(Map<String, dynamic> json) {
    return BreedListResponse(
      status: json['status'],
      data: BreedModel.fromJsonList(json['data']),
      message: json['message'],
    );
  }
}

class BreedModel {
  final int id;
  final String name;
  final String petType;
  final String description;
  final int status;

  BreedModel({
    required this.id,
    required this.name,
    required this.petType,
    required this.description,
    required this.status,
  });

  // Factory constructor para crear una instancia de BreedModel desde un JSON
  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'],
      name: json['name'],
      petType: json['pettype'],
      description: json['description'] ?? "",
      status: json['status'],
    );
  }

  // Método para convertir una lista de JSON a una lista de BreedModel
  static List<BreedModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BreedModel.fromJson(json)).toList();
  }
}
