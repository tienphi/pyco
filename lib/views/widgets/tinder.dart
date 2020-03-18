import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyco/input.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/view_models/person.dart';
import 'package:pyco/views/dialog.dart';
import 'package:pyco/views/utilities.dart';
import 'package:pyco/views/widgets/person_info_item.dart';

import '../../database/remote/app_exception.dart';
import '../utilities.dart';

const _PERSON_KEY = 'person';
const _POSITION_KEY = 'positon';

class PeopleTinder extends StatefulWidget {
  final List<Person> initPeopleData;

  const PeopleTinder({Key key, @required this.initPeopleData})
      : super(key: key);

  @override
  _PeopleTinderState createState() => _PeopleTinderState();
}

class _PeopleTinderState extends State<PeopleTinder> {
  final _marginTopRadio = 0.05;
  final _marginLeftRadio = 0.1;
  List<Map<String, dynamic>> _buildData = [];
  bool _isInit = true;
  bool _isLoading = false;
  PersonViewModel _viewModel;

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
      print('last person : ${people.last.id}');
      createBuildDataFromList(_buildData, people);
    } catch (e) {
      isLoading = false;
      showDialogErrorWithMessage(
        context: context,
        message: (e as AppException).message,
      );
      throw e;
    }
  }

  void onDragLeft(Person person, bool isCallAPI) {
    if (isCallAPI) {
      getNewPerson();
    }
  }

  void onDragRight(Person person, bool isCallAPI) {
    _viewModel.updateToFavorite(person.id);

    if (isCallAPI) {
      getNewPerson();
    }
  }

  void createBuildDataFromList(
      List<Map<String, dynamic>> previousBuildData, List<Person> newData) {
    if (newData.isEmpty) return;

    final lastPositionValue = previousBuildData.last[_POSITION_KEY];

    switch (lastPositionValue) {
      case 0:
        {
          List<Map<String, dynamic>> newBuildData = [];
          newData.asMap().forEach((index, person) {
            newBuildData.insert(0, {
              _PERSON_KEY: person,
              _POSITION_KEY: isEvenNumber(index) ? 1 : 0,
            });
          });
          buildData = newBuildData;
          break;
        }
      case 1:
        {
          List<Map<String, dynamic>> newBuildData = [];
          newData.asMap().forEach((index, person) {
            newBuildData.insert(0, {
              _PERSON_KEY: person,
              _POSITION_KEY: isEvenNumber(index) ? 0 : 1,
            });
          });
          buildData = newBuildData;
          break;
        }
      default:
        {}
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _viewModel = Provider.of<PersonViewModel>(context, listen: false);
      final people = widget.initPeopleData;

      people.asMap().forEach((index, person) {
        _buildData.add({
          _PERSON_KEY: person,
          _POSITION_KEY: isEvenNumber(index) ? 0 : 1,
        });
      });
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
              final isCallAPI = identical(
                  _buildData.reversed.last[_PERSON_KEY] as Person, person);

              onDragLeft(person, isCallAPI);
            } else if (direction == DismissDirection.startToEnd) {
              final isCallAPI = identical(
                  _buildData.reversed.last[_PERSON_KEY] as Person, person);

              onDragRight(person, isCallAPI);
            }
          },
          child: PersonInfoItem(
            person: person,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTinder(BuildContext context) {
    final _personItemWidth = getWidth(context) * 0.8;
    List<Widget> result = [];

    _buildData.forEach(
      (item) {
        result.add(
          Positioned(
            top: item[_POSITION_KEY] == 0
                ? 0
                : getHeight(context) * 0.6 * _marginTopRadio,
            left: item[_POSITION_KEY] == 0
                ? 0
                : _personItemWidth * _marginLeftRadio,
            right: item[_POSITION_KEY] == 0
                ? _personItemWidth * _marginLeftRadio
                : 0,
            child: _buildSingleItem(item[_PERSON_KEY]),
          ),
        );
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            height: getHeight(context) * 0.6 * (1 + 2 * _marginTopRadio),
            width: getWidth(context) * 0.8 * (1 + 2 * _marginLeftRadio),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Center(
            child: Container(
              height: getHeight(context) * 0.6 * (1 + 2 * _marginTopRadio),
              child: Stack(
                children: _buildTinder(context),
              ),
            ),
          );
  }
}
