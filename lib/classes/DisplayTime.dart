import 'package:flutter/material.dart';

/// DisplayTime is a helper class to create
/// easily displayable dates from DateTime objects
class DisplayTime {
  DisplayTime(this.dateObj);
  DateTime dateObj;

  int _to12Time(DateTime date) {
    int convertedTime = date.hour % 12;
    if (convertedTime == 0) {
      convertedTime = 12;
    }
    return convertedTime;
  }

  String _amOrPm(DateTime date) {
    if (date.hour < 12) {
      return "AM";
    } else {
      return "PM";
    }
  }

  String _time() {
    return "${_to12Time(dateObj)}:${dateObj.minute.toString().padLeft(2, "0")}${_amOrPm(dateObj)}";
  }

  String _date() {
    return "${dateObj.month}/${dateObj.day}/${dateObj.year}";
  }

  Widget display(BuildContext context,
      {bool dateOnly = false, bool showTime = true}) {
    return RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
          TextSpan(text: !dateOnly ? "Last changed on   " : ""),
          TextSpan(
              text: _date(),
              style: TextStyle(backgroundColor: Color(0xFF00008F))),
          if (showTime) TextSpan(text: " at "),
          if (showTime)
            TextSpan(
                text: _time(),
                style: TextStyle(backgroundColor: Color(0xFF00008F))),
        ]));
  }
}
