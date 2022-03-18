import 'dart:async';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:playtimer/classes/UnsavedChangeModel.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({Key key, @required this.onPressed}) : super(key: key);
  final Future<void> Function() onPressed;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  Timer _blinkInterval;
  Timer _delayTimer;
  bool _dispTBlueF = true;
  bool _saveInProgress = false;

  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel needSaveModel = context.watch<UnsavedChangeModel>();
    String buttonTextConsideringUnsavedChange =
        needSaveModel.shouldSave ? "Save" : "Reload";

    return MouseRegion(
      onEnter: (_) {
        if (!_saveInProgress) {
          _blinkInterval = Timer.periodic(Duration(milliseconds: 50),
              (timer) => setState(() => _dispTBlueF = !_dispTBlueF));
          _delayTimer = Timer(Duration(milliseconds: 400), () {
            setState(() => _dispTBlueF = true);
            _blinkInterval.cancel();
          });
        }
      },
      onExit: (_) {
        setState(() => _dispTBlueF = true);
        _delayTimer?.cancel();
        _blinkInterval?.cancel();
      },
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              animationDuration: Duration(milliseconds: 0),
              side: BorderSide(
                  color: _dispTBlueF ? Colors.white : Color(0xFF0000C8))),
          onPressed: !_saveInProgress
              ? () async {
                  setState(() => _saveInProgress = true);
                  await widget.onPressed();
                  setState(() => _saveInProgress = false);
                  needSaveModel.didSave();
                }
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonTextConsideringUnsavedChange,
                style: TextStyle(fontSize: 85),
              ),
              if (_saveInProgress) CircularProgressIndicator()
            ],
          )),
    );
  }

  @override
  void dispose() {
    _blinkInterval?.cancel();
    _delayTimer?.cancel();
    super.dispose();
  }
}
