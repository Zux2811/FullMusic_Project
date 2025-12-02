import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Theme Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _ThemeSettingCard(),
              ],
            ),
          ),
          const Divider(),
          // Other settings can be added here
        ],
      ),
    );
  }
}

class _ThemeSettingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyan.withAlpha(128),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text('Light Theme'),
                leading: const Icon(Icons.light_mode),
                trailing: Radio<AppThemeMode>(
                  value: AppThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setTheme(value);
                    }
                  },
                ),
                onTap: () {
                  themeProvider.setTheme(AppThemeMode.light);
                },
              ),
              const Divider(height: 0),
              ListTile(
                title: const Text('Dark Theme'),
                leading: const Icon(Icons.dark_mode),
                trailing: Radio<AppThemeMode>(
                  value: AppThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setTheme(value);
                    }
                  },
                ),
                onTap: () {
                  themeProvider.setTheme(AppThemeMode.dark);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

