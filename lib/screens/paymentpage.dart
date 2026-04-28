import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lang.dart';

class PaymentPage extends StatefulWidget {
  final String productName;
  final String price;
  final String storeName;
  final String pickupTime;
  final String deliveryType;

  const PaymentPage({
    super.key,
    required this.productName,
    required this.price,
    required this.storeName,
    required this.pickupTime,
    required this.deliveryType,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final cardController = TextEditingController();
  final dateController = TextEditingController();
  final cvvController = TextEditingController();

  String? _paymentMethod;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
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
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                          onChanged: (value) =>
                              setState(() => _paymentMethod = value),
                        ),
                        RadioListTile<String>(
                          value: "en_ligne",
                          groupValue: _paymentMethod,
                          title: Text(lang.t("payment_online")),
                          activeColor: const Color(0xFF0A3B2A),
                          onChanged: (value) =>
                              setState(() => _paymentMethod = value),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_paymentMethod == null)
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(lang.t("please_select_payment")),
                      ),
                    ),
                  ),
                if (_paymentMethod == "sur_place") _buildOnSitePayment(lang),
                if (_paymentMethod == "en_ligne") _buildOnlinePayment(lang),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnSitePayment(Lang lang) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.t("order_summary"),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
                color: Color(0xFF0A3B2A),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(lang.t("product_label"), widget.productName, lang),
            _buildDetailRow(lang.t("price_label"), widget.price, lang),
            _buildDetailRow(lang.t("store_label"), widget.storeName, lang),
            _buildDetailRow(
              lang.t("pickup_time_label"),
              widget.pickupTime,
              lang,
            ),
            _buildDetailRow(
              lang.t("type_label"),
              widget.deliveryType == "sur_place" ? "Sur place" : "Livraison",
              lang,
            ),
            const Divider(height: 24),
            _buildDetailRow(
              lang.t("total_label"),
              widget.price,
              lang,
              isTotal: true,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(lang.t("qr_code_placeholder")),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _showSuccessDialog(lang),
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

  Widget _buildOnlinePayment(Lang lang) {
    return Form(
      key: _formKey,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                lang.t("card_title"),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  color: Color(0xFF0A3B2A),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: cardController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: lang.t("card_number"),
                  prefixIcon: const Icon(Icons.credit_card),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFF0A3B2A),
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return lang.t("required_field");
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
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF0A3B2A),
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? lang.t("required_field")
                          : null,
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
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF0A3B2A),
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) => (value == null || value.length < 3)
                          ? lang.t("invalid_cvv")
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate())
                    _showOnlinePaymentConfirmation(lang);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3B2A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(lang.t("pay_now")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOnlinePaymentConfirmation(Lang lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(lang.t("order_summary")),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                lang.t("product_label"),
                widget.productName,
                lang,
              ),
              _buildDetailRow(lang.t("price_label"), widget.price, lang),
              _buildDetailRow(lang.t("store_label"), widget.storeName, lang),
              _buildDetailRow(
                lang.t("pickup_time_label"),
                widget.pickupTime,
                lang,
              ),
              _buildDetailRow(
                lang.t("type_label"),
                widget.deliveryType == "sur_place" ? "Sur place" : "Livraison",
                lang,
              ),
              const Divider(),
              _buildDetailRow(
                lang.t("total_paid_label"),
                widget.price,
                lang,
                isTotal: true,
              ),
              const SizedBox(height: 16),
              const Center(
                child: Icon(Icons.payment, size: 48, color: Color(0xFF0A3B2A)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.t("cancel")),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog(lang);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A3B2A),
              foregroundColor: Colors.white,
            ),
            child: Text(lang.t("confirm")),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Lang lang, {
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
              color: isTotal ? const Color(0xFF0A3B2A) : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF2E7D32) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(Lang lang) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(lang.t("reservation_success_title")),
        content: Text(lang.t("reservation_success_msg")),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(lang.t("ok")),
          ),
        ],
      ),
    );
  }
}
