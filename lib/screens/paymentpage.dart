import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang.dart';
import '../services/api_service.dart';
import 'qrpage.dart';

class PaymentPage extends StatefulWidget {
  final int productId;
  final int clientId;
  final String productName;
  final String price;
  final String storeName;
  final String pickupTime;
  final String deliveryType;
  final VoidCallback onBack;
  final String oldPrice;
  final String description;

  const PaymentPage({
    super.key,
    required this.productId,
    required this.clientId,
    required this.productName,
    required this.price,
    required this.storeName,
    required this.pickupTime,
    required this.deliveryType,
    required this.onBack,
    required this.oldPrice,
    required this.description,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final cardController = TextEditingController();
  final dateController = TextEditingController();
  final cvvController = TextEditingController();
  String _paymentMethod = "sur_place";

  // ----------------------------- CREATE RESERVATION --------------------------
  Future<Map<String, dynamic>?> createReservation(int clientId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/reservations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "client_id": clientId,
          "product_id": widget.productId,
          "quantity": 1,
        }),
      );

      final data = jsonDecode(response.body);
      print("STATUS = ${response.statusCode}");
      print("DATA = $data");

      if (response.statusCode == 200 && data["success"] == true) {
        final reservation = data["reservation"];
        if (widget.deliveryType == "livraison") {
          await ApiService.createDelivery(reservation["id"]);
        }
        return reservation;
      }
      return null;
    } catch (e) {
      print("❌ ERROR = $e");
      return null;
    }
  }

  //  confirme + va vers le QR
  Future<void> _confirmAndShowQr() async {
    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getInt("client_id") ?? 0;

    print("CONFIRM clientId=$clientId  productId=${widget.productId}"); // 🔍

    // 🔒 non connecté
    if (clientId == 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Connexion requise"),
          content: const Text(
              "Vous devez être connecté pour passer une commande."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final reservation = await createReservation(clientId);
    if (!mounted) return;
    if (reservation != null) {
      _goToQr(reservation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de réservation ❌")),
      );
    }
  }

  //  aller vers le QR réel
  void _goToQr(Map<String, dynamic> reservation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QrPage(
          qrCode: reservation["qr_code"]?.toString() ?? "",
          productName: reservation["product_name"]?.toString(),
          storeName: reservation["store_name"]?.toString(),
          status: reservation["status"]?.toString(),
          quantity: reservation["quantity"]?.toString(),
          showFinish: true, // 🆕 bouton "Terminer" → Categories
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final colors = Theme.of(context).colorScheme;
    final isRtl = lang.current == "ar";

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F0E6),
        appBar: AppBar(
          title: Text(
            lang.t("payment_title"),
            style: const TextStyle(fontFamily: 'PlayfairDisplay'),
          ),
          backgroundColor: const Color(0xFF0A3B2A),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: widget.onBack,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: "sur_place",
                        groupValue: _paymentMethod,
                        title: Text(lang.t("payment_on_site")),
                        activeColor: const Color(0xFF0A3B2A),
                        onChanged: (value) {
                          setState(() => _paymentMethod = value!);
                        },
                      ),
                      RadioListTile<String>(
                        value: "en_ligne",
                        groupValue: _paymentMethod,
                        title: Text(lang.t("payment_online")),
                        activeColor: const Color(0xFF0A3B2A),
                        onChanged: (value) {
                          setState(() => _paymentMethod = value!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (_paymentMethod == "sur_place")
                _buildOnSitePayment(lang, colors),
              if (_paymentMethod == "en_ligne")
                _buildOnlinePayment(lang, colors),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------- ON‑SITE PAYMENT ----------------------------
  Widget _buildOnSitePayment(Lang lang, ColorScheme colors) {
    return Card(
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.t("order_summary"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(lang.t("product_label"), widget.productName, lang, colors),
            _buildDetailRow(lang.t("price_label"), widget.price, lang, colors),
            _buildDetailRow(lang.t("store_label"), widget.storeName, lang, colors),
            _buildDetailRow(lang.t("pickup_time_label"), widget.pickupTime, lang, colors),
            _buildDetailRow(
              lang.t("type_label"),
              widget.deliveryType == "sur_place" ? "Sur place" : "Livraison",
              lang,
              colors,
            ),
            const Divider(height: 24),
            _buildDetailRow(
              lang.t("total_label"),
              widget.price,
              lang,
              colors,
              isTotal: true,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.qr_code_2, color: colors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Votre QR code sera généré après confirmation.",
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _confirmAndShowQr,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3B2A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(lang.t("confirm_reservation")),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------- ONLINE PAYMENT -----------------------------
  Widget _buildOnlinePayment(Lang lang, ColorScheme colors) {
    return Form(
      key: _formKey,
      child: Card(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                lang.t("card_title"),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: cardController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: lang.t("card_number"),
                  labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.credit_card, color: colors.primary),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
                style: TextStyle(color: colors.onSurface),
                validator: (value) {
                  if (value == null || value.isEmpty) return lang.t("required_field");
                  if (value.length < 16) return lang.t("invalid_card");
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: lang.t("expiry_date"),
                        labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
                        filled: true,
                        fillColor: colors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: colors.primary, width: 1.5),
                        ),
                      ),
                      style: TextStyle(color: colors.onSurface),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? lang.t("required_field") : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: lang.t("cvv"),
                        labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
                        filled: true,
                        fillColor: colors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: colors.primary, width: 1.5),
                        ),
                      ),
                      style: TextStyle(color: colors.onSurface),
                      validator: (value) =>
                          (value == null || value.length < 3) ? lang.t("invalid_cvv") : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showOnlinePaymentConfirmation(lang, colors);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(lang.t("pay_now")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------- ONLINE PAYMENT CONFIRMATION DIALOG -------------
  void _showOnlinePaymentConfirmation(Lang lang, ColorScheme colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colors.surface,
        title: Text(lang.t("order_summary"), style: TextStyle(color: colors.onSurface)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(lang.t("product_label"), widget.productName, lang, colors),
              _buildDetailRow(lang.t("price_label"), widget.price, lang, colors),
              _buildDetailRow(lang.t("store_label"), widget.storeName, lang, colors),
              _buildDetailRow(lang.t("pickup_time_label"), widget.pickupTime, lang, colors),
              _buildDetailRow(
                lang.t("type_label"),
                widget.deliveryType == "sur_place" ? "Sur place" : "Livraison",
                lang,
                colors,
              ),
              const Divider(),
              _buildDetailRow(
                lang.t("total_paid_label"),
                widget.price,
                lang,
                colors,
                isTotal: true,
              ),
              const SizedBox(height: 16),
              Center(child: Icon(Icons.payment, size: 48, color: colors.primary)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.t("cancel"), style: TextStyle(color: colors.onSurface)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _confirmAndShowQr();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
            child: Text(lang.t("confirm")),
          ),
        ],
      ),
    );
  }

  // ----------------------------- DETAIL ROW HELPER --------------------------
  Widget _buildDetailRow(
    String label,
    String value,
    Lang lang,
    ColorScheme colors, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? colors.primary : colors.onSurface,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? colors.secondary : colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}