import 'package:flutter/material.dart';
import '../components/footer.dart';

class ProfilePage extends StatelessWidget {
  final String role;
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.role, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    if (role == 'Store') {
      return StoreProfile();
    } else {
      return ClientProfile();
    }
  }
}

class StoreProfile extends StatelessWidget {
  const StoreProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/how1.jpg'),
            ),
          ),
          SizedBox(height: 16),

          Text(
            "My Store",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8),
          Text("This is my store description"),

          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              Text(" 4.5"),
            ],
          ),

          SizedBox(height: 20),
          Text("Products", style: TextStyle(fontSize: 18)),

          SizedBox(height: 10),

          ListTile(
            leading: Image.asset('assets/how2.jpg', width: 50),
            title: Text("Product 1"),
          ),

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
            ),
          ),
        ],
      ),
    );
  }
}

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
