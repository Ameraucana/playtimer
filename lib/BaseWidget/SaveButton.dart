import 'dart:async';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:playtimer/classes/UnsavedChangeModel.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({Key key, @required this.onPressed}) : super(key: key);
  final void Function() onPressed;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  Timer _blinkInterval;
  Timer _delayTimer;
  bool _dispTBlueF = true;

  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel needSaveModel = context.watch<UnsavedChangeModel>();
    Color outlineNeutralColor =
        needSaveModel.shouldSave ? Colors.red : Colors.white;

    return MouseRegion(
      onEnter: (_) {
        _blinkInterval = Timer.periodic(Duration(milliseconds: 100),
            (timer) => setState(() => _dispTBlueF = !_dispTBlueF));
        _delayTimer = Timer(Duration(milliseconds: 400), () {
          setState(() => _dispTBlueF = true);
          _blinkInterval.cancel();
        });
      },
      onExit: (_) {
        setState(() => _dispTBlueF = true);
        _delayTimer?.cancel();
        _blinkInterval?.cancel();
      },
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color:
                      _dispTBlueF ? outlineNeutralColor : Color(0xFF0000C8))),
          onPressed: () {
            needSaveModel.didSave();
            widget.onPressed();
          },
          child: Text(
            "Save",
            style: TextStyle(fontSize: 85, color: Colors.white),
          )),
    );
  }

  @override
  @override
  void dispose() {
    _blinkInterval?.cancel();
    _delayTimer?.cancel();
    super.dispose();
  }
}
