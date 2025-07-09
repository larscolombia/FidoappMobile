class AvailabilityResponse {
  final bool success;
  final int employeeId;
  final String date;
  final int serviceDuration;
  final List<OccupiedInterval> occupiedIntervals;
  final String requestedTime;
  final int serviceId;
  final bool isOccupied;

  AvailabilityResponse({
    required this.success,
    required this.employeeId,
    required this.date,
    required this.serviceDuration,
    required this.occupiedIntervals,
    required this.requestedTime,
    required this.serviceId,
    required this.isOccupied,
  });

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      success: json['success'] ?? false,
      employeeId: json['employee_id'] is int 
          ? json['employee_id'] 
          : int.tryParse(json['employee_id']?.toString() ?? '0') ?? 0,
      date: json['date'] ?? '',
      serviceDuration: json['service_duration'] is int 
          ? json['service_duration'] 
          : int.tryParse(json['service_duration']?.toString() ?? '0') ?? 0,
      occupiedIntervals: json['occupied_intervals'] != null
          ? (json['occupied_intervals'] as List)
              .map((interval) => OccupiedInterval.fromJson(interval))
              .toList()
          : [],
      requestedTime: json['requested_time'] ?? '',
      serviceId: json['service_id'] is int 
          ? json['service_id'] 
          : int.tryParse(json['service_id']?.toString() ?? '0') ?? 0,
      isOccupied: json['is_occupied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'employee_id': employeeId,
      'date': date,
      'service_duration': serviceDuration,
      'occupied_intervals': occupiedIntervals.map((interval) => interval.toJson()).toList(),
      'requested_time': requestedTime,
      'service_id': serviceId,
      'is_occupied': isOccupied,
    };
  }
}

class OccupiedInterval {
  final String start;
  final String end;

  OccupiedInterval({
    required this.start,
    required this.end,
  });

  factory OccupiedInterval.fromJson(Map<String, dynamic> json) {
    return OccupiedInterval(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
} 