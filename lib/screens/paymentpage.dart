import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'categorydetailspage.dart';
import '../lang.dart';

class PaymentPage extends StatefulWidget {
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

  // ✅ FIX: Initialize with a default value instead of null
  String _paymentMethod = "sur_place";

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final colors = Theme.of(context).colorScheme;
    final isRtl = lang.current == "ar";

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          // ✅ Custom Header (Back arrow + Title)
          Container(
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.95),
              border: Border(
                bottom: BorderSide(color: colors.onSurface.withOpacity(0.1)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: colors.onSurface),
                    onPressed: widget.onBack,
                  ),
                  Expanded(
                    child: Text(
                      lang.t("payment_title"),
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      color: colors.surface,
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
                              title: Text(
                                lang.t("payment_on_site"),
                                style: TextStyle(color: colors.onSurface),
                              ),
                              activeColor: colors.primary,
                              onChanged: (value) =>
                                  setState(() => _paymentMethod = value!),
                            ),
                            RadioListTile<String>(
                              value: "en_ligne",
                              groupValue: _paymentMethod,
                              title: Text(
                                lang.t("payment_online"),
                                style: TextStyle(color: colors.onSurface),
                              ),
                              activeColor: colors.primary,
                              onChanged: (value) =>
                                  setState(() => _paymentMethod = value!),
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
          ),
        ],
      ),
    );
  }

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
            _buildDetailRow(
              lang.t("product_label"),
              widget.productName,
              lang,
              colors,
            ),
            _buildDetailRow(lang.t("price_label"), widget.price, lang, colors),
            _buildDetailRow(
              lang.t("store_label"),
              widget.storeName,
              lang,
              colors,
            ),
            _buildDetailRow(
              lang.t("pickup_time_label"),
              widget.pickupTime,
              lang,
              colors,
            ),
            _buildDetailRow(
              lang.t("type_label"),
              widget.deliveryType == "sur_place" ? "Sur place" : "Livraison",
              lang,
              colors,
            ),
            Divider(height: 24, color: colors.onSurface.withOpacity(0.12)),
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
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.onSurface.withOpacity(0.12),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 60,
                    color: colors.onSurface.withOpacity(0.5),
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
            ElevatedButton(
              onPressed: () => _showSuccessDialog(lang, colors),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
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
                  labelStyle: TextStyle(
                    color: colors.onSurface.withOpacity(0.6),
                  ),
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
                        labelStyle: TextStyle(
                          color: colors.onSurface.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: colors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: TextStyle(color: colors.onSurface),
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
                        labelStyle: TextStyle(
                          color: colors.onSurface.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: colors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: TextStyle(color: colors.onSurface),
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
                    _showOnlinePaymentConfirmation(lang, colors);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                lang.t("product_label"),
                widget.productName,
                lang,
                colors,
              ),
              _buildDetailRow(
                lang.t("price_label"),
                widget.price,
                lang,
                colors,
              ),
              _buildDetailRow(
                lang.t("store_label"),
                widget.storeName,
                lang,
                colors,
              ),
              _buildDetailRow(
                lang.t("pickup_time_label"),
                widget.pickupTime,
                lang,
                colors,
              ),
              _buildDetailRow(
                lang.t("type_label"),
                widget.deliveryType == "sur_place" ? "Sur place" : "Livraison",
                lang,
                colors,
              ),
              Divider(color: colors.onSurface.withOpacity(0.12)),
              _buildDetailRow(
                lang.t("total_paid_label"),
                widget.price,
                lang,
                colors,
                isTotal: true,
              ),
              const SizedBox(height: 16),
              Center(
                child: Icon(Icons.payment, size: 48, color: colors.primary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              lang.t("cancel"),
              style: TextStyle(color: colors.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
                    categoryName:
                        widget.storeName, // or real category if you have it
                    onBack: () {
                      Navigator.pop(context);
                    },
                    onReserve: (product, data) {
                      // keep same callback if needed
                    },
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
