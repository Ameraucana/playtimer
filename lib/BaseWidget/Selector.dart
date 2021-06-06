import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playtimer/classes/TimedItem.dart';
import 'package:playtimer/classes/UnsavedChangeModel.dart';

class Selector extends StatefulWidget {
  Selector({Key key, @required this.items, @required this.onSelect, @required this.onRemove}) : super(key: key);
  final List<TimedItem> items;
  final Function(TimedItem) onSelect;
  final Function(TimedItem) onRemove;

  @override
  _SelectorState createState() => _SelectorState(items);
}

class _SelectorState extends State<Selector> {
  _SelectorState(items) : dropdownValue = items[0]??TimedItem("None", 0);
  TimedItem dropdownValue;

  void pressedRemove(UnsavedChangeModel model) {
    if (widget.items.isNotEmpty) {
      model.madeChange();
      int currentIndex = widget.items.indexOf(dropdownValue);
      if (currentIndex > 0) {
        setState(() => dropdownValue = widget.items[currentIndex-1]);
        print("selected $dropdownValue");
      } else {
        if (widget.items.length > 1) {
          setState(() => dropdownValue = widget.items[currentIndex+1]);
        } else {
          setState(() => dropdownValue = null);
        }
      }
      widget.onRemove(widget.items[currentIndex]);
    }

  }

  @override
  Widget build(BuildContext context) {
    UnsavedChangeModel unsavedChangeModel = context.watch<UnsavedChangeModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<TimedItem>(
          
          onChanged: (TimedItem newValue) {
            setState(() => dropdownValue = newValue);
            widget.onSelect(newValue);
          },
          value: dropdownValue,
          items: widget.items
            .map((item) => DropdownMenuItem(
              child: Text(item.name, style: TextStyle(fontFamily: "Roboto")),
              value: item
            )
          ).toList()
        ),
        IconButton(
          icon: Icon(
            Icons.delete_forever_sharp
          ),
          onPressed: () => pressedRemove(unsavedChangeModel)
        )
      ],
    );
  }
}