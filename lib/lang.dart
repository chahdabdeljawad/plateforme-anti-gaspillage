import 'package:flutter/material.dart';

class Lang extends ChangeNotifier {
  String _current = "fr";

  String get current => _current;

  void changeLang(String lang) {
    if (_current == lang) return;
    _current = lang;
    notifyListeners();
  }

  final Map<String, Map<String, String>> _data = {
    "fr": {
      // Navbar
      "home": "Accueil",
      "categories": "Catégories",
      "about": "À propos",
      "profile": "Profil",

      // HomePage
      "save_planet": "SAUVER LA PLANÈTE",
      "about_small":
          "Notre application est un marché pour les surplus alimentaires.",
      "why_use": "POURQUOI UTILISER",
      "how_it_works": "COMMENT ÇA MARCHE",
      "download": "Téléchargez l'application",
      "find": "Trouvez des magasins proches",
      "reserve": "Réservez votre panier",
      "pickup": "Récupérez et profitez",

      // Footer
      "footer_tagline": "Réduisons le gaspillage alimentaire ensemble",
      "footer_platform": "Plateforme",
      "footer_how_it_works": "Comment ça marche",
      "footer_browse_food": "Parcourir la nourriture",
      "footer_donate_food": "Donner de la nourriture",
      "footer_impact": "Impact",
      "footer_our_mission": "Notre mission",
      "footer_statistics": "Statistiques",
      "footer_sustainability": "Durabilité",
      "footer_community": "Communauté",
      "footer_events": "Événements",
      "footer_partners": "Partenaires",
      "footer_volunteers": "Bénévoles",
      "footer_stories": "Histoires",
      "footer_support": "Support",
      "footer_contact": "Contact",
      "footer_faq": "FAQ",
      "footer_privacy": "Confidentialité",
      "footer_terms": "Conditions",
      "footer_mission":
          "Notre mission est de réduire le gaspillage alimentaire en connectant les commerces de proximité aux consommateurs.",
    },
    "en": {
      // Navbar
      "home": "Home",
      "categories": "Categories",
      "about": "About",
      "profile": "Profile",

      // HomePage
      "save_planet": "SAVE THE PLANET",
      "about_small": "Our app is a marketplace for surplus food.",
      "why_use": "WHY USE",
      "how_it_works": "HOW IT WORKS",
      "download": "Download app",
      "find": "Find nearby stores",
      "reserve": "Reserve your basket",
      "pickup": "Pick up and enjoy",

      // Footer
      "footer_tagline": "Reducing food waste together",
      "footer_platform": "Platform",
      "footer_how_it_works": "How it works",
      "footer_browse_food": "Browse food",
      "footer_donate_food": "Donate food",
      "footer_impact": "Impact",
      "footer_our_mission": "Our mission",
      "footer_statistics": "Statistics",
      "footer_sustainability": "Sustainability",
      "footer_community": "Community",
      "footer_events": "Events",
      "footer_partners": "Partners",
      "footer_volunteers": "Volunteers",
      "footer_stories": "Stories",
      "footer_support": "Support",
      "footer_contact": "Contact",
      "footer_faq": "FAQ",
      "footer_privacy": "Privacy",
      "footer_terms": "Terms",
      "footer_mission":
          "Our mission is to reduce food waste by connecting local stores with consumers.",
    },
    "ar": {
      // Navbar
      "home": "الرئيسية",
      "categories": "الفئات",
      "about": "حول",
      "profile": "الملف الشخصي",

      // HomePage
      "save_planet": "أنقذ الكوكب",
      "about_small": "تطبيقنا سوق للطعام الفائض.",
      "why_use": "لماذا تستخدم",
      "how_it_works": "كيف يعمل",
      "download": "تحميل التطبيق",
      "find": "ابحث عن متاجر قريبة",
      "reserve": "احجز سلتك",
      "pickup": "استلم واستمتع",

      // Footer
      "footer_tagline": "نحد من هدر الطعام معًا",
      "footer_platform": "المنصة",
      "footer_how_it_works": "كيف يعمل",
      "footer_browse_food": "تصفح الطعام",
      "footer_donate_food": "تبرع بالطعام",
      "footer_impact": "التأثير",
      "footer_our_mission": "مهمتنا",
      "footer_statistics": "إحصائيات",
      "footer_sustainability": "الاستدامة",
      "footer_community": "المجتمع",
      "footer_events": "فعاليات",
      "footer_partners": "شركاء",
      "footer_volunteers": "متطوعين",
      "footer_stories": "قصص",
      "footer_support": "الدعم",
      "footer_contact": "اتصل بنا",
      "footer_faq": "أسئلة شائعة",
      "footer_privacy": "الخصوصية",
      "footer_terms": "الشروط",
      "footer_mission":
          "مهمتنا هي تقليل هدر الطعام من خلال ربط المتاجر المحلية بالمستهلكين.",
    },
  };

  String t(String key) => _data[_current]?[key] ?? key;
}
