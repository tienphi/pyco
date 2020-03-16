import 'package:flutter/material.dart';

import 'package:pyco/views/widgets/main_app_bar.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        titleText: 'Favorite',
      ),
      body: Center(
        child: Text('Favorite Screen comming soon ...'),
      ),
    );
  }
}
