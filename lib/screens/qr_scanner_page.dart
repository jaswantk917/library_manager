import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:native_qr/native_qr.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final _nativeQr = NativeQr();
  String? qrString;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  var result = await _nativeQr.get();
                  setState(() {
                    qrString = result;
                  });
                } catch (err) {
                  setState(() {
                    qrString = err.toString();
                    log(err.toString());
                  });
                }
              },
              child: const Text("Scan"),
            ),
            Text(qrString ?? "No data")
          ],
        ),
      ),
    );
  }
}
