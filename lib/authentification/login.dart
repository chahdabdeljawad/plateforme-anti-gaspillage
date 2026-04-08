import 'package:flutter/material.dart';
import 'registre.dart'; // path to registre.dart

class LoginPage extends StatefulWidget {
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

      if ((user == 'test@example.com' || user == '1234567890') && password == '1234') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email/number or password')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _userController,
                decoration: InputDecoration(labelText: 'Email or Phone Number', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Enter email or phone' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _login, child: Text('Login')),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrePage()));
                },
                child: Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}