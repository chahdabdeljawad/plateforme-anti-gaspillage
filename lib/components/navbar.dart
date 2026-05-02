import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lang.dart';
import '../screens/homepage.dart';
import '../screens/profilpage.dart';
import '../screens/about.dart';
import '../screens/categoriespage.dart';
import '../authentification/login.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  bool isLoggedIn = false;
  String userRole = 'Client';

  void loginSuccess(String role) {
    setState(() {
      isLoggedIn = true;
      userRole = role;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
      userRole = 'Client';
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(95),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  "ZeroGaspi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.language, color: Colors.black),
                    onSelected: (value) => lang.changeLang(value),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: "fr", child: Text("Français")),
                      PopupMenuItem(value: "en", child: Text("English")),
                      PopupMenuItem(value: "ar", child: Text("العربية")),
                    ],
                  ),
                ],
                bottom: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(text: lang.t("home")),
                    Tab(text: lang.t("categories")),
                    Tab(text: lang.t("about")),
                    Tab(text: lang.t("profile")),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const HomePage(),
            const CategoriesPage(),
            const AboutPage(),
            isLoggedIn
                ? ProfilePage(role: userRole, onLogout: logout)
                : LoginPage(onLoginSuccess: loginSuccess),
          ],
        ),
      ),
    );
  }
}
