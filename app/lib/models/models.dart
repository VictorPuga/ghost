library models;

import 'dart:convert';

import 'package:bungie_api/models/destiny_character_component.dart';
import 'package:bungie_api/models/destiny_display_properties_definition.dart';
import 'package:bungie_api/models/destiny_inventory_item_definition.dart';
import 'package:bungie_api/models/destiny_item_component.dart';
import 'package:bungie_api/models/destiny_item_instance_component.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/utils.dart';
import 'package:meta/meta.dart';

part './destiny_2.dart';
part './firestore.dart';
part './user.dart';

final _encoder = JsonEncoder.withIndent(' ');
const String _assetPrefix = 'https://www.bungie.net';

abstract class BaseModel extends Equatable {
  BaseModel([List props = const []]) : super([props]);

  @override
  String toString() => '$runtimeType $_asBeautifulString';

  Map<String, dynamic> toJson();

  String toJsonString() => jsonEncode(toJson());

  String get _asBeautifulString => _encoder.convert(toJson());
}
