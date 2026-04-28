import 'package:flutter/material.dart';

class RegistrePage extends StatefulWidget {
  const RegistrePage({super.key});

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _role = 'Client';

  void _signup() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signup Successful!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // beige background
      appBar: AppBar(
        title: const Text(
          "Create Account",
          style: TextStyle(
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
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Join Us ",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                    color: Color(0xFF0A3B2A),
                  ),
                ),
                const SizedBox(height: 20),
                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: _inputDecoration("Full Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Full name required" : null,
                ),
                const SizedBox(height: 16),
                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? "Email required" : null,
                ),
                const SizedBox(height: 16),
                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration("Phone"),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? "Phone number required" : null,
                ),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration("Password"),
                  validator: (value) =>
                      value!.length < 4 ? "Password too short" : null,
                ),
                const SizedBox(height: 16),
                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: _inputDecoration("Confirm Password"),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Role dropdown
                DropdownButtonFormField<String>(
                  value: _role,
                  items: const [
                    DropdownMenuItem(value: 'Client', child: Text('Client')),
                    DropdownMenuItem(value: 'Deliver', child: Text('Deliver')),
                    DropdownMenuItem(value: 'Store', child: Text('Store')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                  decoration: _inputDecoration("Role"),
                ),
                const SizedBox(height: 30),
                // Sign Up button
                ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3B2A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
                ),
              ],
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
      enabledBorder: OutlineInputBorder(
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
