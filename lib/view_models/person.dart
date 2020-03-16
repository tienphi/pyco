import 'package:flutter/material.dart';
import 'package:pyco/database/local/database_creator.dart';
import 'package:pyco/database/local/services.dart';
import 'package:pyco/database/remote/app_exception.dart';
import 'package:pyco/database/remote/reponse_handler.dart';
import 'package:pyco/database/remote/services/person_api.dart';
import 'package:pyco/models/person.dart';

class PersonViewModel with ChangeNotifier {
  List<Person> _people;

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

  Future<List<Person>> getPeopleFromServer() async {
    List<Person> result = [];
    await PersonService().getPeopleAPI(
      responseHandler: ResponseHandler(
        onResponseSuccess: (data) {
          result = data as List<Person>;
        },
        onResponseError: (AppException e) {
          throw e;
        },
      ),
    );

    return result;
  }

  Future<List<Person>> getPeopleFromLocalDatabase() async {
    try {
      return await SQLiteService.getAll<Person>(
        database: personDb,
        dbName: PERSON_TABLE,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<List<Person>> getPeople() async {
    try {
      final people = await getPeopleFromServer();
      for (Person person in people) {
        await SQLiteService.insert<Person>(
          database: personDb,
          dbName: PERSON_TABLE,
          item: person,
        );
      }
      return people;
    } catch (e) {
      throw e;
    }
  }
}
