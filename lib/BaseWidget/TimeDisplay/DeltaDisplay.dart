import 'package:flutter/material.dart';

import 'package:playtimer/classes/TimeDelta.dart';

class DeltaDisplay extends StatelessWidget {
  const DeltaDisplay({Key key, @required this.delta}) : super(key: key);

  final TimeDelta delta;

  List<int> converter(int seconds) {
    int hours = 0, minutes = 0;
    if (seconds > 0) {
      hours = (seconds / 3600).floor();
      seconds -= 3600 * hours;
      minutes = (seconds / 60).floor();
      seconds -= 60 * minutes;
    } else {
      hours = (seconds / 3600).ceil();
      seconds -= 3600 * hours;
      minutes = (seconds / 60).ceil();
      seconds -= 60 * minutes;
    }

    return [hours, minutes, seconds];
  }

  @override
  Widget build(BuildContext context) {
    List<int> threeTimes = converter(delta.delta);
    Color textColor;
    String sign;
    if (delta.delta > 0) {
      textColor = Colors.green[400];
      sign = "+";
    } else if (delta.delta < 0) {
      textColor = Colors.red[400];
      sign = "-";
      //i don't want negative signs on every number
      threeTimes = threeTimes.map((time) => time * -1).toList();
    } else {
      textColor = Colors.white;
    }

    if (delta.delta == 0) {
      return SizedBox(height: 0, width: 0);
    } else {
      return RichText(
          text: TextSpan(
              style:
                  TextStyle(fontFamily: "DSEG", fontSize: 20, color: textColor),
              children: [
            TextSpan(text: sign),
            TextSpan(text: threeTimes[0].toString()),
            TextSpan(text: "hours ", style: TextStyle(fontSize: 12)),
            TextSpan(text: threeTimes[1].toString()),
            TextSpan(text: "minutes ", style: TextStyle(fontSize: 12)),
            TextSpan(text: threeTimes[2].toString()),
            TextSpan(text: "seconds ", style: TextStyle(fontSize: 12))
          ]));
    }
  }
}
