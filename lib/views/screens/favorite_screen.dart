import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/view_models/person.dart';

import 'package:pyco/views/widgets/main_app_bar.dart';

class FavoriteScreen extends StatelessWidget {
  void _unFavoritePerson(String personId) {}

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PersonViewModel>(context, listen: false);

    return Scaffold(
      appBar: MainAppBar(
        titleText: 'Favorite',
      ),
      body: Container(
        // TODO Fix use Consumer
        child: FutureBuilder<List<Person>>(
          future: viewModel.getPeopleFromLocalDatabase(),
          builder: (_, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.done:
                final favoritePeople =
                    snapshot.data.where((person) => person.isFavorite).toList();
                return favoritePeople.isEmpty
                    ? Center(
                        child: Text('You not favorite any person!'),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text('List person you favorite:'),
                          SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: ListView.builder(
                              itemCount: favoritePeople.length,
                              itemBuilder: (ctx, index) {
                                final person = favoritePeople[index];
                                return Dismissible(
                                  background: Container(
                                    color: Colors.blue,
                                    child: Align(
                                      alignment: FractionalOffset.centerLeft,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      Provider.of<PersonViewModel>(context,
                                              listen: false)
                                          .deleteItem(person.id);
                                    }
                                  },
                                  direction: DismissDirection.startToEnd,
                                  key: ValueKey(person.id),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(person.picture),
                                    ),
                                    title: Text(
                                        person.personName.personNameToCall),
                                    trailing: IconButton(
                                      onPressed: () =>
                                          _unFavoritePerson(person.id),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                break;
            }
            return Container();
          },
        ),
      ),
    );
  }
}
