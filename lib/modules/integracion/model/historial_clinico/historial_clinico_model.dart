class HistorialClinico {
  final int? id; // Cambiado a int? porque parece ser un número
  final String reportName;
  final String? reportType;
  final String applicationDate;
  final String? medicalConditions;
  final String? testResults;
  final int vetVisits; // Cambiado a int porque parece ser un número
  final String? file;
  final String? image;
  final int? petId; // Cambiado a int? porque parece ser un número
  final String petName;
  final int? veterinarianId; // Cambiado a int? porque parece ser un número
  final String veterinarianName;
  final String categoryName;
  final int? detailHistoryId; // Cambiado a int?
  final String? detailHistoryName;
  final String? fechaAplicacion;
  final String? fechaRefuerzo;
  final String? weight;
  final String? notes;

  HistorialClinico({
    this.id,
    required this.reportName,
    this.reportType,
    required this.applicationDate,
    this.medicalConditions,
    this.testResults,
    required this.vetVisits,
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
  });

  // Método para mapear desde JSON
  factory HistorialClinico.fromJson(Map<String, dynamic> json) {
    return HistorialClinico(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      reportName: json['report_name'] ?? 'Sin nombre',
      reportType: json['report_type'],
      applicationDate: json['application_date'] ?? 'No disponible',
      medicalConditions: json['medical_conditions'],
      testResults: json['test_results'],
      vetVisits: json['vet_visits'] != null
          ? int.tryParse(json['vet_visits'].toString()) ?? 0
          : 0,
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
    );
  }
}
