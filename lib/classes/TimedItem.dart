import 'dart:convert';

class TimedItem {
  TimedItem.yetUnchanged(String name, int seconds) {
    contents = {
      "name": name,
      "seconds": seconds.toString(),
      "lastChangeDate": DateTime.now().toString()
    };
  }
  TimedItem(String name, int seconds, DateTime lastChangeDate) {
    contents = {
      "name": name,
      "seconds": seconds.toString(),
      "lastChangeDate": lastChangeDate.toString()
    };
  }

  Map<String, String> contents;

  String get name => contents["name"];
  int get seconds => int.parse(contents["seconds"]);
  DateTime get lastChangeDate => DateTime.parse(contents["lastChangeDate"]);
  set seconds (int newValue) => contents["seconds"] = newValue.toString();

  static List<TimedItem> decode(String json) {
    List<dynamic> decodedJson = jsonDecode(json);
    print(decodedJson);
    List<TimedItem> items = [];
    for (var item in decodedJson) {
      String name = item["name"];
      String seconds = item["seconds"];
      String lastChangeDate = item["lastChangeDate"];
      items.add(TimedItem(name, int.parse(seconds), DateTime.parse(lastChangeDate)));
    }
    return items;
  }
  static String encode(List<TimedItem> items) {
    var mapItems = items.map((item) => item.contents).toList();
    print(mapItems);
    return jsonEncode(mapItems);
  }

  @override
  String toString() {
    return name;
  }

  
}