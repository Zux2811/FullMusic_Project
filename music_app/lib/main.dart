import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'package:music_app/presentation/auth/signin_option_page.dart';
import 'presentation/auth/signin_page.dart';
import 'presentation/auth/signup_page.dart';

import 'presentation/auth/auth_provider.dart'; // Import AuthProvider
import 'presentation/home/home_page.dart';
import 'presentation/splash/splash_page.dart';
import 'presentation/player/player_provider.dart';
import 'presentation/player/player_page.dart';
import 'presentation/theme/theme_provider.dart';
import 'presentation/theme/theme_selection_page.dart';
import 'presentation/home/tabs/library/library_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ), // Thêm AuthProvider
      ],
      child: const MusicApp(),
    ),
  );
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Music App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash', // Mở Splash để kiểm tra token và auto-login
          routes: {
            '/splash': (context) => const SplashPage(),
            '/signin_option': (context) => const SignInOptionPage(),
            '/signin': (context) => const SignInPage(),
            '/signup': (context) => const SignUpPage(),
            '/theme_selection': (context) => const ThemeSelectionPage(),
            '/home': (context) => const HomePage(),
            '/player': (context) => const PlayerPage(),
          },
        );
      },
    );
  }
}
