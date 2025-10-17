import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/debouncer.dart';
import '../../data/models/gif_model.dart';
import '../../data/repositories/gif_repository.dart';
import '../../data/repositories/local_storage_repository.dart';

enum GifLoadingState { initial, loading, loaded, error, empty }

class GifProvider with ChangeNotifier {
  final GifRepository _gifRepository;
  final LocalStorageRepository _localStorage;

  GifProvider({
    required GifRepository gifRepository,
    required LocalStorageRepository localStorage,
  })  : _gifRepository = gifRepository,
        _localStorage = localStorage;

  List<GifModel> _gifs = [];
  GifLoadingState _state = GifLoadingState.initial;
  String _errorMessage = '';
  String _searchQuery = '';
  int _offset = 0;
  bool _hasMore = true;

  final Debouncer _debouncer = Debouncer(
    milliseconds: AppConstants.searchDebounceMillis,
  );

  List<GifModel> get gifs => _gifs;
  GifLoadingState get state => _state;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasMore => _hasMore;

  Future<void> loadTrendingGifs({bool refresh = false}) async {
    if (refresh) {
      _offset = 0;
      _gifs = [];
      _hasMore = true;
    }

    if (!_hasMore) return;

    _setState(GifLoadingState.loading);

    try {
      final settings = _localStorage.getSettings();
      final newGifs = await _gifRepository.getTrendingGifs(
        limit: settings.itemsPerPage,
        offset: _offset,
        rating: settings.rating,
      );

      if (newGifs.isEmpty) {
        _hasMore = false;
        if (_gifs.isEmpty) {
          _setState(GifLoadingState.empty);
        } else {
          _setState(GifLoadingState.loaded);
        }
      } else {
        _gifs.addAll(newGifs);
        _offset += newGifs.length;
        _setState(GifLoadingState.loaded);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(GifLoadingState.error);
    }
  }

  void searchGifs(String query) {
    _searchQuery = query.trim();
    _debouncer.run(() => _performSearch());
  }

  Future<void> _performSearch() async {
    if (_searchQuery.isEmpty) {
      await loadTrendingGifs(refresh: true);
      return;
    }

    _offset = 0;
    _gifs = [];
    _hasMore = true;

    _setState(GifLoadingState.loading);

    try {
      await _localStorage.addSearchQuery(_searchQuery);

      final settings = _localStorage.getSettings();
      final results = await _gifRepository.searchGifs(
        query: _searchQuery,
        limit: settings.itemsPerPage,
        offset: _offset,
        rating: settings.rating,
        lang: settings.language,
      );

      if (results.isEmpty) {
        _setState(GifLoadingState.empty);
      } else {
        _gifs = results;
        _offset = results.length;
        _setState(GifLoadingState.loaded);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(GifLoadingState.error);
    }
  }

  Future<void> loadMoreGifs() async {
    if (!_hasMore || _state == GifLoadingState.loading) return;

    try {
      final settings = _localStorage.getSettings();
      final List<GifModel> newGifs;

      if (_searchQuery.isEmpty) {
        newGifs = await _gifRepository.getTrendingGifs(
          limit: settings.itemsPerPage,
          offset: _offset,
          rating: settings.rating,
        );
      } else {
        newGifs = await _gifRepository.searchGifs(
          query: _searchQuery,
          limit: settings.itemsPerPage,
          offset: _offset,
          rating: settings.rating,
          lang: settings.language,
        );
      }

      if (newGifs.isEmpty) {
        _hasMore = false;
      } else {
        _gifs.addAll(newGifs);
        _offset += newGifs.length;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  void _setState(GifLoadingState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
