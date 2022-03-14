import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'BaseWidget.dart';
import 'classes/TimedItem.dart';
import 'package:playtimer/BaseWidget/painters/LCDGridPainter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<TimedItem>> getTimedItems() async {
    final String urlEndpoint = "https://json.psty.io/api_v1/stores/playtimer";
    Directory documentsDir = await getApplicationDocumentsDirectory();
    File saveFile =
        File(path.join(documentsDir.path, "playtimer_data", "timedItems.json"));

    await saveFile.create(recursive: true);
    List<TimedItem> remoteTimedItems = [];
    List<TimedItem> localTimedItems = [];

    try {
      http.Response response = await http.get(Uri.parse(urlEndpoint), headers: {
        "Content-Type": "application/json",
        "Api-Key": await rootBundle.loadString("assets/key")
      });
      if (response.statusCode == 200) {
        remoteTimedItems = TimedItem.formTimedItems(
            json.encode(json.decode(response.body)['data']));
        if (await saveFile.exists()) {
          String jsonString = await saveFile.readAsString();
          localTimedItems = TimedItem.formTimedItems(jsonString);
        }
        TimedItem.merge(localTimedItems, remoteTimedItems);
      }
    } catch (e) {
      print(e);
    }
    // This isn't in the catch because an error in the response doesn't
    // throw an error. Being disconnected from the internet, however,
    // would cause an error to be thrown when the host resolution failed
    if (localTimedItems.isEmpty) {
      if (await saveFile.exists()) {
        String jsonString = await saveFile.readAsString();
        localTimedItems = TimedItem.formTimedItems(jsonString);
        if (localTimedItems.length == 0) {
          print("the length was 0");
          localTimedItems.add(TimedItem.yetUnchanged("None", 0));
        }
      } else {
        saveFile.writeAsString("[]");
        localTimedItems = [TimedItem.yetUnchanged("None", 0)];
      }
    }
    return localTimedItems;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Playtimer',
        theme: ThemeData(
            fontFamily: "DSEG",
            scaffoldBackgroundColor: Color(0xFF0000C2),
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: Colors.white, selectionColor: Color(0xFF00008F)),
            cardColor: Color(0xFF0000A2),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    textStyle:
                        TextStyle(color: Colors.white, fontFamily: "DSEG"),
                    onSurface: Colors.white)),
            canvasColor: Color(0xFF00008F),
            colorScheme: ColorScheme(
                background: Color(0xFF0000C2),
                onBackground: Colors.white,
                primary: Colors.white,
                onPrimary: Colors.white,
                primaryContainer: Color(0xFF0000A9),
                secondary: Color(0xFF00008F),
                onSecondary: Colors.white,
                secondaryContainer: Color(0xFF000082),
                brightness: Brightness.dark,
                error: Color(0xFFf7d800),
                onError: Colors.black,
                surface: Color(0xFF00008F),
                onSurface: Colors.white)),
        home: Scaffold(
            body: CustomPaint(
          foregroundPainter: LCDGridPainter(),
          child: FutureBuilder(
              future: getTimedItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(child: BaseWidget(timedItems: snapshot.data));
                } else {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }
              }),
        )));
  }
}
