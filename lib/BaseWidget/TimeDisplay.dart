import 'package:flutter/material.dart';

import 'TimeDisplay/Numeral.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    Key key,
    @required this.seconds,
    @required this.mergeSeconds}) 
    :super(key: key);

  final int seconds;
  final void Function(int) mergeSeconds;

  List<int> converter(int seconds) {
    int hours = (seconds / 3600).floor();
    seconds -= 3600 * hours;
    int minutes = (seconds / 60).floor();
    seconds -= 60 * minutes;

    return [hours, minutes, seconds];
  }

  void updateTime(int diff) {
    print("seconds before: $seconds");
    mergeSeconds(seconds + diff);
    print("$diff, $seconds");
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontFamily: "DSEG",
      fontSize: 80
    );
    TextStyle smallStyle = TextStyle(
      fontFamily: "DSEG",
      fontStyle: FontStyle.italic
    );
    List<int> times = converter(seconds);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Numeral(time: times[0], secondsInUnit: 3600, style: style, onChanged: updateTime),
        Text("hours", style: smallStyle),
        Numeral(time: times[1], secondsInUnit: 60, style: style, onChanged: updateTime),
        Text("minutes", style: smallStyle),
        Numeral(time: times[2], secondsInUnit: 1, style: style, onChanged: updateTime),
        Text("seconds", style: smallStyle)

      ],
    );
  }
}