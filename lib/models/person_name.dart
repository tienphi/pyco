import 'package:json_annotation/json_annotation.dart';
import 'package:pyco/bases/model.dart';
import 'package:pyco/input.dart';
import 'package:pyco/models/person.dart';

part 'person_name.g.dart';

@JsonSerializable(explicitToJson: true)
class PersonName extends BaseModel {
  @override
  @JsonKey(defaultValue: '-1')
  String id;

  @JsonKey(name: 'title', defaultValue: '')
  String nameTitle;

  String get nameTitleToDisplay => nameTitle ?? '';

  @JsonKey(name: 'first', defaultValue: '')
  String firstName;

  String get firstNameToDisplay => firstName ?? '';

  @JsonKey(name: 'last', defaultValue: '')
  String lastName;

  String get lastNameToDisplay => lastName ?? '';

  String get personNameToCall =>
      '${capitalize(nameTitle ?? '')} ${capitalize(firstName ?? '')} ${capitalize(lastName ?? '')}';

  String get personName =>
      '${capitalize(firstName ?? '')} ${capitalize(lastName ?? '')}';

  PersonName({
    this.id = '-1',
    this.nameTitle = '',
    this.firstName = '',
    this.lastName = '',
  });

  factory PersonName.fromJson(Map<String, dynamic> json) =>
      _$PersonNameFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonNameToJson(this);

  Map<String, dynamic> toJsonToSaveDatabase(String id) {
    final jsonData = _$PersonNameToJson(this);
    final Map<String, dynamic> result = {};
    jsonData.keys.forEach((key) {
      switch (key) {
        case 'title':
          {
            result[PERSON_TABLE_NAME_TITLE_COLUMN] = jsonData[key];
            break;
          }
        case 'first':
          {
            result[PERSON_TABLE_FIRST_NAME_COLUMN] = jsonData[key];
            break;
          }
        case 'last':
          {
            result[PERSON_TABLE_LAST_NAME_COLUMN] = '${jsonData[key]} #$id';
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
