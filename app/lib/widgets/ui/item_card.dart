import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/widgets/widgets.dart';

import 'loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ghost/models/models.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool empty;
  final String characterId;
  // final VoidCallback onPressed;

  ItemCard({
    Key key,
    this.item,
    this.empty = false,
    this.characterId,
    // this.onPressed,
  })  : assert(empty != null),
        super(key: key);

  static const TextStyle _statStyle = TextStyle(
    color: Colors.grey,
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    final apiBloc = BlocProvider.of<APIBloc>(context);
    final provider = UserProvider.of(context);
    final Credentials credentials = provider.credentials;
    final int membershipType = provider.userInfoCard.membershipType;

    return CupertinoButton(
      // onPressed: onPressed,
      pressedOpacity: 0.7,
      onPressed: () {
        apiBloc.dispatch(
          EquipItem(
            id: item.itemInstanceId,
            characterId: characterId,
            membershipType: membershipType,
            accessToken: credentials.accessToken,
          ),
        );
      },
      child: Container(
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: Color.fromRGBO(0, 0, 0, 0.2),
        //       blurRadius: 5.0,
        //       offset: Offset(1.0, 1.0),
        //     )
        //   ],
        // ),
        child: Row(
          children: <Widget>[
            // Expanded(
            //   child:
            Container(
              height: 100,
              width: 100,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                  child: Container(
                    color: CupertinoColors.lightBackgroundGray,
                    child: !empty ? _content() : LoadingImage(),
                  ),
                ),
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }

  _content() => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item.icon,
            placeholder: (_, __) => Container(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // SizedBox.expand(),
                        Text(
                          item.primaryStat?.toString() ?? '',
                          style: _statStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  factory ItemCard.empty() => ItemCard(empty: true);
}
