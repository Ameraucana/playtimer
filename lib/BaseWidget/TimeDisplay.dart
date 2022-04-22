import 'package:flutter/material.dart';
import 'package:playtimer/classes/TimedItem.dart';
import 'package:playtimer/BaseWidget/TimeDisplay/DeltaDisplay.dart';
import 'TimeDisplay/Numeral.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay(
      {Key key,
      @required this.timedItem,
      @required this.mergeSeconds,
      @required this.disabled})
      : super(key: key);

  final TimedItem timedItem;
  final void Function(int) mergeSeconds;
  final bool disabled;

  List<int> converter(int seconds) {
    int hours = (seconds / 3600).floor();
    seconds -= 3600 * hours;
    int minutes = (seconds / 60).floor();
    seconds -= 60 * minutes;

    return [hours, minutes, seconds];
  }

  void updateTime(int diff) {
    mergeSeconds(timedItem.seconds + diff);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: "DSEG", fontSize: 80);
    TextStyle smallStyle =
        TextStyle(fontFamily: "DSEG", fontStyle: FontStyle.italic);
    List<int> times = converter(timedItem.seconds);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          alignment: WrapAlignment.center,
          children: [
            Numeral(
                time: times[0],
                secondsInUnit: 3600,
                style: style,
                onChanged: updateTime,
                disabled: disabled),
            Text("hours", style: smallStyle),
            Numeral(
                time: times[1],
                secondsInUnit: 60,
                style: style,
                onChanged: updateTime,
                disabled: disabled),
            Text("minutes", style: smallStyle),
            Numeral(
                time: times[2],
                secondsInUnit: 1,
                style: style,
                onChanged: updateTime,
                disabled: disabled),
            Text("seconds", style: smallStyle)
          ],
        ),
        SizedBox(
          height: 5,
          width: 0,
        ),
        DeltaDisplay(delta: timedItem.delta)
      ],
    );
  }
}
