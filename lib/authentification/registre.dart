import 'package:flutter/material.dart';
import '../style/authantification/login_style.dart';

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
      backgroundColor: LoginStyle.background,

      appBar: AppBar(
        backgroundColor: LoginStyle.primaryGreen,
        title: const Text("Create Account"),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: LoginStyle.cardDecoration,

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: 60,
                  color: LoginStyle.primaryGreen,
                ),

                const SizedBox(height: 10),

                const Text("Join Us 🌱", style: LoginStyle.title),

                const SizedBox(height: 20),

                // 👤 FULL NAME
                TextFormField(
                  controller: _fullNameController,
                  decoration: LoginStyle.inputDecoration(
                    "Full Name",
                    Icons.person,
                  ),
                ),

                const SizedBox(height: 16),

                // 📧 EMAIL
                TextFormField(
                  controller: _emailController,
                  decoration: LoginStyle.inputDecoration(
                    "Email",
                    Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 16),

                // 📱 PHONE
                TextFormField(
                  controller: _phoneController,
                  decoration: LoginStyle.inputDecoration("Phone", Icons.phone),
                ),

                const SizedBox(height: 16),

                // 🔒 PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: LoginStyle.inputDecoration(
                    "Password",
                    Icons.lock_outline,
                  ),
                ),

                const SizedBox(height: 16),

                // 🔒 CONFIRM PASSWORD
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: LoginStyle.inputDecoration(
                    "Confirm Password",
                    Icons.lock_outline,
                  ),
                ),

                const SizedBox(height: 16),

                // 👥 ROLE SELECT
                DropdownButtonFormField<String>(
                  initialValue: _role,
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
                  decoration: LoginStyle.inputDecoration(
                    "Role",
                    Icons.work_outline,
                  ),
                ),

                const SizedBox(height: 25),

                // 🔘 SIGN UP BUTTON
                ElevatedButton(
                  onPressed: _signup,
                  style: LoginStyle.buttonStyle,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
