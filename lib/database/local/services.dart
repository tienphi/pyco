import 'package:flutter/material.dart';
import 'package:pyco/bases/model.dart';
import 'package:pyco/models/person.dart';
import 'package:sqflite/sqflite.dart';

// Map of types to fromMap named constructor factory functions
final constructorFromMapFactories = <Type, Function>{
  Person: (Map<String, dynamic> map) => Person.fromJsonLocalDatabase(map),
};

// Get type of T
Type typeOf<T>() => T;

class SQLiteService {
  static Future<List<T>> getAll<T extends BaseModel>({
    @required Database database,
    @required String dbName,
  }) async {
    final sql = 'SELECT * FROM $dbName';
    final data = await database.rawQuery(sql);
    List<T> result = List();

    for (final node in data) {
      final item = constructorFromMapFactories[T](node);
      result.add(item);
    }

    return result;
  }

  static Future<T> getItemById<T extends BaseModel>({
    @required Database database,
    @required String dbName,
    @required String idColumn,
    @required int id,
  }) async {
    final sql = '''SELECT * FROM $dbName
    WHERE $idColumn = ?''';

    List<dynamic> params = [id];
    final data = await database.rawQuery(sql, params);

    return constructorFromMapFactories[T](data.first);
  }

  static Future<void> insert<T extends BaseModel>({
    @required Database database,
    @required String dbName,
    @required T item,
  }) async {
    if (typeOf<T>() == Person) {
      await database.insert(dbName, (item as Person).toJsonSaveLocalDatabase());
    } else {
      await database.insert(dbName, item.toJson());
    }
  }

  static Future<void> deleteAll({
    @required Database database,
    @required String dbName,
  }) async {
    final sql = 'DELETE FROM $dbName';
    await database.rawQuery(sql);
  }

  static Future<int> deleteItemById<T extends BaseModel>({
    @required Database database,
    @required String dbName,
    @required String idColumn,
    @required int id,
  }) async {
    return await database
        .delete(dbName, where: '$idColumn = ?', whereArgs: [id]);
  }

  static Future<int> update<T extends BaseModel>({
    @required Database database,
    @required String dbName,
    @required String idColumn,
    @required T item,
  }) async {
    if (typeOf<T>() == Person) {
      return await database.update(
          dbName, (item as Person).toJsonSaveLocalDatabase(),
          where: '$idColumn = ?', whereArgs: [item.id]);
    } else {
      return await database.update(dbName, item.toJson(),
          where: '$idColumn = ?', whereArgs: [item.id]);
    }
  }

  static Future<int> count({
    @required Database database,
    @required String dbName,
  }) async {
    int count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM $dbName'));
    return count;
  }
}
