import 'package:flutter/foundation.dart';
import '../../data/models/gif_model.dart';
import '../../data/repositories/local_storage_repository.dart';

class FavoritesProvider with ChangeNotifier {
  final LocalStorageRepository _localStorage;

  FavoritesProvider({required LocalStorageRepository localStorage})
      : _localStorage = localStorage;

  List<GifModel> get favorites => _localStorage.getFavorites();

  bool isFavorite(String gifId) => _localStorage.isFavorite(gifId);

  Future<void> toggleFavorite(GifModel gif) async {
    if (isFavorite(gif.id)) {
      await _localStorage.removeFavorite(gif.id);
    } else {
      await _localStorage.addFavorite(gif);
    }
    notifyListeners();
  }

  Future<void> addFavorite(GifModel gif) async {
    await _localStorage.addFavorite(gif);
    notifyListeners();
  }

  Future<void> removeFavorite(String gifId) async {
    await _localStorage.removeFavorite(gifId);
    notifyListeners();
  }
}
