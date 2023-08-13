import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/student_list.dart';
import 'package:library_management/screens/student_profile.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<StudentModel> studentsList = [];
  late Future<List<StudentModel>> future;

  @override
  void initState() {
    future = StudentRepository().fetchStudentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong! Restart the app.'),
          );
        } else {
          studentsList = snapshot.data!;

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              setState(() {
                future = StudentRepository().fetchStudentList();
              });
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: studentsList.length,
              itemBuilder: (BuildContext context, int index) {
                final student = studentsList[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(student.name),
                    subtitle: Text(
                        'Last paid on ${DateFormat.yMMMd().format(student.admissionDate)}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentProfile(index: index),
                        ),
                      );
                    },
                    trailing: const Icon(Icons.arrow_forward_sharp),
                  ),
                );
              },
            ),
          );
        }
      },
      future: future,
    );
  }
}
