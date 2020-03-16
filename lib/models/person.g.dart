// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    picture: json['picture'] as String ?? 'Unknown',
    gender: json['gender'] as String ?? 'Unknown',
    phone: json['phone'] as String ?? 'Unknown',
    userName: json['username'] as String ?? 'Unknown',
    salt: json['salt'] as String ?? 'Unknown',
    isFavorite: json['isFavorite'] as bool ?? false,
    personName:
        Person._personNameFromJson(json['name'] as Map<String, dynamic>),
    location:
        Person._locationFromJson(json['location'] as Map<String, dynamic>),
  )..id = json['md5'] as String ?? 'Unknown';
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'md5': instance.id,
      'picture': instance.picture,
      'gender': instance.gender,
      'phone': instance.phone,
      'username': instance.userName,
      'salt': instance.salt,
      'isFavorite': instance.isFavorite,
      'name': Person._personNameToJson(instance.personName),
      'location': Person._locationToJson(instance.location),
    };
