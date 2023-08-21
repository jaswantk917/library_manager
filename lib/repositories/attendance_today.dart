import 'package:library_management/models/attendance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceRepository {
  Future<Attendance> fetchAttendance() async {
    final sharedPref = await SharedPreferences.getInstance();
    String? temp = sharedPref.getString('attendance');
    if (temp != null) {
      Attendance tempAttendanceList = Attendance.fromRawJson(temp);
      if (tempAttendanceList.date.day == DateTime.now().day &&
          tempAttendanceList.date.month == DateTime.now().month &&
          tempAttendanceList.date.year == DateTime.now().year) {
        return Attendance.fromRawJson(temp);
      }
    }
    return Attendance(date: DateTime.now(), attendance: []);
  }

  Future<void> saveAttendance(Attendance attendanceList) async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('attendance', attendanceList.toRawJson());
  }

  Future<void> markAttendance(String id) async {
    Attendance attendanceList = await fetchAttendance();
    attendanceList.attendance.add(StudentList(id: id, time: DateTime.now()));
    await saveAttendance(attendanceList);
  }

  Future<DateTime?> hasMarkedAttendance(String id) async {
    Attendance attendanceList = await fetchAttendance();
    DateTime? ans;
    for (var element in attendanceList.attendance) {
      if (element.id == id) ans = element.time;
    }
    return ans;
  }
}
