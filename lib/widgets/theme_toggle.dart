import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return IconButton(
      icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        themeProvider.toggleTheme();
      },
      tooltip: themeProvider.isDarkMode
          ? 'Switch to Light Mode'
          : 'Switch to Dark Mode',
    );
  }
}

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.light_mode,
            size: 20,
            color: !isDark
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isDark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.dark_mode,
            size: 20,
            color: isDark
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Theme Mode', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildThemeOption(
          context,
          title: 'Light',
          subtitle: 'Use light theme',
          icon: Icons.light_mode,
          isSelected: themeProvider.themeMode == ThemeMode.light,
          onTap: () => themeProvider.setThemeMode(ThemeMode.light),
        ),
        const SizedBox(height: 12),
        _buildThemeOption(
          context,
          title: 'Dark',
          subtitle: 'Use dark theme',
          icon: Icons.dark_mode,
          isSelected: themeProvider.themeMode == ThemeMode.dark,
          onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
        ),
        const SizedBox(height: 12),
        _buildThemeOption(
          context,
          title: 'System',
          subtitle: 'Follow system settings',
          icon: Icons.settings_suggest,
          isSelected: themeProvider.themeMode == ThemeMode.system,
          onTap: () => themeProvider.setThemeMode(ThemeMode.system),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
