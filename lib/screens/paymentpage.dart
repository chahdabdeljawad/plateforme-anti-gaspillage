import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:qr_flutter/qr_flutter.dart';

import '../lang.dart';
import 'categorydetailspage.dart';

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
  String _paymentMethod = "sur_place"; // 'sur_place' or 'en_ligne'

  // ----------------------------- CREATE RESERVATION --------------------------
  Future<void> createReservation() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/reservations'),
        // For Android emulator: Uri.parse('http://10.0.2.2:5000/api/reservations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "client_id": widget.clientId,
          "product_id": widget.productId,
          "product_name": widget.productName,
          "store_name": widget.storeName,
          "pickup_time": widget.pickupTime,
          "delivery_type": widget.deliveryType,
          "quantity": 1,
        }),
      );

      final data = jsonDecode(response.body);
    
      print("STATUS = ${response.statusCode}");
      print("DATA = $data");

      if (response.statusCode == 200) {
        print("✅ Reservation added");
      } else {
        print("❌ Reservation error");
      }
    } catch (e) {
      print("❌ ERROR = $e");
    }
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
              // ---------- Payment method selection ----------
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

              // ---------- Dynamic content based on payment method ----------
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

            // ---------- QR Code placeholder ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
         
              decoration: BoxDecoration(
                border: Border.all(color: colors.onSurface.withOpacity(0.12), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            
              child: Column(
                children: [
                  const Icon(Icons.qr_code_scanner, size: 60),
                  const SizedBox(height: 8),
                  QrImageView(
                    data:
                        "${widget.productName}-${widget.storeName}-${widget.price}-${Random().nextInt(999999)}",
                 
                    version: QrVersions.auto,
                    size: 200,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lang.t("qr_code_placeholder"),
                    style: TextStyle(color: colors.onSurface.withOpacity(0.5)),
                  ),
             
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // ---------- Confirm button ----------
            ElevatedButton(
           
              onPressed: () async {
                await createReservation();
                _showSuccessDialog(lang, colors);
              },
          
              style: ElevatedButton.styleFrom(
           
                backgroundColor: const Color(0xFF0A3B2A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

              // Card number
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

              // Expiry date & CVV row
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

              // Pay button
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
        title: Text(
          lang.t("order_summary"),
          style: TextStyle(color: colors.onSurface),
        ),
       
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
              await createReservation();
              _showSuccessDialog(lang, colors);
            
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

  // ----------------------------- SUCCESS DIALOG -----------------------------
  void _showSuccessDialog(Lang lang, ColorScheme colors) {
    showDialog(
      context: context,
     
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colors.surface,
        title: Text(
          lang.t("reservation_success_title"),
          style: TextStyle(color: colors.onSurface),
        ),
        content: Text(
          lang.t("reservation_success_msg"),
          style: TextStyle(color: colors.onSurface),
        ),
       
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => CategoryDetailsPage(
                    categoryName: widget.storeName,
                    onBack: () => Navigator.pop(context),
                    onReserve: (product, data) {},
                  ),
                ),
                (route) => false,
              );
            },
            child: Text(lang.t("ok"), style: TextStyle(color: colors.primary)),
         
          ),
        ],
      ),
    );
  }
}