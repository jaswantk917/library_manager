import 'dart:convert';

class Attendance {
  final DateTime date;
  final List<StudentList> attendance;

  Attendance({
    required this.date,
    required this.attendance,
  });

  factory Attendance.fromRawJson(String str) =>
      Attendance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        date: DateTime.parse(json["date"]),
        attendance: json["attendance"] == null
            ? []
            : List<StudentList>.from(
                json["attendance"]!.map((x) => StudentList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "attendance": List<dynamic>.from(attendance.map((x) => x.toJson())),
      };
}

class StudentList {
  final String id;
  final DateTime time;

  StudentList({
    required this.id,
    required this.time,
  });

  factory StudentList.fromRawJson(String str) =>
      StudentList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
        id: json["id"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time.toIso8601String(),
      };
}
