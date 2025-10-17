import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/favorites_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/responsive_gif_grid.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favProvider, _) {
          final favorites = favProvider.favorites;

          if (favorites.isEmpty) {
            return const EmptyState(
              message: 'No favorites yet!\nStart adding GIFs you love.',
              icon: Icons.favorite_border,
            );
          }

          return ResponsiveGifGrid(gifs: favorites);
        },
      ),
    );
  }
}
