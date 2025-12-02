import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import '../home/home_page.dart';

class ThemeSelectionPage extends StatefulWidget {
  final bool isFirstTime;

  const ThemeSelectionPage({Key? key, this.isFirstTime = true})
    : super(key: key);

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue.withAlpha(26), Colors.blue.withAlpha(26)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.palette,
                      size: 64,
                      color: Colors.lightBlue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Choose Your Theme',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Select a theme that suits your preference',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Theme Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Light Theme Card
                    _ThemeCard(
                      title: 'Light Theme',
                      description: 'Bright and clean interface',
                      icon: Icons.light_mode,
                      onTap: () => _selectTheme(AppThemeMode.light),
                    ),
                    const SizedBox(height: 24),

                    // Dark Theme Card
                    _ThemeCard(
                      title: 'Dark Theme',
                      description: 'Easy on the eyes',
                      icon: Icons.dark_mode,
                      onTap: () => _selectTheme(AppThemeMode.dark),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTheme(AppThemeMode mode) async {
    final themeProvider = context.read<ThemeProvider>();
    await themeProvider.setTheme(mode);

    if (!mounted) return;

    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.lightBlue.withAlpha(128), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlue.withAlpha(51),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.lightBlue),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.lightBlue),
          ],
        ),
      ),
    );
  }
}
