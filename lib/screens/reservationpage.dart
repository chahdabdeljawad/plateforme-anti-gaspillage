import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/footer.dart';
import '../lang.dart';
import 'mappage.dart';

class ReservationPage extends StatefulWidget {
  final String productName;
  final String price;
  final String image;
  final double lat;
  final double lng;
  final String storeName;
  final String time;
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onConfirm;

  const ReservationPage({
    super.key,
    required this.productName,
    required this.price,
    required this.image,
    required this.lat,
    required this.lng,
    required this.storeName,
    required this.time,
    required this.onBack,
    required this.onConfirm,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  String deliveryType = "sur_place";
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    try {
      final parts = widget.time.split(":");
      selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      selectedTime = const TimeOfDay(hour: 18, minute: 0);
    }
  }

  void pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final colors = Theme.of(context).colorScheme;
    final isRtl = lang.current == "ar";

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          // ✅ Custom Header
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
                      widget.productName,
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  Image.asset(
                    widget.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Center(
                    child: Text(
                      widget.price,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colors.secondary,
                        fontFamily: 'PlayfairDisplay',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Location card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: colors.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.location_on, color: colors.primary),
                        title: Text(
                          lang.t("store_location"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          widget.storeName,
                          style: TextStyle(
                            color: colors.onSurface.withOpacity(0.6),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.map, color: colors.primary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapPage(
                                  lat: widget.lat,
                                  lng: widget.lng,
                                  storeName: widget.storeName,
                                  onBack: () => Navigator.pop(context),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Time picker card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: colors.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.access_time, color: colors.primary),
                        title: Text(
                          lang.t("pickup_time"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          selectedTime.format(context),
                          style: TextStyle(
                            color: colors.onSurface.withOpacity(0.6),
                          ),
                        ),
                        onTap: pickTime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Delivery type card (FIXED)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: colors.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            RadioListTile(
                              value: "sur_place",
                              groupValue: deliveryType,
                              title: Text(
                                lang.t("pickup_on_site"),
                                style: TextStyle(color: colors.onSurface),
                              ),
                              activeColor: colors.primary,
                              onChanged: (value) {
                                setState(() {
                                  deliveryType = value!;
                                });
                              },
                            ),
                            RadioListTile(
                              value: "livraison",
                              groupValue: deliveryType,
                              title: Text(
                                lang.t("delivery_home"),
                                style: TextStyle(color: colors.onSurface),
                              ),
                              activeColor: colors.primary,
                              onChanged: (value) {
                                setState(() {
                                  deliveryType = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reviews section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      lang.t("reviews"),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildReview(lang.t("review_great"), 5, colors),
                  _buildReview(lang.t("review_average"), 3, colors),
                  _buildReview(lang.t("review_good_price"), 4, colors),

                  const SizedBox(height: 30),

                  // Confirm button
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        widget.onConfirm({
                          'productName': widget.productName,
                          'price': widget.price,
                          'storeName': widget.storeName,
                          'pickupTime': selectedTime.format(context),
                          'deliveryType': deliveryType,
                        });
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        lang.t("next"),
                        style: TextStyle(fontSize: 16, color: colors.onPrimary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(String text, int stars, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: colors.primary,
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
          title: Text(text, style: TextStyle(color: colors.onSurface)),
          subtitle: Row(
            children: List.generate(
              stars,
              (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
            ),
          ),
        ),
      ),
    );
  }
}
