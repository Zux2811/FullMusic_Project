import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'package:music_app/presentation/auth/signin_option_page.dart';
import 'presentation/auth/signin_page.dart';
import 'presentation/auth/signup_page.dart';
import 'presentation/home/home_page.dart';
import 'presentation/splash/splash_page.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/signin_option': (context) => const SignInOptionPage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
