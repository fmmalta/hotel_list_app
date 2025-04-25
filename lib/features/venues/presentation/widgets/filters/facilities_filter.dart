import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';

class FacilitiesFilter extends StatefulWidget {
  final List<String> availableFacilities;

  const FacilitiesFilter({super.key, required this.availableFacilities});

  @override
  State<FacilitiesFilter> createState() => _FacilitiesFilterState();
}

class _FacilitiesFilterState extends State<FacilitiesFilter> {
  final List<String> _selectedFacilities = [];
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenuesBloc, VenuesState>(
      builder: (context, state) {
        if (state is VenuesLoaded && state.selectedFacilities.isEmpty && _selectedFacilities.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _selectedFacilities.clear();
              _hasInitialized = false;
            });
          });
        }

        if (state is VenuesLoaded && !_hasInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateSelectedFromState(state.selectedFacilities);
          });
        }

        return ExpansionTile(
          title: Row(children: [const Text('Hotel facilities', style: TextStyle(fontWeight: FontWeight.bold))]),
          subtitle:
              _selectedFacilities.isEmpty
                  ? const Text('Any facilities')
                  : Text('${_selectedFacilities.length} selected'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    widget.availableFacilities.map((facility) {
                      final isSelected = _selectedFacilities.contains(facility);
                      return FilterChip(
                        label: Text(facility),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFacilities.add(facility);
                            } else {
                              _selectedFacilities.remove(facility);
                            }
                          });

                          try {
                            final bloc = BlocProvider.of<VenuesBloc>(context);
                            if (!bloc.isClosed) {
                              bloc.add(
                                VenuesFetchByFacilitiesEvent(
                                  facilities: List.from(_selectedFacilities),
                                  filterType: 'facilities',
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint('Failed to send event: $e');
                          }
                        },
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _updateSelectedFromState(List<String> stateSelected) {
    if (_selectedFacilities.length != stateSelected.length ||
        !_selectedFacilities.toSet().containsAll(stateSelected.toSet())) {
      setState(() {
        _selectedFacilities.clear();
        _selectedFacilities.addAll(stateSelected);
        _hasInitialized = true;
      });
    }
  }
}
