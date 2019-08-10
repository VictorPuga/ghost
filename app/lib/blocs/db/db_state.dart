import 'package:equatable/equatable.dart';
import 'package:ghost/models/models.dart';

abstract class DBState extends Equatable {
  DBState([List props = const []]) : super(props);
}

class DBInitial extends DBState {
  @override
  String toString() => 'DBInitial';
}

class DBLoading extends DBState {
  @override
  String toString() => 'DBLoading';
}

class DBError extends DBState {
  final String error;
  final StackTrace trace;
  DBError(this.error, [this.trace]) : super([error, trace]);

  @override
  String toString() => '''DBError {
    error: $error,
    trace: $trace 
  }''';
}

// class DBSuccessful extends DBState {
//   final data;
//   DBSuccessful([this.data]) : super([data]);

//   @override
//   String toString() => 'DBSuccessful';
// }

class DBItems extends DBState {
  final Map<int, Map<int, List<Item>>> items;
  DBItems([this.items]) : super([items]);

  @override
  String toString() => '''DBItems {
    items: $items
  }''';
}
