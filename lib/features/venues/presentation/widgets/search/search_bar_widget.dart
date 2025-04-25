import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';

class SearchBarWidget extends StatefulWidget {
  final String initialQuery;

  const SearchBarWidget({super.key, this.initialQuery = ''});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery && widget.initialQuery != _searchController.text) {
      _searchController.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    BlocProvider.of<VenuesBloc>(context).add(VenuesSearchEvent(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5.0, spreadRadius: 1.0)],
      ),
      child: Row(
        children: [
          Semantics(label: 'Search icon', excludeSemantics: true, child: Icon(Icons.search, color: Colors.grey)),
          SizedBox(width: 10),
          Expanded(
            child: Semantics(
              label: 'Search for venue',
              hint: 'Enter venue name or keywords to search',
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (value) {
                  _onSearch(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for venue',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Semantics(
              button: true,
              label: 'Clear search',
              onTap: () {
                _searchController.clear();
                _onSearch('');
              },
              child: ExcludeSemantics(
                child: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                  child: Icon(Icons.clear, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
