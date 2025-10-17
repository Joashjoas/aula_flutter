import '../models/gif_model.dart';
import '../services/giphy_service.dart';

class GifRepository {
  final GiphyService _giphyService;

  GifRepository({GiphyService? giphyService})
      : _giphyService = giphyService ?? GiphyService();

  Future<List<GifModel>> getTrendingGifs({
    required int limit,
    required int offset,
    String rating = 'g',
  }) async {
    return await _giphyService.getTrendingGifs(
      limit: limit,
      offset: offset,
      rating: rating,
    );
  }

  Future<List<GifModel>> searchGifs({
    required String query,
    required int limit,
    required int offset,
    String rating = 'g',
    String lang = 'en',
  }) async {
    return await _giphyService.searchGifs(
      query: query,
      limit: limit,
      offset: offset,
      rating: rating,
      lang: lang,
    );
  }
}
