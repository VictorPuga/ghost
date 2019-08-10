import 'package:equatable/equatable.dart';
import 'package:ghost/models/models.dart';

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
  final List<ItemComponent> items;

  GetItemData(this.items) : super([items]);

  @override
  String toString() => '''
      GetItemData {
        items: $items 
      }
      ''';
}
