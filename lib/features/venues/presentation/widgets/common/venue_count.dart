import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/extensions/venues_state_extension.dart';

class VenueCount extends StatelessWidget {
  final VenuesState state;

  const VenueCount({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final count = state.venueCount;
    final categoryName = state.categoryName;

    if (count == 0 && (state is! VenuesLoaded && state is! VenuesLoadingMore)) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: '$count $categoryName venues found',
      excludeSemantics: true,
      child: Text(
        '$count $categoryName venues',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2D3C4E)),
      ),
    );
  }
}
