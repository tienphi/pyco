import 'package:flutter/material.dart';

import 'package:pyco/constants.dart';
import 'package:pyco/views/widgets/main_app_bar.dart';
import 'package:pyco/views/widgets/person_info_icons.dart';
import 'package:pyco/views/widgets/person_info_item.dart';

class PeopleCarouselScreen extends StatefulWidget {
  @override
  _PeopleCarouselScreenState createState() => _PeopleCarouselScreenState();
}

class _PeopleCarouselScreenState extends State<PeopleCarouselScreen>
    with AutomaticKeepAliveClientMixin {
  INFO_TYPE infoType;

  @override
  void initState() {
    infoType = INFO_TYPE.NAME;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    comingText(i) => Text('#$i People carousel screen  comming soon ...');

    return Scaffold(
      appBar: MainAppBar(
        titleText: 'People carousel',
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: APP_PADDING_HORIZONTAL,
            vertical: APP_PADDING_VERTICAL,
          ),
          child: Column(
            children: <Widget>[
              ListPersonInfoIcon(
                onItemSelected: (type) {
                  setState(() {
                    infoType = type;
                  });
                },
              ),
              Text(
                infoType.toString(),
              ),
//              PersonInfoItem(
//
//              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
