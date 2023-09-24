// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:library_management/constants/db_constants.dart';
import 'package:library_management/models/custom_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:library_management/models/student_model.dart';

class StudentRepository {
  final FirebaseFirestore _firebaseFirestore;
  final fb_auth.FirebaseAuth _firebaseAuth;

  StudentRepository({
    required FirebaseFirestore firebaseFirestore,
    required fb_auth.FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;
  Future<List<Student>> fetchStudentList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await studentListRef.get();
    return snapshot.docs
        .map((docSnapshot) => Student.fromJson(docSnapshot.data()))
        .toList();
  }

  Future<void> addStudent(Student student) async {
    try {
      studentListRef.doc(student.phone.toString()).set(student.toJson());
    } on fb_auth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw const CustomError(
        code: 'Exception',
        message: 'flutter error/server error',
        plugin: '',
      );
    }
  }

  Future<Student> fetchStudentById(String id) async {
    final prefs = await SharedPreferences.getInstance();

    Student student =
        studentListFromJson(prefs.getString('student') ?? '[]').firstWhere(
      (element) => element.id == id,
      orElse: () => Student(
          name: '',
          phone: 0,
          admissionDate: DateTime(1),
          slots: [],
          lastPaymentDate: DateTime(1),
          id: id),
    );

    return student;
  }

  Future<void> paidOnDate(String id, DateTime lastPaymentDate) async {
    final prefs = await SharedPreferences.getInstance();
    List<Student> studentList =
        studentListFromJson(prefs.getString('student') ?? '[]');

    studentList.firstWhere((element) => element.id == id).lastPaymentDate =
        lastPaymentDate;

    prefs.setString('student', studentListToJson(studentList));
  }

  Future<List<int>> getSeatData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Student> studentList =
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

  Future<void> deleteStudentById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<Student> studentList =
        studentListFromJson(prefs.getString('student') ?? '[]');
    studentList.removeWhere((element) => element.id == id);

    prefs.setString('student', studentListToJson(studentList));
  }
}
