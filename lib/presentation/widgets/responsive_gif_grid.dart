import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../data/models/gif_model.dart';
import 'gif_grid_item.dart';

class ResponsiveGifGrid extends StatelessWidget {
  final List<GifModel> gifs;
  final ScrollController? scrollController;

  const ResponsiveGifGrid({
    super.key,
    required this.gifs,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

        return MasonryGridView.count(
          controller: scrollController,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          itemCount: gifs.length,
          itemBuilder: (context, index) {
            return GifGridItem(gif: gifs[index]);
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }
}
