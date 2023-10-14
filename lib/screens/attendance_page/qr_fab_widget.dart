import 'package:flutter/material.dart';
import 'package:library_management/screens/attendance_page/qr_scanner_page.dart';

class QRFAB extends StatelessWidget {
  const QRFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const QRScanPage(),
          ),
        );
      },
      tooltip: 'Scan to mark attendance',
      child: const Icon(Icons.qr_code),
    );
  }
}
