import 'package:library_management/models/student_model.dart';

Slots getCurrentSlot() {
  switch (DateTime.now().hour) {
    case >= 6 && <= 10:
      return Slots.morning;
    case >= 11 && <= 15:
      return Slots.noon;
    case >= 16 && <= 20:
      return Slots.evening;
    case >= 21 && <= 3:
      return Slots.night;
    default:
      return Slots.evening;
  }
}
