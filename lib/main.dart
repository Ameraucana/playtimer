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
  // This widget is the root of your application.
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        fontFamily: "DSEG"
      ),
      home: Scaffold(
        
        body: FutureBuilder(
          future: getTimedItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return BaseWidget(timedItems: snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        )
      )
    );
  }
}
