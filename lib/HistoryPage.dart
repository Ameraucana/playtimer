import "package:flutter/material.dart";
import 'package:playtimer/BaseWidget/painters/LCDGridPainter.dart';
import 'package:playtimer/classes/History/ChangeHistory.dart';
import 'package:playtimer/classes/History/DayGroup.dart';
import 'package:playtimer/classes/History/Record.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({this.changeHistory});
  final ChangeHistory changeHistory;

  @override
  Widget build(context) {
    Widget widgetToDisplay;

    if (changeHistory.records.length == 0) {
      widgetToDisplay = Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("No records."),
          SizedBox(height: 10),
          OutlinedButton(
            child: Text("Return"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ));
    } else {
      List<DayGroup> dayGroups = [
        DayGroup(firstMember: changeHistory.records.first)
      ];
      for (Record record in changeHistory.records.sublist(1)) {
        if (!dayGroups.last.addIfSameDay(record)) {
          dayGroups.add(DayGroup(firstMember: record));
        }
      }

      widgetToDisplay = Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              itemCount: dayGroups.length,
              itemBuilder: (context, index) {
                return dayGroups[index].toWidget(context);
              },
            ),
          ),
          Positioned(
              left: 10,
              top: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("History", style: TextStyle(fontSize: 23)),
                  SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    child: Text("Return"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )),
        ],
      );
    }

    return Scaffold(
      body: CustomPaint(
          foregroundPainter: LCDGridPainter(), child: widgetToDisplay),
    );
  }
}
