import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 16,
      ),
      Icon(
        Icons.edit_document,
        size: 50,
      ),
      SizedBox(
        height: 16,
      ),
      Text('Nothing Here')
    ]);
  }
}
