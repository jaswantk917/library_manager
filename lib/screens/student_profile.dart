import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/student_list.dart';
import 'package:library_management/screens/edit_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key, required this.index});
  final int index;

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  StudentRepository rep = StudentRepository();
  late Future<StudentModel> future;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    future = rep.fetchStudentByIndex(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jaswant Kumar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'SampleItem.itemOne',
                child: const Text('Edit'),
                onTap: () {
                  print('Tapped');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditStudentForm(index: widget.index);
                      },
                    ),
                  );
                },
              ),
              PopupMenuItem<String>(
                value: 'SampleItem.itemTw',
                child: const Text('Delete'),
                onTap: () {
                  bool undo = true;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Deleted student"),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          undo = false;
                        },
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  Timer(const Duration(seconds: 4), () async {
                    if (undo) await rep.deleteStudentByIndex(widget.index);
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
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
              StudentModel student = snapshot.data!;
              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  setState(() {
                    future = rep.fetchStudentByIndex(widget.index);
                  });
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Contact Info',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              ListTile(
                                title: Text(student.phone.toString()),
                                onTap: () {
                                  try {
                                    launchUrl(
                                      Uri.parse(
                                          'tel://+91${student.phone.toString()}'),
                                    );
                                  } catch (e) {
                                    //To handle error and display error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                },
                                leading: const Icon(Icons.call),
                                trailing: IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                  onPressed: () async {
                                    var whatsappUrl =
                                        "whatsapp://send?phone=+91${student.phone.toString()}&text=Hi";
                                    try {
                                      launchUrl(
                                        Uri.parse(whatsappUrl),
                                      );
                                    } catch (e) {
                                      //To handle error and display error message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'Admission Date',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                ListTile(
                                  title: Text(DateFormat.yMMMd()
                                      .format(student.admissionDate)
                                      .toString()),
                                  leading: const Icon(Icons.calendar_today),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'Last Payment Date',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                ListTile(
                                  title: Text(DateFormat.yMMMd()
                                      .format(student.lastPaymentDate)
                                      .toString()),
                                  leading: const Icon(Icons.calendar_today),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (DateTime.now()
                            .difference(student.lastPaymentDate)
                            .inDays >
                        30)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        child: FilledButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            DateTime? paymentDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime.now(),
                            );
                            if (paymentDate != null) {
                              await rep.paidOnDate(widget.index, paymentDate);
                            }
                            setState(() {
                              loading = false;
                              future = rep.fetchStudentByIndex(widget.index);
                            });
                          },
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: loading
                              ? const CircularProgressIndicator.adaptive()
                              : const Text('Mark as Paid'),
                        ),
                      )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
