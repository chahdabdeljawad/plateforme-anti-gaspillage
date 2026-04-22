import 'package:flutter/material.dart';
import 'registre.dart';
import '../style/authantification/login_style.dart';
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
      backgroundColor: LoginStyle.background,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: LoginStyle.cardDecoration,

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.eco, size: 60, color: LoginStyle.primaryGreen),

                      const SizedBox(height: 10),

                      const Text("Welcome Back", style: LoginStyle.title),

                      const SizedBox(height: 6),

                      Text(
                        "Login to continue saving food 🌱",
                        style: LoginStyle.subtitle,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 25),

                      TextFormField(
                        controller: _userController,
                        decoration: LoginStyle.inputDecoration(
                          "Email or Phone Number",
                          Icons.person_outline,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: LoginStyle.inputDecoration(
                          "Password",
                          Icons.lock_outline,
                        ),
                      ),

                      const SizedBox(height: 25),

                      ElevatedButton(
                        onPressed: _login,
                        style: LoginStyle.buttonStyle,
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegistrePage()),
                          );
                        },
                        child: Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: LoginStyle.primaryGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const AppFooter(), // ✅ NOW IT WORKS
            ],
          ),
        ),
      ),
    );
  }
}
