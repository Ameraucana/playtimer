import 'package:flutter/material.dart';

class SynchronicityIndicator extends StatelessWidget {
  SynchronicityIndicator({@required this.didDownload});
  final bool didDownload;

  @override
  Widget build(context) {
    if (didDownload) {
      return Icon(Icons.sync_sharp, color: Colors.white);
    } else {
      return Icon(Icons.sync_problem_sharp,
          color: Colors.white.withOpacity(.5));
    }
  }
}
