// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

enum Slots {
  evening,
  morning,
  noon,
  night,
}

List<StudentModel> studentListFromJson(String str) => List<StudentModel>.from(
    json.decode(str).map((x) => StudentModel.fromJson(x)));
String studentListToJson(List<StudentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Slots getSlot(String s) {
  switch (s) {
    case "evening":
      return Slots.evening;
    case "morning":
      return Slots.morning;
    case "noon":
      return Slots.noon;
    case "night":
      return Slots.night;
    default:
      return Slots.evening;
  }
}

String getSlotString(Slots s) {
  switch (s) {
    case Slots.evening:
      return "evening";
    case Slots.morning:
      return "morning";
    case Slots.noon:
      return "noon";
    case Slots.night:
      return "night";
    default:
      return "evening";
  }
}

class StudentModel {
  final String name;
  final int phone;
  final DateTime admissionDate;
  final List<Slots> slots;
  DateTime lastPaymentDate;

  StudentModel({
    required this.name,
    required this.phone,
    required this.admissionDate,
    required this.slots,
    required this.lastPaymentDate,
  });

  factory StudentModel.fromRawJson(String str) =>
      StudentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        name: json["name"],
        phone: json["phone"],
        admissionDate: DateTime.parse(json["admission_date"]),
        slots: List<Slots>.from(json["slots"].map((x) => getSlot(x))),
        lastPaymentDate: DateTime.parse(json["last_payment_date"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "admission_date": admissionDate.toIso8601String(),
        "slots": List<dynamic>.from(slots.map((x) => getSlotString(x))),
        "last_payment_date": lastPaymentDate.toIso8601String(),
      };
}
