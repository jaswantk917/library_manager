import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/attendance_today.dart';
import 'package:library_management/repositories/student_list.dart';
import 'package:library_management/src/common_functions.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final StudentRepository rep = StudentRepository();
  late Future<List<Student>> future;

  Future<List<Student>> fetchStudentListFiltered() async {
    List<Student> list = await rep.fetchStudentList();
    Slots now = getCurrentSlot();
    List<Student> filteredList =
        list.where((obj) => obj.slots.contains(now)).toList();
    return filteredList;
  }

  @override
  void initState() {
    super.initState();
    future = fetchStudentListFiltered();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong. Restart the app'),
          );
        } else {
          List<Student> students = snapshot.data!;
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              setState(() {
                future = StudentRepository().fetchStudentList();
              });
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: AttendanceRepository()
                      .hasMarkedAttendance(students[index].id),
                  builder: (context, snapshot) {
                    return Card(
                      child: CheckboxListTile.adaptive(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        secondary: const Icon(Icons.person),
                        title: Text(students[index].name),
                        subtitle: snapshot.data != null
                            ? Text(
                                'Attendance marked at ${DateFormat('h:mm a').format(snapshot.data!)}')
                            : const Text('Has not arrived yet.'),
                        onChanged: (value) {},
                        value: snapshot.data != null,
                      ),
                    );
                  },
                );
              },
              itemCount: students.length,
            ),
          );
        }
      },
    );
  }
}

// const Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Text(
//         'Mark the students who are present:',
//         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
//       ),
//     );
  