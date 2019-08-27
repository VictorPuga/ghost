import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  final void Function() onPressed;
  AddItem({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      pressedOpacity: 0.8,
      onPressed: onPressed,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: CupertinoColors.lightBackgroundGray,
            child: Column(
              children: [
                Flexible(child: Container()),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      CupertinoIcons.add,
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                ),
                Flexible(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
