import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: brand and tagline
          const Text(
            "GLYPHS",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Make Things You Love",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),

          // Footer columns (responsive grid)
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                // Mobile: wrap into two rows
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFooterColumn("FEATURES", [
                          "Create",
                          "Produce",
                          "Extend",
                        ]),
                        _buildFooterColumn("GLYPHS", [
                          "Learn",
                          "Tools",
                          "Buy",
                          "EULA",
                        ]),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFooterColumn("COMMUNITY", [
                          "Forum",
                          "Events",
                          "News",
                          "Resources",
                        ]),
                        _buildFooterColumn("ABOUT", [
                          "Contact",
                          "Press",
                          "Privacy",
                          "VPAT",
                        ]),
                      ],
                    ),
                  ],
                );
              } else {
                // Desktop: all columns in one row
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFooterColumn("FEATURES", [
                      "Create",
                      "Produce",
                      "Extend",
                    ]),
                    _buildFooterColumn("GLYPHS", [
                      "Learn",
                      "Tools",
                      "Buy",
                      "EULA",
                    ]),
                    _buildFooterColumn("COMMUNITY", [
                      "Forum",
                      "Events",
                      "News",
                      "Resources",
                    ]),
                    _buildFooterColumn("ABOUT", [
                      "Contact",
                      "Press",
                      "Privacy",
                      "VPAT",
                    ]),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 48),

          // Divider
          const Divider(color: Colors.black12, thickness: 1),

          const SizedBox(height: 24),

          // Bottom text (typography + copyright)
          const Text(
            "The text of this website is composed in ABC Arizona, a sans-to-serif variable font courtesy of ABC Dinamo. Cyrillic text set in Accia by Mint Type.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "© 2026 Glyphs. All rights reserved.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}