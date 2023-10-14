import 'dart:convert';

class Attendance {
  final DateTime date;
  final List<String> ids;

  Attendance({
    required this.date,
    required this.ids,
  });

  factory Attendance.fromRawJson(String str) =>
      Attendance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        date: DateTime.parse(json["date"]),
        ids: json["ids"] == null
            ? <String>[]
            : List<String>.from(json["attendance"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "ids": List<dynamic>.from(ids.map((x) => x)),
      };
}
