import 'package:cloud_firestore/cloud_firestore.dart';

final studentListRef = FirebaseFirestore.instance.collection('students');
final attendancesListRef = FirebaseFirestore.instance.collection('attendance');
