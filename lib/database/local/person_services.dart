import 'package:flutter/material.dart';
import 'package:pyco/database/local/database_creator.dart';

import 'package:pyco/models/person.dart';

Future<int> updatePersonFavoriteStateAtLocal({
  @required String id,
  @required bool isFavorite,
}) async {
  final int newState = isFavorite ? 1 : 0;
  final sql = '''UPDATE $PERSON_TABLE
    SET $PERSON_TABLE_IS_FAVORITE_COLUMN = ?
    WHERE $PERSON_TABLE_ID_COLUMN = ?
    ''';
  List<dynamic> params = [newState, id];

  return await personDb.rawUpdate(sql, params);
}
