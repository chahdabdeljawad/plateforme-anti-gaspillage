import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../lang.dart';
import 'loginadmin.dart';

class LoginPage extends StatefulWidget {
  final Function(String) onLoginSuccess;
  final VoidCallback onSignUp; // ✅ Add this

  const LoginPage({
    super.key,
    required this.onLoginSuccess,
    required this.onSignUp,
  });

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

      widget.onLoginSuccess(role);
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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
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
                      Text(
                        lang.t("welcome_back"),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                          color: colors.primary,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        lang.t("login_subtitle"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.onSurface.withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // EMAIL
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: lang.t("email"),
                          labelStyle: TextStyle(
                            color: colors.onSurface.withOpacity(0.6),
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: colors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: TextStyle(color: colors.onSurface),
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
                          labelStyle: TextStyle(
                            color: colors.onSurface.withOpacity(0.6),
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: colors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: TextStyle(color: colors.onSurface),
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
                          ? CircularProgressIndicator(color: colors.primary)
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(lang.t("login")),
                            ),

                      TextButton(
                        onPressed: widget
                            .onSignUp, // ✅ Uses callback (no Navigator.push)
                        child: Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: colors.primary),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
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
