import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pyco/database/remote/http_client.dart';
import 'package:pyco/models/person.dart';

import '../../../models/person.dart';
import '../app_exception.dart';
import '../reponse_handler.dart';

class PersonService {
  Future<void> getPeopleAPI({
    ResponseHandler responseHandler,
  }) async {
    final path = '?randomapi';
    final url = createUrlFromPath(path);

    await createGetRequest(
      url: url,
      responseHandler: ResponseHandler(
        onResponseSuccess: (responseData) async {
          List<Person> people = [];
          for (Map<String, dynamic> data in responseData) {
            final person = Person.fromJson(data['user']);
            people.add(person);
          }
          responseHandler.onResponseSuccess(people);
        },
        onResponseError: (AppException e) async {
          if (e.code == FORMAT_EXCEPTION_CODE) {
            final path = 'assets/jsons/dummy_person.json';
            final jsonString = await rootBundle.loadString(path);
            final jsonData =
                await jsonDecode(jsonString) as Map<String, dynamic>;

            List<Map<String, dynamic>> listJsonFix = [];

            (jsonData['results']).forEach((item) {
              final keys = item.keys;
              Map<String, dynamic> jsonFix = {};

              keys.forEach((key) {
                switch (key) {
                  case 'login':
                    {
                      if (item[key] is Map<String, dynamic>) {
                        jsonFix['username'] = item[key]['username'];
                        jsonFix['salt'] = item[key]['salt'];
                        jsonFix['md5'] = item[key]['md5'];
                      }
                      break;
                    }
                  case 'picture':
                    {
                      if (item[key] is Map<String, dynamic>) {
                        jsonFix['picture'] = item[key]['large'];
                      }
                      break;
                    }
                  default:
                    {
                      if (item[key] is Map<String, dynamic>) {
                        jsonFix[key] = item[key];
                      }
                    }
                }
              });

              listJsonFix.add(jsonFix);
            });

            List<Person> people = [];

            listJsonFix.forEach((map) {
              people.add(Person.fromJson(map));
            });
            responseHandler.onResponseSuccess(people);
          } else {
            responseHandler.onResponseError(e);
          }
        },
      ),
    );
  }
}
