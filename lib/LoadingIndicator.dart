import 'package:flutter/material.dart';
import 'package:playtimer/BaseWidget/painters/LoadingPainter.dart';
import 'package:playtimer/classes/LoadingIndicator/SquareTrain.dart';

class LoadingIndicator extends StatefulWidget {
  LoadingIndicator({Key key}) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  SquareTrain train = SquareTrain();
  AnimationController animationController;
  IntTween engine;
  Animation step;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    engine = IntTween(begin: 0, end: 7);
    step = engine.animate(animationController)
      ..addListener(() => setState(() => train.chug(step.value)));
    animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 27,
        width: 27,
        child: CustomPaint(
          painter: LoadingPainter(train: train),
        ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
