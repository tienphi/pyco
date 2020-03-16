import 'package:flutter/material.dart';
import 'package:pyco/input.dart';

typedef ItemSelectedCallBack = Function(INFO_TYPE infoType);

enum INFO_TYPE {
  AVATAR,
  NAME,
  GENDER,
  LOCATION,
  CONTACT,
  ACCOUNT,
  SALT,
  UNKNOWN,
}

final _widthSize = 30.0;

class ListPersonInfoIcon extends StatefulWidget {
  final _ListPersonInfoIconState state = _ListPersonInfoIconState();

  final ItemSelectedCallBack onItemSelected;

  ListPersonInfoIcon({Key key, @required this.onItemSelected})
      : super(key: key);

  @override
  _ListPersonInfoIconState createState() => state;
}

class _ListPersonInfoIconState extends State<ListPersonInfoIcon> {
  INFO_TYPE _highlightInfoType;

  set highlightInfoType(INFO_TYPE value) {
    if (value == _highlightInfoType) return;

    setState(
      () {
        _highlightInfoType = value;
        widget.onItemSelected(_highlightInfoType);
      },
    );
  }

  @override
  void initState() {
    _highlightInfoType = INFO_TYPE.NAME;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _widthSize * 5 * 1.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () {
              highlightInfoType = INFO_TYPE.NAME;
            },
            child: PersonInfoIcon(
              icon: Icons.info,
              active: _highlightInfoType == INFO_TYPE.NAME,
            ),
          ),
          InkWell(
            onTap: () {
              highlightInfoType = INFO_TYPE.SALT;
            },
            child: PersonInfoIcon(
              icon: Icons.calendar_today,
              active: _highlightInfoType == INFO_TYPE.SALT,
            ),
          ),
          InkWell(
            onTap: () {
              highlightInfoType = INFO_TYPE.LOCATION;
            },
            child: PersonInfoIcon(
              icon: Icons.location_on,
              active: _highlightInfoType == INFO_TYPE.LOCATION,
            ),
          ),
          InkWell(
            onTap: () {
              highlightInfoType = INFO_TYPE.CONTACT;
            },
            child: PersonInfoIcon(
              icon: Icons.phone,
              active: _highlightInfoType == INFO_TYPE.CONTACT,
            ),
          ),
          InkWell(
            onTap: () {
              highlightInfoType = INFO_TYPE.ACCOUNT;
            },
            child: PersonInfoIcon(
              icon: Icons.lock,
              active: _highlightInfoType == INFO_TYPE.ACCOUNT,
            ),
          ),
        ],
      ),
    );
  }
}

class PersonInfoIcon extends StatelessWidget {
  final bool active;
  final IconData icon;

  final _activeColor = Colors.lightGreen;
  final _inactiveColor = Colors.grey;

  PersonInfoIcon({
    Key key,
    @required this.icon,
    @required this.active,
  }) : super(key: key);

  Widget buildBarStroke() {
    return active
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: _widthSize / 6,
                height: _widthSize / 6,
                color: _activeColor,
              ),
              Container(
                width: _widthSize,
                height: 2,
                color: _activeColor,
              ),
            ],
          )
        : Container(
            width: _widthSize,
            height: _widthSize / 6 + 2,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildBarStroke(),
          SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            color: active ? _activeColor : _inactiveColor,
            size: _widthSize,
          ),
        ].where(notNull).toList(),
      ),
    );
  }
}
