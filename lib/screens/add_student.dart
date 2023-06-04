import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/services_models/students.dart';
import 'package:provider/provider.dart';
import 'package:library_management/services_models/student_list_service.dart';
import 'package:library_management/widgets_components/text_field_widget.dart';

class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AddStudentForm();
  }
}

class AddStudentForm extends StatefulWidget {
  const AddStudentForm({Key? key}) : super(key: key);

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  late StudentsList studentsList;
  DateTime selectedDate = DateTime.now();
  String studentName = '';
  String studentPhone = '';
  TextEditingController dateInput = TextEditingController();
  bool is24Hr = false;
  bool morning = false;
  bool noon = false;
  bool evening = false;
  bool night = false;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022, 9),
      lastDate: DateTime(2060),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> addStudentToList() async {
    await studentsList.addStudent(
      Student(
          name: studentName,
          phone: studentPhone,
          admissionDate: selectedDate,
          is24Hr: is24Hr,
          morning: morning,
          noon: noon,
          evening: evening,
          night: night),
    );
  }

  @override
  Widget build(BuildContext context) {
    studentsList = Provider.of<StudentsList>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            TextFieldWidget(
              callback: (value) {
                studentName = value!;
              },
              labelText: 'Student Name',
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.name,
              icon: const Icon(Icons.person),
            ),
            TextFieldWidget(
              callback: (value) {
                studentPhone = value!;
              },
              labelText: 'Phone Number',
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.phone,
              icon: const Icon(Icons.phone),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Admission Date',
                  icon: Icon(Icons.calendar_today),
                ),
                controller: dateInput,
                readOnly: true,
                onTap: () {
                  setState(() {
                    _selectDate();
                    dateInput.text =
                        DateFormat.yMMMd().format(selectedDate).toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('24 hour'),
              leading: Radio<bool>(
                value: true,
                groupValue: is24Hr,
                onChanged: (bool? value) {
                  setState(() {
                    is24Hr = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Individual Slots'),
              leading: Radio<bool>(
                value: false,
                groupValue: is24Hr,
                onChanged: (bool? value) {
                  setState(() {
                    is24Hr = value!;
                  });
                },
              ),
            ),
            is24Hr
                ? const SizedBox(
                    height: 1,
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CheckboxListTile(
                          value: morning,
                          onChanged: (bool? value) {
                            setState(() {
                              morning = value!;
                            });
                          },
                          title: const Text('Morning'),
                          subtitle: const Text('6am to 11am'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CheckboxListTile(
                          value: noon,
                          onChanged: (bool? value) {
                            setState(() {
                              noon = value!;
                            });
                          },
                          title: const Text('Noon'),
                          subtitle: const Text('11am to 4pm'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CheckboxListTile(
                          value: evening,
                          onChanged: (bool? value) {
                            setState(() {
                              evening = value!;
                            });
                          },
                          title: const Text('Evening'),
                          subtitle: const Text('4pm to 9pm'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CheckboxListTile(
                          value: night,
                          onChanged: (bool? value) {
                            setState(() {
                              night = value!;
                            });
                          },
                          title: const Text('Night'),
                          subtitle: const Text('10pm to 4am'),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add a new student'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          Navigator.pop(context);
          await addStudentToList();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added')),
          );
          // print(studentsList[0].phone);
        },
      ),
    );
  }
}
