import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';

extension VenueStateExtension on VenuesState {
  int get totalFilters {
    if (this is VenuesLoaded) {
      final state = this as VenuesLoaded;
      return state.selectedFacilities.length + state.selectedFamilyAccess.length + state.selectedGuestAccess.length;
    } else if (this is VenuesLoadingMore) {
      final state = this as VenuesLoadingMore;
      return state.selectedFacilities.length + state.selectedFamilyAccess.length + state.selectedGuestAccess.length;
    }
    return 0;
  }

  String get searchQuery => this is VenuesLoaded ? (this as VenuesLoaded).searchQuery : '';

  String get sortOrder => this is VenuesLoaded ? (this as VenuesLoaded).sortOrder : 'desc';

  String get categoryName =>
      this is VenuesLoaded
          ? (this as VenuesLoaded).selectedCategory
          : this is VenuesLoadingMore
          ? (this as VenuesLoadingMore).selectedCategory
          : '';

  int get venueCount =>
      this is VenuesLoaded
          ? (this as VenuesLoaded).venues.length
          : this is VenuesLoadingMore
          ? (this as VenuesLoadingMore).currentVenues.length
          : 0;

  bool get isLoading => this is VenuesLoading || this is VenuesLoadingMore;

  bool get hasFilters => totalFilters > 0;

  bool get hasSearch => searchQuery.isNotEmpty;

  bool get isFilterActive => hasFilters || hasSearch;

  bool get isEmpty =>
      this is VenuesLoaded
          ? (this as VenuesLoaded).venues.isEmpty
          : this is VenuesLoadingMore
          ? (this as VenuesLoadingMore).currentVenues.isEmpty
          : true;

  List<VenueEntity> get venues =>
      this is VenuesLoaded
          ? (this as VenuesLoaded).venues
          : this is VenuesLoadingMore
          ? (this as VenuesLoadingMore).currentVenues
          : [];

  T? mapState<T>({
    T Function(VenuesInitial)? initial,
    T Function(VenuesLoading)? loading,
    T Function(VenuesLoadingMore)? loadingMore,
    T Function(VenuesLoaded)? loaded,
    T Function(VenuesError)? error,
    T Function(VenuesNoResults)? noResults,
    T Function(VenuesState)? orElse,
  }) {
    if (this is VenuesInitial && initial != null) {
      return initial(this as VenuesInitial);
    } else if (this is VenuesLoading && loading != null) {
      return loading(this as VenuesLoading);
    } else if (this is VenuesLoadingMore && loadingMore != null) {
      return loadingMore(this as VenuesLoadingMore);
    } else if (this is VenuesLoaded && loaded != null) {
      return loaded(this as VenuesLoaded);
    } else if (this is VenuesError && error != null) {
      return error(this as VenuesError);
    } else if (this is VenuesNoResults && noResults != null) {
      return noResults(this as VenuesNoResults);
    } else if (orElse != null) {
      return orElse(this);
    }
    return null;
  }

  Map<String, dynamic> get analyticsProperties => {
    'category': categoryName,
    'has_filters': hasFilters,
    'filter_count': totalFilters,
    'has_search': hasSearch,
    'search_query': searchQuery,
    'sort_order': sortOrder,
    'venue_count': venueCount,
    'state_type': runtimeType.toString(),
  };
}
