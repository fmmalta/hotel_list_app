import 'package:equatable/equatable.dart';

abstract class VenueDetailEvent extends Equatable {
  const VenueDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchVenueDetailEvent extends VenueDetailEvent {
  final String id;

  const FetchVenueDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
