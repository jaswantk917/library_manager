import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'students.dart';

class StudentsList extends ChangeNotifier {
  bool loading = true;
  List<Student> students = [];
  bool firstTimeLoaded = false;

  Future<void> firstTimeLoading() async {
    firstTimeLoaded = true;
    await loadStudents();
  }

  Future<void> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    students = decode(prefs.getString('student') ?? '[]');
    loading = false;
    notifyListeners();
    print(students);
  }

  Future<void> addStudent(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    //List<Student>? students = await loadStudents();
    students.add(student);
    await prefs.setString('student', encode(students));
    students = decode(prefs.getString('student') ?? '[]');

    notifyListeners();
  }
}
