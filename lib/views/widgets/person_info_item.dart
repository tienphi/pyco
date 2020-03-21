import 'package:flutter/material.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/views/widgets/person_info_icons.dart';

class PersonInfoItem extends StatefulWidget {
  final Person person;
  final bool hasData;

  const PersonInfoItem({
    Key key,
    @required this.person,
    @required this.hasData,
  }) : super(key: key);

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

    bool hasData = widget.hasData;

    return Container(
      child: LayoutBuilder(
        builder: (_, constraints) {
          final parentHeight = constraints.maxHeight;
          final avatarSize = parentHeight * 0.4;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            elevation: 0,
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
                      height: parentHeight * 0.37,
                    ),
                    Divider(
                      height: parentHeight * 0.002,
                      color: Colors.black,
                    ),
                    Container(
                      height: parentHeight * 0.6,
                      color: Colors.white,
                      child: LayoutBuilder(
                        builder: (ctx, constraints) {
                          final parentHeight = constraints.maxHeight;
                          return Container(
                            child: hasData ? Column(
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
                                Flexible(
                                  child: Container(
                                    height: double.infinity,
                                    child: ListPersonInfoIcon(
                                      onItemSelected: (type) {
                                        highlightInfoType = type;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ) : Center(
                              child: Container(
                                width: parentHeight > 40 ? 40 : parentHeight,
                                height: parentHeight > 40 ? 40 : parentHeight,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset(0.5, 2 / 15),
                    child: Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(avatarSize * 0.5),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(avatarSize * 0.03),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            avatarSize * 0.5,
                          ),
                          child: hasData ? FadeInImage.assetNetwork(
                            fadeInDuration: const Duration(milliseconds: 1),
                            placeholder: 'assets/images/default_avatar.png',
                            image: widget.person.picture,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ) :
                          Image.asset('assets/images/loading_avatar.jpg',
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
