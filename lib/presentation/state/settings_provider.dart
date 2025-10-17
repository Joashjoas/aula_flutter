import 'package:flutter/foundation.dart';
import '../../data/models/user_settings.dart';
import '../../data/repositories/local_storage_repository.dart';

class SettingsProvider with ChangeNotifier {
  final LocalStorageRepository _localStorage;
  late UserSettings _settings;

  SettingsProvider({required LocalStorageRepository localStorage})
      : _localStorage = localStorage {
    _settings = _localStorage.getSettings();
  }

  UserSettings get settings => _settings;
  bool get isDarkMode => _settings.isDarkMode;
  String get language => _settings.language;
  int get itemsPerPage => _settings.itemsPerPage;
  bool get autoPlay => _settings.autoPlay;
  String get rating => _settings.rating;

  Future<void> toggleTheme() async {
    _settings.isDarkMode = !_settings.isDarkMode;
    await _localStorage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _settings.language = language;
    await _localStorage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setItemsPerPage(int itemsPerPage) async {
    _settings.itemsPerPage = itemsPerPage;
    await _localStorage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleAutoPlay() async {
    _settings.autoPlay = !_settings.autoPlay;
    await _localStorage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setRating(String rating) async {
    _settings.rating = rating;
    await _localStorage.saveSettings(_settings);
    notifyListeners();
  }

  List<String> getSearchHistory() => _localStorage.getSearchHistory();

  Future<void> clearSearchHistory() async {
    await _localStorage.clearSearchHistory();
    notifyListeners();
  }
}
