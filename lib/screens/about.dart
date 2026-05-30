import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/footer.dart';
import '../lang.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final colors = Theme.of(context).colorScheme;
    final isRtl = lang.current == "ar";

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          title: Text(
            lang.t("about_title"),
            style: const TextStyle(fontFamily: 'PlayfairDisplay'),
          ),
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section
              Container(
                height: 280,
                width: double.infinity,
                color: colors.primary,
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
                        style: TextStyle(
                          fontSize: 18,
                          color: colors.onPrimary.withOpacity(0.7),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.t("about_mission_title"),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        height: 1.2,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.t("about_mission_text"),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          lang.t("about_stat_meals_value"),
                          lang.t("about_stat_meals"),
                          colors,
                        ),
                        _buildStatCard(
                          lang.t("about_stat_stores_value"),
                          lang.t("about_stat_stores"),
                          colors,
                        ),
                        _buildStatCard(
                          lang.t("about_stat_co2_value"),
                          lang.t("about_stat_co2"),
                          colors,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(
                thickness: 1,
                indent: 24,
                endIndent: 24,
                color: colors.onSurface.withOpacity(0.12),
              ),

              // Story section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.t("about_story_label"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang.t("about_story_title"),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.t("about_story_text1"),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.t("about_story_text2"),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // How it works section
              Container(
                color: colors.surface,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      lang.t("about_how_label"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
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
                          colors,
                        ),
                        _buildStepCard(
                          "2",
                          lang.t("about_step2_title"),
                          lang.t("about_step2_desc"),
                          colors,
                        ),
                        _buildStepCard(
                          "3",
                          lang.t("about_step3_title"),
                          lang.t("about_step3_desc"),
                          colors,
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

  Widget _buildStatCard(String number, String label, ColorScheme colors) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: colors.onSurface),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    String stepNumber,
    String title,
    String description,
    ColorScheme colors,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: colors.primary.withOpacity(0.1),
              child: Text(
                stepNumber,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
