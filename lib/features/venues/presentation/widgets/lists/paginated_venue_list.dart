import 'package:flutter/material.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/lists/empty_venue_list.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/lists/populated_venue_list.dart';

class PaginatedVenueList extends StatelessWidget {
  final List venues;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool isLoading;
  final ScrollController scrollController;
  final EdgeInsetsGeometry padding;
  final VoidCallback onRefresh;

  const PaginatedVenueList({
    super.key,
    required this.venues,
    required this.hasReachedMax,
    required this.scrollController,
    required this.onRefresh,
    this.isLoadingMore = false,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child:
            venues.isEmpty
                ? const EmptyVenueList()
                : PopulatedVenueList(
                  venues: venues,
                  hasReachedMax: hasReachedMax,
                  isLoadingMore: isLoadingMore,
                  isLoading: isLoading,
                  scrollController: scrollController,
                ),
      ),
    );
  }
}
