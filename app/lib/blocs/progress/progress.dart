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
  final bool isLoading;

  ProgressUpdate({
    @required this.progress,
    @required this.status,
    this.isLoading,
  }) : super([progress, status, isLoading]);

  @override
  String toString() => '''ProgressUpdate {
      progress: $progress,
      status: $status,
      isLoading: $isLoading,
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
  final bool isLoading;

  ProgressState({
    @required this.progress,
    @required this.status,
    this.isLoading = false,
  }) : super([progress, status, isLoading]);

  @override
  String toString() => '''ProgressState {
      progress: $progress,
      status: $status,
      isLoading: $isLoading,
    }''';
}

// BLoC

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  @override
  get initialState => ProgressState(progress: 0, status: '', isLoading: false);

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
        isLoading: event.isLoading,
      );
    }
    if (event is ProgressRestart) {
      yield initialState;
    }
  }
}
