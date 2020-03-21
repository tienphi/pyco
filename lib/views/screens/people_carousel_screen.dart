import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyco/constants.dart';
import 'package:pyco/database/remote/app_exception.dart';
import 'package:pyco/models/person.dart';
import 'package:pyco/view_models/person.dart';
import 'package:pyco/views/utilities.dart';

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
      if (newPeopleData.length < 2) {
        try {
          while (newPeopleData.length < 2) {
            final newData = await _viewModel.getPeople();
            newPeopleData.addAll(newData);
          }
        } catch (e){
          print(e.toString());
        }
      }
      setPeopleAndLoading(newPeopleData, true);
      isLoading = false;
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
    return _people.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Nobody to display!'),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Text('Retry'),
                  onPressed: _getPeople,
                ),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(
              horizontal: APP_PADDING_HORIZONTAL,
            ),
            child: LayoutBuilder(
              builder: (_, constraints) {
                final parentHeight = constraints.maxHeight;
                final parentWidth = constraints.maxWidth;

                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        'Swipe to show new person, swipe right to add to favorite list'),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: PeopleTinder(
                        width: getWidth(context) * 0.8,
                        height: getHeight(context) * 0.6,
                        initPeopleData: _people,
                      ),
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
                        Text(
                          '${_viewModel.peopleCount}',
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${_viewModel.favoriteCount}',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
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
