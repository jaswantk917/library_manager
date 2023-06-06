import 'package:flutter/material.dart';

class AttendanceList extends StatelessWidget {
  const AttendanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Mark the students who are present:',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
    );
  }
}
