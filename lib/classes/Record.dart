import 'package:flutter/material.dart';
import 'package:playtimer/classes/DisplayTime.dart';

class Record {
  //for new Records
  Record.present(this.start);
  //for reading in
  Record.fromData(this.start, this.end);

  DateTime start;
  DateTime end;

  Widget toWidget(BuildContext context) {
    return Card(
        child: Column(children: [
      DisplayTime(start).display(context),
      Icon(Icons.arrow_downward_sharp),
      DisplayTime(end).display(context)
    ]));
  }
}
