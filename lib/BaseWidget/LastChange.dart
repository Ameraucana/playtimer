import 'package:flutter/material.dart';

class LastChange extends StatelessWidget {
  LastChange({@required this.lastChangeDate});
  final DateTime lastChangeDate;

  String date() {
    return "${lastChangeDate.month}/${lastChangeDate.day}/${lastChangeDate.year}";
  }
  String time() {
    int to12Time() {
      int convertedTime = lastChangeDate.hour % 12;
      if (convertedTime == 0) {
        convertedTime = 12;
      }
      return convertedTime;
    }
    String amOrPm() {
      if (lastChangeDate.hour < 12) {
        return "AM";
      } else {
        return "PM";
      }
    }
    return "${to12Time()}:${lastChangeDate.minute.toString().padLeft(2, "0")}${amOrPm()}";
  }

  @override
  Widget build(context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(text: "Last changed on   "),
          TextSpan(text: date(), style: TextStyle(backgroundColor: Color(0xFF00008F))),
          TextSpan(text: " at "),
          TextSpan(text: time(), style: TextStyle(backgroundColor: Color(0xFF00008F))),
        ]
      )
    );
  }
}