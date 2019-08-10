import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/utils.dart';
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

  static const TextStyle _titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    color: Colors.white70,
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _lightStyle = const TextStyle(
    color: Colors.cyan,
    fontSize: 25.0,
  );

  CharacterCard({
    Key key,
    this.character,
    this.empty = false,
    this.onPressed,
  })  : _className = character?.className,
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
        //       color: Color.fromRGBO(0, 0, 0, 0.2),
        //       blurRadius: 5.0,
        //       offset: Offset(1.0, 1.0),
        //     )
        //   ],
        // ),
        child: Row(
          children: <Widget>[
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

  _content() => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: _emblemPath,
            placeholder: (_, __) => Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 70.0),
            child: Text(
              capitalize(_className),
              style: _titleStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35.0, left: 72.0),
            child: Text(
              capitalize(_raceName),
              style: _subtitleStyle,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
              child: Text(
                _light.toString(),
                style: _lightStyle,
              ),
            ),
          ),
        ],
      );

  factory CharacterCard.empty() => CharacterCard(empty: true);
}
