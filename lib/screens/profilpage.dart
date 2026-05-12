import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../screens/addproductpage.dart';

class ProfilePage extends StatefulWidget {
  final String role;
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.role, required this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  String role = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    final result = await ApiService.getProfile(token);

    if (result["success"]) {
      final user = result["data"]["user"];

      setState(() {
        name = user["name"];
        email = user["email"];
        role = user["role"];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 👤 Avatar
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(
              role == "store" ? 'assets/how1.png' : 'assets/how4.png',
            ),
          ),

          const SizedBox(height: 16),

          // 👤 Name
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // 📧 Email
          Text(email),

          const SizedBox(height: 8),

          // 🎭 Role
          Text(role.toUpperCase(), style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 20),

          // 🏪 STORE UI
          if (role == "store") ...[
            const Text("My Store", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            ListTile(
              leading: Image.asset('assets/how2.png', width: 50),
              title: const Text("Product 1"),
            ),
            ListTile(
              leading: Image.asset('assets/how3.png', width: 50),
              title: const Text("Product 2"),
            ),
            const SizedBox(height: 20),

ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF0A3B2A),
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 55),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddProductPage(),
      ),
    );
  },
  icon: const Icon(Icons.add_business),
  label: const Text(
    "Add Product",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),
          ],

          // 👤 CLIENT UI
          if (role == "client") ...[
            const Text("Comments", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text("Great person 👍"),
            ),
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text("Trusted client 💯"),
            ),
          ],

          const SizedBox(height: 30),

          // 🚪 Logout
          ElevatedButton(
            onPressed: widget.onLogout,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
