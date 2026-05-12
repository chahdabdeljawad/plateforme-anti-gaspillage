import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../screens/addproductpage.dart';
import '../lang.dart';
import 'package:provider/provider.dart';

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

    if (result["success"] == true) {
      final user = result["data"]["user"];

      setState(() {
        name = (user["name"] ?? "").toString();
        email = (user["email"] ?? "").toString();
        role = (user["role"] ?? "").toString();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    final safeRole = role.isEmpty ? widget.role : role;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              // PROFILE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFF0A3B2A),
                      backgroundImage: AssetImage(
                        safeRole == "store"
                            ? 'assets/how1.png'
                            : 'assets/how4.png',
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        color: Color(0xFF0A3B2A),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      email,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A3B2A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        safeRole.isNotEmpty ? safeRole.toUpperCase() : "USER",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // STORE SECTION
              if (safeRole == "store") ...[
                _buildSectionTitle(lang.t("my_store")),

                const SizedBox(height: 16),

                _buildStoreCard('assets/how2.png', "Product 1"),
                const SizedBox(height: 12),
                _buildStoreCard('assets/how3.png', "Product 2"),
              ],


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

              // CLIENT SECTION
              if (safeRole == "client") ...[
                _buildSectionTitle(lang.t("comments")),

                const SizedBox(height: 16),

                _buildCommentCard(lang.t("good_person")),
                const SizedBox(height: 12),
                _buildCommentCard(lang.t("trusted_client")),
              ],

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onLogout,
                  icon: const Icon(Icons.logout),
                  label: Text(lang.t("logout")),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3B2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
          color: Color(0xFF0A3B2A),
        ),
      ),
    );
  }

  Widget _buildStoreCard(String image, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(image, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Color(0xFF0A3B2A),
        ),
      ),
    );
  }

  Widget _buildCommentCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
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

          const Icon(Icons.comment, color: Color(0xFF0A3B2A)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),

        ],
      ),
    );
  }
}
