import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _languageKey = 'language';
  static const String _downloadQualityKey = 'downloadQuality';
  static const String _notificationsKey = 'notifications';
  static const String _emailNotificationsKey = 'email_notifications';

  // Language
  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'English';
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  // Download Quality
  Future<String> getDownloadQuality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_downloadQualityKey) ?? 'HD';
  }

  Future<void> setDownloadQuality(String quality) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_downloadQualityKey, quality);
  }

  // Notifications
  Future<bool> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  // Email Notifications
  Future<bool> getEmailNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_emailNotificationsKey) ?? true;
  }

  Future<void> setEmailNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailNotificationsKey, enabled);
  }
}
