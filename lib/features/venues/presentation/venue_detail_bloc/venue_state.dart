import 'package:equatable/equatable.dart';
import 'package:hotel_list_app/core/error/failures.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';

abstract class VenueDetailState extends Equatable {
  const VenueDetailState();

  @override
  List<Object?> get props => [];
}

class VenueDetailInitial extends VenueDetailState {}

class VenueDetailLoading extends VenueDetailState {}

class VenueDetailLoaded extends VenueDetailState {
  final VenueEntity venue;

  const VenueDetailLoaded(this.venue);

  @override
  List<Object?> get props => [venue];
}

class VenueDetailError extends VenueDetailState {
  final String message;
  final Failure? failure;
  final String? errorCode;
  final bool isRecoverable;

  const VenueDetailError({required this.message, this.failure, this.errorCode, this.isRecoverable = true});

  @override
  List<Object?> get props => [message, failure, errorCode, isRecoverable];
}
