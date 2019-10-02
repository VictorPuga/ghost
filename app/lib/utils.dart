import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ghost/models/models.dart';
import 'package:flutter/cupertino.dart';

void printObject(Object object) {
  final encoder = JsonEncoder.withIndent('  ', (item) {
    try {
      return item.toJson();
    } on NoSuchMethodError {}
    if (item is Map && item.keys.first is! String) {
      return Map.fromEntries(
        item.entries.map(
          (e) => MapEntry(
            e.key?.toString() ?? 'Instance of `${e.key.runtimeType}`',
            e.value,
          ),
        ),
      );
    } else {
      print('------------------JsonEncoder warning!------------------');
      print(
          "Item of type `${item.runtimeType}` couldn't be represented in Json");
      try {
        return item.toString();
      } on NoSuchMethodError {
        return 'Instance of `${item.runtimeType}` ...';
      }
    }
  });
  print(encoder.convert(object));
}

/// Capitalize the first letter of a string.
String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

int hash(int id) => id + (1 << 32);
int unHash(int hash) {
  if ((hash & (1 << (32 - 1))) != 0) {
    hash = hash - (1 << 32);
  }
  return hash;
}

///
/// Iterates through the elements of a `List` of `Map`s, and returns a new `Map` keyed by the specified key in `byKey`.
///
/// For example:
///
///     final List<Map<String, dynamic>> = [
///       {'id': 01, 'name': 'John'},
///       {'id': 02, 'name': 'Kate'},
///     ];
///
///     final map = listToMap(list, byKey: 'id');
///
///     print(newList);
///     /*
///       {
///         '01': { 'name': 'John' },
///         '02': { 'name': 'Kate' },
///       }
///     */
///
Map<String, dynamic> listToMap(
  List<Map<String, dynamic>> list, {
  @required String byKey,
}) {
  assert(byKey != null);
  final Map<String, dynamic> map = {};

  list.forEach((el) {
    final entries = el.entries.toList();
    final keyEntry = entries.singleWhere((e) => e.key == byKey);
    if (keyEntry != null) {
      final rest = entries.where((e) => e.key != byKey);
      map[keyEntry.value.toString()] = Map.fromEntries(rest);
    }
  });
  return map;
}

_decode(response) => jsonDecode(response);

/// Parses a `String` into `Json`, isolating the execution into a different thread.
parseJson(String text) {
  return compute(_decode, text);
}

// ignore: camel_case_types
abstract class safelyCompare {
  static int numbers(num n1, num n2) {
    if (n1 != null && n2 != null) {
      return n1.compareTo(n2);
    }
    if (n1 == null) {
      return -1;
    }
    return 1;
  }

  static int strings(String s1, String s2) {
    if (s1 != null && s2 != null) {
      return s1.compareTo(s2);
    }
    if (s1 == null) {
      return -1;
    }
    return 1;
  }
}

enum Sorting {
  type,
  bucket,
}

enum Order {
  defaultOrder,
  levelAsc,
  levelDesc,
  nameAsc,
  nameDesc,
}

Map<int, List<Item>> sortItems(
  List<Item> items, {
  @required Sorting by,
  Order orderedBy = Order.defaultOrder,
}) {
  final Map<int, List<Item>> sortedItems = {};

  switch (orderedBy) {
    case Order.levelAsc:
      items.sort(
          (i1, i2) => safelyCompare.numbers(i1.primaryStat, i2.primaryStat));
      break;
    case Order.levelDesc:
      items.sort(
          (i1, i2) => safelyCompare.numbers(i2.primaryStat, i1.primaryStat));
      break;
    case Order.nameAsc:
      items.sort((i1, i2) => safelyCompare.strings(i1.name, i2.name));
      break;
    case Order.nameDesc:
      items.sort((i1, i2) => safelyCompare.strings(i2.name, i1.name));
      break;
    case Order.defaultOrder:
      break;
  }

  items.forEach((item) {
    int sub;

    switch (by) {
      case Sorting.type:
        sub = item.typeHash;
        break;
      case Sorting.bucket:
        sub = item.bucketHash;
        break;
    }

    if (!sortedItems.containsKey(sub)) sortedItems[sub] = [];
    sortedItems[sub].add(item);
  });
  return sortedItems;
}

void showBasicAlert(BuildContext context, String title, String message) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext ctx) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      );
    },
  );
}
