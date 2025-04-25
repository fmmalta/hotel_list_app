import 'package:bloc/bloc.dart';
import 'package:hotel_list_app/core/error/bloc_error_handler_mixin.dart';
import 'package:hotel_list_app/core/error/failures.dart';
import 'package:hotel_list_app/core/injection/dependency_injection.dart';
import 'package:hotel_list_app/features/venues/domain/repositories/venue_repository.dart';

import 'venue_event.dart';
import 'venue_state.dart';

class VenueDetailBloc extends Bloc<VenueDetailEvent, VenueDetailState> with BlocErrorHandlerMixin {
  final VenueRepository venueRepository = serviceLocator<VenueRepository>();

  VenueDetailBloc() : super(VenueDetailInitial()) {
    on<FetchVenueDetailEvent>(_onFetchVenueDetailEvent);
  }

  Future<void> _onFetchVenueDetailEvent(FetchVenueDetailEvent event, Emitter<VenueDetailState> emit) async {
    emit(VenueDetailLoading());
    try {
      final venue = await venueRepository.getVenueById(event.id);
      emit(VenueDetailLoaded(venue));
    } catch (e) {
      final failure = handleException(e);
      final errorMessage = getErrorMessage(e);

      emit(
        VenueDetailError(
          message: errorMessage,
          failure: failure,
          errorCode: failure is ServerFailure ? '${failure.statusCode}' : null,
          isRecoverable: failure is! CacheFailure,
        ),
      );
    }
  }
}
