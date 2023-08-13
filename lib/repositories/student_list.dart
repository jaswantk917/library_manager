import 'package:library_management/models/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRepository {
  Future<List<StudentModel>> fetchStudentList() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('student') ?? '[]');
    List<StudentModel> studentList =
        studentListFromJson(prefs.getString('student') ?? '[]');

    return studentList;
  }

  Future<void> addStudent(StudentModel student) async {
    final prefs = await SharedPreferences.getInstance();
    List<StudentModel> studentList =
        studentListFromJson(prefs.getString('student') ?? '[]');
    studentList.add(student);
    print(studentListToJson(studentList));
    prefs.setString('student', studentListToJson(studentList));
  }
  // Future<void> addStudent(StudentModel student) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   //List<Student>? students = await loadStudents();
  //   students.add(student);
  //   await prefs.setString('student', encode(students));
  //   students = decode(prefs.getString('student') ?? '[]');

  //   notifyListeners();
  // }
}
