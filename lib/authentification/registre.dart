import 'package:flutter/material.dart';

class RegistrePage extends StatefulWidget {
  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _role = 'Client';

  void _signup() {
    if (_formKey.currentState!.validate()) {
      String fullName = _fullNameController.text.trim();
      String email = _emailController.text.trim();
      String phone = _phoneController.text.trim();
      String password = _passwordController.text;
      String role = _role;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Signup Successful!\nName: $fullName\nEmail: $email\nPhone: $phone\nRole: $role')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup Page')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter valid email';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter phone';
                  if (!RegExp(r'^\d+$').hasMatch(value)) return 'Enter valid phone';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter password';
                  if (value.length < 4) return 'Password too short';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
                validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _role,
                items: ['Client', 'Deliver'].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                onChanged: (value) => setState(() => _role = value!),
                decoration: InputDecoration(labelText: 'Select Role', border: OutlineInputBorder()),
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _signup, child: Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}