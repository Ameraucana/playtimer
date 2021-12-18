import 'package:flutter/material.dart';
import 'package:playtimer/classes/DisplayTime.dart';

class LastChange extends StatelessWidget {
  LastChange({@required this.lastChangeDate});
  final DateTime lastChangeDate;

  @override
  Widget build(context) {
    return DisplayTime(lastChangeDate).display(context);
  }
}
