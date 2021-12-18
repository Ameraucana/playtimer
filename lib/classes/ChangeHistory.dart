import 'package:playtimer/classes/Record.dart';

class ChangeHistory {
  List<Record> _changeRecords;

  void addRecord(Record newRecord) {
    _changeRecords.add(newRecord);
  }
}
