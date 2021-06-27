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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.play_arrow_sharp, size: 60),
                    label: Text("Start", style: style),
                    onPressed: timekeeper.isRunning ? null : () {
                      setState(() => timekeeper.start(unsavedChangeModel, setState));
                    },
                    
                  ),
                  SizedBox(height: 0, width: 10),
                  OutlinedButton.icon(
                    icon: Icon(Icons.stop_sharp, size: 60),
                    label: Text("Stop", style: style),
                    onPressed: timekeeper.isRunning ? () {
                      setState(() => timekeeper.stop());
                    } : null,
                  )         
                ],
              ),
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