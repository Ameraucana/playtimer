import "package:flutter/material.dart";

class StartStopButton extends StatelessWidget {
  StartStopButton({
    @required this.startButtonIsActive,
    @required this.startButtonFunc,
    @required this.stopButtonFunc
  }) :
    startButton = OutlinedButton.icon(
      icon: Icon(Icons.play_arrow_sharp, size: 60),
      label: Text("Start", style: TextStyle(fontFamily: "DSEG", fontSize: 30)),
      onPressed: () {
        startButtonFunc();
      }
    ),
    stopButton = OutlinedButton.icon(
      icon: Icon(Icons.stop_sharp, size: 60),
      label: Text("Stop", style: TextStyle(fontFamily: "DSEG", fontSize: 30)),
      onPressed: () {
        stopButtonFunc();
      },
    );

  final void Function() startButtonFunc;
  final void Function() stopButtonFunc;
  final bool startButtonIsActive;

  final Widget startButton;
  final Widget stopButton; 

  @override
  Widget build(BuildContext context) {
    return startButtonIsActive ? startButton : stopButton;
  }
}