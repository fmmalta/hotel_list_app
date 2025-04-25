import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/extensions/venues_state_extension.dart';

class SortButton extends StatelessWidget {
  final VenuesState state;

  const SortButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final sortOrder = state.sortOrder;
    final sortLabel = sortOrder == 'asc' ? 'Oldest first' : 'Newest first';

    return Semantics(
      label: 'Sort order: $sortLabel',
      hint: 'Tap to change sort order',
      button: true,
      excludeSemantics: true,
      child: TextButton.icon(
        onPressed: () => context.read<VenuesBloc>().add(VenuesToggleSortOrderEvent()),
        icon: Icon(
          sortOrder == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
          size: 18,
          color: const Color(0xFF2D3C4E),
        ),
        label: Text(sortLabel, style: TextStyle(color: const Color(0xFF2D3C4E))),
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      ),
    );
  }
}
