import 'package:equatable/equatable.dart';
import 'package:hotel_list_app/features/venues/domain/entities/filter_entity.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {
  final List<FilterEntity> filters;
  final List<String> selectedFacilities;
  final List<String> selectedFamilyAccess;
  final List<String> selectedGuestAccess;

  const FilterLoaded({
    required this.filters,
    this.selectedFacilities = const [],
    this.selectedFamilyAccess = const [],
    this.selectedGuestAccess = const [],
  });

  FilterLoaded copyWith({
    List<FilterEntity>? filters,
    List<String>? selectedFacilities,
    List<String>? selectedFamilyAccess,
    List<String>? selectedGuestAccess,
  }) {
    return FilterLoaded(
      filters: filters ?? this.filters,
      selectedFacilities: selectedFacilities ?? this.selectedFacilities,
      selectedFamilyAccess: selectedFamilyAccess ?? this.selectedFamilyAccess,
      selectedGuestAccess: selectedGuestAccess ?? this.selectedGuestAccess,
    );
  }

  @override
  List<Object> get props => [filters, selectedFacilities, selectedFamilyAccess, selectedGuestAccess];
}

class FilterLoadFailure extends FilterState {
  final String message;

  const FilterLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}
