// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  String name;
  String phone;
  DateTime admissionDate;
  bool is24Hr;
  bool morning;
  bool noon;
  bool evening;
  bool night;
  Student({
    required this.name,
    required this.phone,
    required this.admissionDate,
    required this.is24Hr,
    required this.morning,
    required this.noon,
    required this.evening,
    required this.night,
  });

  Student copyWith({
    String? name,
    String? phone,
    DateTime? admissionDate,
    bool? is24Hr,
    bool? morning,
    bool? noon,
    bool? evening,
    bool? night,
  }) {
    return Student(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      admissionDate: admissionDate ?? this.admissionDate,
      is24Hr: is24Hr ?? this.is24Hr,
      morning: morning ?? this.morning,
      noon: noon ?? this.noon,
      evening: evening ?? this.evening,
      night: night ?? this.night,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'admissionDate': admissionDate.millisecondsSinceEpoch,
      'is24Hr': is24Hr,
      'morning': morning,
      'noon': noon,
      'evening': evening,
      'night': night,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'] as String,
      phone: map['phone'] as String,
      admissionDate:
          DateTime.fromMillisecondsSinceEpoch(map['admissionDate'] as int),
      is24Hr: map['is24Hr'] as bool,
      morning: map['morning'] as bool,
      noon: map['noon'] as bool,
      evening: map['evening'] as bool,
      night: map['night'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Student(name: $name, phone: $phone, admissionDate: $admissionDate, is24Hr: $is24Hr, morning: $morning, noon: $noon, evening: $evening, night: $night)';
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.phone == phone &&
        other.admissionDate == admissionDate &&
        other.is24Hr == is24Hr &&
        other.morning == morning &&
        other.noon == noon &&
        other.evening == evening &&
        other.night == night;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        phone.hashCode ^
        admissionDate.hashCode ^
        is24Hr.hashCode ^
        morning.hashCode ^
        noon.hashCode ^
        evening.hashCode ^
        night.hashCode;
  }
}

//

String encode(List<Student> students) => json.encode(
      students.map<Map<String, dynamic>>((student) => student.toMap()).toList(),
    );

List<Student> decode(String students) =>
    (json.decode(students) as List<dynamic>)
        .map<Student>((item) => Student.fromMap(item))
        .toList();
