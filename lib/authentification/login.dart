import 'package:flutter/material.dart';
import 'registre.dart';

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

    // 👤 CLIENT ACCOUNT
    if ((user == 'test@example.com' || user == '1234567890') &&
        password == '1234') {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client Login Successful!')),
      );

      widget.onLoginSuccess('Client');
    }

    // 🏪 STORE ACCOUNT
    else if (user == 'store@example.com' && password == '1234') {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store Login Successful!')),
      );

      widget.onLoginSuccess('Store');
    }

    // ❌ WRONG LOGIN
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid email/number or password')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'Email or Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter email or phone'
                        : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter password'
                        : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrePage(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}