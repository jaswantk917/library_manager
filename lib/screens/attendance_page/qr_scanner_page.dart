import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_management/repositories/attendance_today.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        controller: controller,
        overlay: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
        fit: BoxFit.contain,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          debugPrint('Barcode found! ${barcodes.first.rawValue}');
          final data = barcodes.first.rawValue;
          if (data == null) return;
          try {
            final json = jsonDecode(data);
            if (json['type'] != 'library attendance by Jaswant') {
              Fluttertoast.showToast(msg: 'Invalid QR code');
              return;
            }
            controller.stop();

            await AttendanceRepository().markAttendance(json['id']);
            if (context.mounted) Navigator.pop(context);
          } catch (e) {
            log(e.toString());
          }
        },
      ),
    );
  }
}
