import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'authentification/login.dart';
import 'authentification/registre.dart';
import 'components/navbar.dart';
import 'lang.dart';
import 'providers/location_provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locationProvider = LocationProvider();

  // Load saved location
  await locationProvider.loadSavedLocation();

  // Auto GPS location
  await locationProvider.initializeLocation();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Lang()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: locationProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,

      // 🌞 LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0A3B2A),
        scaffoldBackgroundColor: const Color(0xFFF5F0E6),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0A3B2A),
          secondary: Color(0xFF9ACD32),
          surface: Color(0xFFF5F0E6),
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      // 🌙 DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 20, 103, 74),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 19, 112, 79),
          secondary: Color(0xFF9ACD32),
          surface: Color.fromARGB(255, 55, 55, 55),
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),

      locale: Locale(lang.current),
      supportedLocales: const [Locale('fr'), Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: '/home',

      routes: {
        // ✅ UPDATED: Added the required 'onSignUp' callback.
        // Since this is a standalone route, we use an empty function.
        '/login': (context) => LoginPage(
          onLoginSuccess: (role) {},
          onSignUp: () {}, // ✅ Added missing required parameter
        ),

        // ✅ UPDATED: Added the required 'onBack' callback.
        '/register': (context) => RegistrePage(
          onBack: () {}, // ✅ Added missing required parameter
        ),

        '/home': (context) => const CustomNavbar(),
      },
    );
  }
}
