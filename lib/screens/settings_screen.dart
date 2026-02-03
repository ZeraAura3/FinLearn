import 'package:flutter/material.dart';
import '../widgets/theme_toggle.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Theme Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.palette_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Appearance',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ThemeModeSelector(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Account Settings Card
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  subtitle: 'Manage your profile information',
                  onTap: () {
                    // Navigate to profile
                  },
                ),
                _buildDivider(context),
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    // Navigate to notifications
                  },
                ),
                _buildDivider(context),
                _buildSettingsTile(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Control your privacy settings',
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // App Settings Card
          Card(
            child: Column(
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {
                    // Change language
                  },
                ),
                _buildDivider(context),
                _buildSettingsTile(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help or contact us',
                  onTap: () {
                    // Navigate to help
                  },
                ),
                _buildDivider(context),
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    // Show about dialog
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Sign Out Button
          ElevatedButton(
            onPressed: () {
              _showSignOutDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Sign Out'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 72,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Sign out logic here
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
