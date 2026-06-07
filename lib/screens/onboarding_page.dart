import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final VoidCallback onStart; // ما يصير وقت يكبس GO
  const OnboardingPage({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF0A3B2A);
    const lime = Color(0xFF9ACD32);
    const bg = Color(0xFFF5F0E6);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // 🟢 Blobs (كيف الـ design : دوائر كبار)
          Positioned(
            top: -80,
            left: -60,
            child: _blob(220, green.withOpacity(0.85)),
          ),
          Positioned(
            top: 40,
            right: -70,
            child: _blob(160, lime.withOpacity(0.7)),
          ),
          Positioned(
            bottom: -90,
            right: -50,
            child: _blob(240, green.withOpacity(0.85)),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: _blob(150, lime.withOpacity(0.6)),
          ),

          // 🏷 Logo + nom au centre
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.eco, size: 90, color: green),
                SizedBox(height: 16),
                Text(
                  "ZEROGASPI",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                    color: green,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Réduisons le gaspillage ensemble",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          // ⬛ Bouton GO en bas
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "GO !",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دائرة (blob)
  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}