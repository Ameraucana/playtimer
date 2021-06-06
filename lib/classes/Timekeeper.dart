import 'dart:async';
import 'TimedItem.dart';
import 'UnsavedChangeModel.dart';

class Timekeeper {
  Timer repeatingTimer;
  TimedItem activeItem;
  int seconds = 0;
  bool isRunning = false;

  void start(UnsavedChangeModel model, void Function(void Function()) setState) {
    isRunning = true;
    repeatingTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() => seconds++);
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
    print('${newItem.name}: ${newItem.seconds}');
  }
  void merge(int definedSeconds) {
    seconds = definedSeconds;
    activeItem.seconds = seconds;
  }
}