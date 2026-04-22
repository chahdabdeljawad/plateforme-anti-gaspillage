import 'package:flutter/material.dart';

class CategoriesStyle {

  // 🎨 Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color primary = Color(0xFF00C896);
  static const Color textDark = Colors.black;
  static const Color textLight = Colors.white;

  // 🧱 AppBar Container
  static BoxDecoration appBarDecoration = const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  // 🔍 Search Field
  static InputDecoration searchInput = InputDecoration(
    hintText: 'Rechercher une catégorie...',
    prefixIcon: const Icon(Icons.search),
    filled: true,
    fillColor: const Color(0xFFF0F0F0),
    contentPadding: const EdgeInsets.symmetric(vertical: 0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide.none,
    ),
  );

  // 🏷️ Section Label
  static TextStyle sectionLabel = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
    letterSpacing: 1,
  );

  // 🛒 Grandes surfaces card
  static BoxDecoration brandCard = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha:0.06),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );

  // 🍽️ Category card (shadow)
  static BoxDecoration categoryShadow = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha:0.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // 🌈 Gradient overlay
  static BoxDecoration gradientOverlay = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.black.withValues(alpha:0.7),
        Colors.transparent,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.center,
    ),
  );

  // 🔤 Title style
  static TextStyle categoryTitle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
}