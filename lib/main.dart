import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/gif_repository.dart';
import 'data/repositories/local_storage_repository.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/state/favorites_provider.dart';
import 'presentation/state/gif_provider.dart';
import 'presentation/state/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = LocalStorageRepository();
  await localStorage.init();

  runApp(GifApp(localStorage: localStorage));
}

class GifApp extends StatelessWidget {
  final LocalStorageRepository localStorage;

  const GifApp({
    super.key,
    required this.localStorage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(localStorage: localStorage),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(localStorage: localStorage),
        ),
        ChangeNotifierProvider(
          create: (_) => GifProvider(
            gifRepository: GifRepository(),
            localStorage: localStorage,
          ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'GifApp',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
