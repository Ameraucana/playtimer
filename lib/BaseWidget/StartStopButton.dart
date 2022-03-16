import "package:flutter/material.dart";

class StartStopButton extends StatelessWidget {
  StartStopButton(
      {@required this.startButtonIsActive,
      @required this.startButtonFunc,
      @required this.stopButtonFunc,
      @required this.disabled})
      : startButton = OutlinedButton.icon(
            icon: Icon(Icons.play_arrow_sharp, size: 60, color: Colors.white),
            label: Text("Start", style: _style),
            style: _buttonStyle,
            onPressed: !disabled
                ? () {
                    startButtonFunc();
                  }
                : null),
        stopButton = OutlinedButton.icon(
          icon: Icon(Icons.stop_sharp, size: 60, color: Colors.white),
          label: Text("Stop", style: _style),
          style: _buttonStyle,
          onPressed: !disabled
              ? () {
                  stopButtonFunc();
                }
              : null,
        );
  static final TextStyle _style =
      TextStyle(fontFamily: "DSEG", fontSize: 30, color: Colors.white);
  static final ButtonStyle _buttonStyle =
      OutlinedButton.styleFrom(side: BorderSide(color: Colors.white));

  final void Function() startButtonFunc;
  final void Function() stopButtonFunc;
  final bool startButtonIsActive;
  final bool disabled;

  final Widget startButton;
  final Widget stopButton;

  @override
  Widget build(BuildContext context) {
    return startButtonIsActive ? startButton : stopButton;
  }
}
