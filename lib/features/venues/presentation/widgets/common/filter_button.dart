import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/extensions/venues_state_extension.dart';

class FilterButton extends StatelessWidget {
  final VenuesState state;
  final VoidCallback onPressed;

  const FilterButton({super.key, required this.state, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final totalFilters = state.totalFilters;

    return Semantics(
      label: 'Filter venues',
      hint: totalFilters > 0 ? '$totalFilters filters applied' : 'No filters applied',
      button: true,
      child: ExcludeSemantics(
        child: Badge(
          isLabelVisible: totalFilters > 0,
          backgroundColor: Colors.grey,
          label: Text(
            totalFilters.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF2D3C4E)),
          ),
        ),
      ),
    );
  }
}
