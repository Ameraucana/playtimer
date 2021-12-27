import 'package:flutter/material.dart';
import 'package:playtimer/HistoryPage/RecordMeasurementDisplay.dart';
import 'package:playtimer/classes/DisplayTime.dart';
import 'package:playtimer/classes/History/Record.dart';

class DayGroup {
  DayGroup({@required this.firstMember});
  Record firstMember;
  List<Record> _members = [];
  List<Record> get members => [firstMember, ..._members];

  int get cumulativeSeconds => members.fold(
      0, (previousValue, element) => previousValue += element.deltaTime);

  bool addIfSameDay(Record candidate) {
    if (candidate.startTime.day == firstMember.startTime.day &&
        candidate.startTime.month == firstMember.startTime.month &&
        candidate.startTime.year == firstMember.startTime.year) {
      _members.add(candidate);
      return true;
    }
    return false;
  }

  Widget toWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor)),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DisplayTime(firstMember.startTime)
                          .display(context, dateOnly: true, showTime: false),
                      Text(" :  "),
                      RecordMeasurementDisplay(cumulativeSeconds, scale: .5)
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: members
                            .map((member) => member.toWidget(context))
                            .toList(),
                      ))
                ])),
      ),
    );
  }
}
