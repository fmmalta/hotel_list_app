import 'package:equatable/equatable.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class FilterFetchEvent extends FilterEvent {}

class FilterFetchByCategoryEvent extends FilterEvent {
  final String category;

  const FilterFetchByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class FilterFetchByFacilitiesEvent extends FilterEvent {
  final List<String> facilities;

  const FilterFetchByFacilitiesEvent({required this.facilities});

  @override
  List<Object> get props => [facilities];
}

class FilterFetchByFamilyAccessEvent extends FilterEvent {
  final List<String> familyAccess;

  const FilterFetchByFamilyAccessEvent({required this.familyAccess});

  @override
  List<Object> get props => [familyAccess];
}

class FilterFetchByGuestAccessEvent extends FilterEvent {
  final List<String> guestAccess;

  const FilterFetchByGuestAccessEvent({required this.guestAccess});

  @override
  List<Object> get props => [guestAccess];
}
