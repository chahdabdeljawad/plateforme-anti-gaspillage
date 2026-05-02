import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'authentification/login.dart';
import 'authentification/registre.dart';
import 'components/navbar.dart';
import 'lang.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => Lang(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Lang>(
      builder: (context, lang, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(lang.current),
          supportedLocales: const [Locale('fr'), Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primaryColor: const Color(0xFF00A082),
            scaffoldBackgroundColor: const Color(0xFFF7F7F7),
            textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
          ),
          initialRoute: '/home',
          routes: {
            '/login': (context) => LoginPage(onLoginSuccess: (role) {}),
            '/register': (context) => const RegistrePage(),
            '/home': (context) => const CustomNavbar(),
          },
        );
      },
    );
  }
}
