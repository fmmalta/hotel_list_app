import 'package:json_annotation/json_annotation.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';

part 'venue_dto.g.dart';

@JsonSerializable()
class VenueDTO {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'location', defaultValue: '')
  final String location;

  @JsonKey(name: 'overview')
  final String overview;

  @JsonKey(name: 'rating', defaultValue: 0.0)
  final double rating;

  @JsonKey(name: 'price', defaultValue: 0.0)
  final double price;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'images', defaultValue: [])
  final List<ImageDTO> images;

  @JsonKey(name: 'activities', defaultValue: [])
  final List<ActivityDTO> activities;

  @JsonKey(name: 'facilities', defaultValue: [])
  final List<FacilityDTO> facilities;

  @JsonKey(name: 'coordinates')
  final CoordinatesDTO? coordinates;

  @JsonKey(name: 'thingsToDo', defaultValue: [])
  final List<ThingToDoDTO> thingsToDo;

  VenueDTO({
    required this.id,
    required this.name,
    required this.location,
    required this.overview,
    required this.rating,
    required this.price,
    required this.createdAt,
    required this.images,
    required this.activities,
    required this.facilities,
    this.coordinates,
    required this.thingsToDo,
  });

  factory VenueDTO.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('coordinates')) {
      json['coordinates'] = {'latitude': 0.0, 'longitude': 0.0};
    }

    if (!json.containsKey('thingsToDo')) {
      json['thingsToDo'] = [];
    }

    return _$VenueDTOFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VenueDTOToJson(this);

  VenueEntity toEntity() {
    return VenueEntity(
      id: id,
      name: name,
      location: location,
      overview: overview,
      rating: rating,
      price: price,
      latitude: coordinates?.latitude ?? 0.0,
      longitude: coordinates?.longitude ?? 0.0,
      createdAt: createdAt,
      imageUrls: images.map((img) => img.url).toList(),
      activities: activities.map((a) => a.name).toList(),
      facilities: facilities.map((f) => f.name).toList(),
      thingsToDo: thingsToDo.map((t) => t.toEntity()).toList(),
    );
  }

  static List<VenueEntity> toEntityList(List<VenueDTO> dtos) {
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}

@JsonSerializable()
class ImageDTO {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'venueId')
  final String venueId;

  ImageDTO({required this.id, required this.url, required this.venueId});

  factory ImageDTO.fromJson(Map<String, dynamic> json) => _$ImageDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ImageDTOToJson(this);
}

@JsonSerializable()
class ActivityDTO {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  ActivityDTO({required this.id, required this.name});

  factory ActivityDTO.fromJson(Map<String, dynamic> json) => _$ActivityDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityDTOToJson(this);
}

@JsonSerializable()
class FacilityDTO {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  FacilityDTO({required this.id, required this.name});

  factory FacilityDTO.fromJson(Map<String, dynamic> json) => _$FacilityDTOFromJson(json);
  Map<String, dynamic> toJson() => _$FacilityDTOToJson(this);
}

@JsonSerializable()
class CoordinatesDTO {
  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  CoordinatesDTO({required this.latitude, required this.longitude});

  factory CoordinatesDTO.fromJson(Map<String, dynamic> json) => _$CoordinatesDTOFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesDTOToJson(this);
}

@JsonSerializable()
class ThingToDoDTO {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'badge')
  final String? badge;

  @JsonKey(name: 'subtitle')
  final String? subtitle;

  @JsonKey(name: 'content')
  final String? content;

  @JsonKey(name: 'venueId')
  final String venueId;

  ThingToDoDTO({required this.id, required this.title, this.badge, this.subtitle, this.content, required this.venueId});

  factory ThingToDoDTO.fromJson(Map<String, dynamic> json) => _$ThingToDoDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ThingToDoDTOToJson(this);

  ThingToDoEntity toEntity() {
    return ThingToDoEntity(
      id: id,
      title: title,
      badge: badge,
      subtitle: subtitle,
      content: content,
      venueId: venueId,
      items: [],
    );
  }
}
