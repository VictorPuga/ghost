import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshHeader extends CustomHeader {
  RefreshHeader({Key key}) : super(key: key, builder: _builder);

  static Widget _builder(BuildContext context, RefreshStatus status) {
    switch (status) {
      case RefreshStatus.idle:
      case RefreshStatus.canRefresh:
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: CupertinoActivityIndicator(animating: false),
        );
      case RefreshStatus.refreshing:
      case RefreshStatus.completed:
      case RefreshStatus.failed:
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: CupertinoActivityIndicator(),
        );
    }
    // Never gets executed
    return Container();
  }
}
