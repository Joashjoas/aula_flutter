import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 1)
class UserSettings extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String language;

  @HiveField(2)
  int itemsPerPage;

  @HiveField(3)
  bool autoPlay;

  @HiveField(4)
  String rating;

  UserSettings({
    this.isDarkMode = false,
    this.language = 'en',
    this.itemsPerPage = 20,
    this.autoPlay = true,
    this.rating = 'g',
  });
}
