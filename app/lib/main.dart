import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:screen/screen.dart';
// import 'package:background_fetch/background_fetch.dart';

import './app.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('Event dispatched: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('Error in BLoC!\n$bloc,\n$error,\n$stacktrace');
  }
}

// void task() async {
//   print('[BackgroundFetch] Headless event received.');
//   BackgroundFetch.finish();
// }

void main() {
  Screen.keepOn(true);

  // BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
  // BackgroundFetch.registerHeadlessTask(task);
}

// Future<void> initPlatformState() async {
//   BackgroundFetch.configure(
//     BackgroundFetchConfig(
//       minimumFetchInterval: 15,
//       stopOnTerminate: false,
//       enableHeadless: true,
//       requiresBatteryNotLow: false,
//       requiresCharging: false,
//       requiresStorageNotLow: false,
//       requiresDeviceIdle: false,
//       requiredNetworkType: BackgroundFetchConfig.NETWORK_TYPE_ANY,
//     ),
//     () async => task,
//   ).then((int status) {
//     print('[BackgroundFetch] configure success: $status');
//   }).catchError((e) {
//     print('[BackgroundFetch] configure ERROR: $e');
//   });
// }
