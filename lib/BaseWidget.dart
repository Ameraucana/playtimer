import 'dart:io';
import 'package:flutter/material.dart';
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


class BaseWidget extends StatefulWidget {
  BaseWidget({@required this.timedItems});
  final List<TimedItem> timedItems;
  @override
  createState() => BaseWidgetState(timedItems);
}

class BaseWidgetState extends State<BaseWidget> {
  BaseWidgetState(this.timedItems) {
    timekeeper = Timekeeper()
      ..activeItem = timedItems[0]
      ..seconds = timedItems.singleWhere((item) => item.name == timedItems[0].name).seconds;
   }
  Timekeeper timekeeper;
  List<TimedItem> timedItems;
  UnsavedChangeModel unsavedChangeModel = UnsavedChangeModel();
  bool startButtonIsActive = true;

  @override
  void initState() { 
    super.initState();
    print(timekeeper.seconds.toString());
  }
  
  void addNew(TimedItem item) {
    setState(() {
      timedItems.add(item);
    });
  }

  void remove(TimedItem item) {
    int currentIndex = timedItems.indexOf(item);
    print("currentIndex: $currentIndex");
    if (currentIndex > 0) {
      setState(() => timekeeper.select(timedItems[currentIndex-1]));
    } else {
      if (timedItems.length > 1) {
        setState(() => setState(() => timekeeper.select(timedItems[currentIndex+1])));
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
    File file = File(path.join(documentsDir.path, "timedItems.json"));
    String output = TimedItem.encode(timedItems);
    await file.writeAsString(output);
  }

  TextStyle style = TextStyle(
    fontFamily: "DSEG",
    fontSize: 30
  );
  @override
  Widget build(context) {
    return Provider.value(
      value: unsavedChangeModel,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GroupingBox(
            children: [
              TimeDisplay(seconds: timekeeper.seconds, mergeSeconds: (definedSeconds) {
                setState(() => timekeeper.merge(definedSeconds));
              }),

              SizedBox(width: 0, height: 10),
              StartStopButton(
                startButtonFunc: () {
                  setState(() {
                    timekeeper.start(unsavedChangeModel, setState);
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
            ]
          ),
          SizedBox(height: 10, width: 0),
          GroupingBox(
            children: [
              ItemCreator(creationCallback: addNew)
            ]
          ),
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
                onRemove: remove
              ),
              LastChange(lastChangeDate: timekeeper.activeItem.lastChangeDate)
            ],
          ),
          SizedBox(height: 10, width: 0),
          SaveButton(onPressed: rewrite)
        ],
      ),
    );
  }
}