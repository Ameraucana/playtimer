import 'package:flutter/material.dart';
import 'package:playtimer/classes/UnsavedChangeModel.dart';
import 'package:provider/provider.dart';
import '../classes/TimedItem.dart';

class ItemCreator extends StatefulWidget {
  ItemCreator({Key key, this.creationCallback}) : super(key: key);
  final void Function(TimedItem) creationCallback;

  @override
  _ItemCreatorState createState() => _ItemCreatorState();
}

class _ItemCreatorState extends State<ItemCreator> {
  TextEditingController _controller = TextEditingController();
  bool _showError = false;

  void create(UnsavedChangeModel model) async {
    if (_controller.text.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    model.madeChange();
    TimedItem newItem = TimedItem.yetUnchanged(_controller.text, 0);
    _controller.text = "";
    widget.creationCallback(newItem);
   
  }
  
  TextStyle style = TextStyle(
    fontFamily: "Roboto"
  );
  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel unsavedChangeModel = context.watch<UnsavedChangeModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 300,
          child: TextField(
            controller: _controller,
            maxLines: 1,
            style: style,
            onEditingComplete: () => create(unsavedChangeModel),
            decoration: InputDecoration(
              errorStyle: style,
              hintText: "Name of game or task",
              errorText: _showError ? "Field must not be empty" : null,
            ),
            onChanged: (_) => setState(() => _showError = false),
          ),
        ),
        SizedBox(width: 10, height: 0),
        ElevatedButton.icon(
          icon: Icon(Icons.add_sharp),
          label: Text("Add", style: style),
          onPressed: () => create(unsavedChangeModel),
        )
      ],
    );
  }
}