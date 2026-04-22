import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lang.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    return Directionality(
      textDirection: lang.current == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Container(
        color: const Color(0xFF0A3B2A),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ZEROGASPI",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              lang.t("footer_tagline"),
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 800;
                return isMobile
                    ? Column(children: _buildColumns(lang))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _buildColumns(lang),
                      );
              },
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.white24),
            const SizedBox(height: 20),
            Text(
              lang.t("footer_mission"),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "© 2026 Zerogaspi. All rights reserved.",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColumns(Lang lang) {
    return [
      _col(lang, lang.t("footer_platform"), [
        "footer_how_it_works",
        "footer_browse_food",
        "footer_donate_food",
      ]),
      _col(lang, lang.t("footer_impact"), [
        "footer_our_mission",
        "footer_statistics",
        "footer_sustainability",
      ]),
      _col(lang, lang.t("footer_community"), [
        "footer_events",
        "footer_partners",
        "footer_volunteers",
        "footer_stories",
      ]),
      _col(lang, lang.t("footer_support"), [
        "footer_contact",
        "footer_faq",
        "footer_privacy",
        "footer_terms",
      ]),
    ];
  }

  Widget _col(Lang lang, String title, List<String> itemKeys) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...itemKeys.map(
            (key) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                lang.t(key),
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
