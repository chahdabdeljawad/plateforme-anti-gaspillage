import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../screens/admindashboard.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  // 🌐 Base URL
  String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000";
    } else {
      return "http://192.168.1.5:5000";
    }
  }

  Future<void> loginAdmin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/admin/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      print("RESPONSE: $data");

      if (data["success"] != null && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Admin login successful ✅")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login failed ❌")),
        );
      }
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Server error ❌")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface, // ✅ Dynamic
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: colors.surface, // ✅ Dynamic
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 👤 ADMIN ICON
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.primary, // ✅ Dynamic
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: colors.onPrimary, // ✅ Dynamic
                      size: 55,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // TITLE
                  Text(
                    "Admin Panel",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      color: colors.primary, // ✅ Dynamic
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Login to manage the platform",
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.5), // ✅ Dynamic
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // 📧 EMAIL FIELD
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: colors.onSurface), // ✅ Dynamic
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: colors.onSurface.withOpacity(0.4),
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: colors.primary, // ✅ Dynamic
                      ),
                      filled: true,
                      fillColor: colors.surface, // ✅ Dynamic
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: colors.primary,
                          width: 2,
                        ), // ✅ Dynamic
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 🔒 PASSWORD FIELD
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: TextStyle(color: colors.onSurface), // ✅ Dynamic
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: TextStyle(
                        color: colors.onSurface.withOpacity(0.4),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: colors.primary, // ✅ Dynamic
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: colors.primary, // ✅ Dynamic
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: colors.surface, // ✅ Dynamic
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: colors.primary,
                          width: 2,
                        ), // ✅ Dynamic
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🚀 LOGIN BUTTON
                  isLoading
                      ? CircularProgressIndicator(
                          color: colors.primary,
                        ) // ✅ Dynamic
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loginAdmin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary, // ✅ Dynamic
                              foregroundColor: colors.onPrimary, // ✅ Dynamic
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
