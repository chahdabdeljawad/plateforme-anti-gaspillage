import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/footer.dart';
import '../lang.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final isRtl = lang.current == "ar";

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F0E6),
        appBar: AppBar(
          title: Text(
            lang.t("about_title"),
            style: const TextStyle(fontFamily: 'PlayfairDisplay'),
          ),
          backgroundColor: const Color(0xFF0A3B2A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section (solid color – no missing image)
              Container(
                height: 280,
                width: double.infinity,
                color: const Color(0xFF0A3B2A),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang.t("about_hero_title"),
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        lang.t("about_hero_subtitle"),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Mission section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.t("about_mission_label"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A3B2A),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.t("about_mission_title"),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        height: 1.2,
                        color: Color(0xFF0A3B2A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.t("about_mission_text"),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 30),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          lang.t("about_stat_meals_value"),
                          lang.t("about_stat_meals"),
                        ),
                        _buildStatCard(
                          lang.t("about_stat_stores_value"),
                          lang.t("about_stat_stores"),
                        ),
                        _buildStatCard(
                          lang.t("about_stat_co2_value"),
                          lang.t("about_stat_co2"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 1, indent: 24, endIndent: 24),

              // Story section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.t("about_story_label"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A3B2A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.t("about_story_title"),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        color: Color(0xFF0A3B2A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.t("about_story_text1"),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.t("about_story_text2"),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),

              // How it works section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      lang.t("about_how_label"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A3B2A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStepCard(
                          "1",
                          lang.t("about_step1_title"),
                          lang.t("about_step1_desc"),
                        ),
                        _buildStepCard(
                          "2",
                          lang.t("about_step2_title"),
                          lang.t("about_step2_desc"),
                        ),
                        _buildStepCard(
                          "3",
                          lang.t("about_step3_title"),
                          lang.t("about_step3_desc"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const AppFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A3B2A),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(String stepNumber, String title, String description) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF0A3B2A).withValues(alpha: 0.1),
              child: Text(
                stepNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A3B2A),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0A3B2A),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
