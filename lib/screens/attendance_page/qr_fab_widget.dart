import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:library_management/repositories/attendance_today.dart';
import 'package:native_qr/native_qr.dart';

class QRFAB extends StatelessWidget {
  const QRFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        try {
          String? result = await NativeQr().get();

          if (result != null) {
            await AttendanceRepository().markAttendance(result);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Attendance marked')));
            }
          }
        } catch (err) {
          log('error has occured');
          log(err.toString());
        }

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const QRScanPage(),
        //   ),
        // );
      },
      tooltip: 'Scan to mark attendance',
      child: const Icon(Icons.qr_code),
    );
  }
}
