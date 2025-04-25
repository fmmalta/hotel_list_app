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
}
