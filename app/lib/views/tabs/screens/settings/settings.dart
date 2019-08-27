import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/blocs/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return SafeArea(
      child: Container(
        child: Column(
          children: [
            const Text('Settings'),
            CupertinoButton(
              child: Text('Log out'),
              onPressed: () {
                authBloc.dispatch(LogOut());
              },
            )
          ],
        ),
      ),
    );
  }
}
