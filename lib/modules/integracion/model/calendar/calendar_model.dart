import 'package:flutter/material.dart';

class CalendarModel {
  String? id;
  String name;
  String? description;
  String? startDate;
  String? endDate;
  String? date;
  String? eventime;
  String? slug;
  int? userId;
  String? tipo;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? eventImage;

  CalendarModel({
    this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.date,
    this.eventime,
    this.slug,
    this.userId,
    this.tipo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.eventImage,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      startDate: json['start_date'].toString(),
      endDate: json['end_date'].toString(),
      date: json['date'].toString(),
      eventime: json['event_time'].toString(),
      slug: json['slug'],
      userId: json['user_id'],
      tipo: json['tipo'],
      status: json['status'],
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      deletedAt: json['deleted_at'].toString(),
      eventImage: json['event_image'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "start_date": startDate,
        "end_date": endDate,
        "date": date,
        "event_time": eventime,
        "slug": slug,
        "user_id": userId,
        "tipo": tipo,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "event_image": eventImage,
      };
}
