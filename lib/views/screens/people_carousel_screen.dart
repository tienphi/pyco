import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyco/database/remote/app_exception.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/view_models/person.dart';

import 'package:pyco/views/widgets/main_app_bar.dart';
import 'package:pyco/views/widgets/person_info_icons.dart';
import 'package:pyco/views/widgets/tinder.dart';

import '../dialog.dart';

class PeopleCarouselScreen extends StatefulWidget {
  @override
  _PeopleCarouselScreenState createState() => _PeopleCarouselScreenState();
}

class _PeopleCarouselScreenState extends State<PeopleCarouselScreen>
    with AutomaticKeepAliveClientMixin {
  INFO_TYPE infoType;
  List<Person> _people;
  PersonViewModel _viewModel;
  bool _isInit = true;
  bool _isLoading = false;

  set isLoading(bool value) {
    if (value == _isLoading) return;
    setState(() {
      _isLoading = value;
    });
  }

  setPeopleAndLoading(List<Person> value, bool isLoading) {
    if (value == _people) return;
    setState(() {
      _isLoading = isLoading;
      _people = value;
    });
  }

  Future<void> _getPeople() async {
    isLoading = true;
    try {
      final newPeopleData = await _viewModel.getPeople();
      setPeopleAndLoading(newPeopleData, false);
    } catch (e) {
      showDialogErrorWithMessage(
        context: context,
        message: e.message,
      );
      isLoading = false;
      throw e;
    }
  }

  @override
  void initState() {
    infoType = INFO_TYPE.NAME;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _viewModel = Provider.of<PersonViewModel>(context, listen: false);
      isLoading = true;
      _viewModel.getPeopleFromLocalDatabase().then((list) {
        setPeopleAndLoading(list, false);
      }).catchError((e) {
        isLoading = false;
        showDialogErrorWithMessage(
          context: context,
          message: (e as AppException).message,
        );
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Widget _buildContentWhenHasData(List<Person> people) {
    final favoritePeople = people.where((person) => person.isFavorite).toList();
    return _people.isEmpty
        ? Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Nobody to display!'),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text('Retry'),
            onPressed: _getPeople,
          ),
        ],
      ),
    )
        : Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.person,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 10,
              ),
              Text('${people.length}'),
              SizedBox(
                width: 100,
              ),
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text('${favoritePeople.length}'),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          PeopleTinder(
            initPeopleData: _people,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: MainAppBar(
        titleText: 'People carousel',
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ChangeNotifierProvider.value(
        value: _viewModel,
        child: _buildContentWhenHasData(_people),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
