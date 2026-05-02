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
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data["message"] ?? "Login failed"};
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {"success": false, "message": "Server error"};
    }
  }

  // 📝 REGISTER (updated with additional fields)
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role, {
    String? phone,
    String? storeCategory,
    double? latitude,
    double? longitude,
    String? placeName,
  }) async {
    try {
      // Base request body (common to all roles)
      final Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      };

      // Add phone if provided (required for both roles)
      if (phone != null && phone.isNotEmpty) {
        body["phone"] = phone;
      }

      // Add store-specific fields only when role is "store"
      if (role == "store") {
        if (storeCategory != null && storeCategory.isNotEmpty) {
          body["storeCategory"] = storeCategory;
        }
        if (latitude != null) {
          body["latitude"] = latitude;
        }
        if (longitude != null) {
          body["longitude"] = longitude;
        }
        if (placeName != null && placeName.isNotEmpty) {
          body["placeName"] = placeName;
        }
      }

      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Signup failed",
        };
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      return {"success": false, "message": "Server error"};
    }
  }

  // 👤 GET PROFILE
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

