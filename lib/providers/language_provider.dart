import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class LanguageProvider extends ChangeNotifier {
  final PreferencesService _prefs = PreferencesService();
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final languageName = await _prefs.getLanguage();
    _locale = _getLocaleFromLanguageName(languageName);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setLanguage(String languageName) async {
    _locale = _getLocaleFromLanguageName(languageName);
    await _prefs.setLanguage(languageName);
    notifyListeners();
  }

  Locale _getLocaleFromLanguageName(String languageName) {
    switch (languageName) {
      case 'Spanish':
        return const Locale('es');
      case 'French':
        return const Locale('fr');
      case 'German':
        return const Locale('de');
      case 'Hindi':
        return const Locale('hi');
      case 'Mandarin':
        return const Locale('zh');
      case 'Tamil':
        return const Locale('ta');
      case 'Telugu':
        return const Locale('te');
      case 'Kannada':
        return const Locale('kn');
      case 'English':
      default:
        return const Locale('en');
    }
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'hi':
        return 'Hindi';
      case 'zh':
        return 'Mandarin';
      case 'ta':
        return 'Tamil';
      case 'te':
        return 'Telugu';
      case 'kn':
        return 'Kannada';
      case 'en':
      default:
        return 'English';
    }
  }
}
