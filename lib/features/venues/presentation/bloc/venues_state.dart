part of 'venues_bloc.dart';

abstract class VenuesState extends Equatable {
  const VenuesState();

  @override
  List<Object> get props => [];
}

class VenuesInitial extends VenuesState {}

class VenuesLoading extends VenuesState {}

class VenuesLoadingMore extends VenuesState {
  final List<VenueEntity> currentVenues;
  final int currentPage;
  final String searchQuery;
  final String selectedCategory;
  final List<String> selectedFacilities;
  final List<String> selectedFamilyAccess;
  final List<String> selectedGuestAccess;

  const VenuesLoadingMore({
    required this.currentVenues,
    required this.currentPage,
    this.searchQuery = '',
    this.selectedCategory = 'hotel',
    this.selectedFacilities = const [],
    this.selectedFamilyAccess = const [],
    this.selectedGuestAccess = const [],
  });

  @override
  List<Object> get props => [
    currentVenues,
    currentPage,
    searchQuery,
    selectedCategory,
    selectedFacilities,
    selectedFamilyAccess,
    selectedGuestAccess,
  ];
}

class VenuesLoaded extends VenuesState {
  final List<VenueEntity> venues;
  final int totalPages;
  final int currentPage;
  final bool hasReachedMax;
  final String searchQuery;
  final String selectedCategory;
  final String sortOrder;
  final List<String> selectedFacilities;
  final List<String> selectedFamilyAccess;
  final List<String> selectedGuestAccess;

  const VenuesLoaded({
    required this.venues,
    required this.totalPages,
    required this.currentPage,
    this.hasReachedMax = false,
    this.searchQuery = '',
    this.selectedCategory = 'hotel',
    this.sortOrder = 'desc',
    this.selectedFacilities = const [],
    this.selectedFamilyAccess = const [],
    this.selectedGuestAccess = const [],
  });

  @override
  List<Object> get props => [
    venues,
    totalPages,
    currentPage,
    hasReachedMax,
    searchQuery,
    selectedCategory,
    sortOrder,
    selectedFacilities,
    selectedFamilyAccess,
    selectedGuestAccess,
  ];
}

class VenueDetailLoaded extends VenuesState {
  final VenueEntity venue;

  const VenueDetailLoaded({required this.venue});

  @override
  List<Object> get props => [venue];
}

class VenuesError extends VenuesState {
  final String message;

  const VenuesError({required this.message});

  @override
  List<Object> get props => [message];
}

class VenuesNoResults extends VenuesState {
  final String searchQuery;

  const VenuesNoResults({required this.searchQuery});

  @override
  List<Object> get props => [searchQuery];
}
