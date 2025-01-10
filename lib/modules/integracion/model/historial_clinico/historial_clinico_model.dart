class HistorialClinico {
  int? id;
  String? reportName;
  String? reportType;
  String? applicationDate;
  String? medicalConditions;
  String? testResults;
  String? vetVisits;
  String? file;
  String? image;
  int? petId;
  String petName;
  int? veterinarianId;
  String? veterinarianName;
  String? categoryName;
  int? detailHistoryId;
  String? detailHistoryName;
  String? fechaAplicacion;
  String? fechaRefuerzo;
  String? weight;
  String? notes;
  String? createdAt;
  String? updatedAt;
  String? category;

  HistorialClinico({
    this.id,
    required this.reportName,
    this.reportType,
    required this.applicationDate,
    this.medicalConditions,
    this.testResults,
    this.vetVisits,
    this.file,
    this.image,
    this.petId,
    required this.petName,
    this.veterinarianId,
    required this.veterinarianName,
    required this.categoryName,
    this.detailHistoryId,
    this.detailHistoryName,
    this.fechaAplicacion,
    this.fechaRefuerzo,
    this.weight,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory HistorialClinico.fromJson(Map<String, dynamic> json) {
    return HistorialClinico(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      reportName: json['report_name'] ?? 'Sin nombre',
      reportType: json['report_type']?.toString(),
      applicationDate: json['application_date'],
      medicalConditions: json['medical_conditions'],
      testResults: json['test_results'],
      vetVisits: json['vet_visits']?.toString(),
      file: json['file'],
      image: json['image'],
      petId: json['pet_id'] != null
          ? int.tryParse(json['pet_id'].toString())
          : null,
      petName: json['pet_name'] ?? 'Sin nombre de mascota',
      veterinarianId: json['veterinarian_id'] != null
          ? int.tryParse(json['veterinarian_id'].toString())
          : null,
      veterinarianName:
          json['veterinarian_name'] ?? 'Sin nombre de veterinario',
      categoryName: json['category_name'] ?? 'Sin categoría',
      detailHistoryId: json['detail_history_id'] != null
          ? int.tryParse(json['detail_history_id'].toString())
          : null,
      detailHistoryName: json['detail_history_name'],
      fechaAplicacion: json['fecha_aplicacion'],
      fechaRefuerzo: json['fecha_refuerzo'],
      weight: json['weight'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: json['category']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_name': reportName,
      'report_type': reportType,
      'application_date': applicationDate,
      'medical_conditions': medicalConditions,
      'test_results': testResults,
      'vet_visits': vetVisits,
      'file': file,
      'image': image,
      'pet_id': petId,
      'pet_name': petName,
      'veterinarian_id': veterinarianId,
      'veterinarian_name': veterinarianName,
      'category_name': categoryName,
      'detail_history_id': detailHistoryId,
      'detail_history_name': detailHistoryName,
      'fecha_aplicacion': fechaAplicacion,
      'fecha_refuerzo': fechaRefuerzo,
      'weight': weight,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category,
    };
  }
}
