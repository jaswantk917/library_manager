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

    prefs.setString('student', studentListToJson(studentList));
  }

  Future<StudentModel> fetchStudentByIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();

    StudentModel student =
        studentListFromJson(prefs.getString('student') ?? '[]')[index];
    return student;
  }

  Future<void> paidOnDate(int index, DateTime lastPaymentDate) async {
    final prefs = await SharedPreferences.getInstance();
    List<StudentModel> studentList =
        studentListFromJson(prefs.getString('student') ?? '[]');
    studentList[index].lastPaymentDate = lastPaymentDate;
    prefs.setString('student', studentListToJson(studentList));
  }

  Future<List<int>> getSeatData() async {
    final prefs = await SharedPreferences.getInstance();
    List<StudentModel> studentList =
        studentListFromJson(prefs.getString('student') ?? '[]');
    int seats = prefs.getInt('seats') ?? 100;
    int morning = 0, noon = 0, evening = 0, night = 0;
    for (var student in studentList) {
      if (student.slots.contains(Slots.morning)) morning++;
      if (student.slots.contains(Slots.noon)) noon++;
      if (student.slots.contains(Slots.evening)) evening++;
      if (student.slots.contains(Slots.night)) night++;
    }
    return [seats, studentList.length, morning, noon, evening, night];
  }

  Future<void> setSeats(int seats) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('seats', seats);
  }

  Future<void> deleteStudentByIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<StudentModel> studentList =
        studentListFromJson(prefs.getString('student') ?? '[]');
    studentList.removeAt(index);

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
