class Vacuna {
  final int id;
  final int petId;
  final String vacunaName;
  final String fechaAplicacion;
  final String fechaRefuerzoVacuna;
  final String? weight;
  final String? notes;

  Vacuna({
    required this.id,
    required this.petId,
    required this.vacunaName,
    required this.fechaAplicacion,
    required this.fechaRefuerzoVacuna,
    this.weight,
    this.notes,
  });

  factory Vacuna.fromJson(Map<String, dynamic> json) {
    return Vacuna(
      id: json['id'] as int,
      petId: json['pet_id'] as int,
      vacunaName: json['vacuna_name'] ?? json['name'] ?? '',
      fechaAplicacion: json['fecha_aplicacion'] ?? '',
      fechaRefuerzoVacuna: json['fecha_refuerzo_vacuna'] ?? json['fecha_refuerzo'] ?? '',
      weight: json['weight']?.toString(),
      notes: json['notes'],
    );
  }
}
