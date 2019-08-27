import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ghost/utils.dart';
import 'package:ghost/views/tabs/screens/sets/select-items.dart';

class SelectConfigs extends StatefulWidget {
  SelectConfigs({
    Key key,
  }) : super(key: key);
  @override
  _SelectConfigsState createState() => _SelectConfigsState();
}

class _SelectConfigsState extends State<SelectConfigs> {
  TextEditingController _nameController;
  int _selected = 3;

  @override
  void initState() {
    _nameController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        middle: Text('New Set'),
      ),
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notif) {
                if (notif is UserScrollNotification) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                return;
              },
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Name'),
                      CupertinoTextField(
                        placeholder: 'My armor',
                        controller: _nameController,
                      ),
                      const Text('Class'),
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
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  CupertinoButton.filled(
                    child: const Text('Continue'),
                    onPressed: () {
                      // if (_nameController.text.isEmpty) {
                      //   showBasicAlert(
                      //     context,
                      //     'Oops',
                      //     'The name of the set must not be empty',
                      //   );
                      // } else {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => SelectItems(
                            name: _nameController.text,
                            type: _selected,
                          ),
                        ),
                      );
                      // }
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
