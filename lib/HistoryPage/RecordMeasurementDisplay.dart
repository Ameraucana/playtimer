import "package:flutter/material.dart";

class RecordMeasurementDisplay extends StatelessWidget {
  RecordMeasurementDisplay(this._seconds, {double scale = 1.0})
      : numberSize = scale * 25, // needed this for
        letterSize = scale * 15; // DayGroup.dart
  final int _seconds;
  final double numberSize;
  final double letterSize;

  List<String> getTimeValues(int seconds) {
    Duration duration = Duration(seconds: seconds);
    List<String> times = duration.toString().split(".").first.split(":");
    return [times[0], times[1], times[2]];
  }

  @override
  Widget build(context) {
    final TextStyle lightBackground = TextStyle(
        backgroundColor: Color(0xFF0000C2),
        fontFamily: "DSEG",
        fontSize: numberSize);
    List<String> hms = getTimeValues(_seconds);
    return RichText(
      text: TextSpan(
          style: TextStyle(fontFamily: "DSEG", fontSize: letterSize),
          children: [
            if (_seconds.isNegative)
              TextSpan(text: "-", style: lightBackground),
            if (int.parse(hms[0]) != 0) ...[
              TextSpan(text: hms[0], style: lightBackground),
              if (int.parse(hms[0]) == 1) TextSpan(text: " hour ")
              else TextSpan(text: " hours ")
            ],
            if (int.parse(hms[1]) != 0) ...[
              TextSpan(text: hms[1], style: lightBackground),
              if (int.parse(hms[1]) == 1) TextSpan(text: " minute ")
              else TextSpan(text: " minutes ")
            ],
            if (int.parse(hms[2]) != 0) ...[
              TextSpan(text: hms[2], style: lightBackground),
              if (int.parse(hms[2]) == 1) TextSpan(text: " second")
              else TextSpan(text: " seconds")
            ]
          ]),
    );
  }
}
