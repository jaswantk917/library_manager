import 'package:intl/intl.dart';
import 'package:library_management/models/attendance_model.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:library_management/constants/db_constants.dart';
import 'package:library_management/models/custom_error.dart';

String formatDate(DateTime date) {
  return DateFormat('yyyyMMdd').format(date);
}

class AttendanceRepository {
  Future<Attendance> fetchAttendance() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await attendancesListRef.doc(formatDate(DateTime.now())).get();

      if (snapshot.data() == null) {
        log('was null');
        await attendancesListRef
            .doc(formatDate(DateTime.now()))
            .set({'date': formatDate(DateTime.now()), 'attendance': []});
        return Attendance(date: DateTime.now(), ids: []);
      }
      log(snapshot.data().toString());

      return Attendance.fromJson(snapshot.data()!);
    } on fb_auth.FirebaseAuthException catch (e) {
      log('firebase error');
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      log('here error 1');
      log(e.toString());
      throw CustomError(
        code: 'Exception',
        message: 'Somethig went wrong.',
        plugin: e.toString(),
      );
    }
  }

  Future<void> saveAttendance(Attendance attendanceList) async {
    try {
      await attendancesListRef
          .doc(formatDate(DateTime.now()))
          .set(attendanceList.toJson());
    } on fb_auth.FirebaseAuthException catch (e) {
      log('firebase error');
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      log('here error 2');
      throw CustomError(
        code: 'Exception',
        message: 'Somethig went wrong.',
        plugin: e.toString(),
      );
    }
  }

  Future<void> markAttendance(String id) async {
    Attendance attendanceList = await fetchAttendance();
    attendanceList.ids.add(id);
    await saveAttendance(attendanceList);
  }

  Future<bool> hasMarkedAttendance(String id) async {
    Attendance attendanceList = await fetchAttendance();
    return attendanceList.ids.contains(id);
  }
}
