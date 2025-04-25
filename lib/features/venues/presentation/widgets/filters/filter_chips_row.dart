import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_state.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/filter_chip_widget.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, filterState) {
        if (filterState is FilterLoaded) {
          return BlocBuilder<VenuesBloc, VenuesState>(
            builder: (context, venuesState) {
              String selectedCategory = '';

              if (venuesState is VenuesLoaded) {
                selectedCategory = venuesState.selectedCategory;
              } else if (venuesState is VenuesLoadingMore) {
                selectedCategory = venuesState.selectedCategory;
              }

              final categoryFilter = filterState.filters.firstWhere(
                (filter) => filter.type == 'category',
                orElse: () => filterState.filters.first,
              );

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      categoryFilter.categories
                          .map(
                            (category) => FilterChipWidget(
                              category: category,
                              isSelected: category.name.toLowerCase() == selectedCategory.toLowerCase(),
                            ),
                          )
                          .toList(),
                ),
              );
            },
          );
        }

        if (filterState is FilterLoading) {
          return const Center(
            child: Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: CircularProgressIndicator()),
          );
        }

        if (filterState is FilterLoadFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: Text('Failed to load filters: ${filterState.message}', style: const TextStyle(color: Colors.red)),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
