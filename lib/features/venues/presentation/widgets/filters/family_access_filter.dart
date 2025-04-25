import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';

class FamilyAccessFilter extends StatefulWidget {
  final List<String> availableFamilyAccessOptions;

  const FamilyAccessFilter({super.key, required this.availableFamilyAccessOptions});

  @override
  State<FamilyAccessFilter> createState() => _FamilyAccessFilterState();
}

class _FamilyAccessFilterState extends State<FamilyAccessFilter> {
  final List<String> _selectedFamilyAccessOptions = [];
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenuesBloc, VenuesState>(
      builder: (context, state) {
        if (state is VenuesLoaded && state.selectedFamilyAccess.isEmpty && _selectedFamilyAccessOptions.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _selectedFamilyAccessOptions.clear();
              _hasInitialized = false;
            });
          });
        }

        if (state is VenuesLoaded && !_hasInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateSelectedFromState(state.selectedFamilyAccess);
          });
        }

        return ExpansionTile(
          title: Row(children: [const Text('Family access', style: TextStyle(fontWeight: FontWeight.bold))]),
          subtitle:
              _selectedFamilyAccessOptions.isEmpty
                  ? const Text('Any options')
                  : Text('${_selectedFamilyAccessOptions.length} selected'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    widget.availableFamilyAccessOptions.map((option) {
                      final isSelected = _selectedFamilyAccessOptions.contains(option);
                      return FilterChip(
                        label: Text(option),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFamilyAccessOptions.add(option);
                            } else {
                              _selectedFamilyAccessOptions.remove(option);
                            }
                          });

                          try {
                            final bloc = BlocProvider.of<VenuesBloc>(context);
                            if (!bloc.isClosed) {
                              bloc.add(
                                VenuesFetchByFacilitiesEvent(
                                  facilities: List.from(_selectedFamilyAccessOptions),
                                  filterType: 'familyAccess',
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
    if (_selectedFamilyAccessOptions.length != stateSelected.length ||
        !_selectedFamilyAccessOptions.toSet().containsAll(stateSelected.toSet())) {
      setState(() {
        _selectedFamilyAccessOptions.clear();
        _selectedFamilyAccessOptions.addAll(stateSelected);
        _hasInitialized = true;
      });
    }
  }
}
