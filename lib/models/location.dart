import 'package:json_annotation/json_annotation.dart';
import 'package:pyco/bases/model.dart';
import 'package:pyco/models/person.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location extends BaseModel {
  @override
  @JsonKey(defaultValue: '-1')
  String id;

  @JsonKey(name: 'street', defaultValue: '')
  String locationStreet;

  String get locationStreetToDisplay => locationStreet ?? 'Unknown';

  Location({
    this.id = '-1',
    this.locationStreet = 'Unknown',
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  Map<String, dynamic> toJsonToSaveDatabase() {
    final jsonData = _$LocationToJson(this);
    final Map<String, dynamic> result = {};
    jsonData.keys.forEach((key) {
      switch (key) {
        case 'street':
          {
            result[PERSON_TABLE_LOCATION_STREET_COLUMN] = jsonData[key];
            break;
          }
        default:
          {
            result[key] = jsonData[key];
          }
      }
    });

    return result;
  }
}
