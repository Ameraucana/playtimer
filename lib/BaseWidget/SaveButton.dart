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

class _SaveButtonState extends State<SaveButton> with SingleTickerProviderStateMixin {
  AnimationController _blinkController;
  Animation<Color> _blueBlink;
  Animation<Color> _redBlink;
  Timer _delayTimer;

  @override
  void initState() { 
    super.initState();
    _blinkController = AnimationController(vsync: this, duration: Duration(milliseconds: 80));
    _blueBlink = ColorTween(
      begin: Colors.indigo,
      end: Colors.indigo[100]
    ).animate(_blinkController)..addListener(() {setState(() {});});
    _redBlink = ColorTween(
      begin: Colors.red,
      end: Colors.red[100]
    ).animate(_blinkController)..addListener(() {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel needSaveModel = context.watch<UnsavedChangeModel>();
    Animation<Color> displayColor = needSaveModel.shouldSave ? _redBlink : _blueBlink;
    
    return SizedBox(
      height: 150,
      width: 300,
      child: MouseRegion(
        onEnter: (_) {
          _blinkController.repeat();
          _delayTimer = Timer(Duration(milliseconds: 400), () => _blinkController.reset());
        },
        onExit: (_) {
          _blinkController.reset();
          _delayTimer?.cancel();
        },
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(displayColor.value)
          ),
          onPressed: () {
            needSaveModel.didSave();
            widget.onPressed();
          },
          child: Text(
            "Save",
            style: TextStyle(
              fontSize: 85,
              color: Colors.blueGrey[100]
            ),
          )
        ),
      )
    );
  }

  @override
  void dispose() { 
    _blinkController.dispose();
    super.dispose();
  }
}