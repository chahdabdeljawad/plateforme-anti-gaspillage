import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

class ApiService {

  // 🌍 BASE URL
  static String get baseUrl {

    if (kIsWeb) {
      return "http://localhost:5000/api";
    } else {
      return "http://10.0.2.2:5000/api";
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

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return {
          "success": true,
          "data": data,
        };

      } else {

        return {
          "success": false,
          "message":
              data["message"] ?? "Login failed",
        };
      }

    } catch (e) {

      print("LOGIN ERROR = $e");

      return {
        "success": false,
        "message": "Server error",
      };
    }
  }

  // 📝 REGISTER
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

      final Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      };

      if (phone != null && phone.isNotEmpty) {
        body["phone"] = phone;
      }

      if (role == "store") {

        if (storeCategory != null) {
          body["storeCategory"] = storeCategory;
        }

        if (latitude != null) {
          body["latitude"] = latitude;
        }

        if (longitude != null) {
          body["longitude"] = longitude;
        }

        if (placeName != null) {
          body["placeName"] = placeName;
        }
      }

      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {

        return {
          "success": true,
          "data": data,
        };

      } else {

        return {
          "success": false,
          "message":
              data["message"] ?? "Signup failed",
        };
      }

    } catch (e) {

      print("REGISTER ERROR = $e");

      return {
        "success": false,
        "message": "Server error",
      };
    }
  }

  // 👤 PROFILE
static Future<Map<String, dynamic>> getProfile(
  String token,
) async {

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

      return {
        "success": false,
      };
    }

  } catch (e) {

    print("PROFILE ERROR = $e");

    return {
      "success": false,
    };
  }
}

  // 🌍 GET ALL PRODUCTS
  static Future<Map<String, dynamic>>
      getProducts() async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/products"),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return {
          "success": true,
          "products": data["products"],
        };

      } else {

        return {
          "success": false,
        };
      }

    } catch (e) {

      print("GET PRODUCTS ERROR = $e");

      return {
        "success": false,
      };
    }
  }

  // 📦 GET MY PRODUCTS
  static Future<Map<String, dynamic>>
      getMyProducts(
    String token,
  ) async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/products/my"),

        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print(
        "MY PRODUCTS STATUS = ${response.statusCode}",
      );

      print(
        "MY PRODUCTS BODY = ${response.body}",
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return {
          "success": true,
          "products": data["products"],
        };

      } else {

        return {
          "success": false,
        };
      }

    } catch (e) {

      print("GET MY PRODUCTS ERROR = $e");

      return {
        "success": false,
      };
    }
  }

  // ➕ ADD PRODUCT
  static Future<Map<String, dynamic>>
      addProduct(
    String token,
    String name,
    String price,
    String oldPrice,
    String description,
    String category,
    dynamic image,
    String imageName,
  ) async {

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/products"),
      );

      request.headers['Authorization'] =
          'Bearer $token';

      request.fields['name'] = name;
      request.fields['price'] = price;
      request.fields['oldPrice'] = oldPrice;
      request.fields['description'] =
          description;
      request.fields['category'] =
          category;

      // WEB
      if (kIsWeb) {

        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            image as Uint8List,
            filename: imageName,
          ),
        );

      }

      // MOBILE
      else {

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            (image as File).path,
          ),
        );
      }

      var response = await request.send();

      var responseData =
          await response.stream.bytesToString();

      print(
        "ADD STATUS = ${response.statusCode}",
      );

      print(
        "ADD BODY = $responseData",
      );

      if (responseData.isEmpty) {

        if (response.statusCode == 201) {

          return {
            "success": true,
          };
        }

        return {
          "success": false,
          "message": "Empty response",
        };
      }

      final data = jsonDecode(responseData);

      if (response.statusCode == 201) {

        return {
          "success": true,
          "product": data,
        };

      } else {

        return {
          "success": false,
          "message":
              data["message"] ?? "Error",
        };
      }

    } catch (e) {

      print("ADD PRODUCT ERROR = $e");

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  // ✏️ UPDATE PRODUCT
  static Future<Map<String, dynamic>>
      updateProduct(
    String token,
    int id,
    String name,
    String price,
    String oldPrice,
    String description,
    String category,
  ) async {

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
        }),
      );

      print(
        "UPDATE STATUS = ${response.statusCode}",
      );

      print(
        "UPDATE BODY = ${response.body}",
      );

      if (response.body.isEmpty) {

        if (response.statusCode == 200) {

          return {
            "success": true,
          };
        }

        return {
          "success": false,
          "message": "Empty response",
        };
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return {
          "success": true,
          "product": data,
        };

      } else {

        return {
          "success": false,
          "message":
              data["message"] ??
              "Update failed",
        };
      }

    } catch (e) {

      print("UPDATE PRODUCT ERROR = $e");

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  // 🗑 DELETE PRODUCT
  static Future<bool> deleteProduct(
    String token,
    int id,
  ) async {

    try {

      final response = await http.delete(
        Uri.parse("$baseUrl/products/$id"),

        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print(
        "DELETE STATUS = ${response.statusCode}",
      );

      print(
        "DELETE BODY = ${response.body}",
      );

      return response.statusCode == 200;

    } catch (e) {

      print("DELETE ERROR = $e");

      return false;
    }
  }
  // ================= CLIENT RESERVATIONS =================

static Future<Map<String, dynamic>>
    getClientReservations(
  int clientId,
) async {

  try {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/client-reservations/$clientId",
      ),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {

      return {
        "success": true,
        "reservations":
            data["reservations"] ?? [],
      };

    } else {

      return {
        "success": false,
        "message":
            data["message"] ??
            "Failed to load reservations",
      };
    }

  } catch (e) {

    return {
      "success": false,
      "message": e.toString(),
    };
  }
}
// ================= GET PENDING STORES =================

static Future<Map<String, dynamic>>
getPendingStores() async {

  try {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/admin/pending-stores",
      ),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {

      return {
        "success": true,
        "stores": data["stores"],
      };

    } else {

      return {
        "success": false,
      };
    }

  } catch (e) {

    return {
      "success": false,
    };
  }
}


// ================= VALIDATE STORE =================

static Future<bool>
validateStore(
  int id,
) async {

  try {

    final response = await http.put(
      Uri.parse(
        "$baseUrl/admin/validate-store/$id",
      ),
    );

    return response.statusCode == 200;

  } catch (e) {

    return false;
  }
}

// ================= UPDATE PROFILE =================

static Future<Map<String, dynamic>>
updateProfile(
  int id,
  String role,
  String name,
  String email,
  String num, {
  String? categorie,
  String? localisation,
}) async {

  try {

    final response = await http.put(

      Uri.parse(
        "$baseUrl/auth/update-profile",
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "id": id,
        "role": role,
        "name": name,
        "email": email,
        "num": num,
        "categorie": categorie,
        "localisation": localisation,
      }),
    );

    print(
      "UPDATE PROFILE STATUS = ${response.statusCode}",
    );

    print(
      "UPDATE PROFILE BODY = ${response.body}",
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {

      return {
        "success": true,
        "user": data["user"],
      };

    } else {

      return {
        "success": false,
        "message":
            data["message"],
      };
    }

  } catch (e) {

    print(
      "UPDATE PROFILE ERROR = $e",
    );

    return {
      "success": false,
      "message": e.toString(),
    };
  }
}

}