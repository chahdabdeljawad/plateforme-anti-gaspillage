import 'package:flutter/material.dart';
import '../screens/homepage.dart';
import '../screens/profilpage.dart';
import '../screens/about.dart';
import '../screens/categoriespage.dart';


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
              Tab(text: "categories"),
              Tab(text: "about"),
              Tab(text: "Profile"),
            ],
          ),
        ),
          body: TabBarView(
            children: [
                    HomePage(),
                    CategoriesPage(),
                    AboutPage(),
                    ProfilePage(),
                    ],
        ),
      ),
    );
  }
}