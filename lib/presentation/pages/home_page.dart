import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/gif_provider.dart';
import '../state/settings_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/responsive_gif_grid.dart';
import '../widgets/search_bar_widget.dart';
import 'favorites_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GifProvider>().loadTrendingGifs(refresh: true);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<GifProvider>().loadMoreGifs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GifApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSearch: (query) {
              context.read<GifProvider>().searchGifs(query);
            },
          ),
          Expanded(
            child: Consumer<GifProvider>(
              builder: (context, gifProvider, _) {
                switch (gifProvider.state) {
                  case GifLoadingState.initial:
                  case GifLoadingState.loading:
                    if (gifProvider.gifs.isEmpty) {
                      return const LoadingIndicator(
                        message: 'Loading GIFs...',
                      );
                    }
                    return ResponsiveGifGrid(
                      gifs: gifProvider.gifs,
                      scrollController: _scrollController,
                    );

                  case GifLoadingState.empty:
                    return EmptyState(
                      message: gifProvider.searchQuery.isEmpty
                          ? 'No GIFs available'
                          : 'No results found for "${gifProvider.searchQuery}"',
                      icon: Icons.search_off,
                      actionText: 'Load Trending',
                      onAction: () {
                        context
                            .read<GifProvider>()
                            .loadTrendingGifs(refresh: true);
                      },
                    );

                  case GifLoadingState.error:
                    return ErrorView(
                      message: gifProvider.errorMessage,
                      onRetry: () {
                        context
                            .read<GifProvider>()
                            .loadTrendingGifs(refresh: true);
                      },
                    );

                  case GifLoadingState.loaded:
                    return ResponsiveGifGrid(
                      gifs: gifProvider.gifs,
                      scrollController: _scrollController,
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
