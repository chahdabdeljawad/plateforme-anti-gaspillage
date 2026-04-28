import 'package:flutter/material.dart';
import 'registre.dart';
import '../components/footer.dart';

class LoginPage extends StatefulWidget {
  final Function(String) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String user = _userController.text.trim();
      String password = _passwordController.text;

      if ((user == 'test@example.com' || user == '1234567890') &&
          password == '1234') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Client Login Successful!')),
        );
        widget.onLoginSuccess('Client');
      } else if (user == 'store@example.com' && password == '1234') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Store Login Successful!')),
        );
        widget.onLoginSuccess('Store');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email/number or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // beige background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                          color: Color(0xFF0A3B2A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Login to continue saving food ",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // Email/Phone field
                      TextFormField(
                        controller: _userController,
                        decoration: InputDecoration(
                          labelText: "Email or Phone Number",
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
                            borderSide: const BorderSide(
                              color: Color(0xFF0A3B2A),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email or phone";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
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
                            borderSide: const BorderSide(
                              color: Color(0xFF0A3B2A),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // Login button
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3B2A),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Sign up link
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegistrePage()),
                          );
                        },
                        child: Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(
                            color: const Color(0xFF0A3B2A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
