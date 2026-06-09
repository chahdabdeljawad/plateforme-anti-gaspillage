import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatelessWidget {
  final String qrCode;
  final String? productName;
  final String? storeName;
  final String? status;
  final String? quantity;
  final bool showFinish; // 🆕 montrer "Terminer" (après checkout)

  const QrPage({
    super.key,
    required this.qrCode,
    this.productName,
    this.storeName,
    this.status,
    this.quantity,
    this.showFinish = false,
  });

  @override
  Widget build(BuildContext context) {
    final qrData =
        "Produit: ${productName ?? ''}\n"
        "Magasin: ${storeName ?? ''}\n"
        "Quantité: ${quantity ?? ''}\n"
        "Code: $qrCode";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      appBar: AppBar(
        title: const Text("Mon QR Réservation"),
        backgroundColor: const Color(0xFF0A3B2A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (productName != null && productName!.isNotEmpty)
                      Text(
                        productName!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                          color: Color(0xFF0A3B2A),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (storeName != null) _info("Magasin", storeName!),
                    if (quantity != null) _info("Quantité", quantity!),
                    if (status != null) _info("Statut", status!),
                    const SizedBox(height: 20),
                    qrCode.isEmpty
                        ? const Text("QR indisponible")
                        : QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 230,
                          ),
                    const SizedBox(height: 16),
                    SelectableText(
                      qrCode,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Présentez ce QR au magasin pour récupérer votre commande.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // 🆕 Terminer → retour aux Catégories
              if (showFinish) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.popUntil(
                        context, (route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3B2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Terminer"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}