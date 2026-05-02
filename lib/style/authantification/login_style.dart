import 'package:flutter/material.dart';

class LoginStyle {
  // 🌿 MAIN GREEN
  static const Color primaryGreen = Color(0xFF0A3B2A);

  // 🌱 BACKGROUND
  static const Color background = Color(0xFFF4FAF7);

  // 🧾 CARD STYLE
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10)),
    ],
  );

  // ✏️ INPUT STYLE
  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryGreen),
      filled: true,
      fillColor: const Color(0xFFF6FBF8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  // 🔘 BUTTON STYLE
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryGreen,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    minimumSize: const Size(double.infinity, 50),
  );

  // 🧠 TITLE STYLE
  static const TextStyle title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  // 🌿 SUBTITLE STYLE
  static TextStyle subtitle = TextStyle(color: Colors.grey[600]);
}
