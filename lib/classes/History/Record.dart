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
}
