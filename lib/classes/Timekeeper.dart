import 'dart:async';
import 'TimedItem.dart';
import 'UnsavedChangeModel.dart';

class Timekeeper {
  Timekeeper(this.setState);
  void Function(void Function()) setState;
  UnsavedChangeModel model;
  Timer repeatingTimer;
  Timer stubSecondTimer;
  TimedItem activeItem;
  int seconds = 0;
  bool isRunning = false;

  // If you want to do something when the start button is pressed,
  // put it here if it uses TimedItem state
  void start() {
    isRunning = true;
    stubSecondTimer = Timer(Duration(seconds: 1), () {
      activeItem.changeHistory.stub.begin();
    });
    repeatingTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
        activeItem.seconds = seconds;
        activeItem.delta.increment();
      });
      activeItem.lastChangeDate = DateTime.now();
      activeItem.changeHistory.stub.advanceStopDate();
      model.madeChange();
    });
  }

  void stop({bool fromSaveButton = false}) {
    repeatingTimer?.cancel();
    stubSecondTimer?.cancel();
    activeItem.seconds = seconds;
    isRunning = false;
  }

  void select(TimedItem newItem) {
    stop();
    activeItem = newItem;
    seconds = newItem.seconds;
    print('new item: ${newItem.name}: ${newItem.seconds}');
  }

  void merge(int definedSeconds) {
    activeItem.delta.setTo(activeItem.seconds, definedSeconds);
    activeItem.changeHistory.stub.begin();
    activeItem.changeHistory.stub.advanceStopDate();
    activeItem.changeHistory.stub.usedBonusTime();
    activeItem.lastChangeDate = DateTime.now();
    seconds = definedSeconds;
    activeItem.seconds = seconds;
  }
}
