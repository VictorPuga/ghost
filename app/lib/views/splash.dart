import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/widgets/widgets.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text('Splash Screen'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: LoadingIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
