import 'package:playtimer/classes/History/Record.dart';
import 'package:playtimer/classes/History/RecordStub.dart';
import 'package:playtimer/classes/TimeDelta.dart';

class ChangeHistory {
  ChangeHistory.fromJsonList(List<dynamic> unformedList)
      : _records = unformedList.map((item) => Record.fromString(item)).toList();
  ChangeHistory();
  RecordStub stub = RecordStub();
  List<Record> _records = [];

  List<Record> get records => _records;

  void completeRecord(TimeDelta delta) {
    if (stub.isFresh) {
      _records.insert(0, Record(stub, delta.delta));
      stub.reset();
    }
  }
}
