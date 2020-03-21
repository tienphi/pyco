import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pyco/database/local/database_creator.dart';
import 'package:pyco/database/local/person_services.dart';
import 'package:pyco/database/local/services.dart';
import 'package:pyco/database/remote/app_exception.dart';
import 'package:pyco/database/remote/reponse_handler.dart';
import 'package:pyco/database/remote/services/person_api.dart';
import 'package:pyco/models/person.dart';

class PersonViewModel with ChangeNotifier {
  List<Person> _people = [];

  List<Person> get people => []..addAll(_people);

  set people(List<Person> value) {
    _people.clear();
    _people.addAll(value);
    notifyListeners();
  }

  void addPerson(Person person) {
    _people.add(person);
    notifyListeners();
  }

  int get favoriteCount =>
      people
          .where((person) => person.isFavorite)
          .length;

  int get peopleCount =>
      people.length;

  Future<List<Person>> getPeopleFromServer() async {
    Completer<List<Person>> result = Completer<List<Person>>();
    await PersonService().getPeopleAPI(
      responseHandler: ResponseHandler(
        onResponseSuccess: (data) {
          result.complete(data as List<Person>);
        },
        onResponseError: (AppException e) {
          throw e;
        },
      ),
    );
    return result.future;
  }

  Future<List<Person>> getPeopleFromLocalDatabase() async {
    try {
      final peopleData = await SQLiteService.getAll<Person>(
        database: personDb,
        dbName: PERSON_TABLE,
      );
      people = peopleData;
      return peopleData;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Person>> getPeople() async {
    try {
      final peopleData = await getPeopleFromServer();
      for (Person person in peopleData) {
        await SQLiteService.insert<Person>(
          database: personDb,
          dbName: PERSON_TABLE,
          item: person,
        );
      }
      _people.addAll(peopleData);
      return peopleData;
    } catch (e) {
      throw e;
    }
  }

  Future<int> updateToFavorite(String personId, [bool value = true]) async {
    try {
      await updatePersonFavoriteStateAtLocal(
        id: personId,
        isFavorite: value ?? true,
      );
      notifyListeners();
      return 1;
    } catch (e) {
      return -1;
    }
  }

  Future<bool> deleteItem(String personId) async {
    try {
      await SQLiteService.deleteItemById<Person>(
        database: personDb,
        dbName: PERSON_TABLE,
        idColumn: PERSON_TABLE_ID_COLUMN,
        id: personId,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
