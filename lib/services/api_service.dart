import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

class ApiService {

  //  BASE URL
  static String get baseUrl {

    if (kIsWeb) {
      return "http://localhost:5000/api";
    } else {
      return "http://10.0.2.2:5000/api";
    }
  }

  //  LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
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

      print("LOGIN ERROR = $e");
      return {"success": false, "message": "Server error"};
    }
  }

  //  REGISTER
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
    String? vehicle,
  }) async {

    try {

      final Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      };

      if (phone != null && phone.isNotEmpty) body["phone"] = phone;

      if (role == "store") {
        if (storeCategory != null) body["storeCategory"] = storeCategory;
        if (latitude != null) body["latitude"] = latitude;
        if (longitude != null) body["longitude"] = longitude;
        if (placeName != null) body["placeName"] = placeName;
      }

      if (role == "livreur" && vehicle != null) body["vehicle"] = vehicle;

  if (latitude != null) body["latitude"] = latitude;
      if (longitude != null) body["longitude"] = longitude;
      
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data["message"] ?? "Signup failed"};
      }

    } catch (e) {

      print("REGISTER ERROR = $e");
      return {"success": false, "message": "Server error"};
    }
  }

  //  PROFILE
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/auth/me"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("PROFILE STATUS = ${response.statusCode}");
      print("PROFILE BODY = ${response.body}");
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        return {"success": false};
      }
    } catch (e) {
      print("PROFILE ERROR = $e");
      return {"success": false};
    }
  }


  //  GET ALL PRODUCTS (client → validés seulement)
  static Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/products/validated"));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "products": data["products"]};
      } else {
        return {"success": false};
      }

    } catch (e) {

      print("GET PRODUCTS ERROR = $e");
      return {"success": false};
    }
  }

  //  GET MY PRODUCTS
  static Future<Map<String, dynamic>> getMyProducts(String token) async {
    try {

      final response = await http.get(
        Uri.parse("$baseUrl/products/my"),
        headers: {"Authorization": "Bearer $token"},
      );
      print("MY PRODUCTS STATUS = ${response.statusCode}");
      print("MY PRODUCTS BODY = ${response.body}");
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "products": data["products"]};
      } else {
        return {"success": false};
      }

    } catch (e) {

      print("GET MY PRODUCTS ERROR = $e");
      return {"success": false};
    }
  }

  //  ADD PRODUCT
  static Future<Map<String, dynamic>> addProduct(
    String token,
    String name,
    String price,
    String oldPrice,
    String description,
    String category,
    dynamic image,
    String imageName, {
    String? expirationDate,
    String? quantity,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/products"));
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = name;
      request.fields['price'] = price;
      request.fields['oldPrice'] = oldPrice;
      request.fields['description'] = description;
      request.fields['category'] = category;
      if (expirationDate != null) request.fields['expirationDate'] = expirationDate;
      if (quantity != null) request.fields['quantity'] = quantity;

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes('image', image as Uint8List, filename: imageName));
      } else {
        request.files.add(await http.MultipartFile.fromPath('image', (image as File).path));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print("ADD STATUS = ${response.statusCode}");
      print("ADD BODY = $responseData");

      if (responseData.isEmpty) {
        if (response.statusCode == 201) return {"success": true};
        return {"success": false, "message": "Empty response"};
      }

      final data = jsonDecode(responseData);

      if (response.statusCode == 201) {
        return {"success": true, "product": data};
      } else {
        return {"success": false, "message": data["message"] ?? "Error"};
      }

    } catch (e) {

      print("ADD PRODUCT ERROR = $e");
      return {"success": false, "message": e.toString()};
    }
  }

  //  UPDATE PRODUCT
  static Future<Map<String, dynamic>> updateProduct(
    String token,
    int id,
    String name,
    String price,
    String oldPrice,
    String description,
    String category, {
    String? expirationDate,
    String? quantity,
  }) async {
    try {

      final response = await http.put(
        Uri.parse("$baseUrl/products/$id"),

        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },

        body: jsonEncode({
          "name": name,
          "price": price,
          "oldPrice": oldPrice,
          "description": description,
          "category": category,
          "expirationDate": expirationDate,
          "quantity": quantity,
        }),
      );
      print("UPDATE STATUS = ${response.statusCode}");
      print("UPDATE BODY = ${response.body}");
      if (response.body.isEmpty) {
        if (response.statusCode == 200) return {"success": true};
        return {"success": false, "message": "Empty response"};
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return {"success": true, "product": data};
      } else {
        return {"success": false, "message": data["message"] ?? "Update failed"};
      }

    } catch (e) {

      print("UPDATE PRODUCT ERROR = $e");
      return {"success": false, "message": e.toString()};
    }
  }

  //  DELETE PRODUCT
  static Future<bool> deleteProduct(String token, int id) async {
    try {

      final response = await http.delete(
        Uri.parse("$baseUrl/products/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
      print("DELETE STATUS = ${response.statusCode}");
      print("DELETE BODY = ${response.body}");
      return response.statusCode == 200;
      
    } catch (e) {

      print("DELETE ERROR = $e");

      return false;
    }
  }

  // ================= RESERVATIONS =================

  //  CREATE RESERVATION (checkout panier)
  static Future<Map<String, dynamic>> createReservation(
    int clientId,
    int productId,
    int quantity,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reservations"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "client_id": clientId,
          "product_id": productId,
          "quantity": quantity,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        return {"success": true, "reservation": data["reservation"]};
      }
      return {"success": false, "message": data["message"] ?? "Erreur"};
    } catch (e) {
      print("CREATE RESERVATION ERROR = $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // CLIENT RESERVATIONS
  static Future<Map<String, dynamic>> getClientReservations(int clientId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/client-reservations/$clientId"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "reservations": data["reservations"] ?? []};
      } else {
        return {"success": false, "message": data["message"] ?? "Failed to load reservations"};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  // ================= GET PENDING STORES =================
  static Future<Map<String, dynamic>> getPendingStores() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/admin/pending-stores"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "stores": data["stores"]};
      } else {
        return {"success": false};
      }
    } catch (e) {
      return {"success": false};
    }
  }


  // ================= VALIDATE STORE =================
  static Future<bool> validateStore(int id) async {
    try {
      final response = await http.put(Uri.parse("$baseUrl/admin/validate-store/$id"));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ================= UPDATE PROFILE =================
  static Future<Map<String, dynamic>> updateProfile(
    int id,
    String role,
    String name,
    String email,
    String num, {
    String? categorie,
    String? localisation,
    String? phone,
    String? vehicle,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/auth/update-profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "role": role,
          "name": name,
          "email": email,
          "num": num,
          "categorie": categorie,
          "localisation": localisation,
          "phone": phone,
          "vehicle": vehicle,
        }),
      );
      print("UPDATE PROFILE STATUS = ${response.statusCode}");
      print("UPDATE PROFILE BODY = ${response.body}");
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "user": data["user"]};
      } else {
        return {"success": false, "message": data["message"]};
      }
    } catch (e) {
      print("UPDATE PROFILE ERROR = $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ================= DELIVERIES =================
  static Future<List> getAvailableDeliveries() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/deliveries/available"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) return data["deliveries"] ?? [];
      return [];
    } catch (e) {
      print("AVAILABLE DELIVERIES ERROR = $e");
      return [];
    }
  }

  static Future<List> getMyDeliveries(int livreurId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/deliveries/my/$livreurId"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) return data["deliveries"] ?? [];
      return [];
    } catch (e) {
      print("MY DELIVERIES ERROR = $e");
      return [];
    }
  }

  static Future<bool> acceptDelivery(int idDelivery, int idLivreur) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/deliveries/$idDelivery/accept"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_livreur": idLivreur}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("ACCEPT DELIVERY ERROR = $e");
      return false;
    }
  }

  static Future<bool> confirmDelivery(int idDelivery) async {
    try {
      final response = await http.put(Uri.parse("$baseUrl/deliveries/$idDelivery/confirm"));
      return response.statusCode == 200;
    } catch (e) {
      print("CONFIRM DELIVERY ERROR = $e");
      return false;
    }
  }

  static Future<bool> createDelivery(int idReservation) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/deliveries"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_reservation": idReservation}),
      );
      print("CREATE DELIVERY STATUS = ${response.statusCode}");
      print("CREATE DELIVERY BODY = ${response.body}");
      return response.statusCode == 201;
    } catch (e) {
      print("CREATE DELIVERY ERROR = $e");
      return false;
    }
  }

  // ================= STORE RESERVATIONS =================
  static Future<List> getStoreReservations(int storeId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/store-reservations/$storeId"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) return data["reservations"] ?? [];
      return [];
    } catch (e) {
      print("STORE RESERVATIONS ERROR = $e");
      return [];
    }
  }

  static Future<bool> updateReservationStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/reservations/$id/status"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("UPDATE RESERVATION STATUS ERROR = $e");
      return false;
    }
  }

  //  VERIFY QR
  static Future<Map<String, dynamic>> verifyQrCode(String qrCode) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reservations/verify-qr"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"qr_code": qrCode}),
      );
      final data = jsonDecode(response.body);
      return {
        "success": data["success"] == true,
        "message": data["message"] ?? "Erreur",
      };
    } catch (e) {
      print("VERIFY QR ERROR = $e");
      return {"success": false, "message": "Erreur serveur"};
    }
  }

  // ================= REVIEWS / REPORTS =================
  static Future<bool> createReview(
    String clientName,
    String storeName,
    String comment,
    int rating,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reviews"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "client_name": clientName,
          "store_name": storeName,
          "comment": comment,
          "rating": rating,
        }),
      );
      print("CREATE REVIEW STATUS = ${response.statusCode}");
      return response.statusCode == 201;
    } catch (e) {
      print("CREATE REVIEW ERROR = $e");
      return false;
    }
  }

  static Future<List> getStoreReviews(String storeName) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/reviews/$storeName"));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) return data["reviews"] ?? [];
      return [];
    } catch (e) {
      print("GET REVIEWS ERROR = $e");
      return [];
    }
  }

  static Future<bool> createReport(int reviewId, String reason) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reports"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"review_id": reviewId, "reason": reason}),
      );
      print("CREATE REPORT STATUS = ${response.statusCode}");
      return response.statusCode == 201;
    } catch (e) {
      print("CREATE REPORT ERROR = $e");
      return false;
    }
  }
}