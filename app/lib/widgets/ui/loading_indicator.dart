import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/progress/progress.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ProgressBloc>(context),
      builder: (_, ProgressState state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.status),
            Text(state.progress.toString()),
          ],
        );
      },
    );
  }
}
