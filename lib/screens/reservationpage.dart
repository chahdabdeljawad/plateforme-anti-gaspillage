import 'package:flutter/material.dart';
import 'mappage.dart';
import 'paymentpage.dart';

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

  //TimeOfDay selectedTime = TimeOfDay.now();
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
    selectedTime = const TimeOfDay(hour: 18, minute: 0); // fallback ثابت
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
      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// IMAGE PRODUIT
          Image.asset(widget.image, height: 200, fit: BoxFit.cover),

           const SizedBox(height: 10),


            const SizedBox(height: 10),
            /// PRIX
            Text(
              widget.price,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            /// LOCALISATION
              ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: const Text("Localisation du magasin"),
              subtitle: Text(widget.storeName),
              trailing: IconButton(
                icon: const Icon(Icons.map),
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

            /// TEMPS RECUPERATION
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Choisir l'heure de récupération"),
              subtitle: Text("${selectedTime.format(context)}"),
              onTap: pickTime,
            ),

            const Divider(),

            /// TYPE LIVRAISON
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  RadioListTile(
                    value: "sur_place",
                    groupValue: deliveryType,
                    title: const Text("Récupération sur place"),
                    onChanged: (value) {
                      setState(() {
                        deliveryType = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    value: "livraison",
                    groupValue: deliveryType,
                    title: const Text("Livraison à domicile"),
                    onChanged: (value) {
                      setState(() {
                        deliveryType = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Divider(),

            /// AVIS
            const Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Avis clients",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            _buildReview("Très bon produit 👌", 5),
            _buildReview("Qualité moyenne", 3),
            _buildReview("Prix intéressant 🔥", 4),

            const SizedBox(height: 20),

            ///  BUTTON CONFIRM
ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
    );
  },
  icon: const Icon(Icons.arrow_forward),
  label: const Text(
    "Suivant",
    style: TextStyle(fontSize: 16),
  ),
),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(String text, int stars) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(text),
      subtitle: Row(
        children: List.generate(
          stars,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
        ),
      ),
    );
  }
}
