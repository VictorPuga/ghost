import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost/custom_theme.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/views/tabs/screens/sets/select_items.dart';
import 'package:ghost/utils.dart';

class SelectConfigs extends StatefulWidget {
  final List<String> characterIds;

  SelectConfigs({
    Key key,
    this.characterIds,
  }) : super(key: key);

  @override
  _SelectConfigsState createState() => _SelectConfigsState();
}

class _SelectConfigsState extends State<SelectConfigs> {
  TextEditingController _nameController;
  int _selected = 3;

  List<String> get _characterIds => widget.characterIds;

  @override
  void initState() {
    _nameController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('New Set'),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notif) {
                if (notif is UserScrollNotification) {
                  if (FocusScope.of(context).hasFocus) {
                    FocusScope.of(context).unfocus();
                  }
                }
                // return true;
                return false;
              },
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Name', style: CustomTheme.headingStyle),
                      CupertinoTextField(
                        placeholder: 'My armor',
                        controller: _nameController,
                      ),
                      const Text('Class', style: CustomTheme.headingStyle),
                      CupertinoSegmentedControl(
                        groupValue: _selected,
                        children: const {
                          0: Text('Warlock'),
                          1: Text('Titan'),
                          2: Text('Hunter'),
                          3: Text('Any'),
                        },
                        onValueChanged: (int v) {
                          setState(() {
                            _selected = v;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  CupertinoButton.filled(
                    child: const Text('Continue'),
                    onPressed: () {
                      if (_nameController.text.isEmpty) {
                        showBasicAlert(
                          context,
                          'Oops',
                          'The name of the set must not be empty.',
                        );
                      } else {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => SelectItems(
                              name: _nameController.text,
                              characterId: [..._characterIds, null][_selected],
                              classCategoryHash: [
                                DestinyCategoryHash.warlock,
                                DestinyCategoryHash.titan,
                                DestinyCategoryHash.hunter,
                                null
                              ][_selected],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
