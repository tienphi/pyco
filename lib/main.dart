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
        theme: ThemeData(
          // Scaffold color
          scaffoldBackgroundColor: Color(0xFFF2FCF1),
          // Dialog theme
          dialogTheme: Theme
              .of(context)
              .dialogTheme
              .copyWith(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            contentTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),

          // Text theme
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(
            // Title of appbar
            headline: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),

            // Person info content
            title: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),

            // Normal text
            body1: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        home: BottomNavigationScreen(),
      ),
    );
  }
}
