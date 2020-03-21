import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyco/input.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/view_models/person.dart';
import 'package:pyco/views/dialog.dart';
import 'package:pyco/views/widgets/person_info_item.dart';

import '../../database/remote/app_exception.dart';

const _PERSON_KEY = 'person';
const _POSITION_KEY = 'positon';

class PeopleTinder extends StatefulWidget {
  final List<Person> initPeopleData;
  final double width;
  final double height;

  const PeopleTinder({
    Key key,
    @required this.initPeopleData,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  @override
  _PeopleTinderState createState() => _PeopleTinderState();
}

class _PeopleTinderState extends State<PeopleTinder> {
  final _marginTopRadio = 0.05;
  final _marginLeftRadio = 0.1;
  List<Map<String, dynamic>> _buildData = [];
  List<Map<String, dynamic>> _restBuildData = [];
  bool _isInit = true;
  bool _isLoading = false;
  PersonViewModel _viewModel;

  double get height => widget.height;

  double get width => widget.width;

  List<Map<String, dynamic>> get restBuildData => _restBuildData;

  bool get isCallAPI => _restBuildData.length < 3;

  set isLoading(bool value) {
    if (value == _isLoading) return;
    setState(() {
      _isLoading = value;
    });
  }

  set buildData(List<Map<String, dynamic>> value) {
    if (value == _buildData) return;
    setState(() {
      _buildData = value;
    });
  }

  void getNewPerson() async {
    try {
      isLoading = true;
      final people = await _viewModel.getPeople();
      isLoading = false;
      createBuildDataFromList(_restBuildData, people);
    } catch (e) {
      isLoading = false;
      showDialogErrorWithMessage(
        context: context,
        message: (e as AppException).message,
      );
      throw e;
    }
  }

  void onDrag(Person person) {
    _restBuildData.removeLast();

    if (isCallAPI) {
      getNewPerson();
    }
  }

  void onDragLeft(Person person) {
    onDrag(person);
  }

  void onDragRight(Person person) {
    _viewModel.updateToFavorite(person.id);

    onDrag(person);
  }

  void createBuildDataFromList(List<Map<String, dynamic>> previousBuildData,
      List<Person> newData) {
    if (newData.isEmpty) return;

    List<Map<String, dynamic>> newBuildData = [];
    bool hasPreviousBuildData = previousBuildData.length > 0;

    int getNextPosition(int index) {
      if (hasPreviousBuildData) {
        final lastPosition = previousBuildData.first[_POSITION_KEY];
        return isEvenNumber(index + lastPosition) ? 0 : 1;
      } else {
        return isEvenNumber(index) ? 0 : 1;
      }
    }

    newData.asMap().forEach((index, person) {
      newBuildData.insert(0, {
        _PERSON_KEY: person,
        _POSITION_KEY: getNextPosition(index),
      });
    });

    if (hasPreviousBuildData){
      for (int i = 1; i < previousBuildData.length; i++) {
        newBuildData.add(previousBuildData[i]);
      }
    }

    final lastPosition = previousBuildData.first[_POSITION_KEY];

    newBuildData.insert(0, {
      _PERSON_KEY: null,
      _POSITION_KEY: lastPosition == 0 ? 1 : 0,
    });

    buildData = newBuildData;
    _restBuildData = newBuildData;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _viewModel = Provider.of<PersonViewModel>(context, listen: false);
      final people = widget.initPeopleData;

      final numberPeople = people.length;

      people.asMap().forEach((index, person) {
        _buildData.add({
          _PERSON_KEY: person,
          _POSITION_KEY: isEvenNumber(index + numberPeople) ? 1 : 0,
        });
      });

      final lastPosition = _buildData.first[_POSITION_KEY];

      _buildData.insert(0, {
        _PERSON_KEY: null,
        _POSITION_KEY: lastPosition == 0 ? 1 : 0,
      });

      _restBuildData = _buildData;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Widget _buildSingleItem(Person person) {
    return Container(
      child: Center(
        child: Dismissible(
          key: ValueKey(person.id),
          background: Container(),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onDragLeft(person);
            } else if (direction == DismissDirection.startToEnd) {
              onDragRight(person);
            }
          },
          child: PersonInfoItem(
            hasData: true,
            person: person,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTinder(BuildContext context) {
    if (_buildData.isEmpty) return [Container()];

    List<Widget> result = [];
    final _personItemWidth = width / (1 + 2 * _marginLeftRadio);
    final _personItemHeight = height / (1 + _marginTopRadio);

    Widget loadingItem = Container(
      child: Center(
        child: PersonInfoItem(
          hasData: false,
          person: Person(),
        ),
      ),
    );

    _buildData.asMap().forEach(
          (idx, item) {
        result.add(
          Positioned(
            top: item[_POSITION_KEY] == 0
                ? 0
                : _personItemHeight * _marginTopRadio,
            left: item[_POSITION_KEY] == 0
                ? 0
                : _personItemWidth * _marginLeftRadio,
            right: item[_POSITION_KEY] == 0
                ? _personItemWidth * _marginLeftRadio
                : 0,
            child: Container(
              width: _personItemWidth,
              height: _personItemHeight,
              child: isNull(item[_PERSON_KEY]) ? loadingItem : _buildSingleItem(
                  item[_PERSON_KEY]),
            ),
          ),
        );
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        child: Stack(
          children: _buildTinder(context),
        ),
      ),
    );
  }
}
