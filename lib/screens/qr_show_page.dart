import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QRShowScreen extends StatelessWidget {
  const QRShowScreen({super.key, required this.title, required this.data});
  final String title;
  final String data;
  Future<Uint8List> generateQRCodeAsPng(
      String data, BuildContext context) async {
    final qrCode = Material(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'App by Jaswant Kumar',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );

    ScreenshotController screenshotController = ScreenshotController();

    return screenshotController.captureFromWidget(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR ID'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
            ),
            const Icon(Icons.qr_code),
            Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.all(16.0),
                  child: QrImageView(
                    data: data,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ],
            ),
            ActionChip(
              label: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.share)],
              ),
              onPressed: () async {
                // Share.shareXFiles([XFile.fromData(QrCode())]);
                Share.shareXFiles(
                  [
                    XFile.fromData(await generateQRCodeAsPng(data, context),
                        name: '$title.png', mimeType: 'image/png'),
                  ],
                  subject: 'QR ID $title',
                  text: 'Haha',
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
