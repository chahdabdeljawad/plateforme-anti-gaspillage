import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lang.dart';
import '../screens/homepage.dart';
import '../screens/profilpage.dart';
import '../screens/about.dart';
import '../screens/categoriespage.dart';
import '../authentification/login.dart';
import '../providers/theme_provider.dart';
import '../authentification/registre.dart';
import '../services/cart_service.dart';
import '../screens/panierpage.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  bool isLoggedIn = false;
  String userRole = 'Client';
  bool _showRegister = false;

  void loginSuccess(String role) {
    setState(() {
      isLoggedIn = true;
      userRole = role;
      _showRegister = false;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
      userRole = 'Client';
      _showRegister = false;
    });
  }

  void toggleRegister() {
    setState(() {
      _showRegister = !_showRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(95),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  "ZeroGaspi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                actions: [
                  // 🛒 PANIER + badge
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart_outlined,
                            color: colors.onSurface),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PanierPage()),
                          );
                          setState(() {}); // refresh badge
                        },
                      ),
                      if (CartService.count > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${CartService.count}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // (يكمّل: زرّ الـ theme + اللغة كيف ما هم)
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: colors.onSurface,
                    ),
                    onPressed: themeProvider.toggleTheme,
                  ),
                  PopupMenuButton<String>(
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset("assets/langue/translator.png"),
                    ),
                    onSelected: (value) => lang.changeLang(value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "fr",
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                "assets/langue/france.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "en",
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                "assets/langue/united-kingdom.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "ar",
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                "assets/langue/flag.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                bottom: TabBar(
                  labelColor: colors.onSurface,
                  unselectedLabelColor: colors.onSurface.withOpacity(0.6),
                  indicatorColor: colors.onSurface,
                  tabs: [
                    Tab(text: lang.t("home")),
                    Tab(text: lang.t("categories")),
                    Tab(text: lang.t("about")),
                    Tab(text: lang.t("profile")),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const HomePage(),
            const CategoriesPage(),
            const AboutPage(),
            isLoggedIn
                ? ProfilePage(role: userRole, onLogout: logout)
                : _showRegister
                ? RegistrePage(onBack: toggleRegister)
                : LoginPage(
                    onLoginSuccess: loginSuccess,
                    onSignUp: toggleRegister,
                  ), // ✅ Fixed syntax
          ],
        ),
      ),
    );
  }
}
