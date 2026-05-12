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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450),

              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: Colors.white,

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
                      color: const Color(0xFF0A3B2A),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // TITLE
                  const Text(
                    "Admin Panel",

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      color: Color(0xFF0A3B2A),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Login to manage the platform",

                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),

                  const SizedBox(height: 35),

                  // 📧 EMAIL FIELD
                  TextField(
                    controller: emailController,

                    decoration: InputDecoration(
                      hintText: "Enter your email",

                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF0A3B2A),
                      ),

                      filled: true,
                      fillColor: const Color(0xFFF8F8F8),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),

                        borderSide: const BorderSide(
                          color: Color(0xFF0A3B2A),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 🔒 PASSWORD FIELD
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,

                    decoration: InputDecoration(
                      hintText: "Enter your password",

                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF0A3B2A),
                      ),

                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF0A3B2A),
                        ),

                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),

                      filled: true,
                      fillColor: const Color(0xFFF8F8F8),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),

                        borderSide: const BorderSide(
                          color: Color(0xFF0A3B2A),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🚀 LOGIN BUTTON
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF0A3B2A),
                        )
                      : SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: loginAdmin,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A3B2A),

                              foregroundColor: Colors.white,

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
