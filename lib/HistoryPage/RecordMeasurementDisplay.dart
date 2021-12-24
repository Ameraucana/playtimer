import "package:flutter/material.dart";
import 'package:playtimer/classes/History/Record.dart';

class RecordMeasurementDisplay extends StatelessWidget {
  RecordMeasurementDisplay(this._record);
  final Record _record;

  List<String> getTimeValues(Record record) {
    Duration duration = Duration(seconds: record.deltaTime);
    List<String> times = duration.toString().split(".").first.split(":");
    return [times[0], times[1], times[2]];
  }

  final TextStyle lightBackground = TextStyle(
      backgroundColor: Color(0xFF0000C2), fontFamily: "DSEG", fontSize: 25);
  @override
  Widget build(context) {
    List<String> hms = getTimeValues(_record);
    return RichText(
      text: TextSpan(style: TextStyle(fontFamily: "DSEG"), children: [
        if (_record.deltaTime.isNegative)
          TextSpan(text: "-", style: lightBackground),
        if (int.parse(hms[0]) != 0) ...[
          TextSpan(text: hms[0], style: lightBackground),
          TextSpan(text: " hours ")
        ],
        if (int.parse(hms[1]) != 0) ...[
          TextSpan(text: hms[1], style: lightBackground),
          TextSpan(text: " minutes ")
        ],
        TextSpan(text: hms[2], style: lightBackground),
        TextSpan(text: " seconds ")
      ]),
    );
  }
}
