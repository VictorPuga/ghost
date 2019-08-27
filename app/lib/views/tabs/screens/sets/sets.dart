import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'select-configs.dart';

class Sets extends StatelessWidget {
  Sets({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Sets'),
        // leading: CupertinoButton(
        //   padding: EdgeInsets.only(),
        //   child: Icon(CupertinoIcons.circle_filled, size: 30),
        //   onPressed: () {
        //     print('filter');
        //   },
        // ),
        trailing: CupertinoButton(
          padding: const EdgeInsets.only(),
          child: const Icon(CupertinoIcons.add, size: 30),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => SelectConfigs(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              color: Colors.red,
              height: 20,
              width: 20,
            ),
            Container(
              color: Colors.blue,
              height: 20,
              width: 20,
            ),
            Container(
              color: Colors.red,
              height: 20,
              width: 20,
            ),
            Container(
              color: Colors.blue,
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
