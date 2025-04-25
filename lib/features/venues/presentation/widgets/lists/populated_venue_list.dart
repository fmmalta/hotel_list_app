import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/cards/venue_card.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/common/venue_loading_more_indicator.dart';

class PopulatedVenueList extends StatelessWidget {
  final List venues;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool isLoading;
  final ScrollController scrollController;

  const PopulatedVenueList({
    super.key,
    required this.venues,
    required this.hasReachedMax,
    required this.scrollController,
    this.isLoadingMore = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: venues.length + (hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index >= venues.length) {
          return isLoadingMore || (isLoading && !hasReachedMax)
              ? const VenueLoadingMoreIndicator()
              : const SizedBox.shrink();
        }
        return VenueCard(venue: venues[index]);
      },
    );
  }
}
