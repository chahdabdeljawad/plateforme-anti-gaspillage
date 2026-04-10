import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My App"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Home"),
              Tab(text: "Profile"),
              Tab(text: "Contact"),
              Tab(text: "Disabled"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("Home Page")),
            Center(child: Text("Profile Page")),
            Center(child: Text("Contact Page")),
            Center(child: Text("Disabled Page")),
          ],
        ),
      ),
    );
  }
}