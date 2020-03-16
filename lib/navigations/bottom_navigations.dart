import 'package:flutter/material.dart';
import 'package:pyco/dummys/sqlife_test.dart';
import 'package:pyco/views/screens/favorite_screen.dart';
import 'package:pyco/views/screens/people_carousel_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  static const PAGE_BODY_KEY = 'body';
  static const PAGE_ICON_KEY = 'icon_name';
  static const PAGE_BOTTOM_NAVIGATION_TITLE_KEY = 'bottom_nav_title';
  int _pageSelectedIndex;
  bool _isInit = true;
  List<Map<String, Object>> _pageList;
  Color _activeColor;
  Color _inActiveColor;
  List<BottomNavigationBarItem> itemsView;
  final PageController pageController = PageController();

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageSelectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _activeColor = Theme.of(context).accentColor;
      _inActiveColor = Color(0xFFA8A2B2);

      _pageList = [
        {
          PAGE_BODY_KEY: SqlifeTest(),
          PAGE_ICON_KEY: Icons.home,
          PAGE_BOTTOM_NAVIGATION_TITLE_KEY: 'People carousel',
        },
        {
          PAGE_BODY_KEY: FavoriteScreen(),
          PAGE_ICON_KEY: Icons.favorite,
          PAGE_BOTTOM_NAVIGATION_TITLE_KEY: 'Favorite screen',
        },
      ];

      _isInit = false;
    }
  }

  @override
  void initState() {
    _pageSelectedIndex = 0;
    super.initState();
  }

  bool _isAtPageIndex(int index) {
    return _pageSelectedIndex == index;
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarItem _buildBottomNavigationBarItem({
      @required int index,
      @required IconData iconData,
      String title,
    }) {
      return BottomNavigationBarItem(
        icon: Icon(
          iconData,
          color: _isAtPageIndex(index) ? _activeColor : _inActiveColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    itemsView = [];
    _pageList.asMap().forEach((index, item) {
      itemsView.insert(
          index,
          _buildBottomNavigationBarItem(
            index: index,
            iconData: item[PAGE_ICON_KEY],
            title: item[PAGE_BOTTOM_NAVIGATION_TITLE_KEY],
          ));
    });

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: _pageList.map((e) => e[PAGE_BODY_KEY] as Widget).toList(),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow,
        onTap: _onItemTapped,
        currentIndex: _pageSelectedIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: _inActiveColor,
        selectedItemColor: _activeColor,
        items: itemsView,
      ),
    );
  }
}
