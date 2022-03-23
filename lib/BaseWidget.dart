import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:playtimer/BaseWidget/LastChange.dart';
import 'package:playtimer/BaseWidget/SynchronictyIndicator.dart';
import 'package:playtimer/HistoryPage.dart';
import 'package:playtimer/LoadingIndicator.dart';
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
  BaseWidget({@required this.timedItems, @required this.didDownload});
  final bool didDownload;
  final List<TimedItem> timedItems;
  @override
  createState() => BaseWidgetState(timedItems, didDownload);
}

class BaseWidgetState extends State<BaseWidget> {
  BaseWidgetState(this.timedItems, this.didDownload) {
    unsavedChangeModel = UnsavedChangeModel();
    timekeeper = Timekeeper(setState)
      ..activeItem = timedItems[0]
      ..model = unsavedChangeModel
      ..seconds = timedItems[0].seconds;
  }
  Timekeeper timekeeper;
  List<TimedItem> timedItems;
  UnsavedChangeModel unsavedChangeModel;
  bool startButtonIsActive = true;
  bool didDownload;
  bool saveIsInProgress = false;
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
      item.isMarkedForOmission = true;
    });
  }

  Future<bool> rewrite() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    print(documentsDir.path);
    File saveFile =
        File(path.join(documentsDir.path, "playtimer_data", "timedItems.json"));
    await saveFile.create(recursive: true);

    bool uploadSucceeded = true;
    String output = "";

    try {
      http.Response potentiallyDifferingResponse =
          await http.get(Uri.parse(urlEndpoint), headers: {
        "Content-Type": "application/json",
        "Api-Key": await rootBundle.loadString("assets/key")
      }).timeout(Duration(seconds: 10));
      List<TimedItem> potentiallyDifferingInfo = TimedItem.formTimedItems(
          json.encode(json.decode(potentiallyDifferingResponse.body)['data']));

      setState(() {
        TimedItem.merge(timedItems, potentiallyDifferingInfo);
      });

      setState(() {
        timedItems.removeWhere((timedItem) => timedItem.isMarkedForOmission);
      });

      output = TimedItem.formOutput(timedItems);
      http.Response response = await http
          .put(Uri.parse(urlEndpoint),
              headers: {
                "Content-Type": "application/json",
                "Api-Key": await rootBundle.loadString("assets/key")
              },
              body: output)
          .timeout(Duration(seconds: 10));
      print(response.statusCode);
    } catch (e) {
      setState(() {
        timedItems.removeWhere((timedItem) => timedItem.isMarkedForOmission);
      });
      uploadSucceeded = false;
      output = TimedItem.formOutput(timedItems);
      print(e);
    }
    await saveFile.writeAsString(output);

    return uploadSucceeded;
  }

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
              SizedBox(width: 0, height: 10),
              TimeDisplay(
                  disabled: saveIsInProgress,
                  timedItem: timekeeper.activeItem,
                  mergeSeconds: (definedSeconds) {
                    setState(() => timekeeper.merge(definedSeconds));
                  }),
              SizedBox(width: 0, height: 10),
              StartStopButton(
                disabled: saveIsInProgress,
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
            GroupingBox(children: [
              ItemCreator(
                creationCallback: addNew,
                disabled: saveIsInProgress,
              )
            ]),
            SizedBox(height: 10, width: 0),
            GroupingBox(
              children: [
                Selector(
                    items: timedItems,
                    disabled: saveIsInProgress,
                    onSelect: (newItem) => setState(() {
                          timekeeper.select(newItem);
                          setState(() => startButtonIsActive = true);
                          print("activeItem is now ${timekeeper.activeItem}");
                        }),
                    onRemove: remove),
                LastChange(
                    lastChangeDate: timekeeper.activeItem.lastChangeDate),
                SizedBox(height: 10, width: 0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                        child: Text("HISTORY"),
                        onPressed: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                                reverseTransitionDuration: Duration(seconds: 0),
                                transitionDuration: Duration(seconds: 0),
                                pageBuilder: (context, _, __) => HistoryPage(
                                      changeHistory:
                                          timekeeper.activeItem.changeHistory,
                                    )))),
                    SizedBox(width: 5),
                    SynchronicityIndicator(didDownload: didDownload)
                  ],
                )
              ],
            ),
            SizedBox(height: 10, width: 0),
            SaveButton(onPressed: () async {
              setState(() {
                // We need to stop first so the stop date is set if it needs to be,
                // and need that argument so that it isn't overwritten if unneeded
                timekeeper.stop(fromSaveButton: true);
                startButtonIsActive = true;
                timedItems.forEach((item) {
                  // You must keep completeRecord before delta.reset
                  // because an empty TimeDelta is useless here
                  item.changeHistory.completeRecord(item.delta);
                  item.delta.reset();
                });
                saveIsInProgress = true;
              });
              didDownload = await rewrite();
              setState(() => saveIsInProgress = false);
            }),
          ],
        ),
      ),
    );
  }
}
