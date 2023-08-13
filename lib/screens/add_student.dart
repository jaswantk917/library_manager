import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/student_list.dart';
import 'package:library_management/src/common_functions.dart';
import 'package:library_management/widgets_components/checkbox_formfield.dart';

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
  late List<StudentModel> studentsList;
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
    studentRepository = StudentRepository();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Student Name',
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == '' || value == null) return 'Name is requried';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                child: TextFormField(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
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
                      dateInput.text =
                          DateFormat.yMMMd().format(selectedDate).toString();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CheckboxListTileFormField(
                  title: const Text('Morning'),
                  validator: (value) {
                    if (!(evening || night || noon || morning)) {
                      return 'Select at least one slot';
                    }
                    return null;
                  },
                  onSaved: (bool? value) {
                    setState(() {
                      morning = value!;
                    });
                  },
                  subtitle: const Text('6am to 11am'),
                  initialValue: morning,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CheckboxListTileFormField(
                  title: const Text('Noon'),
                  validator: (value) {
                    if (!(evening || night || noon || morning)) {
                      return 'Select at least one slot';
                    }
                    return null;
                  },
                  onSaved: (bool? value) {
                    setState(() {
                      noon = value!;
                    });
                  },
                  subtitle: const Text('11am to 4pm'),
                  initialValue: noon,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CheckboxListTileFormField(
                  title: const Text('Evening'),
                  validator: (value) {
                    if (!(evening || night || noon || morning)) {
                      return 'Select at least one slot';
                    }
                    return null;
                  },
                  onSaved: (bool? value) {
                    setState(() {
                      evening = value!;
                    });
                  },
                  subtitle: const Text('4pm to 9pm'),
                  initialValue: evening,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CheckboxListTileFormField(
                  title: const Text('Night'),
                  validator: (value) {
                    if (!(evening || night || noon || morning)) {
                      return 'Select at least one slot';
                    }
                    return null;
                  },
                  onSaved: (bool? value) {
                    setState(() {
                      night = value!;
                    });
                  },
                  subtitle: const Text('10pm to 4pm'),
                  initialValue: night,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add a new student'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await studentRepository.addStudent(StudentModel(
              name: studentName,
              phone: int.parse(studentPhone),
              admissionDate: selectedDate,
              lastPaymentDate: selectedDate,
              slots: getSlots(),
            ));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added')),
              );
            }
            if (context.mounted) Navigator.pop(context);
          }
          // print(studentsList[0].phone);
        },
      ),
    );
  }
}
