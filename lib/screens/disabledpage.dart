import 'package:flutter/material.dart';
import '../components/navbar.dart';

class DisabledPage extends StatelessWidget {
  const DisabledPage
({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Welcome to the Home Page!"),
    );
  }
}