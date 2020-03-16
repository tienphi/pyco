import 'package:flutter/material.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/views/utilities.dart';
import 'package:pyco/views/widgets/person_info_icons.dart';

class PersonInfoItem extends StatefulWidget {
  final Person person;

  const PersonInfoItem({Key key, @required this.person}) : super(key: key);

  @override
  _PersonInfoItemState createState() => _PersonInfoItemState();
}

class _PersonInfoItemState extends State<PersonInfoItem> {
  INFO_TYPE _highlightInfoType;

  set highlightInfoType(INFO_TYPE value) {
    if (value == _highlightInfoType) return;

    setState(
      () {
        _highlightInfoType = value;
      },
    );
  }

  String get _infoTitle {
    switch (_highlightInfoType) {
      case INFO_TYPE.NAME:
        {
          return 'My name is';
        }
      case INFO_TYPE.SALT:
        {
          return 'My salt is';
        }
      case INFO_TYPE.LOCATION:
        {
          return 'My address is';
        }
      case INFO_TYPE.CONTACT:
        {
          return 'My phone is';
        }
      case INFO_TYPE.ACCOUNT:
        {
          return 'My username is';
        }
      default:
        {
          return 'Unknown';
        }
    }
  }

  String get _infoContent {
    switch (_highlightInfoType) {
      case INFO_TYPE.NAME:
        {
          return widget.person.personName.personName;
        }
      case INFO_TYPE.SALT:
        {
          return widget.person.salt;
        }
      case INFO_TYPE.LOCATION:
        {
          return widget.person.location.locationStreet;
        }
      case INFO_TYPE.CONTACT:
        {
          return widget.person.phone;
        }
      case INFO_TYPE.ACCOUNT:
        {
          return widget.person.userName;
        }
      default:
        {
          return 'Unknown';
        }
    }
  }

  @override
  void initState() {
    _highlightInfoType = INFO_TYPE.NAME;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = getWidth(context);
    final itemWidth = deviceWidth * 0.8;
    final itemHeight = 401.0;
    final avatarWidth = deviceWidth * 0.4;

    return Container(
      width: itemWidth,
      height: itemHeight,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8.0,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Color(0xFFF7EEEE),
                  ),
                  height: 150,
                ),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                Container(
                  height: 240,
                  color: Colors.white,
                  child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      final parentHeight = constraints.maxHeight;

                      return Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: parentHeight * 0.37,
                            ),
                            Text(
                              _infoTitle,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _infoContent,
                              style: Theme.of(context).textTheme.title,
                            ),
                            SizedBox(
                              height: parentHeight * 0.13,
                            ),
                            ListPersonInfoIcon(
                              onItemSelected: (type) {
                                highlightInfoType = type;
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: avatarWidth,
                      height: avatarWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(avatarWidth * 0.5),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(avatarWidth * 0.03),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            avatarWidth * 0.5,
                          ),
                          child: FadeInImage.assetNetwork(
                            fadeInDuration: const Duration(milliseconds: 1),
                            placeholder: 'assets/images/default_avatar.png',
                            image: widget.person.picture,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
