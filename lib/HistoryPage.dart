import "package:flutter/material.dart";
import 'package:playtimer/BaseWidget/painters/LCDGridPainter.dart';
import 'package:playtimer/HistoryPage/RecordMeasurementDisplay.dart';
import 'package:playtimer/classes/DisplayTime.dart';
import 'package:playtimer/classes/Timekeeper.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({this.timekeeper});
  final Timekeeper timekeeper;

  @override
  Widget build(context) {
    Widget widgetToDisplay;
    if (timekeeper.activeItem.changeHistory.records.length == 0) {
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
      widgetToDisplay = Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              itemCount: timekeeper.activeItem.changeHistory.records.length,
              itemBuilder: (context, index) {
                return FractionallySizedBox(
                  widthFactor: .5,
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RecordMeasurementDisplay(timekeeper
                              .activeItem.changeHistory.records[index]),
                          if (timekeeper.activeItem.changeHistory.records[index]
                              .usedBonusTime)
                            Text("Used bonus time",
                                style: TextStyle(color: Colors.green[400]))
                        ],
                      ),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        DisplayTime(timekeeper.activeItem.changeHistory
                                .records[index].startTime)
                            .display(context, dateOnly: true),
                        Icon(Icons.arrow_forward),
                        DisplayTime(timekeeper.activeItem.changeHistory
                                .records[index].stopTime)
                            .display(context, dateOnly: true)
                      ])
                    ]),
                  )),
                );
              },
            ),
          ),
          Positioned(
              left: 10,
              top: 10,
              child: OutlinedButton(
                child: Text("Return"),
                onPressed: () => Navigator.pop(context),
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
