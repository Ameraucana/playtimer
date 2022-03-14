import 'package:flutter/material.dart';
import 'package:playtimer/HistoryPage/RecordMeasurementDisplay.dart';
import 'package:playtimer/classes/DisplayTime.dart';
import 'package:playtimer/classes/History/RecordStub.dart';

class Record {
  Record(RecordStub stub, this._deltaTime)
      : _startTime = stub.startDate,
        _stopTime = stub.stopDate,
        _usedBonusTime = stub.didUseBonusTime;

  Record.fromString(String formatString) {
    List<String> parts = formatString.split(",");
    _startTime = DateTime.parse(parts[0]);
    _stopTime = DateTime.parse(parts[1]);
    _deltaTime = int.parse(parts[2]);
    _usedBonusTime = parts[3] == "true";
  }

  DateTime _startTime;
  DateTime _stopTime;
  int _deltaTime;
  bool _usedBonusTime;

  DateTime get startTime => _startTime;
  DateTime get stopTime => _stopTime;
  int get deltaTime => _deltaTime;
  bool get usedBonusTime => _usedBonusTime;

  @override
  String toString() {
    return "${_startTime.toString()},${_stopTime.toString()},$_deltaTime,$_usedBonusTime";
  }

  Widget toWidget(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .5,
      child: Card(
          borderOnForeground: false,
          shape: Border(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  RecordMeasurementDisplay(_deltaTime),
                  if (usedBonusTime)
                    Text("Modified", style: TextStyle(color: Colors.green[400]))
                ],
              ),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                DisplayTime(startTime).display(context, dateOnly: true),
                Icon(Icons.arrow_forward),
                DisplayTime(stopTime).display(context, dateOnly: true)
              ])
            ]),
          )),
    );
  }

  bool operator ==(object) => object is Record && object.startTime == startTime;

  int get hashCode => startTime.hashCode ^ stopTime.hashCode;
}
