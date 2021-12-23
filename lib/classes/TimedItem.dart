import 'dart:convert';

import 'package:playtimer/classes/History/ChangeHistory.dart';

import 'TimeDelta.dart';

class TimedItem {
  TimedItem.yetUnchanged(String name, int seconds) {
    this.name = name;
    this.seconds = seconds;
    this.lastChangeDate = DateTime.now();
  }
  // this constructor is invoked through decode
  TimedItem(String name, String seconds, String lastChangeDate,
      List<dynamic> encodedRecordList) {
    this.name = name;
    this.seconds = int.parse(seconds);
    this.lastChangeDate = DateTime.parse(lastChangeDate);
    this.changeHistory = ChangeHistory.fromJsonList(encodedRecordList);
  }

  TimeDelta delta = TimeDelta();
  ChangeHistory changeHistory;

  String name;
  int seconds;
  DateTime lastChangeDate;

  static List<TimedItem> formTimedItems(String json) {
    // MIRROR formOutput AS BELOW
    List<dynamic> unformedTimedItems = jsonDecode(json);
    return List<TimedItem>.generate(unformedTimedItems.length, (i) {
      return TimedItem(
          unformedTimedItems[i]["name"],
          unformedTimedItems[i]["seconds"],
          unformedTimedItems[i]["lastChangeDate"],
          unformedTimedItems[i]["records"]);
    });
  }

  static String formOutput(List<TimedItem> items) {
    // PUT ALL THE SAVE FILE FIELDS HERE
    var listOfEncodedTimedItems = items
        .map((item) => {
              "name": item.name,
              "seconds": item.seconds.toString(),
              "lastChangeDate": item.lastChangeDate.toString(),
              "records": item.changeHistory.records
                  .map((item) => item.toString())
                  .toList()
            })
        .toList();
    return jsonEncode(listOfEncodedTimedItems);
  }

  @override
  String toString() {
    return name;
  }
}
