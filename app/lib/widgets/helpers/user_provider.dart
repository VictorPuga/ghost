import 'package:bungie_api/models/user_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';

class UserProvider extends InheritedWidget {
  final Widget child;
  final Credentials credentials;
  final UserInfoCard userInfoCard;

  UserProvider({
    Key key,
    @required this.child,
    @required this.credentials,
    @required this.userInfoCard,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static UserProvider of(BuildContext context) {
    final provider = context.inheritFromWidgetOfExactType(UserProvider);
    return provider as UserProvider;
  }
}
