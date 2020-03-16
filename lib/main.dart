import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pyco/navigations/bottom_navigations.dart';
import 'package:pyco/view_models/person.dart';

import 'database/local/database_creator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqLiteDatabaseCreator().initDatabase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonViewModel>.value(
          value: PersonViewModel(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BottomNavigationScreen(),
      ),
    );
  }
}
