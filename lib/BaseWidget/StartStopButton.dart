import "package:flutter/material.dart";

class StartStopButton extends StatefulWidget {
  StartStopButton({
    Key key,
    @required this.startButtonFunc,
    @required this.stopButtonFunc
  }) : super(key: key);
  final void Function() startButtonFunc;
  final void Function() stopButtonFunc;

  @override
  _StartStopButtonState createState() => _StartStopButtonState();
}

class _StartStopButtonState extends State<StartStopButton> {

  @override
  void initState() { 
    super.initState();
    TextStyle style = TextStyle(
      fontFamily: "DSEG",
      fontSize: 30
    );
    startButton = OutlinedButton.icon(
      icon: Icon(Icons.play_arrow_sharp, size: 60),
      label: Text("Start", style: style),
      onPressed: () {
        widget.startButtonFunc();
        setState(() => startButtonActive = false);
      }
    );
    stopButton = OutlinedButton.icon(
      icon: Icon(Icons.stop_sharp, size: 60),
      label: Text("Stop", style: style),
      onPressed: () {
        widget.stopButtonFunc();
        setState(() => startButtonActive = true);
      },
    );
  }
  bool startButtonActive = true;
  Widget startButton;
  Widget stopButton; 

  @override
  Widget build(BuildContext context) {
    return startButtonActive ? startButton : stopButton;
  }
}