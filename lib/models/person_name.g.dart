// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonName _$PersonNameFromJson(Map<String, dynamic> json) {
  return PersonName(
    nameTitle: json['title'] as String ?? '',
    firstName: json['first'] as String ?? '',
    lastName: json['last'] as String ?? '',
  );
}

Map<String, dynamic> _$PersonNameToJson(PersonName instance) =>
    <String, dynamic>{
      'title': instance.nameTitle,
      'first': instance.firstName,
      'last': instance.lastName,
    };
