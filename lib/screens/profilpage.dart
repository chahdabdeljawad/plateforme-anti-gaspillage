import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../components/footer.dart';
=======
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
>>>>>>> 37fb43df02eb5bf293820a257a8a83de675a95bc

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

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

    final result = await ApiService.getProfile(token!);

    if (result["success"]) {
      final user = result["data"]["user"];

      setState(() {
        name = user["name"];
        email = user["email"];
        role = user["role"];
        isLoading = false;
      });
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
          // 👤 IMAGE
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(
              role == "store"
                  ? 'assets/how1.jpg'
                  : 'assets/how4.jpg',
            ),
          ),

          const SizedBox(height: 16),

          // 👤 NAME
          Text(
            name,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // 📧 EMAIL
          Text(email),

          const SizedBox(height: 8),

          // 🎭 ROLE
          Text(
            role.toUpperCase(),
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          // ⭐ STORE UI
          if (role == "store") ...[
            const Text("My Store",
                style: TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

<<<<<<< HEAD
          ListTile(
            leading: Image.asset('assets/how3.jpg', width: 50),
            title: Text("Product 2"),
          ),
          SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: Text("Logout"),
=======
            ListTile(
              leading: Image.asset('assets/how2.jpg', width: 50),
              title: const Text("Product 1"),
>>>>>>> 37fb43df02eb5bf293820a257a8a83de675a95bc
            ),

            ListTile(
              leading: Image.asset('assets/how3.jpg', width: 50),
              title: const Text("Product 2"),
            ),
          ],

          // 💬 CLIENT UI
          if (role == "client") ...[
            const Text("Comments",
                style: TextStyle(fontSize: 18)),

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

          // 🚪 LOGOUT
          ElevatedButton(
            onPressed: widget.onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Logout"),
          )
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class ClientProfile extends StatelessWidget {
  final List<String> comments = const [
    "Great person 👍",
    "Very kind!",
    "Trusted client 💯",
  ];

  const ClientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),

        CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/how4.jpg'),
        ),

        SizedBox(height: 10),

        Text(
          "Client Name",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 20),

        Text("Comments", style: TextStyle(fontSize: 18)),

        Expanded(
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.comment),
                title: Text(comments[index]),
              );
            },
          ),
        ),
        SizedBox(height: 20),

        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            child: Text("Logout"),
          ),
        ),
        const AppFooter(),
      ],
    );
  }
}
=======
>>>>>>> 37fb43df02eb5bf293820a257a8a83de675a95bc
