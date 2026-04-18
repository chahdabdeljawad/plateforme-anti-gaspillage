import 'package:flutter/material.dart';
import '../components/footer.dart';

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
                      image: AssetImage("assets/hero.jpg"),
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
            // SECTION 3 - WHY USE (TOO GOOD TO GO STYLE)
            // =======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    "WHY USE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(text: "Too Good To Go"),
                        TextSpan(
                          text: " ✨",
                          style: TextStyle(
                            color: Colors.amber[700],
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 4,
                    color: Colors.green[700],
                  ),
                  const SizedBox(height: 30),

                  // Grid of TGTG-style benefit cards
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9, // adjust card height
                    ),
                    itemCount: _benefits.length,
                    itemBuilder: (context, index) {
                      final benefit = _benefits[index];
                      return _buildBenefitCard(benefit);
                    },
                  ),
                  const SizedBox(height: 30),

                  // CTA Button
                  ElevatedButton(
                    onPressed: () {
                      // Add your action (e.g., navigate to map)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Find food near me →",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // SECTION 4 - HOW TO USE (unchanged)
            // =======================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
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
            const AppFooter(),  
          ],
        ),
      ),
    );
  }

  // List of benefits (icons, titles, descriptions)
  final List<_Benefit> _benefits = const [
    _Benefit(
      icon: '🍽️',
      title: 'ENJOY GOOD FOOD AT ½ PRICE OR LESS',
      description: 'Surprise bags from local spots at a fraction of the cost.',
    ),
    _Benefit(
      icon: '📍',
      title: 'RESCUE FOOD NEAR YOU',
      description: 'Discover unsold meals that would otherwise go to waste.',
    ),
    _Benefit(
      icon: '🌱',
      title: 'HELP THE ENVIRONMENT BY REDUCING FOOD WASTE',
      description: 'Every rescued meal lowers CO₂ emissions and saves water.',
    ),
    _Benefit(
      icon: '🍰',
      title: 'TRY SOMETHING NEW FROM LOCAL CAFES, BAKERIES OR RESTAURANTS',
      description: 'Explore hidden gems and surprise your taste buds.',
    ),
  ];

  Widget _buildBenefitCard(_Benefit benefit) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              benefit.icon,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Text(
              benefit.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              benefit.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for benefit data
class _Benefit {
  final String icon;
  final String title;
  final String description;

  const _Benefit({
    required this.icon,
    required this.title,
    required this.description,
  });
}