import 'package:hive_flutter/hive_flutter.dart';
import '../models/gif_model.dart';
import '../models/user_settings.dart';

class LocalStorageRepository {
  static const String _favoritesBox = 'favorites';
  static const String _settingsBox = 'settings';
  static const String _searchHistoryBox = 'search_history';
  static const String _settingsKey = 'user_settings';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GifModelAdapter());
    Hive.registerAdapter(UserSettingsAdapter());

    await Hive.openBox<GifModel>(_favoritesBox);
    await Hive.openBox<UserSettings>(_settingsBox);
    await Hive.openBox<String>(_searchHistoryBox);
  }

  Box<GifModel> get _favorites => Hive.box<GifModel>(_favoritesBox);
  Box<UserSettings> get _settings => Hive.box<UserSettings>(_settingsBox);
  Box<String> get _searchHistory => Hive.box<String>(_searchHistoryBox);

  Future<void> addFavorite(GifModel gif) async {
    await _favorites.put(gif.id, gif);
  }

  Future<void> removeFavorite(String gifId) async {
    await _favorites.delete(gifId);
  }

  bool isFavorite(String gifId) {
    return _favorites.containsKey(gifId);
  }

  List<GifModel> getFavorites() {
    return _favorites.values.toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  Future<void> saveSettings(UserSettings settings) async {
    await _settings.put(_settingsKey, settings);
  }

  UserSettings getSettings() {
    return _settings.get(_settingsKey) ?? UserSettings();
  }

  Future<void> addSearchQuery(String query) async {
    if (query.isEmpty) return;

    final history = _searchHistory.values.toList();
    history.remove(query);
    history.insert(0, query);

    await _searchHistory.clear();
    final limitedHistory = history.take(10).toList();
    for (var i = 0; i < limitedHistory.length; i++) {
      await _searchHistory.put(i, limitedHistory[i]);
    }
  }

  List<String> getSearchHistory() {
    return _searchHistory.values.toList();
  }

  Future<void> clearSearchHistory() async {
    await _searchHistory.clear();
  }
}
