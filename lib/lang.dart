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

      // Categories & search
      "search_hint": "Rechercher...",
      "change_maps": "Changer carte",
      "change_maps_placeholder": "Fonctionnalité à venir",
      "large_stores": "Grandes surfaces",
      "other_stores": "Autres commerces",
      "no_results": "Aucun résultat",

      // Benefits
      "benefit1_title": "Produits frais à prix réduit",
      "benefit1_desc": "Jusqu'à 50% de réduction sur les invendus",
      "benefit2_title": "Soutenez l'économie locale",
      "benefit2_desc": "Aidez les commerces de votre quartier",
      "benefit3_title": "Réduisez votre impact",
      "benefit3_desc": "Diminuez le gaspillage alimentaire",
      "benefit4_title": "Découvrez de nouvelles saveurs",
      "benefit4_desc": "Essayez des produits que vous n'auriez pas osé",

      // About page
      "about_title": "À propos",
      "about_hero_title": "ZeroGaspi",
      "about_hero_subtitle": "Réduisons le gaspillage alimentaire ensemble",
      "about_mission_label": "NOTRE MISSION",
      "about_mission_title": "Sauver la nourriture, préserver la planète",
      "about_mission_text":
          "ZeroGaspi connecte les commerces aux consommateurs pour valoriser les invendus. Nous croyons que chaque produit mérite d'être consommé, pas jeté.",
      "about_stat_meals": "Repas sauvés",
      "about_stat_stores": "Commerces partenaires",
      "about_stat_co2": "Tonnes CO₂ évitées",
      "about_stat_meals_value": "+1000",
      "about_stat_stores_value": "+50",
      "about_stat_co2_value": "+10",
      "about_story_label": "NOTRE HISTOIRE",
      "about_story_title": "Une idée simple pour un grand défi",
      "about_story_text1":
          "Chaque jour, des tonnes de nourriture encore consommable sont gaspillées. ZeroGaspi est né pour changer cela : une application qui permet d'acheter les invendus à prix réduit, tout en réduisant l'impact environnemental.",
      "about_story_text2":
          "Nous travaillons avec des commerces de proximité pour offrir une solution gagnant-gagnant : moins de pertes pour les professionnels, plus d'économies pour les consommateurs, et une planète préservée.",
      "about_how_label": "COMMENT ÇA MARCHE",
      "about_step1_title": "Explorer",
      "about_step1_desc": "Trouvez des paniers près de chez vous",
      "about_step2_title": "Réserver",
      "about_step2_desc": "Achetez facilement",
      "about_step3_title": "Récupérer",
      "about_step3_desc": "Profitez de bons produits",

      // CategoryDetailsPage
      "store_not_found": "Magasin non trouvé",
      "no_products": "Aucun produit disponible",

      // PaymentPage
      "payment_title": "Paiement",
      "payment_on_site": "Paiement sur place",
      "payment_online": "Paiement en ligne (carte bancaire)",
      "please_select_payment": "Veuillez sélectionner un mode de paiement",
      "order_summary": "Récapitulatif de votre commande",
      "product_label": "Produit",
      "price_label": "Prix",
      "store_label": "Magasin",
      "pickup_time_label": "Heure de retrait",
      "type_label": "Type",
      "total_label": "Total à payer",
      "total_paid_label": "Total payé",
      "qr_code_placeholder": "QR code à scanner sur place",
      "confirm_reservation": "Confirmer la réservation",
      "card_title": "Carte bancaire 💳",
      "card_number": "Numéro de carte",
      "expiry_date": "MM/YY",
      "cvv": "CVV",
      "required_field": "Champ obligatoire",
      "invalid_card": "Numéro invalide",
      "invalid_cvv": "CVV invalide",
      "pay_now": "Payer maintenant",
      "cancel": "Annuler",
      "confirm": "Confirmer",
      "reservation_success_title": "Réservation confirmée ✅",
      "reservation_success_msg":
          "Votre réservation a été enregistrée avec succès.",
      "ok": "OK",
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

      // Categories & search
      "search_hint": "Search...",
      "change_maps": "Change map",
      "change_maps_placeholder": "Feature coming soon",
      "large_stores": "Large stores",
      "other_stores": "Other shops",
      "no_results": "No results",

      // Benefits
      "benefit1_title": "Fresh food at reduced prices",
      "benefit1_desc": "Up to 50% off on unsold items",
      "benefit2_title": "Support local economy",
      "benefit2_desc": "Help neighborhood businesses",
      "benefit3_title": "Reduce your footprint",
      "benefit3_desc": "Fight food waste",
      "benefit4_title": "Discover new flavors",
      "benefit4_desc": "Try products you wouldn't have dared",

      // About page
      "about_title": "About",
      "about_hero_title": "ZeroGaspi",
      "about_hero_subtitle": "Reducing food waste together",
      "about_mission_label": "OUR MISSION",
      "about_mission_title": "Save food, protect the planet",
      "about_mission_text":
          "ZeroGaspi connects businesses to consumers to rescue unsold food. We believe every product deserves to be eaten, not thrown away.",
      "about_stat_meals": "Meals Saved",
      "about_stat_stores": "Partner Stores",
      "about_stat_co2": "Tons CO₂ Saved",
      "about_stat_meals_value": "+1000",
      "about_stat_stores_value": "+50",
      "about_stat_co2_value": "+10",
      "about_story_label": "OUR STORY",
      "about_story_title": "A simple idea for a big challenge",
      "about_story_text1":
          "Every day, tons of edible food are wasted. ZeroGaspi was born to change that: an app that lets you buy surplus food at a reduced price while reducing environmental impact.",
      "about_story_text2":
          "We work with local stores to offer a win-win solution: fewer losses for professionals, more savings for consumers, and a healthier planet.",
      "about_how_label": "HOW IT WORKS",
      "about_step1_title": "Explore",
      "about_step1_desc": "Find baskets near you",
      "about_step2_title": "Reserve",
      "about_step2_desc": "Buy easily",
      "about_step3_title": "Pick up",
      "about_step3_desc": "Enjoy good products",

      // CategoryDetailsPage
      "store_not_found": "Store not found",
      "no_products": "No products available",

      // PaymentPage
      "payment_title": "Payment",
      "payment_on_site": "On‑site payment",
      "payment_online": "Online payment (credit card)",
      "please_select_payment": "Please select a payment method",
      "order_summary": "Order summary",
      "product_label": "Product",
      "price_label": "Price",
      "store_label": "Store",
      "pickup_time_label": "Pickup time",
      "type_label": "Type",
      "total_label": "Total to pay",
      "total_paid_label": "Total paid",
      "qr_code_placeholder": "QR code to scan on site",
      "confirm_reservation": "Confirm reservation",
      "card_title": "Credit card 💳",
      "card_number": "Card number",
      "expiry_date": "MM/YY",
      "cvv": "CVV",
      "required_field": "Required field",
      "invalid_card": "Invalid card number",
      "invalid_cvv": "Invalid CVV",
      "pay_now": "Pay now",
      "cancel": "Cancel",
      "confirm": "Confirm",
      "reservation_success_title": "Reservation confirmed ✅",
      "reservation_success_msg":
          "Your reservation has been successfully recorded.",
      "ok": "OK",
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

      // Categories & search
      "search_hint": "بحث...",
      "change_maps": "تغيير الخريطة",
      "change_maps_placeholder": "قريباً",
      "large_stores": "المساحات الكبرى",
      "other_stores": "محلات أخرى",
      "no_results": "لا نتائج",

      // Benefits
      "benefit1_title": "طعام طازج بأسعار مخفضة",
      "benefit1_desc": "خصم يصل إلى 50% على الفائض",
      "benefit2_title": "ادعم الاقتصاد المحلي",
      "benefit2_desc": "ساعد المتاجر في منطقتك",
      "benefit3_title": "قلل بصمتك البيئية",
      "benefit3_desc": "حارب هدر الطعام",
      "benefit4_title": "اكتشف نكهات جديدة",
      "benefit4_desc": "جرّب منتجات لم تجربها من قبل",

      // About page
      "about_title": "حول",
      "about_hero_title": "ZeroGaspi",
      "about_hero_subtitle": "نحد من هدر الطعام معًا",
      "about_mission_label": "مهمتنا",
      "about_mission_title": "أنقذ الطعام، احمِ الكوكب",
      "about_mission_text":
          "ZeroGaspi يربط التجار بالمستهلكين لإنقاذ الطعام الفائض. نؤمن بأن كل منتج يستحق أن يؤكل، لا أن يُرمى.",
      "about_stat_meals": "وجبات منقذة",
      "about_stat_stores": "متاجر شريكة",
      "about_stat_co2": "طن CO₂ موفر",
      "about_stat_meals_value": "+١٠٠٠",
      "about_stat_stores_value": "+٥٠",
      "about_stat_co2_value": "+١٠",
      "about_story_label": "قصتنا",
      "about_story_title": "فكرة بسيطة لتحدي كبير",
      "about_story_text1":
          "كل يوم، تُهدر أطنان من الطعام الصالح للأكل. وُلد ZeroGaspi لتغيير ذلك: تطبيق يسمح لك بشراء الطعام الفائض بسعر مخفض مع تقليل التأثير البيئي.",
      "about_story_text2":
          "نعمل مع المتاجر المحلية لتقديم حل مربح للجميع: خسائر أقل للمهنيين، توفير أكبر للمستهلكين، وكوكب أكثر صحة.",
      "about_how_label": "كيف يعمل",
      "about_step1_title": "استكشف",
      "about_step1_desc": "ابحث عن سلال قريبة منك",
      "about_step2_title": "احجز",
      "about_step2_desc": "اشتري بسهولة",
      "about_step3_title": "استلم",
      "about_step3_desc": "استمتع بمنتجات جيدة",

      // CategoryDetailsPage
      "store_not_found": "المتجر غير موجود",
      "no_products": "لا توجد منتجات متاحة",

      // PaymentPage
      "payment_title": "الدفع",
      "payment_on_site": "الدفع عند الاستلام",
      "payment_online": "الدفع عبر الإنترنت (بطاقة بنكية)",
      "please_select_payment": "يرجى اختيار طريقة الدفع",
      "order_summary": "ملخص الطلب",
      "product_label": "المنتج",
      "price_label": "السعر",
      "store_label": "المتجر",
      "pickup_time_label": "وقت الاستلام",
      "type_label": "النوع",
      "total_label": "المبلغ الإجمالي",
      "total_paid_label": "المبلغ المدفوع",
      "qr_code_placeholder": "رمز QR لمسحه ضوئياً في الموقع",
      "confirm_reservation": "تأكيد الحجز",
      "card_title": "بطاقة بنكية 💳",
      "card_number": "رقم البطاقة",
      "expiry_date": "شهر/سنة",
      "cvv": "CVV",
      "required_field": "حقل مطلوب",
      "invalid_card": "رقم بطاقة غير صالح",
      "invalid_cvv": "CVV غير صالح",
      "pay_now": "ادفع الآن",
      "cancel": "إلغاء",
      "confirm": "تأكيد",
      "reservation_success_title": "تم تأكيد الحجز ✅",
      "reservation_success_msg": "تم تسجيل حجزك بنجاح.",
      "ok": "موافق",
    },
  };

  String t(String key) => _data[_current]?[key] ?? key;
}
