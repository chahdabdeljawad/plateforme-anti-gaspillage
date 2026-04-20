import 'package:flutter/material.dart';
import '../components/footer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../style/screens/homepage_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // =======================
            // HERO
            // =======================
            Stack(
              children: [
                Container(
                  height: 750,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/hero.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 750,
                  width: double.infinity,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
                SizedBox(
                  height: 750,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "SAVE THE PLANET",
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
            // ABOUT
            // =======================
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "ZeroGaspi is a social impact company on a mission to inspire and empower everyone to fight food waste together.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Our app is a marketplace for surplus food. We help users rescue good food from going to waste.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // =======================
            // WHY USE
            // =======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "WHY USE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),

                  const SizedBox(height: 20),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600
                          ? 4
                          : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _benefits.length,
                    itemBuilder: (context, index) {
                      return _buildBenefitCard(_benefits[index]);
                    },
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {},
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
                    ),
                    child: const Text("Find food near me →"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // =======================
            // HOW IT WORKS (CAROUSEL)
            // =======================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("HOW IT WORKS", style: HomePageStyle.aboutTitle),

                  const SizedBox(height: 20),

                  CarouselSlider(
                    options: CarouselOptions(
                      height: 220,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                    ),
                    items: [
                      _buildSlide("assets/how1.jpg", "Download the app"),
                      _buildSlide("assets/how2.jpg", "Find nearby stores"),
                      _buildSlide("assets/how3.jpg", "Reserve your food bag"),
                      _buildSlide("assets/how4.jpg", "Pick it up & enjoy"),
                    ],
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

  // =======================
  // DATA
  // =======================
  static const List<_Benefit> _benefits = [
    _Benefit(
      icon: '🍽️',
      title: 'ENJOY GOOD FOOD',
      description: 'Surprise bags at low price.',
    ),
    _Benefit(
      icon: '📍',
      title: 'NEAR YOU',
      description: 'Find food around you.',
    ),
    _Benefit(
      icon: '🌱',
      title: 'SAVE THE PLANET',
      description: 'Reduce food waste.',
    ),
    _Benefit(
      icon: '🍰',
      title: 'DISCOVER FOOD',
      description: 'Try new places.',
    ),
  ];

  // =======================
  // CARD
  // =======================
  Widget _buildBenefitCard(_Benefit benefit) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(benefit.icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              benefit.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              benefit.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================
// MODEL
// =======================
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

// =======================
// CAROUSEL WIDGET
// =======================
Widget _buildSlide(String image, String text) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(image, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 15,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
