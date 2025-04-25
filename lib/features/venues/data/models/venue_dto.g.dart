// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueDTO _$VenueDTOFromJson(Map<String, dynamic> json) => VenueDTO(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String? ?? '',
  overview: json['overview'] as String,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => ImageDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  activities:
      (json['activities'] as List<dynamic>?)
          ?.map((e) => ActivityDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  facilities:
      (json['facilities'] as List<dynamic>?)
          ?.map((e) => FacilityDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  coordinates:
      json['coordinates'] == null
          ? null
          : CoordinatesDTO.fromJson(
            json['coordinates'] as Map<String, dynamic>,
          ),
  thingsToDo:
      (json['thingsToDo'] as List<dynamic>?)
          ?.map((e) => ThingToDoDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$VenueDTOToJson(VenueDTO instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'overview': instance.overview,
  'rating': instance.rating,
  'price': instance.price,
  'createdAt': instance.createdAt.toIso8601String(),
  'images': instance.images,
  'activities': instance.activities,
  'facilities': instance.facilities,
  'coordinates': instance.coordinates,
  'thingsToDo': instance.thingsToDo,
};

ImageDTO _$ImageDTOFromJson(Map<String, dynamic> json) => ImageDTO(
  id: json['id'] as String,
  url: json['url'] as String,
  venueId: json['venueId'] as String,
);

Map<String, dynamic> _$ImageDTOToJson(ImageDTO instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'venueId': instance.venueId,
};

ActivityDTO _$ActivityDTOFromJson(Map<String, dynamic> json) =>
    ActivityDTO(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$ActivityDTOToJson(ActivityDTO instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

FacilityDTO _$FacilityDTOFromJson(Map<String, dynamic> json) =>
    FacilityDTO(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$FacilityDTOToJson(FacilityDTO instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

CoordinatesDTO _$CoordinatesDTOFromJson(Map<String, dynamic> json) =>
    CoordinatesDTO(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesDTOToJson(CoordinatesDTO instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

ThingToDoDTO _$ThingToDoDTOFromJson(Map<String, dynamic> json) => ThingToDoDTO(
  id: json['id'] as String,
  title: json['title'] as String,
  badge: json['badge'] as String?,
  subtitle: json['subtitle'] as String?,
  content: json['content'] as String?,
  venueId: json['venueId'] as String,
);

Map<String, dynamic> _$ThingToDoDTOToJson(ThingToDoDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'badge': instance.badge,
      'subtitle': instance.subtitle,
      'content': instance.content,
      'venueId': instance.venueId,
    };
