import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hotel_list_app/core/injection/dependency_injection.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/venue_repository.dart';

part 'venues_event.dart';
part 'venues_state.dart';

class VenuesBloc extends Bloc<VenuesEvent, VenuesState> {
  final VenueRepository venueRepository = serviceLocator<VenueRepository>();
  List<VenueEntity> _allVenues = [];
  String _selectedCategory = 'hotel';
  String _searchQuery = '';
  List<String> _selectedFacilities = [];
  List<String> _selectedFamilyAccess = [];
  List<String> _selectedGuestAccess = [];
  int _currentPage = 1;
  int _totalPages = 1;
  static const int _pageSize = 10;
  bool _hasReachedMax = false;
  String _sortOrder = 'desc';

  VenuesBloc() : super(VenuesInitial()) {
    on<VenuesFetchEvent>(_onVenuesFetchEvent);
    on<VenuesFetchNextPageEvent>(_onVenuesFetchNextPageEvent);
    on<VenuesSearchEvent>(_onVenuesSearchEvent);
    on<VenuesFetchByCategoryEvent>(_onVenuesFetchByCategoryEvent);
    on<VenuesToggleSortOrderEvent>(_onVenuesToggleSortOrderEvent);
    on<VenuesFetchByFacilitiesEvent>(_onVenuesFetchByFacilitiesEvent);
  }

  Future<List<VenueEntity>> _fetchVenuesWithFilters() async {
    final allFacilities = [..._selectedFacilities, ..._selectedFamilyAccess, ..._selectedGuestAccess];

    return venueRepository.getVenues(
      page: _currentPage,
      limit: _pageSize,
      category: _selectedCategory,
      search: _searchQuery,
      facilities: allFacilities,
    );
  }

  void _updateMetadataFromResults(List<VenueEntity> venues) {
    if (venues.length < _pageSize) {
      _hasReachedMax = true;
      _totalPages = _currentPage;
    } else {
      _totalPages = _currentPage + 1;
      _hasReachedMax = false;
    }

    _allVenues.sort(
      (a, b) => _sortOrder == 'asc' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt),
    );
  }

  VenuesLoaded _createLoadedState() => VenuesLoaded(
    venues: _allVenues,
    totalPages: _totalPages,
    currentPage: _currentPage,
    hasReachedMax: _hasReachedMax,
    searchQuery: _searchQuery,
    selectedCategory: _selectedCategory,
    sortOrder: _sortOrder,
    selectedFacilities: _selectedFacilities,
    selectedFamilyAccess: _selectedFamilyAccess,
    selectedGuestAccess: _selectedGuestAccess,
  );

  Future<void> _onVenuesFetchEvent(VenuesFetchEvent event, Emitter<VenuesState> emit) async {
    emit(VenuesLoading());

    try {
      _currentPage = 1;
      _hasReachedMax = false;

      if (event.resetFilters) {
        _selectedFacilities = [];
        _selectedFamilyAccess = [];
        _selectedGuestAccess = [];
      }

      _allVenues = await _fetchVenuesWithFilters();
      _updateMetadataFromResults(_allVenues);
      emit(_createLoadedState());
    } catch (e) {
      emit(VenuesError(message: e.toString()));
    }
  }

  Future<void> _onVenuesFetchNextPageEvent(VenuesFetchNextPageEvent event, Emitter<VenuesState> emit) async {
    if (_hasReachedMax) return;

    if (state is VenuesLoaded) {
      final currentState = state as VenuesLoaded;
      emit(
        VenuesLoadingMore(
          currentVenues: currentState.venues,
          currentPage: _currentPage,
          searchQuery: _searchQuery,
          selectedCategory: _selectedCategory,
          selectedFacilities: _selectedFacilities,
          selectedFamilyAccess: _selectedFamilyAccess,
          selectedGuestAccess: _selectedGuestAccess,
        ),
      );

      try {
        _currentPage = event.page;
        final newVenues = await _fetchVenuesWithFilters();

        if (newVenues.isEmpty) {
          _hasReachedMax = true;
          emit(
            VenuesLoaded(
              venues: _allVenues,
              totalPages: _currentPage - 1,
              currentPage: _currentPage - 1,
              hasReachedMax: true,
              searchQuery: _searchQuery,
              selectedCategory: _selectedCategory,
              sortOrder: _sortOrder,
              selectedFacilities: _selectedFacilities,
              selectedFamilyAccess: _selectedFamilyAccess,
              selectedGuestAccess: _selectedGuestAccess,
            ),
          );
          return;
        }

        _allVenues.addAll(newVenues);
        _updateMetadataFromResults(newVenues);
        emit(_createLoadedState());
      } catch (e) {
        emit(VenuesError(message: e.toString()));
      }
    }
  }

  void _onVenuesFetchByCategoryEvent(VenuesFetchByCategoryEvent event, Emitter<VenuesState> emit) async {
    _selectedCategory = event.category;
    _currentPage = 1;
    _hasReachedMax = false;
    emit(VenuesLoading());

    try {
      _allVenues = await _fetchVenuesWithFilters();
      _updateMetadataFromResults(_allVenues);
      emit(_createLoadedState());
    } catch (e) {
      emit(VenuesError(message: e.toString()));
    }
  }

  void _onVenuesSearchEvent(VenuesSearchEvent event, Emitter<VenuesState> emit) async {
    _searchQuery = event.query.toLowerCase();
    _currentPage = 1;
    _hasReachedMax = false;

    try {
      _allVenues = await _fetchVenuesWithFilters();
      _updateMetadataFromResults(_allVenues);
      emit(_createLoadedState());
    } catch (e) {
      emit(VenuesError(message: e.toString()));
    }
  }

  void _onVenuesToggleSortOrderEvent(VenuesToggleSortOrderEvent event, Emitter<VenuesState> emit) {
    _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc';
    _allVenues.sort(
      (a, b) => _sortOrder == 'asc' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt),
    );
    emit(_createLoadedState());
  }

  void _onVenuesFetchByFacilitiesEvent(VenuesFetchByFacilitiesEvent event, Emitter<VenuesState> emit) async {
    switch (event.filterType) {
      case 'facilities':
        _selectedFacilities = event.facilities;
        break;
      case 'familyAccess':
        _selectedFamilyAccess = event.facilities;
        break;
      case 'guestAccess':
        _selectedGuestAccess = event.facilities;
        break;
    }

    _currentPage = 1;
    _hasReachedMax = false;
    emit(VenuesLoading());

    try {
      _allVenues = await _fetchVenuesWithFilters();
      _updateMetadataFromResults(_allVenues);
      emit(_createLoadedState());
    } catch (e) {
      emit(VenuesError(message: e.toString()));
    }
  }
}
