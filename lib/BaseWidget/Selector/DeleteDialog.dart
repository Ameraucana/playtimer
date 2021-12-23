import 'package:flutter/material.dart';
import 'package:playtimer/classes/TimedItem.dart';
import 'package:playtimer/classes/UnsavedChangeModel.dart';

class DeleteDialog extends StatelessWidget {
  DeleteDialog(
      {@required this.onConfirm,
      @required this.item,
      @required this.changeModel});
  final Function(UnsavedChangeModel) onConfirm;
  final TimedItem item;
  final UnsavedChangeModel changeModel;

  final buttonStyle = ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
      textStyle: MaterialStateProperty.all(TextStyle(fontFamily: "Roboto")));

  @override
  Widget build(context) {
    return AlertDialog(
        backgroundColor: Color(0xFF00008F),
        title: Text("Delete ${item.name}?",
            style: TextStyle(fontFamily: "Roboto")),
        actions: [
          TextButton(
            style: buttonStyle,
            child: Text("No"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
              style: buttonStyle,
              child: Text("Yes"),
              onPressed: () {
                onConfirm(changeModel);
                Navigator.pop(context);
              })
        ]);
  }
}
