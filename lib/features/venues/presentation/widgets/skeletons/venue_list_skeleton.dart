import 'package:flutter/material.dart';

import 'venue_card_skeleton.dart';

class VenueListSkeleton extends StatelessWidget {
  final int itemCount;

  const VenueListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(itemCount: itemCount, itemBuilder: (context, index) => const VenueCardSkeleton()),
    );
  }
}
