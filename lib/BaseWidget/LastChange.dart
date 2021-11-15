import 'package:flutter/material.dart';

class LastChange extends StatelessWidget {
  LastChange({@required this.lastChangeDate});
  final DateTime lastChangeDate;

  String formatter() {
    return "${lastChangeDate.month}/${lastChangeDate.day}/${lastChangeDate.year}";
  }

  @override
  Widget build(context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(text: "Last changed on "),
          TextSpan(text: formatter())
        ]
      )
    );
  }
}