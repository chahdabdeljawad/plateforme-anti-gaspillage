import 'dart:ui';
import 'package:flutter/material.dart';

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                title: const Text(
                  "ZeroGaspi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: "Home"),
                    Tab(text: "Categories"),
                    Tab(text: "About"),
                    Tab(text: "Profile"),
                  ],
                ),
              ),
            ),
          ),
        ),

        body: TabBarView(
          children: [
            HomePage(),
            CategoriesPage(),
            AboutPage(),

            isLoggedIn
                ? ProfilePage(role: userRole, onLogout: logout)
                : LoginPage(onLoginSuccess: loginSuccess),
          ],
        ),
      ),
    );
  }
}
