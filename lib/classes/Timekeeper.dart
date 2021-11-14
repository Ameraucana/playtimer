import 'dart:async';
import 'TimedItem.dart';
import 'UnsavedChangeModel.dart';

class Timekeeper {
  Timekeeper(this.setState);
  void Function(void Function()) setState;
  UnsavedChangeModel model;
  Timer repeatingTimer;
  TimedItem activeItem;
  int seconds = 0;
  bool isRunning = false;

  void start() {
    isRunning = true;
    activeItem.lastChangeDate = DateTime.now();
    setState(() => model.madeChange());
    repeatingTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        seconds++;
        activeItem.seconds = seconds;
        activeItem.delta.increment();
      });
      model.madeChange();
    });
  }
  void stop() {
    repeatingTimer?.cancel();
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
    seconds = definedSeconds;
    activeItem.seconds = seconds;
  }
}