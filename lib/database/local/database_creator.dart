import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pyco/models/person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database personDb;

Future<String> getDatabasePath(String dbName,
    [bool deleteOldData = false]) async {
  // Get a location using getDatabasesPath
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, dbName);

  // Make sure the folder exists
  if (await Directory(dirname(path)).exists()) {
    if (deleteOldData) {
      await deleteDatabase(path);
    }
  } else {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print('CREATE DB PATH ERROR: $e');
    }
  }
  return path;
}

class SqLiteDatabaseCreator {
  Future<void> initDatabase() async {
    // Create Person database
    final personPath = await getDatabasePath(PERSON_TABLE);
    final personCreatedSqlStatement = '''CREATE TABLE $PERSON_TABLE
    (
      $PERSON_TABLE_ID_COLUMN TEXT,
      $PERSON_TABLE_PICTURE_COLUMN TEXT,
      $PERSON_TABLE_GENDER_COLUMN TEXT,
      $PERSON_TABLE_NAME_TITLE_COLUMN TEXT,
      $PERSON_TABLE_FIRST_NAME_COLUMN TEXT,
      $PERSON_TABLE_LAST_NAME_COLUMN TEXT,
      $PERSON_TABLE_LOCATION_STREET_COLUMN TEXT,
      $PERSON_TABLE_PHONE_COLUMN TEXT,
      $PERSON_TABLE_USERNAME_COLUMN TEXT,
      $PERSON_TABLE_SALT_COLUMN TEXT,
      $PERSON_TABLE_IS_FAVORITE_COLUMN INTEGER
    )''';

    personDb = await createDatabase(
        path: personPath, sqlStatement: personCreatedSqlStatement);
  }

  Future<Database> createDatabase({
    @required String path,
    @required String sqlStatement,
  }) async {
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(sqlStatement);
    });
  }

  Future close(Database db) async {
    return db.close();
  }
}
