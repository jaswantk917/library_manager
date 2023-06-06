import 'package:flutter/material.dart';

class AttendanceList extends StatelessWidget {
  const AttendanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: CheckboxListTile(
            secondary: const Icon(Icons.person),
            title: const Text('Falna'),
            subtitle: const Text('Last paid on '),
            onChanged: (value) {},
            value: true,
          ),
        ),
        Card(
          child: CheckboxListTile(
            secondary: const Icon(Icons.person),
            title: const Text('Chilna'),
            subtitle: const Text('Last paid on '),
            onChanged: (value) {},
            value: true,
          ),
        ),
        Card(
          child: CheckboxListTile(
            secondary: const Icon(Icons.person),
            title: const Text('Dhimka'),
            subtitle: const Text('Last paid on '),
            onChanged: (value) {},
            value: true,
          ),
        ),
      ],
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
  