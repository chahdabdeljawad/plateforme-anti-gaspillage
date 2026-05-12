import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'registre.dart';
import '../lang.dart';
import 'loginadmin.dart';
import '../screens/addproductpage.dart';


class LoginPage extends StatefulWidget {
  final Function(String) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await ApiService.login(
      emailController.text.trim().toLowerCase(),
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (result["success"]) {
      final data = result["data"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      await prefs.setString("role", data["user"]["role"]);
      await prefs.setString("email", data["user"]["email"]);

      String role = data["user"]["role"];

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Successful ✅")));

      //widget.onLoginSuccess(role);
      if (role == "store") {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const AddProductPage(),
    ),
  );
} else {
  widget.onLoginSuccess(role);
}
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lang.t("welcome_back"),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                          color: Color(0xFF0A3B2A),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        lang.t("login_subtitle"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // EMAIL
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: lang.t("email"),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
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
                            return lang.t("required_field");
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: lang.t("password"),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
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
                            return lang.t("required_field");
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // BUTTON
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A3B2A),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(lang.t("login")),
                            ),
                     
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegistrePage(),
                            ),
                          );
                        },
                        child: const Text("Don't have an account? Sign Up"),
                      ),

                       const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginAdminPage(),
                            ),
                          );
                        },
                        child: const Text("Login as Admin"),
                      ),
                      const SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
