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
    File file = File(path.join(documentsDir.path, "playtimer_data", "timedItems.json"));
    await file.create(recursive: true);
    List<TimedItem> timedItems = [];
    try {
      http.Response response = await http.get(Uri.parse(urlEndpoint), headers: {
        "Content-Type": "application/json",
        "Api-Key": await rootBundle.loadString("assets/key")
      });
      if (response.statusCode == 200) {
        timedItems =
            TimedItem.decode(json.encode(json.decode(response.body)['data']));
      }
    } catch (e) {
      print(e);
    }
    if (timedItems.isEmpty) {
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        timedItems = TimedItem.decode(jsonString);
        if (timedItems.length == 0) {
          print("the length was 0");
          timedItems.add(TimedItem.yetUnchanged("None", 0));
        }
      } else {
        file.writeAsString("[]");
        timedItems = [TimedItem.yetUnchanged("None", 0)];
      }
    }
    return timedItems;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Playtimer',
        theme: ThemeData(
          fontFamily: "DSEG",
          
          scaffoldBackgroundColor: Color(0xFF0000C2),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Color(0xFF00008F)
          ),
          canvasColor: Color(0xFF00008F),
          colorScheme: ColorScheme(
            background: Color(0xFF0000C2),
            onBackground: Colors.white,

            primary: Color(0xFF0000C2),
            onPrimary: Colors.white,
            primaryVariant: Color(0xFF0000A9),

            secondary: Color(0xFF00008F),
            onSecondary: Colors.white,
            secondaryVariant: Color(0xFF000082),

            brightness: Brightness.dark,

            error: Color(0xFFf7d800),
            onError: Colors.black,

            surface: Color(0xFF00008F),
            onSurface: Colors.white
          )
        ),
        home: Scaffold(
            body: CustomPaint(
              foregroundPainter: LCDGridPainter(),
              child: FutureBuilder(
                  future: getTimedItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(child: BaseWidget(timedItems: snapshot.data));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            )));
  }
}
