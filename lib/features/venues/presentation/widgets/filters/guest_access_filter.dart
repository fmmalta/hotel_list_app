import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';

class GuestAccessFilter extends StatefulWidget {
  final List<String> availableGuestAccessOptions;

  const GuestAccessFilter({super.key, required this.availableGuestAccessOptions});

  @override
  State<GuestAccessFilter> createState() => _GuestAccessFilterState();
}

class _GuestAccessFilterState extends State<GuestAccessFilter> {
  final List<String> _selectedGuestAccessOptions = [];
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenuesBloc, VenuesState>(
      builder: (context, state) {
        if (state is VenuesLoaded && state.selectedGuestAccess.isEmpty && _selectedGuestAccessOptions.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _selectedGuestAccessOptions.clear();
              _hasInitialized = false;
            });
          });
        }

        if (state is VenuesLoaded && !_hasInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateSelectedFromState(state.selectedGuestAccess);
          });
        }

        return ExpansionTile(
          title: Row(children: [const Text('Guest access', style: TextStyle(fontWeight: FontWeight.bold))]),
          subtitle:
              _selectedGuestAccessOptions.isEmpty
                  ? const Text('Any options')
                  : Text('${_selectedGuestAccessOptions.length} selected'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    widget.availableGuestAccessOptions.map((option) {
                      final isSelected = _selectedGuestAccessOptions.contains(option);
                      return FilterChip(
                        label: Text(option),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedGuestAccessOptions.add(option);
                            } else {
                              _selectedGuestAccessOptions.remove(option);
                            }
                          });

                          try {
                            final bloc = BlocProvider.of<VenuesBloc>(context);
                            if (!bloc.isClosed) {
                              bloc.add(
                                VenuesFetchByFacilitiesEvent(
                                  facilities: List.from(_selectedGuestAccessOptions),
                                  filterType: 'guestAccess',
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
    if (_selectedGuestAccessOptions.length != stateSelected.length ||
        !_selectedGuestAccessOptions.toSet().containsAll(stateSelected.toSet())) {
      setState(() {
        _selectedGuestAccessOptions.clear();
        _selectedGuestAccessOptions.addAll(stateSelected);
        _hasInitialized = true;
      });
    }
  }
}
