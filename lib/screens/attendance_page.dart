import 'package:flutter/material.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/student_list.dart';
import 'package:library_management/src/common_functions.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final StudentRepository rep = StudentRepository();
  late Future<List<StudentModel>> future;

  Future<List<StudentModel>> fetchStudentListFiltered() async {
    List<StudentModel> list = await rep.fetchStudentList();
    Slots now = getCurrentSlot();
    List<StudentModel> filteredList =
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
          List<StudentModel> students = snapshot.data!;
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              setState(() {
                future = StudentRepository().fetchStudentList();
              });
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: CheckboxListTile.adaptive(
                    secondary: const Icon(Icons.person),
                    title: Text(students[index].name),
                    subtitle: const Text('Last paid on '),
                    onChanged: (value) {},
                    value: true,
                  ),
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
  