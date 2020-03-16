import 'package:pyco/database/remote/http_client.dart';
import 'package:pyco/models/person.dart';

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
        onResponseError: responseHandler.onResponseError,
      ),
    );
  }
}
