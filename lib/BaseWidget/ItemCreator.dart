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
  OutlineInputBorder _borderStyle =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1));

  void create(UnsavedChangeModel model) async {
    if (_controller.text.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    model.madeChange();
    TimedItem newItem = TimedItem.yetUnchanged(_controller.text, 0);
    _controller.text = "";
    widget.creationCallback(newItem);
    focusNode.unfocus();
  }

  FocusNode focusNode = FocusNode();

  TextStyle _style = TextStyle(fontFamily: "Roboto", color: Colors.white);
  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel unsavedChangeModel = context.watch<UnsavedChangeModel>();
    OutlineInputBorder _errorBorderStyle = OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.error, width: 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 300,
          child: TextField(
            focusNode: focusNode,
            controller: _controller,
            maxLines: 1,
            style: _style,
            onEditingComplete: () => create(unsavedChangeModel),
            decoration: InputDecoration(
              enabledBorder: _borderStyle,
              focusedBorder: _borderStyle,
              focusedErrorBorder: _errorBorderStyle,
              errorBorder: _borderStyle,
              errorStyle: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontFamily: "Roboto"
              ),
              hintText: "Name of game or task",
              errorText: _showError ? "Field must not be empty" : null,
            ),
            onChanged: (_) => setState(() => _showError = false),
          ),
        ),
        SizedBox(width: 10, height: 0),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white), textStyle: _style),
          icon: Icon(Icons.add_sharp, color: Colors.white),
          label: Text("Add", style: _style),
          onPressed: () => create(unsavedChangeModel),
        )
      ],
    );
  }
}
