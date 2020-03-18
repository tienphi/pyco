// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    locationStreet: json['street'] as String ?? '',
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'street': instance.locationStreet,
    };
