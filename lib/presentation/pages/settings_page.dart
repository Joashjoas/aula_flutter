import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../state/gif_provider.dart';
import '../state/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return ListView(
            children: [
              _buildSection(
                context,
                title: 'Appearance',
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark theme'),
                    value: settingsProvider.isDarkMode,
                    onChanged: (_) => settingsProvider.toggleTheme(),
                    secondary: Icon(
                      settingsProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  ),
                ],
              ),
              _buildSection(
                context,
                title: 'Content',
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    subtitle: Text(
                      settingsProvider.language.toUpperCase(),
                    ),
                    trailing: DropdownButton<String>(
                      value: settingsProvider.language,
                      underline: const SizedBox(),
                      items: AppConstants.supportedLanguages
                          .map((lang) => DropdownMenuItem(
                                value: lang,
                                child: Text(lang.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          settingsProvider.setLanguage(value);
                          context
                              .read<GifProvider>()
                              .loadTrendingGifs(refresh: true);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.filter_list),
                    title: const Text('Content Rating'),
                    subtitle: Text(
                      settingsProvider.rating.toUpperCase(),
                    ),
                    trailing: DropdownButton<String>(
                      value: settingsProvider.rating,
                      underline: const SizedBox(),
                      items: AppConstants.ratingOptions
                          .map((rating) => DropdownMenuItem(
                                value: rating,
                                child: Text(rating.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          settingsProvider.setRating(value);
                          context
                              .read<GifProvider>()
                              .loadTrendingGifs(refresh: true);
                        }
                      },
                    ),
                  ),
                ],
              ),
              _buildSection(
                context,
                title: 'Performance',
                children: [
                  ListTile(
                    leading: const Icon(Icons.grid_view),
                    title: const Text('Items Per Page'),
                    subtitle: Text('${settingsProvider.itemsPerPage} GIFs'),
                    trailing: DropdownButton<int>(
                      value: settingsProvider.itemsPerPage,
                      underline: const SizedBox(),
                      items: [10, 20, 30, 50]
                          .map((count) => DropdownMenuItem(
                                value: count,
                                child: Text('$count'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          settingsProvider.setItemsPerPage(value);
                          context
                              .read<GifProvider>()
                              .loadTrendingGifs(refresh: true);
                        }
                      },
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Auto-play GIFs'),
                    subtitle: const Text('Automatically play animations'),
                    value: settingsProvider.autoPlay,
                    onChanged: (_) => settingsProvider.toggleAutoPlay(),
                    secondary: const Icon(Icons.play_circle_outline),
                  ),
                ],
              ),
              _buildSection(
                context,
                title: 'Search History',
                children: [
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Clear Search History'),
                    subtitle: Text(
                      '${settingsProvider.getSearchHistory().length} searches',
                    ),
                    trailing: ElevatedButton(
                      onPressed: settingsProvider.getSearchHistory().isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Clear History?'),
                                  content: const Text(
                                    'This will delete all your search history.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        settingsProvider.clearSearchHistory();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('History cleared'),
                                          ),
                                        );
                                      },
                                      child: const Text('Clear'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
              _buildSection(
                context,
                title: 'About',
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.code),
                    title: Text('API'),
                    subtitle: Text('Powered by Giphy'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}
