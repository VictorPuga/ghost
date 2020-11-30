import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/widgets/widgets.dart';
import 'loading_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ghost/models/models.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool empty;
  // final String characterId;
  final void Function(Item) onPressed;
  final void Function(Item) onLongPressed;

  ItemCard({
    Key key,
    this.item,
    // this.characterId,
    this.onPressed,
    this.onLongPressed,
  })  : empty = item?.name == null,
        super(
          key: key ?? item?.name != null
              ? ValueKey(
                  item.name,
                )
              : null,
        );

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      activeOpacity: empty ||
              [
                onPressed,
                onLongPressed,
              ].every((el) => el == null)
          ? 1
          : 0.8,
      onTap: onPressed != null
          ? () {
              if (!empty) onPressed(item);
            }
          : null,
      onLongPress: onLongPressed != null
          ? () {
              if (!empty) onLongPressed(item);
            }
          : null,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: CupertinoColors.lightBackgroundGray,
            child: !empty ? _content() : LoadingImage(),
          ),
        ),
      ),
    );
  }

  _content() => Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: item.icon,
            placeholder: (_, __) => Container(),
          ),
          if (item?.primaryStat != null)
            Column(
              children: [
                Flexible(flex: 3, child: Container()),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-0.5, 0),
                        end: Alignment.centerRight,
                        colors: [Colors.transparent, Colors.black],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(flex: 10, child: Container()),
                            Expanded(
                              flex: 5,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Text(
                                  item.primaryStat.toString() ?? '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Flexible(flex: 1, child: Container()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ],
      );
}
