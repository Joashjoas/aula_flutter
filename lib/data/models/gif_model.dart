import 'package:hive/hive.dart';

part 'gif_model.g.dart';

@HiveType(typeId: 0)
class GifModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String? previewUrl;

  @HiveField(4)
  final int? width;

  @HiveField(5)
  final int? height;

  @HiveField(6)
  final String rating;

  @HiveField(7)
  final DateTime addedAt;

  GifModel({
    required this.id,
    required this.title,
    required this.url,
    this.previewUrl,
    this.width,
    this.height,
    required this.rating,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory GifModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>? ?? {};
    final original = images['original'] as Map<String, dynamic>? ?? {};
    final downsized = images['downsized_medium'] as Map<String, dynamic>? ?? {};
    final preview = images['preview_gif'] as Map<String, dynamic>? ?? {};

    return GifModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled GIF',
      url: (downsized['url'] ?? original['url']) as String? ?? '',
      previewUrl: preview['url'] as String?,
      width: int.tryParse(original['width']?.toString() ?? '0'),
      height: int.tryParse(original['height']?.toString() ?? '0'),
      rating: json['rating'] as String? ?? 'g',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'previewUrl': previewUrl,
      'width': width,
      'height': height,
      'rating': rating,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
