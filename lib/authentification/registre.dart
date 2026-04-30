import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../lang.dart';

class RegistrePage extends StatefulWidget {
  const RegistrePage({super.key});

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  String role = "client";
  bool isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match ❌")));
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.register(
      nameController.text.trim(),
      emailController.text.trim().toLowerCase(),
      passwordController.text,
      role,
    );

    setState(() => isLoading = false);

    if (result["success"]) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup Successful ✅")));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),

      appBar: AppBar(
        title: Text(
          lang.t("create_account"),
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A3B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    lang.t("join_us"),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      color: Color(0xFF0A3B2A),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FULL NAME
                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration(lang.t("full_name")),
                    validator: (value) => value == null || value.isEmpty
                        ? lang.t("required_field")
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration(lang.t("email")),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains("@")
                        ? lang.t("invalid_email")
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // PASSWORD
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: _inputDecoration(lang.t("password")),
                    validator: (value) => value != null && value.length >= 4
                        ? null
                        : lang.t("weak_password"),
                  ),

                  const SizedBox(height: 16),

                  // CONFIRM PASSWORD
                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: _inputDecoration(lang.t("confirm_password")),
                    validator: (value) => value == null || value.isEmpty
                        ? lang.t("required_field")
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // ROLE
                  DropdownButtonFormField<String>(
                    value: role,
                    items: [
                      DropdownMenuItem(
                        value: "client",
                        child: Text(lang.t("client")),
                      ),
                      DropdownMenuItem(
                        value: "store",
                        child: Text(lang.t("store")),
                      ),
                    ],
                    onChanged: (val) => setState(() => role = val!),
                    decoration: _inputDecoration(lang.t("role")),
                  ),

                  const SizedBox(height: 30),

                  // BUTTON
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A3B2A),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(lang.t("signup")),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF0A3B2A), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
