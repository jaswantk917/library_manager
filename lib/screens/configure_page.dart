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
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Number of Chairs:'),
                ),
                InputQty(
                  maxVal: 500,
                  initVal: 100,
                  minVal: 20,
                  isIntrinsicWidth: true,
                  borderShape: BorderShapeBtn.circle,
                  boxDecoration: const BoxDecoration(),
                  steps: 5,
                  btnColor1: Theme.of(context).colorScheme.primary,
                  btnColor2: Theme.of(context).colorScheme.onBackground,
                  plusBtn: const Icon(Icons.add),
                  minusBtn: const Icon(Icons.remove),
                  onQtyChanged: (val) {
                    print(val);
                  },
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Info',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Students: 400'),
                Divider(),
                Text('Total Students in morning shift: 100'),
                Text('Total Students in noon shift: 100'),
                Text('Total Students in evening shift: 100'),
                Text('Total Students in night shift: 100'),
                Text('Total Students in 24 hour: 100'),
                Divider(),
                Text('Seats remaining in morning shift: 100'),
                Text('Seats remaining in noon shift: 100'),
                Text('Seats remaining in evening shift: 100'),
                Text('Seats remaining in night shift: 100'),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'About me',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('My name is Jaswant Kumar'),
          ),
        ),
      ],
    );
  }
}
