import 'dart:convert';

import 'package:playtimer/classes/History/ChangeHistory.dart';

import 'TimeDelta.dart';

class TimedItem {
  TimedItem.yetUnchanged(String name, int seconds) {
    this.name = name;
    this.seconds = seconds;
    this.lastChangeDate = DateTime.now();
    this.changeHistory = ChangeHistory();
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

  // when this is true, the TimedItem will not be included in the Selector or in
  // the upload to remote, essentially removing it. it can't just be deleted
  // because the case that something is removed and the case that something is
  // added from another application instance while this one is running share
  // the same conditions of being on remote and not being on local
  bool isMarkedForOmission = false;

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

  // merges into the local list
  static void merge(List<TimedItem> local, List<TimedItem> remote) {
    for (TimedItem potentiallyDifferingItem in remote) {
      // account for new TimedItems create in another application instance
      if (!local.contains(potentiallyDifferingItem)) {
        local.add(potentiallyDifferingItem);
        continue;
      }
      // deleting is undone post-save without this (also introduces bug)
      // remote.removeWhere((oldItem) => !local.contains(oldItem));

      for (TimedItem localEntry in local) {
        if (potentiallyDifferingItem == localEntry) {
          // combine seconds times
          localEntry.seconds =
              potentiallyDifferingItem.seconds + localEntry.delta.preresetDelta;
          // replace lastChangeDate if remote is more recent
          if (potentiallyDifferingItem.lastChangeDate
              .isAfter(localEntry.lastChangeDate)) {
            localEntry.lastChangeDate = potentiallyDifferingItem.lastChangeDate;
          }
          // merge records
          potentiallyDifferingItem.changeHistory.records
              .where((remoteRecord) =>
                  !localEntry.changeHistory.records.contains(remoteRecord))
              .forEach((differingRecord) {
            int targetIndex = localEntry.changeHistory.records.indexWhere(
                (localRecord) =>
                    differingRecord.startTime.isAfter(localRecord.startTime));
            print(
                "${localEntry.name}: ${differingRecord.startTime} -> ${differingRecord.stopTime} in ${differingRecord.deltaTime} at index $targetIndex");
            localEntry.changeHistory.records
                .insert(targetIndex, differingRecord);
          });
        }
      }
    }
    print(local);
  }

  bool operator ==(object) => object is TimedItem && object.name == name;
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
