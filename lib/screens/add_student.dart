import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:library_management/blocs/student_list/student_list_bloc.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/student_list_repository.dart';
import 'package:library_management/screens/qr_show_page.dart';
import 'package:library_management/utils/common_functions.dart';
import 'package:uuid/uuid.dart';

//TODO: maybe refactor
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
  late List<Student> studentsList;
  late final StudentRepository studentRepository;
  DateTime selectedDate = DateTime.now();
  String studentName = '';
  String studentPhone = '';
  TextEditingController dateInput = TextEditingController(
      text: DateFormat.yMMMd().format(DateTime.now()).toString());
  bool morning = getCurrentSlot() == Slots.morning;
  bool noon = getCurrentSlot() == Slots.noon;
  bool evening = getCurrentSlot() == Slots.evening;
  bool night = getCurrentSlot() == Slots.night;
  late final String id;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022, 9),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<Slots> getSlots() {
    List<Slots> list = [];
    if (night) list.add(Slots.night);
    if (noon) list.add(Slots.noon);
    if (morning) list.add(Slots.morning);
    if (evening) list.add(Slots.evening);
    return list;
  }

  @override
  void initState() {
    context.read<StudentListBloc>().add(AddStudentEventInitial());
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentListBloc, StudentListState>(
      listener: (context, state) {
        log(state.addStatus.name);
        if (state.addStatus == StudentAddingStatus.added) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added')),
            );
          }

          if (context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    QRShowScreen(title: studentName, data: id)));
          }
        }
      },
      child: Scaffold(
        body: Hero(
          tag: 'addstud',
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Student Name',
                        icon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == '' || value == null) {
                          return 'Name is requried';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        studentName = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    child: TextFormField(
                      maxLength: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        icon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        studentPhone = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Admission Date',
                        icon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (dateInput.text.isEmpty) {
                          return 'Select admission date';
                        }
                        return null;
                      },
                      controller: dateInput,
                      readOnly: true,
                      onTap: () {
                        setState(() {
                          _selectDate();
                          dateInput.text = DateFormat.yMMMd()
                              .format(selectedDate)
                              .toString();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          morning = !morning;
                        });
                      },
                      title: const Text('Morning'),
                      leading: Checkbox(
                        onChanged: (value) {
                          setState(() {
                            morning = value!;
                          });
                        },
                        value: morning,
                      ),
                      subtitle: const Text('6am to 11am'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      onTap: () {
                        setState(
                          () {
                            noon = !noon;
                          },
                        );
                      },
                      title: const Text('Noon'),
                      leading: Checkbox(
                        onChanged: (value) {
                          setState(
                            () {
                              noon = value!;
                            },
                          );
                        },
                        value: noon,
                      ),
                      subtitle: const Text('11am to 4pm'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          evening = !evening;
                        });
                      },
                      title: const Text('Evening'),
                      leading: Checkbox(
                        onChanged: (value) {
                          setState(() {
                            evening = value!;
                          });
                        },
                        value: evening,
                      ),
                      subtitle: const Text('4pm to 9pm'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTile(
                      title: const Text('Night'),
                      onTap: () {
                        setState(() {
                          night = !night;
                        });
                      },
                      leading: Checkbox(
                        onChanged: (value) {
                          setState(() {
                            night = value!;
                          });
                        },
                        value: night,
                      ),
                      subtitle: const Text('10pm to 4pm'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add a new student'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Row(
            children: [
              context.watch<StudentListBloc>().state.addStatus ==
                      StudentAddingStatus.addding
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator.adaptive())
                  : const Icon(Icons.check),
              const SizedBox(
                width: 8,
              ),
              Text(context.watch<StudentListBloc>().state.addStatus ==
                      StudentAddingStatus.addding
                  ? 'Adding'
                  : 'Add'),
            ],
          ),
          onPressed: (noon || evening || night || morning) &&
                  context.watch<StudentListBloc>().state.addStatus ==
                      StudentAddingStatus.initial
              ? () async {
                  if (_formKey.currentState!.validate()) {
                    log('here 0');
                    id = const Uuid().v1();
                    context.read<StudentListBloc>().add(AddStudentEvent(
                          student: Student(
                            name: studentName,
                            phone: int.parse(studentPhone),
                            admissionDate: selectedDate,
                            lastPaymentDate: selectedDate,
                            slots: getSlots(),
                            id: id,
                          ),
                        ));
                  }
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Select at least one slot."),
                  ));
                },
          foregroundColor: (noon || evening || night || morning)
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.error,
          backgroundColor: (noon || evening || night || morning)
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
