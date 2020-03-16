import 'package:flutter/material.dart';

class PeopleCarouselScreen extends StatefulWidget {
  @override
  _PeopleCarouselScreenState createState() => _PeopleCarouselScreenState();
}

class _PeopleCarouselScreenState extends State<PeopleCarouselScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    comingText(i) => Text('#$i People carousel screen  comming soon ...');
    return Scaffold(
      body: ListView.builder(
        itemCount: 60,
        itemBuilder: (_, index) =>
            Container(
              height: 50,
              child: comingText(index),
            ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
