import 'package:flutter/material.dart';
import 'authentification/login.dart';
import 'authentification/registre.dart';
import 'components/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🎨 Global Theme (SMOOTH UI)
      theme: ThemeData(
        primaryColor: const Color(0xFF00A082), // 💚 main green
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),

        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      // 🚀 Start page
      initialRoute: '/home',

      // 🔗 Routes (VERY IMPORTANT)
      routes: {
        '/login': (context) => LoginPage(onLoginSuccess: (role) {}),
        '/register': (context) => RegistrePage(),
        '/home': (context) => CustomNavbar(),
      },
    );
  }
}
