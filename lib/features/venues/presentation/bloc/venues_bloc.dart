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

      _allVenues = await venueRepository.getVenues(
        page: _currentPage,
        limit: _pageSize,
        category: _selectedCategory,
        search: _searchQuery,
        facilities: _selectedFacilities,
      );

      if (_allVenues.length < _pageSize) {
        _hasReachedMax = true;
        _totalPages = 1;
      } else {
        _totalPages = 2;
      }

      _allVenues.sort(
        (a, b) => _sortOrder == 'asc' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt),
      );

      emit(
        VenuesLoaded(
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
        ),
      );
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

        final newVenues = await venueRepository.getVenues(
          page: _currentPage,
          limit: _pageSize,
          category: _selectedCategory,
          search: _searchQuery,
          facilities: _selectedFacilities,
        );

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

        if (newVenues.length < _pageSize) {
          _hasReachedMax = true;
          _totalPages = _currentPage;
        } else {
          _totalPages = _currentPage + 1;
          _hasReachedMax = false;
        }

        _allVenues.sort(
          (a, b) => _sortOrder == 'asc' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt),
        );

        emit(
          VenuesLoaded(
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
          ),
        );
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
      _allVenues = await venueRepository.getVenues(
        page: _currentPage,
        limit: _pageSize,
        category: _selectedCategory,
        search: _searchQuery,
        facilities: _selectedFacilities,
      );

      if (_allVenues.length < _pageSize) {
        _hasReachedMax = true;
        _totalPages = 1;
      } else {
        _totalPages = 2;
      }

      _allVenues.sort(
        (a, b) => _sortOrder == 'asc' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt),
      );

      emit(
        VenuesLoaded(
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
        ),
      );
    } catch (e) {
      emit(VenuesError(message: e.toString()));
    }
  }

  void _onVenuesSearchEvent(VenuesSearchEvent event, Emitter<VenuesState> emit) async {
    _searchQuery = event.query.toLowerCase();
    _currentPage = 1;
    _hasReachedMax = false;

    try {
      final venues = await venueRepository.getVenues(
        page: _currentPage,
        limit: _pageSize,
        search: _searchQuery,
        category: _selectedCategory,
        facilities: _selectedFacilities,
      );

      _allVenues = venues;

      if (venues.length < _pageSize) {
        _hasReachedMax = true;
        _totalPages = 1;
      } else {
        _totalPages = 2;
      }

      emit(
        VenuesLoaded(
          venues: venues,
          totalPages: _totalPages,
          currentPage: _currentPage,
          hasReachedMax: _hasReachedMax,
          searchQuery: _searchQuery,
          selectedCategory: _selectedCategory,
          sortOrder: _sortOrder,
          selectedFacilities: _selectedFacilities,
          selectedFamilyAccess: _selectedFamilyAccess,
          selectedGuestAccess: _selectedGuestAccess,
        ),
      );
    } catch (e) {
      emit(VenuesError(message: e.toString()));
    }
  }

  void _onVenuesToggleSortOrderEvent(VenuesToggleSortOrderEvent event, Emitter<VenuesState> emit) {
    _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc';

    _allVenues.sort(
      (a, b) => _sortOrder == 'asc' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt),
    );

    emit(
      VenuesLoaded(
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
      ),
    );
  }

  void _onVenuesFetchByFacilitiesEvent(VenuesFetchByFacilitiesEvent event, Emitter<VenuesState> emit) async {
    if (event.filterType == 'facilities') {
      _selectedFacilities = event.facilities;
    } else if (event.filterType == 'familyAccess') {
      _selectedFamilyAccess = event.facilities;
    } else if (event.filterType == 'guestAccess') {
      _selectedGuestAccess = event.facilities;
    }

    final List<String> allFacilities = [..._selectedFacilities, ..._selectedFamilyAccess, ..._selectedGuestAccess];

    _currentPage = 1;
    _hasReachedMax = false;
    emit(VenuesLoading());

    try {
      _allVenues = await venueRepository.getVenues(
        page: _currentPage,
        limit: _pageSize,
        category: _selectedCategory,
        search: _searchQuery,
        facilities: allFacilities,
      );

      if (_allVenues.length < _pageSize) {
        _hasReachedMax = true;
        _totalPages = 1;
      } else {
        _totalPages = 2;
      }

      _allVenues.sort(
        (a, b) => _sortOrder == 'asc' ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt),
      );

      emit(
        VenuesLoaded(
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
        ),
      );
    } catch (e) {
      emit(VenuesError(message: e.toString()));
    }
  }
}
