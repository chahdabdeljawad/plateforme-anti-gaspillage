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

  //  baseUrl dynamique
  String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:5000"; // 🌐 WEB
    } else {
      return "http://192.168.1.5:5000"; // 📱 téléphone + emulator
    }
  }

  Future<void> loginAdmin() async {
    //  validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Remplir tous les champs")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/admin/login"),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      print("RESPONSE: $data"); 

      if (data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Admin réussi ✅")),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur serveur ❌")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("Admin Login"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.admin_panel_settings,
                      size: 80, color: Colors.green),
                  const SizedBox(height: 20),

                  const Text(
                    "Admin Panel",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // 📧 Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔒 Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //  Button
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loginAdmin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 16),
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