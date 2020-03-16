import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyco/database/remote/app_exception.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/view_models/person.dart';
import 'package:pyco/views/widgets/person_info_item.dart';

class SqlifeTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//        body: Center(
//          child: Text('Sqlite Screen comming soon ...'),
//        )
//    );
    final _viewModel = Provider.of<PersonViewModel>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Person>>(
          future: _viewModel.getPeopleFromLocalDatabase(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              if (error is AppException) {
                return Text('Something wrong: ${error.message}');
              } else {
                return Text('Something wrong: ${error.toString()}');
              }
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final people = snapshot.data;

            return PersonInfoItem(
              person: people[0],
            );

//            return ListView.builder(
//              itemCount: people.length,
//              itemBuilder: (ctx, index) =>
//                  Text(people[index].personName.personNameToCall),
////                  Text('A'),
//            );
          },
//          child: Text('Sqlite Screen comming soon ...'),
        ),
      ),
    );
  }
}
