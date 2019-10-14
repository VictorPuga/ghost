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
        if (!state.isLoading) {
          return Container();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.status),
            Container(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: LinearProgressIndicator(
                value: state.progress.toDouble(),
                valueColor: AlwaysStoppedAnimation(CupertinoColors.activeBlue),
                backgroundColor: CupertinoColors.lightBackgroundGray,
              ),
            ),
          ],
        );
      },
    );
  }
}
