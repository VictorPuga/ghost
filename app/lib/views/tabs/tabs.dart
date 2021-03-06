import './screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Tabs extends StatelessWidget {
  Tabs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Sets'),
            icon: Icon(CupertinoIcons.tags_solid),
          ),
          BottomNavigationBarItem(
            title: Text('Characters'),
            icon: Icon(CupertinoIcons.group_solid),
          ),
          BottomNavigationBarItem(
            title: Text('Search'),
            icon: Icon(CupertinoIcons.search),
          ),
          BottomNavigationBarItem(
            title: Text('Settings'),
            icon: Icon(CupertinoIcons.gear_solid),
          )
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return Sets();
              case 1:
                return CharactersView();
              case 2:
                return Search();
              case 3:
                return Settings();
              default:
                return Container();
            }
          },
        );
      },
    );
  }
}
