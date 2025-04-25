part of 'venues_bloc.dart';

abstract class VenuesEvent extends Equatable {
  const VenuesEvent();

  @override
  List<Object> get props => [];
}

class VenuesFetchEvent extends VenuesEvent {
  final bool resetFilters;

  const VenuesFetchEvent({this.resetFilters = true});

  @override
  List<Object> get props => [resetFilters];
}

class VenuesFetchNextPageEvent extends VenuesEvent {
  final int page;
  final bool isLoadMore;

  const VenuesFetchNextPageEvent({required this.page, this.isLoadMore = true});

  @override
  List<Object> get props => [page, isLoadMore];
}

class VenuesFetchPreviousPageEvent extends VenuesEvent {}

class VenuesFetchSortEvent extends VenuesEvent {}

class VenuesFetchSearchEvent extends VenuesEvent {}

class VenuesFetchByIdEvent extends VenuesEvent {
  final String id;

  const VenuesFetchByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class VenuesSearchEvent extends VenuesEvent {
  final String query;

  const VenuesSearchEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class VenuesFetchByCategoryEvent extends VenuesEvent {
  final String category;

  const VenuesFetchByCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class VenuesToggleSortOrderEvent extends VenuesEvent {}

class VenuesFetchByFacilitiesEvent extends VenuesEvent {
  final List<String> facilities;
  final String filterType;

  const VenuesFetchByFacilitiesEvent({required this.facilities, this.filterType = 'facilities'});

  @override
  List<Object> get props => [facilities, filterType];
}
