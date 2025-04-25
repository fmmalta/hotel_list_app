import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/domain/entities/category_entity.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';

class FilterChipWidget extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;

  const FilterChipWidget({super.key, required this.category, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Semantics(
        button: true,
        label: category.name,
        selected: isSelected,
        hint:
            isSelected
                ? 'Selected category ${category.name}. Tap to deselect.'
                : 'Tap to select ${category.name} category',
        excludeSemantics: true,
        child: FilterChip(
          label: Text(
            category.name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          backgroundColor: Colors.white,
          selectedColor: Colors.blueGrey.shade300,
          onSelected: (bool selected) {
            BlocProvider.of<VenuesBloc>(context).add(VenuesFetchByCategoryEvent(category: category.name.toLowerCase()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          tooltip: isSelected ? 'Selected: ${category.name}' : 'Select ${category.name}',
        ),
      ),
    );
  }
}
