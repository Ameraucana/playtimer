import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'BaseWidget.dart';
import 'classes/TimedItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<TimedItem>> getTimedItems() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    File file = File(path.join(documentsDir.path, "timedItems.json"));
    List<TimedItem> timedItems;
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      timedItems = TimedItem.decode(jsonString);
      if (timedItems.length == 0) {
        print("the length was 0");
        timedItems.add(TimedItem("None", 0));
      }
    } else {
      file.writeAsString("[]");
      timedItems = [TimedItem("None", 0)];
    }
    return timedItems;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playtimer',
      theme: ThemeData(
        fontFamily: "DSEG",
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: getTimedItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(child: BaseWidget(timedItems: snapshot.data));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        )
      )
    );
  }
}