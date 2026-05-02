import 'package:flutter/material.dart';

class HomePageStyle {
  // =======================
  // COLORS
  // =======================
  static const Color primaryGreen = Color.fromARGB(255, 30, 70, 32);

  static final Color overlay = Colors.black.withValues(alpha: 0.4);

  // =======================
  // TEXT STYLES
  // =======================

  static const TextStyle heroTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.teal,
    letterSpacing: 1,
  );

  static const TextStyle bigTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle aboutTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle aboutText = TextStyle(fontSize: 16);

  static const TextStyle benefitTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  static TextStyle benefitDescription = TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
    height: 1.3,
  );

  // =======================
  // BUTTONS
  // =======================

  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
  );

  static final ButtonStyle roundedButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    elevation: 0,
  );

  // =======================
  // DECORATIONS
  // =======================

  static const BoxDecoration heroImage = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/hero.jpg"),
      fit: BoxFit.cover,
    ),
  );

  static const BoxDecoration howToImage = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/howto.jpg"),
      fit: BoxFit.cover,
    ),
  );
}
