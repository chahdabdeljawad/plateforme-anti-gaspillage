import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatelessWidget {

  final String qrCode;

  const QrPage({
    super.key,
    required this.qrCode,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("QR Reservation"),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            QrImageView(
              data: qrCode,
              size: 250,
            ),

            const SizedBox(height: 20),

            Text(
              qrCode,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}