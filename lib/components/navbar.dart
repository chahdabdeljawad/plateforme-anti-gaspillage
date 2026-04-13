import 'package:flutter/material.dart';
import '../screens/homepage.dart';
import '../screens/profilpage.dart';
import '../screens/about.dart';
import '../screens/disabledpage.dart';


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
          body: TabBarView(
            children: [
                    HomePage(),
                    ProfilePage(),
                    AboutPage(),
                    DisabledPage(),
                    ],
        ),
      ),
    );
  }
}