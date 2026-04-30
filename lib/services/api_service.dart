import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000/api"; // ✅ WEB
    } else {
      return "http://10.0.2.2:5000/api"; // ✅ ANDROID EMULATOR
    }
  }

  // 🔐 LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Login failed"
        };
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {"success": false, "message": "Server error"};
    }
  }

  // 📝 REGISTER
  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Signup failed"
        };
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      return {"success": false, "message": "Server error"};
    }
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/auth/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {"success": true, "data": data};
    } else {
      return {"success": false};
    }
  } catch (e) {
    return {"success": false};
  }
}

// 📦 GET ALL PRODUCTS
static Future<Map<String, dynamic>> getProducts() async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/products"),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {"success": true, "products": data["products"]};
    } else {
      return {"success": false};
    }
  } catch (e) {
    return {"success": false};
  }
}

// ➕ ADD PRODUCT (STORE ONLY)
static Future<Map<String, dynamic>> addProduct(
    String token,
    String name,
    String price,
    String description,
    String category) async {

  try {
    final response = await http.post(
      Uri.parse("$baseUrl/products"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "name": name,
        "price": price,
        "description": description,
        "category": category
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {"success": true};
    } else {
      return {"success": false, "message": data["message"]};
    }
  } catch (e) {
    return {"success": false};
  }
}

// 🗑️ DELETE PRODUCT
static Future<bool> deleteProduct(String token, int id) async {
  final response = await http.delete(
    Uri.parse("$baseUrl/products/$id"),
    headers: {
      "Authorization": "Bearer $token"
    },
  );

  return response.statusCode == 200;
}
}