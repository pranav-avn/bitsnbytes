import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  final String deepLink;

  QRCodePage({required this.deepLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code for $deepLink'),
      ),
      body: Center(
        child: QrImageView(
          data: deepLink,
          version: QrVersions.auto,
          size: 200.0,
          gapless: false,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
        ),
      ),
    );
  }
}