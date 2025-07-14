class Vacuna {
  String? vacunaName;
  String? fechaAplicacion;
  String? fechaRefuerzoVacuna;
  String? peso;
  String? notas;

  Vacuna({
    this.vacunaName,
    this.fechaAplicacion,
    this.fechaRefuerzoVacuna,
    this.peso,
    this.notas,
  });

  factory Vacuna.fromJson(Map<String, dynamic> json) {
    return Vacuna(
      vacunaName: json['vacuna_name'] ?? json['vacunaName'],
      fechaAplicacion: json['fecha_aplicacion'] ?? json['fechaAplicacion'],
      fechaRefuerzoVacuna: json['fecha_refuerzo_vacuna'] ?? json['fechaRefuerzoVacuna'],
      peso: json['peso']?.toString(),
      notas: json['notas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vacuna_name': vacunaName,
      'fecha_aplicacion': fechaAplicacion,
      'fecha_refuerzo_vacuna': fechaRefuerzoVacuna,
      'peso': peso,
      'notas': notas,
    };
  }
}
