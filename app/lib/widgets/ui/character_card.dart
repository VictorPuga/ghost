import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/custom_theme.dart';
import 'package:ghost/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final String _className;
  final Color _color;
  final String _emblemPath;
  final bool empty;
  final int _light;
  final VoidCallback onPressed;
  final String _raceName;

  // static const TextStyle _titleStyle = TextStyle(
  //   color: Colors.white,
  //   // fontSize: 20.0,
  // );

  // static const TextStyle _subtitleStyle = TextStyle(
  //   color: Colors.white70,
  //   // fontSize: 15.0,
  //   fontWeight: FontWeight.w400,
  // );

  // static const TextStyle _lightStyle = const TextStyle(
  //   color: Colors.cyan,
  //   // fontSize: 25.0,
  // );

  CharacterCard({
    Key key,
    this.character,
    this.onPressed,
  })  : empty = character?.className == null,
        _className = character?.className,
        _raceName = character?.raceName,
        _color = character?.emblemColor,
        _emblemPath = character?.emblemBackgroundPath,
        _light = character?.light,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.7,
      onPressed: onPressed,
      child: Container(
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: Color.fromRGBO(0, 0, 0, 0.5),
        //       blurRadius: 10,
        //       offset: Offset(2, 2),
        //     )
        //   ],
        // ),
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 474 / 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Container(
                    color: _color,
                    child: !empty ? _content() : LoadingImage(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _content() {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: _emblemPath,
                placeholder: (_, __) => Container(),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // 6/28, 21/28, 1/28
            Flexible(flex: 6, child: Container()),
            Flexible(
              flex: 21,
              child: Column(
                children: [
                  Flexible(flex: 1, child: Container()),
                  Flexible(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Text(_className,
                                          style: CustomTheme.titleStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Text(
                                        _raceName,
                                        style: CustomTheme.subtitleStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              flex: 7,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  _light.toString(),
                                  style: CustomTheme.lightStyle,
                                ),
                              ),
                            ),
                            Flexible(flex: 6, child: Container()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(flex: 1, child: Container())
                ],
              ),
            ),
            Flexible(flex: 1, child: Container())
          ],
        ),
      ],
    );
  }
}
