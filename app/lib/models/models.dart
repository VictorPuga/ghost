library models;

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part './destiny_2/user.dart';
part './destiny_2/destiny_2.dart';
part './destiny_2/manifest_definitions.dart';

part './responses/profile_response.dart';
part './responses/character_response.dart';
part './responses/bungie_response.dart';

part './responses/components.dart';

final _encoder = JsonEncoder.withIndent(' ');
const String _assetPrefix = 'https://www.bungie.net';

abstract class Destiny2Model extends Equatable {
  Destiny2Model([List props = const []]) : super([props]);

  @override
  String toString() => '$runtimeType $_asBeautifulString';

  Map<String, dynamic> toJson();

  String toJsonString() => jsonEncode(toJson());

  String get _asBeautifulString => _encoder.convert(toJson());
}
