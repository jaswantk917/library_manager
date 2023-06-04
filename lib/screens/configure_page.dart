import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({super.key});

  @override
  State<ConfigurePage> createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Configure',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        InputQty(
          maxVal: 100,
          initVal: 0,
          minVal: -100,
          isIntrinsicWidth: false,
          borderShape: BorderShapeBtn.circle,
          boxDecoration: const BoxDecoration(color: Colors.amber),
          steps: 10,
          onQtyChanged: (val) {
            print(val);
          },
        ),
      ],
    );
  }
}
