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

List<Student> studentListFromJson(String str) =>
    List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));
String studentListToJson(List<Student> data) =>
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

class Student {
  final String name;
  final int phone;
  final DateTime admissionDate;
  final List<Slots> slots;
  DateTime lastPaymentDate;
  final String id;

  Student({
    required this.name,
    required this.phone,
    required this.admissionDate,
    required this.slots,
    required this.lastPaymentDate,
    required this.id,
  });

  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        name: json["name"],
        phone: json["phone"],
        admissionDate: DateTime.parse(json["admission_date"]),
        slots: List<Slots>.from(json["slots"].map((x) => getSlot(x))),
        lastPaymentDate: DateTime.parse(json["last_payment_date"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "admission_date": admissionDate.toIso8601String(),
        "slots": List<dynamic>.from(slots.map((x) => getSlotString(x))),
        "last_payment_date": lastPaymentDate.toIso8601String(),
        "id": id,
      };
}
