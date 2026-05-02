import 'package:flutter/material.dart';
import 'mappage.dart';
import 'paymentpage.dart';
import '../components/footer.dart';

class ReservationPage extends StatefulWidget {
  final String productName;
  final String price;
  final String image;
  final double lat;
  final double lng;
  final String storeName;
  final String time;

  const ReservationPage({
    super.key,
    required this.productName,
    required this.price,
    required this.image,
    required this.lat,
    required this.lng,
    required this.storeName,
    required this.time,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      appBar: AppBar(
        title: Text(
          widget.productName,
          style: const TextStyle(fontFamily: 'PlayfairDisplay'),
        ),
        backgroundColor: const Color(0xFF0A3B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Location card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color(0xFF0A3B2A),
                  ),
                  title: const Text(
                    "Localisation du magasin",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.storeName),
                  trailing: IconButton(
                    icon: const Icon(Icons.map, color: Color(0xFF0A3B2A)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(
                            lat: widget.lat,
                            lng: widget.lng,
                            storeName: widget.storeName,
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
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.access_time,
                    color: Color(0xFF0A3B2A),
                  ),
                  title: const Text(
                    "Choisir l'heure de récupération",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(selectedTime.format(context)),
                  onTap: pickTime,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Delivery type card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      // ignore: deprecated_member_use
                      RadioListTile(
                        value: "sur_place",
                        groupValue: deliveryType,
                        title: const Text("Récupération sur place"),
                        activeColor: const Color(0xFF0A3B2A),
                        onChanged: (value) {
                          setState(() {
                            deliveryType = value!;
                          });
                        },
                      ),
                      // ignore: deprecated_member_use
                      RadioListTile(
                        value: "livraison",
                        groupValue: deliveryType,
                        title: const Text("Livraison à domicile"),
                        activeColor: const Color(0xFF0A3B2A),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Avis clients",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  color: Color(0xFF0A3B2A),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildReview("Très bon produit 👌", 5),
            _buildReview("Qualité moyenne", 3),
            _buildReview("Prix intéressant 🔥", 4),

            const SizedBox(height: 30),

            // Confirm button → Navigate to PaymentPage with all required data
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3B2A),
                  foregroundColor: Colors.white,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        productName: widget.productName,
                        price: widget.price,
                        storeName: widget.storeName,
                        pickupTime: selectedTime.format(context),
                        deliveryType: deliveryType,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Suivant", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            // Footer
            const AppFooter(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(String text, int stars) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF0A3B2A),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          title: Text(text),
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
