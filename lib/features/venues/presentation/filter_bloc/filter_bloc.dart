import 'package:bloc/bloc.dart';
import 'package:hotel_list_app/core/injection/dependency_injection.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/filter_repository.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final FilterRepository filterRepository = serviceLocator<FilterRepository>();

  FilterBloc() : super(FilterInitial()) {
    on<FilterFetchEvent>(_onFilterFetchEvent);
    on<FilterFetchByFacilitiesEvent>(_onFilterFetchByFacilitiesEvent);
    on<FilterFetchByFamilyAccessEvent>(_onFilterFetchByFamilyAccessEvent);
    on<FilterFetchByGuestAccessEvent>(_onFilterFetchByGuestAccessEvent);
  }

  void _onFilterFetchEvent(FilterFetchEvent event, Emitter<FilterState> emit) async {
    emit(FilterLoading());
    try {
      final filters = await filterRepository.getFilters();
      emit(FilterLoaded(filters: filters));
    } catch (e) {
      emit(FilterLoadFailure(message: e.toString()));
    }
  }

  void _onFilterFetchByFacilitiesEvent(FilterFetchByFacilitiesEvent event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      emit(currentState.copyWith(selectedFacilities: event.facilities));
    }
  }

  void _onFilterFetchByFamilyAccessEvent(FilterFetchByFamilyAccessEvent event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      emit(currentState.copyWith(selectedFamilyAccess: event.familyAccess));
    }
  }

  void _onFilterFetchByGuestAccessEvent(FilterFetchByGuestAccessEvent event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      final currentState = state as FilterLoaded;
      emit(currentState.copyWith(selectedGuestAccess: event.guestAccess));
    }
  }
}
