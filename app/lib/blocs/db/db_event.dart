import 'package:bungie_api/models/destiny_item_component.dart';
import 'package:equatable/equatable.dart';

abstract class DBEvent extends Equatable {
  DBEvent([List props = const []]) : super(props);
}

class ThrowDBError extends DBEvent {
  final String error;
  final StackTrace stackTrace;
  ThrowDBError(this.error, [this.stackTrace]) : super([error, stackTrace]);

  @override
  String toString() => '''
      ThrowDBError {
        error: $error,
        stackTrace: $stackTrace 
      }
      ''';
}

class GetManifest extends DBEvent {}

class DeleteManifest extends DBEvent {}

class GetItemData extends DBEvent {
  final List<DestinyItemComponent> items;

  GetItemData(this.items) : super([items]);

  @override
  String toString() => '''
      GetItemData {
        items: $items 
      }
      ''';
}
