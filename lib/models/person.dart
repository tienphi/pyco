import 'package:json_annotation/json_annotation.dart';
import 'package:pyco/bases/model.dart';
import 'package:pyco/input.dart';
import 'package:pyco/models/location.dart';

import 'person_name.dart';

part 'person.g.dart';

const PERSON_TABLE = 'person';
const PERSON_TABLE_ID_COLUMN = 'id';
const PERSON_TABLE_PICTURE_COLUMN = 'picture';
const PERSON_TABLE_GENDER_COLUMN = 'gender';
const PERSON_TABLE_NAME_TITLE_COLUMN = 'name_title';
const PERSON_TABLE_FIRST_NAME_COLUMN = 'first_name';
const PERSON_TABLE_LAST_NAME_COLUMN = 'last_name';
const PERSON_TABLE_LOCATION_STREET_COLUMN = 'location_street';
const PERSON_TABLE_PHONE_COLUMN = 'phone';
const PERSON_TABLE_USERNAME_COLUMN = 'username';
const PERSON_TABLE_SALT_COLUMN = 'salt';
const PERSON_TABLE_IS_FAVORITE_COLUMN = 'is_favorite';

@JsonSerializable(explicitToJson: true)
class Person extends BaseModel {
  @override
  @JsonKey(name: 'md5', defaultValue: 'Unknown')
  String id;

  String get idToDisplay => id ?? 'Unknown';

  @JsonKey(name: 'picture', defaultValue: 'Unknown')
  String picture;

  String get pictureToDisplay => picture ?? 'Unknown';

  @JsonKey(name: 'gender', defaultValue: 'Unknown')
  String gender;

  String get genderToDisplay => gender ?? 'Unknown';

  @JsonKey(name: 'phone', defaultValue: 'Unknown')
  String phone;

  String get phoneToDisplay => phone ?? 'Unknown';

  @JsonKey(name: 'username', defaultValue: 'Unknown')
  String userName;

  String get userNameToDisplay => userName ?? 'Unknown';

  @JsonKey(name: 'salt', defaultValue: 'Unknown')
  String salt;

  String get saltToDisplay => salt ?? 'Unknown';

  String get nameToDisplay => '$gender';

  @JsonKey(
    defaultValue: false,
  )
  bool isFavorite;

  static PersonName _personNameFromJson(Map<String, dynamic> json) {
    return isNull(json) ? PersonName() : PersonName.fromJson(json);
  }

  static Map<String, dynamic> _personNameToJson(PersonName userName) =>
      isNull(userName) ? PersonName().toJson() : userName.toJson();

  @JsonKey(
    name: 'name',
    fromJson: _personNameFromJson,
    toJson: _personNameToJson,
  )
  PersonName personName;

  static Location _locationFromJson(Map<String, dynamic> json) =>
      isNull(json) ? Location() : Location.fromJson(json);

  static Map<String, dynamic> _locationToJson(Location location) =>
      isNull(location) ? Location().toJson() : location.toJson();

  @JsonKey(
    name: 'location',
    fromJson: _locationFromJson,
    toJson: _locationToJson,
  )
  Location location;

  Person({
    this.picture,
    this.gender,
    this.phone,
    this.userName,
    this.salt,
    this.isFavorite = false,
    this.personName,
    this.location,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  factory Person.fromJsonLocalDatabase(Map<String, dynamic> json) {
    final jsonDataKeys = json.keys;
    Person result = _$PersonFromJson(json);
    result.personName = PersonName();
    result.location = Location();
    jsonDataKeys.forEach(
      (key) {
        switch (key) {
          case PERSON_TABLE_ID_COLUMN:
            {
              result.id = json[key];
              break;
            }
          case PERSON_TABLE_NAME_TITLE_COLUMN:
            {
              result.personName.nameTitle = json[key];
              break;
            }
          case PERSON_TABLE_FIRST_NAME_COLUMN:
            {
              result.personName.firstName = json[key];
              break;
            }
          case PERSON_TABLE_LAST_NAME_COLUMN:
            {
              result.personName.lastName = json[key];
              break;
            }
          case PERSON_TABLE_LOCATION_STREET_COLUMN:
            {
              result.location.locationStreet = json[key];
              break;
            }
          case PERSON_TABLE_IS_FAVORITE_COLUMN:
            {
              result.isFavorite = json[key] == 0 ? false : true;
              break;
            }
          default:
            {}
        }
      },
    );
    return result;
  }

  void addToMapPairsFromMap(
      Map<String, dynamic> source, Map<String, dynamic> target) {
    final jsonKeys = source.keys;
    jsonKeys.forEach(
      (key) {
        target[key] = source[key];
      },
    );
  }

  @override
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  Map<String, dynamic> toJsonSaveLocalDatabase() {
    Map<String, dynamic> result = {};
    final jsonData = _$PersonToJson(this);
    final jsonName = personName.toJsonToSaveDatabase();
    final jsonLocation = location.toJsonToSaveDatabase();
    final jsonDataKeys = jsonData.keys;

    jsonDataKeys.forEach(
      (key) {
        switch (key) {
          case 'md5':
            {
              result[PERSON_TABLE_ID_COLUMN] = jsonData[key];
              break;
            }
          case 'isFavorite':
            {
              final isFavorite = jsonData[key] as bool;
              result[PERSON_TABLE_IS_FAVORITE_COLUMN] = isFavorite ? 1 : 0;
              break;
            }

          case 'name':
            {
              addToMapPairsFromMap(jsonName, result);
              break;
            }

          case 'location':
            {
              addToMapPairsFromMap(jsonLocation, result);
              break;
            }

          default:
            {
              result[key] = jsonData[key];
            }
        }
      },
    );

    return result;
  }
}
