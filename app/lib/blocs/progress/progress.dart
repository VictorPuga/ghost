import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Events

class ProgressEvent extends Equatable {
  ProgressEvent([List props = const []]) : super(props);
}

class ProgressUpdate extends ProgressEvent {
  final String status;
  final num progress;

  ProgressUpdate({
    @required this.progress,
    @required this.status,
  }) : super([progress, status]);

  @override
  String toString() => '''ProgressUpdate {
      progress: $progress,
      status: $status,
    }''';
}

class ProgressRestart extends ProgressEvent {
  @override
  String toString() => 'ProgressRestart';
}

// State

class ProgressState extends Equatable {
  final String status;
  final num progress;

  ProgressState({
    @required this.progress,
    @required this.status,
  }) : super([progress, status]);

  @override
  String toString() => '''ProgressState {
      progress: $progress,
      status: $status,
    }''';
}

// BLoC

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  @override
  get initialState => ProgressState(progress: 0, status: '');

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('Error on ProgressBloc:');
    print(error);
    print(stacktrace);
  }

  @override
  Stream<ProgressState> mapEventToState(ProgressEvent event) async* {
    if (event is ProgressUpdate) {
      yield ProgressState(
        progress: event.progress,
        status: event.status,
      );
    }
    if (event is ProgressRestart) {
      yield initialState;
    }
  }
}
