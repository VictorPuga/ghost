import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

abstract class CustomTheme {
  static const TextStyle titleStyle = TextStyle(
    color: Colors.white,
  );
  static const TextStyle subtitleStyle = TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle lightStyle = TextStyle(
    color: Colors.cyan,
  );
  static const headingStyle = TextStyle(
    fontSize: 26,
    height: 1,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleStyleAlternative = TextStyle(
    color: Colors.black,
  );
  static const TextStyle subtitleStyleAlternative = TextStyle(
    color: Colors.black45,
    fontWeight: FontWeight.w400,
  );
}
