import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:library_management/repositories/student_list_repository.dart';

class ConfigurePage extends StatefulWidget {
  const ConfigurePage({super.key});

  @override
  State<ConfigurePage> createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<ConfigurePage> {
  late Future<List<int>> future;
  StudentRepository repository = StudentRepository(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance);

  @override
  void initState() {
    super.initState();
    future = repository.getSeatData();
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
            child: Text('Something went wrong'),
          );
        } else {
          List<int> data = snapshot.data!;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Number of Chairs:'),
                      ),
                      InputQty(
                        maxVal: 5000,
                        initVal: data[0],
                        minVal: 0,
                        isIntrinsicWidth: true,
                        borderShape: BorderShapeBtn.circle,
                        boxDecoration: const BoxDecoration(),
                        steps: 5,
                        btnColor1: Theme.of(context).colorScheme.primary,
                        btnColor2: Theme.of(context).colorScheme.onBackground,
                        plusBtn: const Icon(Icons.add),
                        minusBtn: const Icon(Icons.remove),
                        onQtyChanged: (val) async {
                          repository.setSeats(val!.toInt());
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Students: ${data[1]}'),
                      Divider(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      Text('Total Students in morning shift: ${data[2]}'),
                      Text('Total Students in noon shift: ${data[3]}'),
                      Text('Total Students in evening shift: ${data[4]}'),
                      Text('Total Students in night shift: ${data[5]}'),
                      Divider(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      Text(
                          'Seats remaining in morning shift: ${data[0] - data[2]}'),
                      Text(
                          'Seats remaining in noon shift: ${data[0] - data[3]}'),
                      Text(
                          'Seats remaining in evening shift: ${data[0] - data[4]}'),
                      Text(
                          'Seats remaining in night shift: ${data[0] - data[5]}'),
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
      },
    );
  }
}
