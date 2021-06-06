import 'dart:convert';

class TimedItem {
  TimedItem(String name, int seconds) {
    contents = {
      "name": name,
      "seconds": seconds.toString()
    };
  }

  Map<String, String> contents;

  get name => contents["name"];
  get seconds => int.parse(contents["seconds"]);
  set seconds (int newValue) => contents["seconds"] = newValue.toString();

  static List<TimedItem> decode(String json) {
    List<dynamic> decodedJson = jsonDecode(json);
    print(decodedJson);
    List<TimedItem> items = [];
    for (var item in decodedJson) {
      String name = item["name"];
      String seconds = item["seconds"];
      items.add(TimedItem(name, int.parse(seconds)));
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