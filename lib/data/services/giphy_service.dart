import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../models/gif_model.dart';

class GiphyService {
  final Dio _dio;

  GiphyService() : _dio = Dio(BaseOptions(
    baseUrl: AppConstants.giphyBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<GifModel>> getTrendingGifs({
    required int limit,
    required int offset,
    String rating = 'g',
  }) async {
    try {
      final response = await _dio.get(
        '/gifs/trending',
        queryParameters: {
          'api_key': AppConstants.giphyApiKey,
          'limit': limit,
          'offset': offset,
          'rating': rating,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((json) => GifModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch trending GIFs: $e');
    }
  }

  Future<List<GifModel>> searchGifs({
    required String query,
    required int limit,
    required int offset,
    String rating = 'g',
    String lang = 'en',
  }) async {
    try {
      final response = await _dio.get(
        '/gifs/search',
        queryParameters: {
          'api_key': AppConstants.giphyApiKey,
          'q': query,
          'limit': limit,
          'offset': offset,
          'rating': rating,
          'lang': lang,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((json) => GifModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search GIFs: $e');
    }
  }
}
