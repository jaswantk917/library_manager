import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/services_models/students.dart';
import 'package:provider/provider.dart';
import 'package:library_management/services_models/student_list_service.dart';
import 'package:library_management/screens/student_profile.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  // Future<void> _getStudentsList() async => getStudentsList();

  // Future<void> getStudentsList() async {
  //   await studentsListController.loadStudents();

  //   studentsList = studentsListController.students;
  // }

  @override
  Widget build(BuildContext context) {
    final StudentsList studentsListController =
        Provider.of<StudentsList>(context);
    if (!studentsListController.firstTimeLoaded) {
      studentsListController.firstTimeLoading();
    }
    final List<Student> studentsList = studentsListController.students;

    if (studentsListController.loading) {
      return const Center(
        child: Text('loading'),
      );
    } else {
      return ListView.builder(
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
      );
    }
  }
}
