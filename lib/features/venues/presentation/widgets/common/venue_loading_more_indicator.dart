import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/skeletons/index.dart';

class VenueLoadingMoreIndicator extends StatelessWidget {
  const VenueLoadingMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(16.0), child: SizedBox(height: 100, child: VenueCardSkeleton()));
  }
}
