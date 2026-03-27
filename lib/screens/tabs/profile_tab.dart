import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/preferences_service.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../l10n/app_localizations.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final PreferencesService _prefs = PreferencesService();
  String _selectedLanguage = 'English';
  String _downloadQuality = 'HD';
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final language = await _prefs.getLanguage();
    final quality = await _prefs.getDownloadQuality();
    final notifications = await _prefs.getNotifications();
    final emailNotifications = await _prefs.getEmailNotifications();

    setState(() {
      _selectedLanguage = language;
      _downloadQuality = quality;
      _notificationsEnabled = notifications;
      _emailNotificationsEnabled = emailNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final user = AuthService().currentUser;
    final userEmail = user?.email ?? 'user@example.com';
    final userName = user?.displayName ?? userEmail.split('@')[0];
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with profile info
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.onPrimary,
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Menu items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildMenuSection(
                      localizations?.translate('account') ?? 'Account',
                      [
                        _buildMenuItem(
                          context,
                          Icons.person_outline,
                          localizations?.translate('edit_profile') ??
                              'Edit Profile',
                          () => _showEditProfileDialog(context),
                        ),
                        _buildMenuItem(
                          context,
                          Icons.lock_outline,
                          localizations?.translate('change_password') ??
                              'Change Password',
                          () => _showChangePasswordDialog(context),
                        ),
                        _buildMenuItem(
                          context,
                          Icons.notifications_outlined,
                          localizations?.translate('notifications') ??
                              'Notifications',
                          () => _showNotificationsDialog(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildMenuSection(
                      localizations?.translate('preferences') ?? 'Preferences',
                      [
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return _buildMenuItem(
                              context,
                              Icons.dark_mode_outlined,
                              localizations?.translate('dark_mode') ??
                                  'Dark Mode',
                              () {},
                              trailing: Switch(
                                value: themeProvider.isDarkMode,
                                onChanged: (value) {
                                  themeProvider.toggleTheme();
                                },
                              ),
                            );
                          },
                        ),
                        Consumer<LanguageProvider>(
                          builder: (context, languageProvider, child) {
                            return _buildMenuItem(
                              context,
                              Icons.language_rounded,
                              localizations?.translate('language') ??
                                  'Language',
                              () => _showLanguageDialog(context),
                              trailing: languageProvider.getLanguageName(
                                languageProvider.locale,
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          Icons.download_outlined,
                          localizations?.translate('download_quality') ??
                              'Download Quality',
                          () => _showDownloadQualityDialog(context),
                          trailing: _downloadQuality,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildMenuSection(
                      localizations?.translate('support') ?? 'Support',
                      [
                        _buildMenuItem(
                          context,
                          Icons.help_outline,
                          localizations?.translate('help_center') ??
                              'Help Center',
                          () => _showHelpCenterDialog(context),
                        ),
                        _buildMenuItem(
                          context,
                          Icons.privacy_tip_outlined,
                          localizations?.translate('privacy_policy') ??
                              'Privacy Policy',
                          () => _launchURL('https://finlearn.com/privacy'),
                        ),
                        _buildMenuItem(
                          context,
                          Icons.description_outlined,
                          localizations?.translate('terms_of_service') ??
                              'Terms of Service',
                          () => _launchURL('https://finlearn.com/terms'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Logout button
                    Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.red),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to logout?',
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );

                          if (shouldLogout == true) {
                            await AuthService().signOut();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout_rounded, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              localizations?.translate('logout') ?? 'Logout',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      '${localizations?.translate('version') ?? 'Version'} 1.0.0',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.onPrimary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: textTheme.titleLarge),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    dynamic trailing,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: textTheme.titleSmall)),
            if (trailing != null)
              trailing is Widget
                  ? trailing
                  : Text(
                      trailing.toString(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
            if (trailing == null || trailing is! Widget)
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  // Dialog functions
  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final user = AuthService().currentUser;

    if (user != null) {
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthService().updateDisplayName(
                  nameController.text.trim(),
                );
                if (mounted) {
                  setState(() {}); // Refresh UI to show new name
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing while loading
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match'),
                            ),
                          );
                          return;
                        }

                        if (newPasswordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password must be at least 6 characters',
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        try {
                          await AuthService().changePassword(
                            currentPasswordController.text,
                            newPasswordController.text,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password changed successfully'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                            setState(() => isLoading = false);
                          }
                        }
                      },
                child: const Text('Change'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Notifications'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    setState(() => _notificationsEnabled = value);
                    await _prefs.setNotifications(value);
                    if (mounted) {
                      this.setState(() {});
                    }
                  },
                ),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive course updates via email'),
                  value: _emailNotificationsEnabled,
                  onChanged: (value) async {
                    setState(() => _emailNotificationsEnabled = value);
                    await _prefs.setEmailNotifications(value);
                    if (mounted) {
                      this.setState(() {});
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Hindi',
      'Mandarin',
      'Tamil',
      'Telugu',
      'Kannada',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.translate('language') ??
              'Select Language',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: languageProvider.getLanguageName(
                  languageProvider.locale,
                ),
                onChanged: (value) async {
                  if (value != null) {
                    await languageProvider.setLanguage(value);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Language changed to $value')),
                      );
                    }
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showHelpCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'For any assistance, please contact:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactItem(context, Icons.person, 'Name', 'Arendra'),
            _buildContactItem(
              context,
              Icons.phone,
              'Phone',
              '9999802132',
              onTap: () => _launchURL('tel:9999802132'),
            ),
            _buildContactItem(
              context,
              Icons.email,
              'Email',
              'arendra6268@gmail.com',
              onTap: () => _launchURL('mailto:arendra6268@gmail.com'),
            ),
            _buildContactItem(
              context,
              Icons.chat,
              'Social',
              '@arendra_62',
              subtitle: 'WhatsApp / Instagram',
              onTap: () => _launchURL('https://instagram.com/arendra_62'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showDownloadQualityDialog(BuildContext context) {
    final qualities = ['SD', 'HD', 'Full HD', 'Auto'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: qualities.map((quality) {
            return RadioListTile<String>(
              title: Text(quality),
              subtitle: Text(_getQualityDescription(quality)),
              value: quality,
              groupValue: _downloadQuality,
              onChanged: (value) async {
                if (value != null) {
                  await _prefs.setDownloadQuality(value);
                  setState(() => _downloadQuality = value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Quality set to $value')),
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getQualityDescription(String quality) {
    switch (quality) {
      case 'SD':
        return '480p - Save data';
      case 'HD':
        return '720p - Balanced';
      case 'Full HD':
        return '1080p - Best quality';
      case 'Auto':
        return 'Based on connection';
      default:
        return '';
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    final mode = url.startsWith('http')
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      } else {
        // Fallback: try launching anyway
        if (!await launchUrl(uri, mode: mode)) {
          throw 'Could not launch';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    }
  }
}
