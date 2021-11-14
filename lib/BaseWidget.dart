import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:playtimer/BaseWidget/LastChange.dart';
import 'package:provider/provider.dart' show Provider;

import 'package:playtimer/BaseWidget/SaveButton.dart';

import 'BaseWidget/TimeDisplay.dart';
import 'BaseWidget/ItemCreator.dart';
import 'BaseWidget/Selector.dart';
import 'BaseWidget/GroupingBox.dart';
import 'BaseWidget/StartStopButton.dart';
import 'classes/TimedItem.dart';
import 'classes/UnsavedChangeModel.dart';
import 'classes/Timekeeper.dart';
import 'BaseWidget/TimeDisplay/DeltaDisplay.dart';

class BaseWidget extends StatefulWidget {
  BaseWidget({@required this.timedItems});
  final List<TimedItem> timedItems;
  @override
  createState() => BaseWidgetState(timedItems);
}

class BaseWidgetState extends State<BaseWidget> {
  BaseWidgetState(this.timedItems) {
    unsavedChangeModel = UnsavedChangeModel();
    timekeeper = Timekeeper(setState)
      ..activeItem = timedItems[0]
      ..model = unsavedChangeModel
      ..seconds = timedItems
          .singleWhere((item) => item.name == timedItems[0].name)
          .seconds;
  }
  Timekeeper timekeeper;
  List<TimedItem> timedItems;
  UnsavedChangeModel unsavedChangeModel;
  bool startButtonIsActive = true;
  final String urlEndpoint = r"https://json.psty.io/api_v1/stores/playtimer";

  void addNew(TimedItem item) {
    setState(() {
      timedItems.add(item);
    });
  }

  void remove(TimedItem item) {
    int currentIndex = timedItems.indexOf(item);
    print("currentIndex: $currentIndex");
    if (currentIndex > 0) {
      setState(() => timekeeper.select(timedItems[currentIndex - 1]));
    } else {
      if (timedItems.length > 1) {
        setState(() =>
            setState(() => timekeeper.select(timedItems[currentIndex + 1])));
      } else {
        return;
      }
    }
    setState(() {
      timedItems.remove(item);
    });
  }

  void rewrite() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    print(documentsDir.path);
    File file =
        File(path.join(documentsDir.path, "playtimer_data", "timedItems.json"));
    await file.create(recursive: true);
    String output = TimedItem.encode(timedItems);
    try {
      http.Response response = await http.put(Uri.parse(urlEndpoint),
          headers: {
            "Content-Type": "application/json",
            "Api-Key": await rootBundle.loadString("assets/key")
          },
          body: output);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
    await file.writeAsString(output);
  }

  TextStyle style = TextStyle(fontFamily: "DSEG", fontSize: 30);
  FocusNode keyboardListenerFocusNode = FocusNode();
  @override
  Widget build(context) {
    return Provider.value(
      value: unsavedChangeModel,
      child: RawKeyboardListener(
        focusNode: keyboardListenerFocusNode,
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            keyboardListenerFocusNode.requestFocus();
          } else if (event.logicalKey == LogicalKeyboardKey.space &&
              event.runtimeType.toString() == "RawKeyDownEvent" &&
              keyboardListenerFocusNode.hasPrimaryFocus) {
            if (!timekeeper.isRunning) {
              setState(() {
                timekeeper.start();
                startButtonIsActive = false;
              });
            } else {
              setState(() {
                timekeeper.stop();
                startButtonIsActive = true;
              });
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GroupingBox(children: [
              DeltaDisplay(delta: timekeeper.activeItem.delta),
              SizedBox(width: 0, height: 10),
              TimeDisplay(
                  seconds: timekeeper.seconds,
                  mergeSeconds: (definedSeconds) {
                    setState(() => timekeeper.merge(definedSeconds));
                  }),
              SizedBox(width: 0, height: 10),
              StartStopButton(
                startButtonFunc: () {
                  setState(() {
                    timekeeper.start();
                    startButtonIsActive = false;
                  });
                },
                stopButtonFunc: () {
                  setState(() {
                    timekeeper.stop();
                    startButtonIsActive = true;
                  });
                },
                startButtonIsActive: startButtonIsActive,
              )
            ]),
            SizedBox(height: 10, width: 0),
            GroupingBox(children: [ItemCreator(creationCallback: addNew)]),
            SizedBox(height: 10, width: 0),
            GroupingBox(
              children: [
                Selector(
                    items: timedItems,
                    onSelect: (newItem) => setState(() {
                          timekeeper.select(newItem);
                          setState(() => startButtonIsActive = true);
                          print("activeItem is now ${timekeeper.activeItem}");
                        }),
                    onRemove: remove),
                LastChange(lastChangeDate: timekeeper.activeItem.lastChangeDate)
              ],
            ),
            SizedBox(height: 10, width: 0),
            SaveButton(onPressed: () {
              setState(() => timedItems.forEach((item) => item.delta.reset()));
              rewrite();
            })
          ],
        ),
      ),
    );
  }
}
