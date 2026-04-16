import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // =======================
            // SECTION 1 - HERO
            // =======================
            Stack(
              children: [
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/hero.jpg"), // 👈 replace with video later
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  height: 500,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),

                SizedBox(
                  height: 500,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "SAVE FOOD. SAVE THE PLANET.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                          ),
                          child: const Text("Download the App"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // =======================
            // SECTION 2 - ABOUT TEXT
            // =======================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  Text(
                    "Too Good To Go is a social impact company on a mission to inspire and empower everyone to fight food waste together.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Our app is the world's largest marketplace for surplus food. We help users rescue good food from going to waste, offering great value for money at local stores, cafes and restaurants.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // =======================
            // SECTION 3 - FEATURES
            // =======================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "WHY USE",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "Too Good To Go",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),

                  const SizedBox(height: 30),

                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      FeatureBox(
                        title: "Save Money",
                        icon: Icons.shopping_bag,
                      ),
                      FeatureBox(
                        title: "Fight Waste",
                        icon: Icons.eco,
                      ),
                      FeatureBox(
                        title: "Local Food",
                        icon: Icons.store,
                      ),
                      FeatureBox(
                        title: "Great Deals",
                        icon: Icons.local_offer,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // =======================
            // SECTION 4 - HOW TO USE
            // =======================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [

                  // LEFT TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "HOW TO USE",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),

                        Text("1. Download the app"),
                        Text("2. Find nearby stores"),
                        Text("3. Reserve your food bag"),
                        Text("4. Pick it up and enjoy"),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // RIGHT IMAGE
                  Expanded(
                    child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/howto.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// =======================
// FEATURE BOX WIDGET
// =======================
class FeatureBox extends StatelessWidget {
  final String title;
  final IconData icon;

  const FeatureBox({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            