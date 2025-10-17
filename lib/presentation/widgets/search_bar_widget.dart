import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/settings_provider.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search GIFs...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearch('');
                        setState(() => _showSuggestions = false);
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        setState(() => _showSuggestions = !_showSuggestions);
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {});
              widget.onSearch(value);
            },
            onSubmitted: widget.onSearch,
          ),
        ),
        if (_showSuggestions) _buildSearchHistory(context),
      ],
    );
  }

  Widget _buildSearchHistory(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final history = settingsProvider.getSearchHistory();

    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No search history'),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: history.length,
        itemBuilder: (context, index) {
          final query = history[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(query),
            onTap: () {
              _controller.text = query;
              widget.onSearch(query);
              setState(() => _showSuggestions = false);
            },
          );
        },
      ),
    );
  }
}
