import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/domain/entities/filter_entity.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_event.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_state.dart';

import 'index.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: BlocBuilder<VenuesBloc, VenuesState>(
            builder: (context, venuesState) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter Venues', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            try {
                              final bloc = BlocProvider.of<VenuesBloc>(context);
                              if (!bloc.isClosed) {
                                bloc.add(const VenuesFetchEvent(resetFilters: true));
                              }
                            } catch (e) {
                              debugPrint('Failed to reset filters: $e');
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Reset All'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: BlocProvider<FilterBloc>(
                      create: (context) => FilterBloc()..add(FilterFetchEvent()),
                      child: BlocBuilder<FilterBloc, FilterState>(
                        builder: (context, state) {
                          if (state is FilterLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (state is FilterLoadFailure) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Failed to load filters: ${state.message}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                                ],
                              ),
                            );
                          }

                          if (state is FilterLoaded) {
                            final filters = state.filters;

                            final hotelFacilitiesFilter = _findFilterByName(filters, 'Hotel facilities');
                            final familyAccessFilter = _findFilterByName(filters, 'Family access');
                            final guestAccessFilter = _findFilterByName(filters, 'Guest access');

                            return ListView(
                              controller: scrollController,
                              children: [
                                if (hotelFacilitiesFilter != null)
                                  FacilitiesFilter(
                                    availableFacilities:
                                        hotelFacilitiesFilter.categories.map((category) => category.name).toList(),
                                  ),
                                if (familyAccessFilter != null)
                                  FamilyAccessFilter(
                                    availableFamilyAccessOptions:
                                        familyAccessFilter.categories.map((category) => category.name).toList(),
                                  ),
                                if (guestAccessFilter != null)
                                  GuestAccessFilter(
                                    availableGuestAccessOptions:
                                        guestAccessFilter.categories.map((category) => category.name).toList(),
                                  ),
                              ],
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3C4E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              );
            },
          ),
        );
      },
    );
  }

  FilterEntity? _findFilterByName(List<FilterEntity> filters, String name) {
    try {
      return filters.firstWhere((filter) => filter.name == name);
    } catch (e) {
      return null;
    }
  }
}
