import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/screens/student_profile.dart';

class StudentDetailsCard extends StatelessWidget {
  const StudentDetailsCard({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        leading: const Icon(Icons.person),
        title: Text(student.name),
        subtitle: Text(
            'Last paid on ${DateFormat.yMMMd().format(student.admissionDate)}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfile(id: student.id),
            ),
          );
        },
        trailing: const Icon(Icons.arrow_forward_sharp),
      ),
    );
  }
}
