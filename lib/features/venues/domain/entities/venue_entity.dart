import 'package:equatable/equatable.dart';

class VenueEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final String overview;
  final double rating;
  final double price;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final List<String> imageUrls;
  final List<String> activities;
  final List<String> facilities;
  final List<ThingToDoEntity> thingsToDo;

  const VenueEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.overview,
    required this.rating,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.imageUrls,
    required this.activities,
    required this.facilities,
    required this.thingsToDo,
  });

  @override
  List<Object> get props => [id, name, location, overview, rating, price, createdAt, imageUrls, activities, facilities];
}

class ThingToDoEntity extends Equatable {
  final String id;
  final String title;
  final String? badge;
  final String? subtitle;
  final String? content;
  final String venueId;
  final List<String> items;

  const ThingToDoEntity({
    required this.id,
    required this.title,
    this.badge,
    this.subtitle,
    this.content,
    required this.venueId,
    required this.items,
  });

  @override
  List<Object> get props => [id, title, venueId, items];
}
